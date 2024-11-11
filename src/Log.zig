const std = @import("std");
const time = std.time;
const Datetime = @import("Datetime.zig");
const c = std.c;

pub fn logger(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    const dt = Datetime.get();
    const prefix = "[" ++ comptime level.asText() ++ "]" ++ " " ++ "(" ++ @tagName(scope) ++ ") ";

    const c_level: c_int = switch (level) {
        // #define LOG_EMERG       0       /* system is unusable */
        // #define LOG_ALERT       1       /* action must be taken immediately */
        // #define LOG_CRIT        2       /* critical conditions */
        // #define LOG_ERR         3       /* error conditions */
        // #define LOG_WARNING     4       /* warning conditions */
        // #define LOG_NOTICE      5       /* normal but significant condition */
        // #define LOG_INFO        6       /* informational */
        // #define LOG_DEBUG       7       /* debug-level messages */
        .debug => 7,
        .info => 6,
        .warn => 4,
        .err => 3,
    };

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const _allocator = gpa.allocator();
    const _format = std.fmt.allocPrintZ(_allocator, prefix ++ format, args) catch
        "(log) Caught an exception! Could be: OutOfMemory";
    defer _allocator.free(_format);
    // Print the message to stderr, silently ignoring any errors
    std.debug.lockStdErr();
    defer std.debug.unlockStdErr();
    const stderr = std.io.getStdErr().writer();
    nosuspend stderr.print("{d:0>4}-{d:0>2}-{d:0>2}T{d:0>2}:{d:0>2}:{d:0>2}.{d:0>3}Z " ++ prefix ++ format ++ "\r\n", .{ dt.year, dt.month, dt.day, dt.hours, dt.minutes, dt.seconds, dt.miliseconds } ++ args) catch return;
    nosuspend c.syslog(c_level, _format);
}
