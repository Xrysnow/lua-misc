---
--- switch.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---


---switch
---@param val any
---@param cases table
function switch(val, cases)
    if cases[val] then
        return cases[val]()
    end
    if cases['default'] then
        return cases['default']()
    end
end

