--=======================================================================
-- File Name    : gamescene.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/27 14:19:54
-- Description  : 
-- Modify       : 
--=======================================================================
local GameScene = wp_class("GameScene", function()
	return cc.Scene:create()
end)

function GameScene.create()
	local scene = GameScene.new()
	scene:addChild(scene:createLayer())
	return scene
end

function GameScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function GameScene:createLayer()
	local layer = cc.Layer:create()
	local label = cc.LabelTTF:create("Game Scene.", "Arial", 30)
	label:setColor(cc.c3b(0,133,255))
	label:setPosition(cc.p(self.visibleSize.width/2, self.visibleSize.height/2))
	layer:addChild(label)

    local function menuCallbackReloadFile()
        DofileScript()
    end

	local function menuCallbackOpenPopup()
		-- DofileScript()
        local scene = ClassMgr:GetClassByName("GameScene")
        local sceneGame = scene.create()
        CCDirector:getInstance():popScene()
        CCDirector:getInstance():pushScene(sceneGame)
    end

    local reloadItem = cc.MenuItemImage:create("menu1.png", "menu1.png")
    reloadItem:setPosition(100, 0)
    reloadItem:registerScriptTapHandler(menuCallbackReloadFile)

    -- add the left-bottom "tools" menu to invoke menuPopup
    local menuToolsItem = cc.MenuItemImage:create("menu1.png", "menu1.png")
    menuToolsItem:setPosition(0, 0)
    menuToolsItem:registerScriptTapHandler(menuCallbackOpenPopup)
    local menuTools = cc.Menu:create(menuToolsItem, reloadItem)
    local itemWidth = menuToolsItem:getContentSize().width
    local itemHeight = menuToolsItem:getContentSize().height
    menuTools:setPosition(itemWidth, itemHeight)
    layer:addChild(menuTools)

	return layer
end

function GameScene:PlayBGMusic( ... )
	local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3") 
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
end

-- return GameScene
local function AddGameSceneClass()
    ClassMgr:Add("GameScene", GameScene)
    return 1
end

AddInitFunction("AddGameSceneClass", AddGameSceneClass)
-- return GameScene