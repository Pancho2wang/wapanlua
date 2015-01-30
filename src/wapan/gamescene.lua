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
	label:setColor(cc.c3b(0,133,0))
	label:setPosition(cc.p(self.visibleSize.width/2, self.visibleSize.height/2))
	layer:addChild(label)

    local function menuCallbackOpenPopup()
        local scene = ClassMgr:GetClassByName("GameScene")
        local sceneGame = scene.create()
        cc.Director:getInstance():popScene()
        cc.Director:getInstance():pushScene(sceneGame)
    end
     -- add the left-bottom "tools" menu to invoke menuPopup
    local menuToolsItem = cc.MenuItemImage:create("menu1.png", "land.png")
    menuToolsItem:setPosition(0, 0)
    menuToolsItem:registerScriptTapHandler(menuCallbackOpenPopup)

    local function menuCallbackReloadFile()
        DofileScript()
    end
    local reloadItem = cc.MenuItemImage:create("menu1.png", "land.png")
    reloadItem:setPosition(100, 0)
    reloadItem:registerScriptTapHandler(menuCallbackReloadFile)

    local function backScene()
        cc.Director:getInstance():popScene()
    end
    local backItem = cc.MenuItemImage:create("menu1.png", "land.png")
    backItem:setPosition(200, 0)
    backItem:registerScriptTapHandler(backScene)

    local menuTools = cc.Menu:create(menuToolsItem, reloadItem, backItem)
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