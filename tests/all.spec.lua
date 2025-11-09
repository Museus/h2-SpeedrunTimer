local lu = require('luaunit')

require("tests/Timer")
lu.LuaUnit.run()

require("tests/LrtTimer")
lu.LuaUnit.run()

require("tests/RtaTimer")
lu.LuaUnit.run()

require("tests/SpeedrunTimer")
lu.LuaUnit.run()


os.exit()
