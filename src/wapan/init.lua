--=======================================================================
-- File Name    : init.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/27 16:13:39
-- Description  : 
-- Modify       : 
--=======================================================================

local PROJECT_NAME = string.sub(..., 1, -6)

-- require (PROJECT_NAME .. ".config")
-- require (PROJECT_NAME .. ".gamescene")

AddProjectFile(PROJECT_NAME .. ".config")
AddProjectFile(PROJECT_NAME .. ".loadscene")
AddProjectFile(PROJECT_NAME .. ".gamescene")