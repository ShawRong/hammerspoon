hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.alert.show("Hello World!")
end)

hs.hotkey.bind({"ctrl", "cmd"}, ".", function()
  hs.pasteboard.setContents(hs.window.focusedWindow():application():path())
  hs.alert.show("App path:        " ..
  hs.window.focusedWindow():application():path() ..
  "\n" ..
  "App name:      " ..
  hs.window.focusedWindow():application():name() ..
  "\n" ..
  "IM source id:  " ..
  hs.keycodes.currentSourceID(), hs.alert.defaultStyle, hs.screen.mainScreen(), 3)
end)

-- this is for automatically switching input methods between apps
local function Chinese()
  hs.keycodes.currentSourceID("com.tencent.inputmethod.wetype.pinyin")
end

local function English()
  hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

local appInputMethod = {
  iTerm2 = English,
  ['微信']  = Chinese,
  Raycast = English,
  QQ = Chinese,
}


-- activated 时切换到指定的输入法，deactivated 时恢复之前的状态
currentID = ""
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        for app, fn in pairs(appInputMethod) do
            if app == appName then
                currentID = hs.keycodes.currentSourceID()
                fn()
            end
        end
    end
    if eventType == hs.application.watcher.deactivated then
        for app, fn in pairs(appInputMethod) do
            if app == appName then
                hs.keycodes.currentSourceID(currentID)
                currentID = hs.keycodes.currentSourceID()
            end
        end
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher):start()
