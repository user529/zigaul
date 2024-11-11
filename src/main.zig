const std = @import("std");
const log = std.log.scoped(.main);
const ArenaAllocator = std.heap.ArenaAllocator;

const Logz = @import("Log.zig");
const Config = @import("Config.zig");
const Ztb = @import("Ztb.zig");
const API = @import("telegramAPI.zig");

const ziglua = @import("ziglua");
const Lua = ziglua.Lua;

var bot: Ztb = undefined;
var active: bool = true;
pub const std_options = .{
    .log_level = .debug,
    .logFn = Logz.logger,
};

// SIGHUP - close connections
fn sigHUPhandler(sig: c_int) callconv(.C) void {
    std.debug.print("Received SIGHUP signal ({})\n", .{sig});
    // Handle SIGHUP here
    active = false;
    std.debug.print("Waiting for a while until the current open connection closes gracefully\n", .{});
}
// SIGTERM | SIGQUIT - greaceful exit

fn getUpdate(lua: *Lua) i32 {
    const update = lua.toString(1) catch "<nil>";
    log.debug("getUpdate: {s}", .{update});
    _ = lua.pushString(update); //?
    lua.setGlobal("update");
    return 1;
}

fn luaHandler(lua: *Lua, update: []const u8) ![]const u8 {
    log.debug("(loop lua) start", .{});
    lua.openBase();
    try lua.loadFile("../../src/handler.lua");
    _ = lua.pushString(update); //?
    lua.setGlobal("update");
    try lua.protectedCall(0, 1, 0);
    const lua_result = lua.toString(1) catch "<none>";
    log.debug("lua handler : {s}", .{lua_result});
    return lua_result;
}

pub fn main() !void {
    // Set up signal handler
    const mask = std.os.linux.empty_sigset;
    const act = std.os.linux.Sigaction{
        .handler = .{ .handler = sigHUPhandler },
        .mask = mask,
        .flags = 0,
    };
    _ = std.os.linux.sigaction(std.os.linux.SIG.HUP, &act, null);
    //
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gallocator = gpa.allocator();
    var arena = ArenaAllocator.init(gpa.allocator());
    defer _ = arena.deinit();
    const allocator = arena.allocator();
    log.info("Starting up", .{});

    var lua = try Lua.init(&gallocator);
    defer lua.deinit();

    // Getting config from file
    const config = try Config.read(gallocator, "config.json", 1024);
    defer config.deinit();
    // Client
    const client = std.http.Client{ .allocator = gallocator };

    // bot initialization
    bot = try Ztb.init(allocator, config, client);
    defer bot.deinit();
    // entering main loop
    var last_update_id: i64 = 0;
    while (active) {
        const current: API.Update = bot.getUpdates(&last_update_id) catch |e| excp: {
            log.warn("(loop) caught an exception: {any}", .{e});
            break :excp API.emptyUpdate;
        };

        log.debug("(loop) current update: {any}", .{current});
        if (current.message.?.text) |msg| {
            const tsStart = try std.time.Instant.now();
            const lua_result = try luaHandler(lua, msg);
            const tsEnd = try std.time.Instant.now();
            const tsDiff: f64 = @floatFromInt(tsEnd.since(tsStart));
            log.debug("luaHandler elapesd: {d:.3} ms", .{tsDiff / std.time.ns_per_ms});
            _ = try bot.sendMessage(lua_result);
            log.debug("(lua loop result): {s}", .{lua_result});
        }

        std.time.sleep(bot.config.polling_interval * std.time.ns_per_ms);
        // log.debug("(loop) Waking up after sleep: {d} ms", .{bot.config.polling_interval});
        //
        // reseting all arena allocations that could happen during single loop run
        arena.deinit();
        arena = ArenaAllocator.init(gallocator);
        bot.allocator = arena.allocator();
        lua.deinit();
        lua = try Lua.init(&gallocator);
    }
    log.info("Shutted down", .{});
}
