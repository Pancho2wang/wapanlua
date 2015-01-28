--=======================================================================
-- File Name    : init.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/27 13:41:49
-- Description  : 
-- Modify       : 
--=======================================================================

local FREEFRAME_NAME = string.sub(..., 1, -6)

require (FREEFRAME_NAME .. ".common")

AddRequireFile(FREEFRAME_NAME .. ".class_mgr")

