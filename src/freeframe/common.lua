
--=======================================================================
-- File Name    : common.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/21 17:32:19
-- Description  : 
-- Modify       : 
--=======================================================================

is_debug = 1
local function Init(self, ...)
	local init_list = {}
	local base_class = self.super
	print("base_class name ===", type(base_class.super))
	ShowTB(base_class, 3)
	while base_class do
		if type(base_class) ~= "table" --[[or (base_class and base_class.__ctype == 1)]] then
			print("Super is not a class.")
			break
		end
		local init_func = rawget(base_class, "_Init")
		if init_func then
			init_list[#init_list + 1] = {init_func, rawget(base_class, "__cname")}
		end
		base_class = base_class.super
	end
	if is_debug == 1 then
		print("------------------------ Init Begin ------------------------------")
	end
	for i = #init_list, 1, -1 do
		local func, name = unpack(init_list[i])
		if is_debug == 1 then
			print("--execute-- " .. tostring(name) .. " Init..", ...)
		end
		assert(func(self, ...) == 1)
	end
	if is_debug == 1 then
		print("------------------------- Init End -----------------------------")
	end
	return 1
end

local function Uninit(self)
	local uninit_list = {}
	local base_class = self.__index
	while base_class do
		if type(base_class) == "function" or (base_class and base_class.__ctype == 1) then
			print("Super is not a class.")
			break
		end
		local uninit_func = rawget(base_class, "_Uninit")
		if uninit_func then
			uninit_list[#uninit_list + 1] = {uninit_func, rawget(base_class, "__cname")}
		end
		base_class = base_class.super
	end
	if is_debug == 1 then
		print("------------------------ Uninit Begin ------------------------------")
	end
	for i = 1, #uninit_list do
		local func, name = unpack(uninit_list[i])
		if is_debug == 1 then
			print("--execute-- " .. tostring(name) .. " Uninit..")
		end
		assert(func(self) == 1)
	end
	if is_debug == 1 then
		print("------------------------- Uninit End -----------------------------")
	end
	return 1
end

function wp_class(classname, super)
	-- local cls = class(classname, super)
	-- function cls.extend(target)
	-- 	if not target then
	-- 		return
	-- 	end
	-- 	local t = tolua.getpeer(target)
	-- 	if not t then
	-- 		t = {}
	-- 		tolua.setpeer(target, t)
	-- 	end
	-- 	setmetatable(t, cls)
	-- 	-- target.class = cls
	-- 	return target
	-- end
	local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.new(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = {}
            setmetatable(cls, {__index = super})
            -- setmetatable(cls, super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        -- cls.__index = cls
        local metatb = {
			__index = function(table, key)
				local v = rawget(table, key)
				if v then
					return v
				end
				local super_class = rawget(table, "super")
				if super_class then
					return super_class[key]
				end
			end
		}
        setmetatable(cls, metatb)
        cls.Init = Init
		cls.Uninit = Uninit
        function cls.new(...)
            local instance = setmetatable({}, {__index = cls})
            -- local instance = setmetatable({}, {__index = cls})
            -- 相当于：	local instance = {}
            -- 			setmetatable(instance, {__index = cls})
            instance.super = cls
            instance.__cname = cls.__cname
            instance.__ctype = 3
            -- instance.class = cls
            -- instance:ctor(...)
            return instance
        end
    end

	return cls
end

function ShowStack(s)
	print(debug.traceback(s,2))
	return s
end

function SafeCall(callback)
	local function InnerCall()
		return callback[1](unpack(callback, 2))
	end
	return xpcall(InnerCall, ShowStack)
end

function Split(str, delim, maxNb)   
    -- Eliminate bad cases...   
    if string.find(str, delim) == nil then  
        return { str }  
    end  
    if maxNb == nil or maxNb < 1 then  
        maxNb = 0    -- No limit   
    end  
    local result = {}  
    local pat = "(.-)" .. delim .. "()"   
    local nb = 0  
    local lastPos   
    for part, pos in string.gfind(str, pat) do  
        nb = nb + 1  
        result[nb] = part   
        lastPos = pos   
        if nb == maxNb then break end  
    end  
    -- Handle the last field   
    if nb ~= maxNb then  
        result[nb + 1] = string.sub(str, lastPos)   
    end  
    return result   
end  

-------------------------------------------------
--	require file and dofile function
-------------------------------------------------

local __require_script_list = {}
local __init_function_list = {}
local __reset_function_list = {}

function AddRequireFile(script_file)
	__require_script_list[#__require_script_list + 1] = script_file
end

function AddProjectFile(script_file)
	return AddRequireFile(script_file)
end

function AddInitFunction(name, func)
	for i, func_item in pairs(__init_function_list) do
		if name == func_item.name then
			func_item.func = func
			return
		end
	end
	__init_function_list[#__init_function_list + 1] = {name = name, func = func}
end

function AddResetFunction(name, func)
	for i, func_item in pairs(__reset_function_list) do
		if name == func_item.name then
			func_item.func = func
			return
		end
	end
	__reset_function_list[#__reset_function_list + 1] = {name = name, func = func}
end

function RequireScript()
	for _, script_file in ipairs(__require_script_list) do
		print("loading\t\""..script_file.."\"")
		require(script_file)
	end
	for _, func_item in pairs(__init_function_list) do
		print("Init\t"..func_item.name .. "...")
		local result, ret_code = SafeCall({func_item.func})
		if not result or ret_code ~= 1 then
			assert(false, "%s execute failed", name)
			return 0
		end
	end
	return 1
end

function DofileScript()
	if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
		for _, func_item in pairs(__reset_function_list) do
			print("Reset\t"..func_item.name .. "...")
			SafeCall({func_item.func})
		end

		print("Reload Lua Script...")
		for _, script_file in ipairs(__require_script_list) do
			script_file = string.gsub(script_file, "%.", "/")
			dofile("src/"..script_file..".lua")
			print("Reload\t["..script_file.."]")
		end

		for _, func_item in pairs(__init_function_list) do
			print("Init\t"..func_item.name .. "...")
			SafeCall({func_item.func})
		end
	else
		print("Can not support Script Reload!!")
	end
end

---------------------------------------------

function ShowTB(table_raw, n)
	if not table_raw or type(table_raw) ~= "table" then
		print("[ShowTB] It's not a table or nil.It's type = " .. type(table_raw))
		return
	end
	if not n then
		n = 7
	end
	local function printTB(table, deepth, max_deepth)
		if deepth > n or deepth > max_deepth then
			return
		end
		local str_blank = ""
		for i = 1, deepth - 1 do
			str_blank = str_blank .. "  "
		end
		for k, v in pairs(table) do
			if type(v) ~= "table" then
				print(string.format("%s[%s] = %s", str_blank, tostring(k), tostring(v)))
			else
				print(string.format("%s[%s] = ", str_blank, tostring(k)))
				printTB(v, deepth + 1, max_deepth)
			end
		end
	end
	printTB(table_raw, 1, n)
end