-- shortly explained: this is my api wrapper for the library so its easier to add tabs sections etc, free to use idc

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

return UI
