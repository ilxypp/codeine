local httpService = game:GetService('HttpService')
local ThemeManager = {} do
	ThemeManager.Folder = 'fentThemes'
	-- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

	ThemeManager.Library = nil
	ThemeManager.BuiltInThemes = {
		['Retro'] = { 
    1, 
    httpService:JSONDecode('{
        "FontColor":"ffd1dc",
        "MainColor":"141026",
        "AccentColor":"ff2e88",
        "BackgroundColor":"0a0a12",
        "OutlineColor":"5a2a82"
    }') 
},,
	}

	function ThemeManager:ApplyTheme(theme)
		local data = self.BuiltInThemes[theme]
		if not data then return end

		local scheme = data[2]
		for idx, col in next, scheme do
			self.Library[idx] = Color3.fromHex(col)
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()		
		local theme = 'Default'
		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

		if content and self.BuiltInThemes[content] then
			theme = content
		elseif self.BuiltInThemes[self.DefaultTheme] then
			theme = self.DefaultTheme
		end

		Options.ThemeManager_ThemeList:SetValue(theme)
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

	function ThemeManager:CreateThemeManager(groupbox)
		local ThemesArray = {}
		for Name, _ in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end
		table.sort(ThemesArray)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme', Values = ThemesArray, Default = 1 })

		groupbox:AddButton('Set as default', function()
			self:SaveDefault(Options.ThemeManager_ThemeList.Value)
			self.Library:Notify(string.format('Default theme set to %q', Options.ThemeManager_ThemeList.Value))
		end)

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)

		self:LoadDefault()
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}
		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end
		table.insert(paths, self.Folder .. '/themes')

		for i = 1, #paths do
			if not isfolder(paths[i]) then
				makefolder(paths[i])
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end

return ThemeManager
