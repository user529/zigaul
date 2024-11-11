-- 'update' is global variable that sets each time the bot gets an update from telegram API
print("handler.lua got:", update)
local result = update .. " with love from lua"
return result
