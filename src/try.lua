---
--- try.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---


local function _traceback(e)
    if e then
        local _, pos = e:find(":%d+: ")
        if pos then
            return e:sub(pos + 1)
        end
    end
    return e
end

---Example:
---`try {`
---`　　function()`
---`　　　　error('err1')`
---`　　end,`
---`　　catch('err1') { function()`
---`　　　　print('err1 catched')`
---`　　end },`
---`　　finally { function()`
---`　　end }`
---`}`
function try(block)
    local try     = block[1]
    local ok, ret = xpcall(try, _traceback)
    if not ok then
        for i = 2, #block do
            local block_i = block[i]
            if block_i.catch and (block_i.e == ret or block_i.e == nil) then
                block_i.catch(ret)
                break--catch once
            end
        end
    end
    if block[#block].finally then
        block[#block].finally(ok, ret)
    end
    if ok then
        return ret
    end
end

function catch(e)
    return function(block)
        return { catch = block[1], e = e }
    end
end

function finally(block)
    return { finally = block[1] }
end

