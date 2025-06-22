--[[

	X-Ro - Self ESP Module

]]

--// Luraph Macros

if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(...)
		return ...
	end
end

--// References

local Players = (cloneref or LPH_NO_VIRTUALIZE(function(...) return ... end))(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer

local DefaultColor

--// Functions

local GetCharacter = LPH_NO_VIRTUALIZE(function()
	return LocalPlayer.Character or workspace:FindFirstChild(LocalPlayer.Name)
end)

--// Main

repeat
	wait(0)
until GetCharacter() and GetCharacter():FindFirstChild("Head")

DefaultColor = GetCharacter().Head.Color

local Module = {
	Config = newproxy(true),

	_Config = {
		Enabled = false,
		ForceField = false,
		ForceFieldAccessories = false,
		Highlight = false,
		ChangeBodyColor = false,
		ChangeClothesColor = false,
		ChangeAccessoriesColor = false,
		CastShadow = true,
		ClothesColor = Color3.fromRGB(0, 150, 90),
		BodyColor = Color3.fromRGB(0, 150, 90),
		AccessoriesColor = Color3.fromRGB(0, 150, 90),
		HighlightColor = Color3.fromRGB(0, 150, 90),
		HighlightOutlineColor = Color3.fromRGB(0, 150, 90),
		HighlightTransparency = 0,
		HighlightOutlineTransparency = 0
	},

	Update = LPH_NO_VIRTUALIZE(function(self)
		local Character = GetCharacter()
		local Highlight = Character:FindFirstChild("X-RO_SELF_ESP")

		if Character then
			local Config = self._Config

			for _, Value in next, Character:GetChildren() do
				if Value:IsA("MeshPart") or (Value:IsA("Part") and Value:FindFirstChildOfClass("SpecialMesh")) then -- Limb
					Value.Material = Config.Enabled and Config.ForceField and Enum.Material.ForceField or Enum.Material.Plastic
					Value.Color = Config.Enabled and Config.ChangeBodyColor and Config.BodyColor or DefaultColor
					Value.CastShadow = Config.Enabled and Config.CastShadow or true

					continue
				end

				if Value:IsA("Accessory") or Value:IsA("Hat") then -- Accessory
					Value = Value:FindFirstChildOfClass("MeshPart")

					if not Value then
						continue
					end

					Value.Material = Config.Enabled and Config.ForceFieldAccessories and Enum.Material.ForceField or Enum.Material.Plastic
					Value.Color = Config.Enabled and Config.ChangeAccessoriesColor and Config.AccessoriesColor or DefaultColor

					continue
				end

				if Value:IsA("Pants") or Value:IsA("Shirt") then -- Clothing
					Value.Color3 = Config.Enabled and Config.ChangeClothesColor and Config.ClothesColor or Color3.fromRGB(255, 255, 255)
				end
			end

			if not Highlight then
				Highlight = Instance.new("Highlight", Character)
				Highlight.Name = "X-RO_SELF_ESP"
			end

			Highlight.Enabled = Config.Enabled and Config.Highlight

			if Highlight.Enabled then
				Highlight.FillColor = Config.HighlightColor
				Highlight.OutlineColor = Config.HighlightOutlineColor
				Highlight.FillTransparency = Config.HighlightTransparency
				Highlight.OutlineTransparency = Config.HighlightOutlineTransparency
			end
		end
	end)
}

local ConfigMetatable = getmetatable(Module.Config)

ConfigMetatable.__iter = LPH_NO_VIRTUALIZE(function()
	return next, Module._Config
end)

ConfigMetatable.__index = LPH_NO_VIRTUALIZE(function(...)
	return Module._Config[select(2, ...)]
end)

ConfigMetatable.__newindex = LPH_NO_VIRTUALIZE(function(...)
	local Index, Value = select(2, ...) -- Ignore 1st argument - "self"

	Module._Config[Index] = Value; Module:Update()
end)

return Module