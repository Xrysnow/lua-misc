---
--- vector.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---

std             = std or {}

---@class vector
local vector    = {}
std.vector      = vector

vector.sort     = table.sort
vector.remove   = table.remove
vector.maxn     = table.maxn
vector.concat   = table.concat
vector.insert   = table.insert

local function ctor(T)
    local ret = {}
    ret._T    = T
    setmetatable(ret, {
        __index = vector
    })
    return ret
end
local mt = { __call = function(op, T)
    return ctor(T)
end }
setmetatable(vector, mt)

function vector:push_back(v)
    self:insert(v)
end

function vector:pop_back()
    local ret   = self[#self]
    self[#self] = nil
    return ret
end

function vector:at(n)
    if n > #self or n < 1 then
        error('out of range')
    end
    return self[n]
end

function vector:front()
    return self[1]
end

function vector:back()
    return self[#self]
end

function vector:size()
    return #self
end

function vector:resize(n)
    for i = n + 1, self:size() do
        self[i] = nil
    end
    for i = self:size() + 1, n do
        self[i] = self._T()
    end
end

function vector:erase(n, m)
    m        = m or n
    local ne = m - n + 1
    for i = n, self:size() - ne do
        self[i] = self[i + ne]
    end
end

function vector:clear()
    self = vector(self._T)
end

function vector:empty()
    return self:size() == 0
end

function vector:get_allocator()
    return self._T
end

function vector:copy()
    local ret = vector(self._T)
    for i = 1, self:size() do
        ret[i] = self[i]
    end
    return ret
end

function std.isvector(v)
    return getmetatable(v) == mt
end

