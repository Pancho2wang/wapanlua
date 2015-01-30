--=======================================================================
-- File Name    : scene_base.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/28 18:14:57
-- Description  : 
-- Modify       : 
--=======================================================================
local SceneBase = ClassMgr:CreateClass("SceneBase")
function SceneBase:_Uninit( ... )
	-- body
	return 1
end
function SceneBase:_Init( ... )
	-- body
	return 1
end
function SceneBase:PrintTest( ... )
	-- body
	print("SceneBase========")
end
-- return SceneBase