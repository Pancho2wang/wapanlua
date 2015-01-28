--=======================================================================
-- File Name    : obj_base.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/27 17:19:45
-- Description  : 
-- Modify       : 
--=======================================================================

if not ObjBase then
	ObjBase = wp_class("ObjBase")
end

function ObjBase:_Uninit()
	self.obj_name = nil
	self.class_name = nil
	self.id = nil
	return 1
end

function ObjBase:_Init(id, class_name, obj_name)
	self.id = id
	self.class_name = class_name
	self.obj_name = obj_name
	return 1
end

function ObjBase:GetId()
	return self.id
end

function ObjBase:GetClassName()
	return self.class_name
end

function ObjBase:GetObjectName()
	return self.obj_name
end