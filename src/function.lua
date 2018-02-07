---
--- function.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---

std = std or {}

---
---bind
---@param f fun(...):any
---@return fun(...):any
function std.bind(f, ...)
    local argsSuper = { ... }
    local n1        = select("#", ...)
    return function(...)
        local args    = { ... }
        local argsOut = { unpack(argsSuper, 1, n1) }
        for i, v in pairs(args) do
            argsOut[n1 + i] = v
        end
        return f(unpack(argsOut, 1, table.maxn(argsOut)))
    end
end

---
---handler
---@param f fun(obj:any,...):any
---@param obj any
---@return fun(...):any
function std.handler(f, obj)
    return function(...)
        return f(obj, ...)
    end
end

---
---Empty function.
function std.fvoid()
end

---
---iscallable
---@param f table|fun(...):any
function std.iscallable(f)
    if type(f) == 'function' then
        return true
    elseif type(f) == 'table' then
        return getmetatable(f) and getmetatable(f).__call
    end
end

---
---@type table<string,fun(a:any,b:any):boolean>
---comparator
---You can use following keys to get a comparator:
--->### '=='　'>='　'<='　'~='　'>'　'<'
---You can add '#' to the front of the key to compare length,
---or add 'f' and give a function to compare result of the function.
---Example:
--->`f1 = Function.comparator［'>='］`
--->`f2 = Function.comparator［'f>='］(f)`
std.comparator = {
    ['==']  = function(a, b)
        return a == b
    end,
    ['>=']  = function(a, b)
        return a >= b
    end,
    ['<=']  = function(a, b)
        return a <= b
    end,
    ['~=']  = function(a, b)
        return a ~= b
    end,
    ['>']   = function(a, b)
        return a > b
    end,
    ['<']   = function(a, b)
        return a < b
    end,

    ['#=='] = function(a, b)
        return #a == #b
    end,
    ['#>='] = function(a, b)
        return #a >= #b
    end,
    ['#<='] = function(a, b)
        return #a <= #b
    end,
    ['#~='] = function(a, b)
        return #a ~= #b
    end,
    ['#>']  = function(a, b)
        return #a > #b
    end,
    ['#<']  = function(a, b)
        return #a < #b
    end,

    ['f=='] = function(f)
        return function(a, b)
            return f(a) == f(b)
        end
    end,
    ['f>='] = function(f)
        return function(a, b)
            return f(a) >= f(b)
        end
    end,
    ['f<='] = function(f)
        return function(a, b)
            return f(a) <= f(b)
        end
    end,
    ['f~='] = function(f)
        return function(a, b)
            return f(a) ~= f(b)
        end
    end,
    ['f>']  = function(f)
        return function(a, b)
            return f(a) > f(b)
        end
    end,
    ['f<']  = function(f)
        return function(a, b)
            return f(a) < f(b)
        end
    end,
}

