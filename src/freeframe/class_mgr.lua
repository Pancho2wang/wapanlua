--=======================================================================
-- File Name    : class_mgr.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/27 18:32:02
-- Description  : 
-- Modify       : 
--=======================================================================

if not ClassMgr then
	ClassMgr = { local_class_list = {}, }
end

function ClassMgr:Uninit()
	for class_name, _ in pairs(self.local_class_list) do
		self.local_class_list[class_name] = nil
	end
	self.local_class_list = nil
	return 1
end

function ClassMgr:Init()
	self.local_class_list = {}
	return 1
end

function ClassMgr:Add(class_name, class)
	if self.local_class_list[class_name] then
		return
	end
	self.local_class_list[class_name] = class
end

function ClassMgr:Remove(class_name)
	if not self.local_class_list[class_name] then
		return
	end
	self.local_class_list[class_name] = nil
end

function ClassMgr:GetClassByName(class_name)
	if not self.local_class_list[class_name] then
		assert(false, "No class["..class_name.."].")
		return
	end
	return self.local_class_list[class_name]
end

local function InitClassMgr()
	return ClassMgr:Init()
end

AddInitFunction("ClassMgr", InitClassMgr)