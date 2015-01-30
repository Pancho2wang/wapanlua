--=======================================================================
-- File Name    : class_mgr.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/27 18:32:02
-- Description  : 
-- Modify       : 
--=======================================================================

if not ClassMgr then
	ClassMgr = { class_list = {}, }
end

function ClassMgr:Uninit()
	for class_name, _ in pairs(self.class_list) do
		self.class_list[class_name] = nil
	end
	self.class_list = nil
	return 1
end

function ClassMgr:Init()
	self.class_list = {}
	return 1
end

function ClassMgr:Add(class_name, class)
	if self.class_list[class_name] then
		return
	end
	self.class_list[class_name] = class
end

function ClassMgr:Remove(class_name)
	if not self.class_list[class_name] then
		return
	end
	self.class_list[class_name] = nil
end

function ClassMgr:GetClassByName(class_name)
	if not self.class_list[class_name] then
		assert(false, "No class["..class_name.."].")
		return
	end
	return self.class_list[class_name]
end

local function InitClassMgr()
	return ClassMgr:Init()
end

AddInitFunction("ClassMgr", InitClassMgr)