local UI = {}
UI.__index = UI

function UI.new(Library, windowProps)
    local self = setmetatable({}, UI)

    self.Library = Library
    self.Window = Library:Window(windowProps)
    self.Pages = {}

    return self
end

function UI:AddTab(name, props)
    props = props or {}

    local page = self.Window:Page({
        Name = props.Name or name,
        Columns = props.Columns or 3
    })

    self.Pages[name] = {
        Page = page,
        Sections = {}
    }

    return self
end

function UI:GetPage(name)
    return self.Pages[name].Page
end

function UI:AddSection(tabName, sectionName, side)
    local page = self:GetPage(tabName)

    local section = page:Section({
        Name = sectionName,
        Side = side or 1
    })

    table.insert(self.Pages[tabName].Sections, section)

    return section
end

function UI:Section(tabName, sectionName, side)
    return self:AddSection(tabName, sectionName, side)
end

function UI:AddToggle(section, props)
    return section:Toggle(props)
end

function UI:AddSlider(section, props)
    return section:Slider(props)
end

function UI:AddDropdown(section, props)
    return section:Dropdown(props)
end

function UI:AddTextbox(section, props)
    return section:Textbox(props)
end

function UI:AddButton(section, props)
    local btn = section:Button()
    return btn:NewButton(props)
end

function UI:AddLabel(section, text, side)
    return section:Label(text, side or "Left")
end

function UI:AddColorpicker(object, props)
    return object:Colorpicker({
        Name = props.Name,
        Flag = props.Flag,
        Default = props.Default,
        Alpha = props.Alpha,
        Callback = props.Callback
    })
end

function UI:AddKeybind(object, props)
    return object:Keybind({
        Name = props.Name,
        Flag = props.Flag,
        Default = props.Default,
        Mode = props.Mode,
        Callback = props.Callback
    })
end

function UI:Notify(text, duration, color)
    return self.Library:Notification(
        text,
        duration or 5,
        color or (self.Library.Theme and self.Library.Theme.Accent or Color3.fromRGB(255,255,255))
    )
end

function UI:NotifySuccess(text)
    return self:Notify(text, 4, Color3.fromRGB(0,255,0))
end

function UI:NotifyError(text)
    return self:Notify(text, 5, Color3.fromRGB(255,0,0))
end

function UI:NotifyInfo(text)
    return self:Notify(text, 4)
end

function UI:CreateSettings()
    if self.Pages["Settings"] then
        return self.Pages["Settings"].Page
    end

    self:AddTab("Settings", {Columns = 2})
    return self.Pages["Settings"].Page
end

function UI:SettingsSection(name, side)
    self:CreateSettings()
    return self:Section("Settings", name, side)
end

function UI:InitConfigSystem(section)
    local Library = self.Library

    local ConfigName
    local ConfigSelected

    local ConfigList = section:Dropdown({
        Name = "Configs",
        Flag = "ConfigsList",
        Items = {},
        Callback = function(v)
            ConfigSelected = v
        end
    })

    section:Textbox({
        Name = "Config Name",
        Flag = "ConfigName",
        Callback = function(v)
            ConfigName = v
        end
    })

    section:Button():NewButton({
        Name = "Create",
        Callback = function()
            if not ConfigName or ConfigName == "" then return end

            local path = Library.Folders.Configs .. "/" .. ConfigName .. ".json"

            if isfile(path) then
                self:NotifyError("Config already exists")
                return
            end

            writefile(path, Library:GetConfig())
            self:NotifySuccess("Created config " .. ConfigName)

            Library:RefreshConfigsList(ConfigList)
        end
    })

    section:Button():NewButton({
        Name = "Delete",
        Callback = function()
            if not ConfigSelected then return end

            Library:DeleteConfig(ConfigSelected)
            self:NotifySuccess("Deleted config " .. ConfigSelected)

            Library:RefreshConfigsList(ConfigList)
        end
    })

    section:Button():NewButton({
        Name = "Save",
        Callback = function()
            if not ConfigSelected then return end

            Library:SaveConfig(ConfigSelected)
            self:NotifySuccess("Saved config " .. ConfigSelected)
        end
    })

    section:Button():NewButton({
        Name = "Load",
        Callback = function()
            if not ConfigSelected then return end

            local ok, err = Library:LoadConfig(
                readfile(Library.Folders.Configs .. "/" .. ConfigSelected)
            )

            if not ok then
                self:NotifyError(err)
            else
                self:NotifySuccess("Loaded config " .. ConfigSelected)
            end
        end
    })

    section:Button():NewButton({
        Name = "Refresh",
        Callback = function()
            Library:RefreshConfigsList(ConfigList)
            self:NotifyInfo("Refreshed configs")
        end
    })

    Library:RefreshConfigsList(ConfigList)
end

function UI:InitMenu(section)
    local Library = self.Library

    section:Button():NewButton({
        Name = "Unload",
        Callback = function()
            Library:Unload()
        end
    })

    section:Label("Menu Keybind", "Left"):Keybind({
        Name = "MenuKeybind",
        Flag = "MenuKeybind",
        Mode = "Toggle",
        Default = Library.MenuKeybind,
        Callback = function()
            Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
        end
    })
end

return UI
