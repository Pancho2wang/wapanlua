--=======================================================================
-- File Name    : loadscene.lua
-- Creator      : pancho(pancho@koogame.com)
-- Date         : 2015/01/28 09:55:25
-- Description  : 
-- Modify       : 
--=======================================================================

local LoadScene = wp_class("LoadScene", function()
	return cc.Scene:create()
end)

function LoadScene.create()
	local scene = LoadScene.new()
	scene:addChild(scene:createLayer())
	return scene
end

function LoadScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
end

function LoadScene:createLayer()
	local layer = cc.Layer:create()
	local label = cc.LabelTTF:create("Hello World.", "Arial", 24)
	label:setColor(cc.c3b(0,0,255))
	label:setPosition(cc.p(self.visibleSize.width/2, self.visibleSize.height/2))
	layer:addChild(label)

	local function menuCallbackOpenPopup()
		-- DofileScript()
		local scene = ClassMgr:GetClassByName("GameScene")
    	local sceneGame = scene.create()
		CCDirector:getInstance():pushScene(sceneGame)
    end

    -- add the left-bottom "tools" menu to invoke menuPopup
    local menuToolsItem = cc.MenuItemImage:create("menu1.png", "menu1.png")
    menuToolsItem:setPosition(0, 0)
    menuToolsItem:registerScriptTapHandler(menuCallbackOpenPopup)
    local menuTools = cc.Menu:create(menuToolsItem)
    local itemWidth = menuToolsItem:getContentSize().width + 100
    local itemHeight = menuToolsItem:getContentSize().height
    menuTools:setPosition(itemWidth, itemHeight)
    layer:addChild(menuTools)

	return layer
end

function LoadScene:PlayBGMusic( ... )
	local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3") 
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
end

local function AddLoadSceneClass()
    ClassMgr:Add("LoadScene", LoadScene)
    return 1
end

AddInitFunction("AddLoadSceneClass", AddLoadSceneClass)