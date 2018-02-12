---
--- with.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---


function with(t, f)
    return setfenv(f, t)()
end

