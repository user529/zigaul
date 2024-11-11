const std = @import("std");
const testing = std.testing;

const Config = @import("Config.zig");

test "Test config readed" {
    const allocator = testing.allocator;

    const config = try Config.read(allocator, "src/config.json", 1024);
    defer config.parsed.deinit();

    try testing.expectEqualStrings(config.name, "zigaul test bot");
    try testing.expectEqualStrings(config.url, "https://api.example.com");
    try testing.expectEqual(config.port, 8081);
    try testing.expectEqualStrings(config.token, "0987654321:AAAAAA-BBBBBBBBBBBB-CCCCCCCCCCCCCCC");
}

test "Test parse chat" {
    const json =
        \\ {
        \\   "id":123456789,
        \\   "first_name":"User Name",
        \\   "username":"UserName",
        \\   "type":"private"
        \\ }
    ;

    const allocator = testing.allocator;

    const options = std.json.ParseOptions{
        .duplicate_field_behavior = .use_last,
        .ignore_unknown_fields = true,
    };
    const chat = try std.json.parseFromSlice(std.json.Value, allocator, json, options);
    defer chat.deinit();
    const chat_type = chat.value.object.get("type").?;
    try testing.expectEqualStrings(chat_type.string, "private");
}
test "Test parse getupdate_response" {
    const test_response =
        \\ {
        \\ "ok":true,
        \\ "result":
        \\   {
        \\     "update_id":111,
        \\     "message":{
        \\       "message_id":12345,
        \\       "from":{
        \\         "id":123456789,
        \\         "is_bot":false,
        \\         "first_name":"User Name",
        \\         "username":"UserName",
        \\         "language_code":"en"
        \\       },
        \\       "chat":{
        \\         "id":123456789,
        \\         "first_name":"User Name",
        \\         "username":"UserName",
        \\         "type":"private"
        \\       },
        \\       "date":1730229690,
        \\       "text":"test mgs"
        \\     }
        \\   }
        \\ }
    ;

    //
    const allocator = testing.allocator;
    const options = std.json.ParseOptions{
        .duplicate_field_behavior = .use_last,
        .ignore_unknown_fields = true,
    };
    const response = try std.json.parseFromSlice(std.json.Value, allocator, test_response, options);
    defer response.deinit();
    const ok = response.value.object.get("ok").?;
    try testing.expectEqual(ok.bool, true);
    const result = response.value.object.get("result").?;
    const update_id = result.object.get("update_id").?;
    try testing.expectEqual(update_id.integer, 111);
}
