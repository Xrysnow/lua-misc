---
--- ref.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---

local _mt = {
    __index    = function(t, k)
        return t.__v[k]
    end,
    __newindex = function(t, k, v)
        t.__v[k] = v
    end,
    __add      = function(op1, op2)
        return ref(op1.__v + op2.__v)
    end,
    __sub      = function(op1, op2)
        return ref(op1.__v - op2.__v)
    end,
    __mul      = function(op1, op2)
        return ref(op1.__v * op2.__v)
    end,
    __div      = function(op1, op2)
        return ref(op1.__v / op2.__v)
    end,
    __mod      = function(op1, op2)
        return ref(op1.__v % op2.__v)
    end,
    __unm      = function(op1)
        return ref(-op1.__v)
    end,
    __concat   = function(op1, op2)
        return ref(op1.__v .. op2.__v)
    end,
    __eq       = function(op1, op2)
        return op1.__v == op2.__v
    end,
    __lt       = function(op1, op2)
        return op1.__v < op2.__v
    end,
    __le       = function(op1, op2)
        return op1.__v <= op2.__v
    end,
    __call     = function(op)
        return op()
    end,
    __tostring = function(op)
        return tostring(op)
    end,
}

function ref(v)
    local ret = { __v = v }
    setmetatable(ret, _mt)
    return ret
end

function isref(v)
    local mt = getmetatable(v)
    return mt and mt == _mt
end

function unref(v)
    if isref(v) then
        return v.__v
    else
        return v
    end
end

