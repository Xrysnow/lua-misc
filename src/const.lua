---
--- const.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---

local function _err()
    error("Can't modify a const table.")
end

function const(v)
    local ret = {}
    local mt  = {
        __index    = v,
        __newindex = _err
    }
    setmetatable(ret, mt)
    return ret
end

function isconst(v)
    local mt = getmetatable(v)
    return mt and mt.__newindex == _err
end

function unconst(v)
    local mt = getmetatable(v)
    if mt and mt.__newindex == _err then
        return mt.__index
    else
        return v
    end
end

