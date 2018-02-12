---
--- math.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---


---@param v number
---@return number
function math.cbrt(v)
    return math.pow(v, 1 / 3)
end

---@param v number
---@param min number
---@param max number
---@return number
function math.clamp(v, min, max)
    if v < min then
        return min
    elseif v > max then
        return max
    else
        return v
    end
end

---@param v1 number
---@param v2 number
---@return number
function math.hypot(v1, v2)
    return math.sqrt(v1 * v1 + v2 * v2)
end

---@param v1 number
---@param v2 number
---@param a number
---@return number
function math.lerp(v1, v2, a)
    return v1 + (v2 - v1) * a
end

---C++ std::remainder
---C# Math.IEEERemainder
---@param v1 number
---@param v2 number
---@return number
function math.remainder(v1, v2)
    return v1 - v2 * math.round(v1 / v2)
end

---@param v number
---@return number
function math.round(v)
    if v - math.floor(v) < math.ceil(v) - v then
        return math.floor(v)
    else
        return math.ceil(v)
    end
end

---@param v number
---@return number
function math.sign(v)
    if v > 0 then
        return 1
    elseif v < 0 then
        return -1
    else
        return 0
    end
end

---from Microsoft.Xna.Framework.MathHelper

---C# MathHelper.Barycentric
---@param v1 number
---@param v2 number
---@param v3 number
---@param a1 number
---@param a2 number
---@return number
function math.barycentric(v1, v2, v3, a1, a2)
    return (v1 + (a1 * (v2 - v1))) + (a2 * (v3 - v1))
end

---C# MathHelper.SmoothStep
---@param v1 number
---@param v2 number
---@param a number
---@return number
function math.smoothstep(v1, v2, a)
    a = math.clamp(a, 0, 1)
    return math.lerp(v1, v2, a * a * (3 - 2 * a))
end

---C# MathHelper.WrapAngle
---@return number
---@param v number
function math.wrapangle(v)
    local a = math.remainder(v, math.M_PIx2)
    if a <= -math.M_PI then
        return a + math.M_PIx2
    elseif a > math.M_PI then
        return a - math.M_PIx2
    else
        return a
    end
end

