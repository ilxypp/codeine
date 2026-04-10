local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/ilxypp/codeine/refs/heads/main/main.luau'))()
local ThemeManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/ilxypp/codeine/refs/heads/main/themeM.luau'))()
local SaveManager = loadstring(game:HttpGet('https://raw.githubusercontent.com/ilxypp/codeine/refs/heads/main/saveM.luau'))()

local Window = Library:CreateWindow({
    Title = 'f e n t . e n t r y',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.5,
    Size = UDim2.fromOffset(700, 750)
})

local Tabs = {
    combat = Window:AddTab('combat'),
    visuals = Window:AddTab('visuals'),
    exploits = Window:AddTab('exploits'),
    misc = Window:AddTab('miscellaneous'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

ThemeManager:SetFolder('fent')
SaveManager:SetFolder('fent/example_baseplate')

ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:BuildConfigSection(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(true)
Library:SetWatermark(('f e n t . e n t r y | a fent enjoyer is running this | 1.0.0'))

Library.KeybindFrame.Visible = true;
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)
