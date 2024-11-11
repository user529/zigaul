const std = @import("std");

const Self = @This();
// const log = std.log;
const DEFAULT_POLLING_TIMEOUT = 60_000; // miliseconds. Default 60_000 = 60 sec
const DEFAULT_POLLING_INTERVAL = 100; // miliseconds. Default 100 ms

url: []const u8,
port: u16,
token: []const u8,
name: []const u8,
chat_id: u32,
polling_interval: u64,
polling_timeout: u64,
parsed: std.json.Parsed(std.json.Value),

pub fn read(allocator: std.mem.Allocator, file_name: []const u8, file_size: usize) !Self {
    const log = std.log.scoped(.@"config.read");
    const conf_buffer = try std.fs.cwd().readFileAlloc(allocator, file_name, file_size);
    errdefer allocator.free(conf_buffer);
    defer allocator.free(conf_buffer);
    const options = std.json.ParseOptions{
        .duplicate_field_behavior = .use_last,
        .ignore_unknown_fields = true,
    };
    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, conf_buffer, options);
    errdefer parsed.deinit();

    const config: Self = .{
        .url = parsed.value.object.get("url").?.string,
        .port = @intCast(parsed.value.object.get("port").?.integer),
        .token = parsed.value.object.get("token").?.string,
        .name = parsed.value.object.get("name").?.string,
        .chat_id = @intCast(parsed.value.object.get("chat_id").?.integer),
        .polling_timeout = blk: {
            if (parsed.value.object.get("polling_timeout")) |value| {
                break :blk @as(u64, @intCast(value.integer));
            } else {
                break :blk DEFAULT_POLLING_TIMEOUT;
            }
        },
        .polling_interval = blk: {
            if (parsed.value.object.get("polling_interval")) |value| {
                break :blk @as(u64, @intCast(value.integer));
            } else {
                break :blk DEFAULT_POLLING_INTERVAL;
            }
        },
        .parsed = parsed,
    };

    log.debug("url: {s}", .{config.url});
    // log.debug("token: {s}", .{config.token}); //don't show token value in logs
    log.debug("port: {d}", .{config.port});
    log.debug("name: {s}", .{config.name});
    log.debug("chat: {d}", .{config.chat_id});
    log.debug("polling_timeout: {d}", .{config.polling_timeout});
    log.debug("polling_interval: {d}", .{config.polling_interval});
    return config;
}

pub fn deinit(self: Self) void {
    self.parsed.deinit();
}
