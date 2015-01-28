
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
	local base_class = self.__index
	while base_class do
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
	local cls = class(classname, super)
	cls.Init = Init
	cls.Uninit = Uninit
	function cls.extend(target)
		if not target then
			return
		end
		local t = tolua.getpeer(target)
		if not t then
			t = {}
			tolua.setpeer(target, t)
		end
		setmetatable(t, cls)
		return target
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

function RequireScript()
	for _, script_file in ipairs(__require_script_list) do
		print("loading\t\""..script_file.."\"")
		require(script_file)
	end
	for _, func_item in pairs(__init_function_list) do
		print(func_item.name .. "...")
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
		print("Reload Lua Script...")
		for _, script_file in ipairs(__require_script_list) do
			script_file = string.gsub(script_file, "%.", "/")
			dofile("src/"..script_file..".lua")
			print("Reload\t["..script_file.."]")
		end

		for _, func_item in pairs(__init_function_list) do
			print(func_item.name .. "...")
			SafeCall({func_item.func})
		end
	else
		print("Can not support Script Reload!!")
	end
end