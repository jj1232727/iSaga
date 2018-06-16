local LocalCallbackAdd = Callback.Add
local file
local data

local EX_PATH            = COMMON_PATH.."iSagaScripts/"

dofile(EX_PATH..myHero.charName.."Saga.lua")
        --[[
file = assert(io.open(EX_PATH.."copy.lua", "r"))

data = file:read("*all")

-- closes the open file
file:close()


-- Opens a file in append mode
local file2 = assert(io.open(EX_PATH.."Pasta.lua", "w"))

-- sets the default output file as test.lua
file2:write(data)

-- appends a word test to the last line of the file


file:close()]]--

