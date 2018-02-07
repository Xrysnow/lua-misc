---
--- list.lua
---
--- Copyright (C) 2018 Xrysnow. All rights reserved.
---

std                 = std or {}

---@class list
---@field protected _begin list_iterator
---@field protected _end list_iterator
local list          = {}
std.list            = list
---@class list_iterator
---@field public prev list_iterator
---@field public next list_iterator
---@field public key string
---@field public val any
local list_iterator = {}
std.list_iterator   = list_iterator


-------------------------------------------------
---list_iterator
-------------------------------------------------


local function iter_ctor(v, prev, next)
    local ret = {
        val  = v,
        prev = prev,
        next = next,
    }
    ret.key   = tostring(ret)
    setmetatable(ret, {
        __index = list_iterator
    })
    return ret
end

local mt_list_iterator = {
    __call = function(t, ...)
        return iter_ctor(...)
    end,
}
setmetatable(list_iterator, mt_list_iterator)

function list_iterator:advance(n)
    local ret = self
    for i = 1, n do
        ret = ret.next
    end
    for i = 1, -n do
        ret = ret.prev
    end
    return ret
end

function list_iterator:move(n)
    local i   = self:advance(n)
    self.val  = i.val
    self.prev = i.prev
    self.next = i.next
    self.key  = i.key
end

function list_iterator:inc()
    self:move(1)
end

function list_iterator:dec()
    self:move(-1)
end


-------------------------------------------------
---list
-------------------------------------------------


local function list_ctor(T)
    local ret  = {
        _end = {},
    }
    ret._begit = ret._end
    ret._T     = T
    setmetatable(ret, {
        __index = list
    })
    return ret
end
local mt_list = { __call = function(op, param)
    local ty = type(param)
    if std.islist(param) then
        return param:copy()
    elseif std.iscallable(param) then
        return list_ctor(param)
    elseif ty == 'table' then
        local ret = list_ctor()
        for i = 1, #param do
            ret:push_back(param[i])
        end
        return ret
    elseif ty == 'number' or ty == 'string' or ty == 'boolean' then
        return list_ctor(function()
            return param
        end)
    elseif param == nil then
        return list_ctor()
    else
        error("Can't construct list from " .. tostring(param))
    end
end }

---alloc
---@param v any
---@param prev list_iterator
---@param next list_iterator
---@return string,list_iterator
local function alloc(v, prev, next)
    local ret = list_iterator(v, prev, next)
    return ret.key, ret
end

--iterators--------------------------------------

---### Return iterator to beginning
---Returns an iterator pointing to the first element in the list container.
---If the container is empty, the returned iterator value shall not be dereferenced.
function list:begin()
    return self._begin
end

---### Return iterator to end
---Returns an iterator referring to the past-the-end element in the list container. It does not point to any element, and thus shall not be dereferenced.
---If the container is empty, this function returns the same as list::begin.
function list:end_()
    return self._end
end

--element access---------------------------------

---### Access first element
---Returns the first element in the list container.
---Calling this function on an empty container causes error.
function list:front()
    assert(not self:empty())
    return self._begin.val
end

---### Access last element
---Returns the last element in the list container.
---Calling this function on an empty container causes error.
function list:back()
    assert(not self:empty())
    return self._end.prev.val
end

--capacity---------------------------------------

---### Test whether container is empty
---Returns whether the list container is empty (i.e. whether its size is 0).
function list:empty()
    return self._begin == self._end
end

---### Return size
---Returns the number of elements in the list container.
---@return number
function list:size()
    local ret = 0
    for _, _ in pairs(self) do
        ret = ret + 1
    end
    return ret - 2
end

--modifiers--------------------------------------

---### Clear content
---Removes all elements from the list container, and leaving the container with a size of 0.
function list:clear()
    self:erase(self._begin, self._end)
end

---### Insert elements
---The container is extended by inserting new elements before the element at the specified position.
---Return value: An iterator that points to the first of the newly inserted elements.
---@param it list_iterator
---@param v any
---@return list_iterator
function list:insert(it, v)
    local key, it_ = alloc(v, it.prev, it)
    self[key]      = it_
    if it == self._begin then
        self._begin = it_
    else
        it.prev.next = it_
        it.prev      = it_
    end
    return it_
end

---### Erase elements
---Removes from the list container either a single element (position) or a range of elements ([first,last)).
---Return value: An iterator pointing to the element that followed the last element erased by the function call. This is the container end if the operation erased the last element in the sequence.
---@param it list_iterator
---@param optional it2 list_iterator
function list:erase(it, it2)
    it2     = it2 or it.next
    local i = it
    while i and i ~= it2 do
        self[i.key] = nil
        i           = i.next
    end
    it2.prev = it.prev
    if it == self._begin then
        self._begin = it2
    else
        it.prev.next = it2
    end
    return it2
end

---### Insert element at beginning
---Inserts a new element at the beginning of the list, right before its current first element. This increases the container size by one.
function list:push_front(v)
    self:insert(self._begin, v)
end

---### Delete first element
---Removes the first element in the list container, reducing its size by one.
function list:pop_front()
    local it = self._begin
    self:erase(it)
    return it.val
end

---### Add element at the end
---Adds a new element at the end of the list container, after its current last element. This increases the container size by one.
function list:push_back(v)
    self:insert(self._end, v)
end

---### Delete last element
---Removes the last element in the list container, reducing the container size by one.
function list:pop_back()
    local it = self._end.prev
    self:erase(it)
    return it.val
end

--list operations--------------------------------

---### Remove elements with specific value
---Removes from the container all the elements that compare equal to v.
function list:remove(v)
    local it = self._begin
    while it ~= self._end do
        if it.val == v then
            it = self:erase(it)
        else
            it = it.next
        end
    end
end

---### Remove elements fulfilling condition
---Removes from the container all the elements for which Predicate p returns true.
function list:remove_if(p)
    local it = self._begin
    while it ~= self._end do
        if p(it.val) then
            it = self:erase(it)
        else
            it = it.next
        end
    end
end

--allocator--------------------------------------

---### Get allocator
---Returns the allocator object associated with the list container.
function list:get_allocator()
    return self._T
end

--copy-------------------------------------------

---copy
---@return list
function list:copy()
    local ret = list(self._T)
    for k, v in pairs(self) do
        ret[k] = v
    end
    return ret
end

function std.islist(v)
    return getmetatable(v) == mt_list
end

