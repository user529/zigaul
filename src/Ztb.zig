const std = @import("std");
const http = std.http;
// const log = std.log.scoped(.ztb);
const JSON = std.json.Value;
const Config = @import("Config.zig");
const API = @import("telegramAPI.zig");
const Self = @This();

config: Config,
client: http.Client,
allocator: std.mem.Allocator,

pub fn init(allocator: std.mem.Allocator, config: Config, client: http.Client) !Self {
    // log.debug("[init] config: {any}", .{config});
    // log.debug("[init] client: {s}", .{});
    return Self{
        .config = config,
        .client = client,
        .allocator = allocator,
    };
}

pub fn deinit(self: *Self) void {
    self.client.deinit(); // client deinitialization should be invoked explicitly
}

fn dispatch(self: *Self, method: API.method, payload: []const u8) !std.json.Parsed(JSON) {
    const log = std.log.scoped(.@"ztb.dispatch");
    var buf: [4096]u8 = undefined;

    const url = try std.fmt.allocPrint(self.allocator, "{s}/bot{s}/{s}", .{ self.config.url, self.config.token, @tagName(method) });
    defer self.allocator.free(url);
    const uri = try std.Uri.parse(url);

    var req = try self.client.open(.POST, uri, .{ .server_header_buffer = &buf });
    defer req.deinit();

    req.transfer_encoding = .{ .content_length = payload.len };
    req.headers.content_type = .{ .override = "application/json" };

    try req.send();
    var wtr = req.writer();
    // log.debug("address: {s}", .{url});  //don't show token value in logs
    log.debug("payload: {s}", .{payload});
    try wtr.writeAll(payload);
    try req.finish();
    log.debug("waiting response", .{});
    try req.wait();

    log.debug("received response: {s}", .{req.response.status.phrase() orelse "<NONE>"});
    if (req.response.status != .ok) {
        return error.ResponseNotOK;
    }

    const ln: usize = try req.readAll(&buf);
    return try self.parseResponse(buf[0..ln]);
}

pub fn parseResponse(self: *Self, response: []u8) !std.json.Parsed(JSON) {
    const log = std.log.scoped(.@"ztb.parseResponse");
    if (!try std.json.validate(self.allocator, response)) {
        log.err("got an invalid json: {s}", .{response});
        return error.InvalidJSON;
    }
    log.debug("processing input json: {s}", .{response});
    const options = std.json.ParseOptions{
        .duplicate_field_behavior = .use_last,
        .ignore_unknown_fields = true,
    };

    const parsed = try std.json.parseFromSlice(JSON, self.allocator, response, options);
    errdefer parsed.deinit();
    return parsed;
}

pub fn sendMessage(self: *Self, message: []const u8) !API.Message {
    const log = std.log.scoped(.@"ztb.sendMessage");
    log.debug("input: {s}", .{message});
    const payload = try std.json.stringifyAlloc(self.allocator, .{ .chat_id = self.config.chat_id, .text = message }, .{});
    defer self.allocator.free(payload);

    const result = try self.dispatch(API.method.sendMessage, payload);
    const response_message: API.Message = parseMessage(result.value.object.get("result").?);
    return response_message;
}

pub fn parseMessage(response: JSON) API.Message {
    const message_id = response.object.get("message_id").?;
    const date = response.object.get("date").?;
    const text = response.object.get("text").?;
    const response_message: API.Message = API.Message{
        .message_id = message_id.integer,
        .date = date.integer,
        .text = text.string,
    };

    return response_message;
}

pub fn getUpdates(self: *Self, offset: *i64) !API.Update {
    const log = std.log.scoped(.@"ztb.getUpdates");
    const payload = try std.json.stringifyAlloc(self.allocator, .{ .offset = offset.*, .limit = 1, .timeout = self.config.polling_timeout * std.time.ms_per_s, .allowed_updates = .{"message"} }, .{});
    defer self.allocator.free(payload);

    const result = try self.dispatch(API.method.getUpdates, payload);
    const update: API.Update = parseUpdate(result.value.object.get("result").?);
    if (update.update_id >= offset.*) {
        offset.* = update.update_id + 1;
        log.debug("new offset: {d}", .{offset.*});
    }
    return update;
}

pub fn parseUpdate(result: JSON) API.Update {
    var response_update: API.Update = undefined;
    if (result.array.items.len > 0) {
        for (result.array.items) |entry| {
            const update_id = entry.object.get("update_id").?;
            const message = entry.object.get("message").?;
            response_update = API.Update{
                .update_id = update_id.integer,
                .message = parseMessage(message),
            };
            break;
        }
        return response_update;
    } else {
        return API.emptyUpdate;
    }
}
