--[[

	X-Ro - Hitbox Expander Module

]]

--// Luraph Macros

if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(...)
		return ...
	end
end

--// References

local Players = (cloneref or LPH_NO_VIRTUALIZE(function(...) return ... end))(game:GetService("Players"))

--// Variables

local DefaultSize

--// Module

local Module = {
	Config = {
		Enabled = false,

		Size = 15,

		Material = Enum.Material.ForceField,
		Transparency = 0,
		Color = Color3.fromRGB(200, 125, 125)
	},

	ServiceConnections = {},

	Set = LPH_NO_VIRTUALIZE(function(self, Object, Disable)
		assert(self, "X-RO_HITBOX.Set > Critical error, \"self\" parameter is unassigned.")

		local Config = self.Config

		if not DefaultSize then -- Module not loaded yet
			return
		end

		if Config.Enabled and not Disable then
			Object.Size = Vector3.new(Config.Size, Config.Size, Config.Size)
			Object.Transparency = Config.Transparency
			Object.Color = Config.Color
			Object.Material = Config.Material
			Object.CanCollide = false
		else
			Object.Size = DefaultSize
			Object.Material = Enum.Material.Plastic
			Object.Transparency = 1
			Object.Color = Color3.fromRGB(180, 180, 180)
			Object.CanCollide = true
		end

		if Object:FindFirstChild("MeshPart") then -- Head
			Object.Mesh.MeshId = Config.Enabled and not Disable and "" or "rbxassetid://8635368421"
		end
	end),

	Update = LPH_NO_VIRTUALIZE(function(self)
		assert(self, "X-RO_HITBOX.Update > Critical error, \"self\" parameter is unassigned.")

		for _, Player in next, Players:GetPlayers() do
			if Player == Players.LocalPlayer then
				continue
			end

			local Character = Player.Character or workspace:FindFirstChild(Player.Name)
			local Object = Character and (Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart)

			if Object then
				self:Set(Object)
			end
		end
	end),

	Wrap = LPH_NO_VIRTUALIZE(function(self, Player)
		assert(self, "X-RO_HITBOX.Wrap > Critical error, \"self\" parameter is unassigned.")

		local ServiceConnections = self.ServiceConnections

		assert(typeof(Player) == "Instance", "X-RO_HITBOX.Wrap > Critical error, parameter \"Player\" is not of type \"Instance\".")

		repeat
			wait(0)
		until Player.Character or workspace:FindFirstChild(Player.Name)

		local Character = Player.Character or workspace:FindFirstChild(Player.Name)

		repeat
			wait(0)
		until Character:FindFirstChild("HumanoidRootPart")

		local Object = Character and (Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart)

		if Object then
			self:Set(Object)
		end

		ServiceConnections[#ServiceConnections + 1] = Player.CharacterAdded:Connect(function(_Character)
			Character = _Character

			repeat
				wait(0)
			until Character and Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart

			Object = Character and (Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart)

			if Object then
				self:Set(Object)

				--[[
				ServiceConnections[#ServiceConnections + 1] = Object.Changed:Connect(function(Property)
					if Property == "CanCollide" and self.Config.Enabled then
						Object.CanCollide = false; self:Set(Object)
					end
				end)
				]]

				repeat
					wait(0)
				until Character:FindFirstChildOfClass("Humanoid")

				ServiceConnections[#ServiceConnections + 1] = Character:FindFirstChildOfClass("Humanoid").Changed:Connect(function()
					self:Set(Object, Character:FindFirstChildOfClass("Humanoid").Sit or Character:FindFirstChildOfClass("Humanoid").Health <= 0)
				end)
			end
		end)

		repeat
			wait(0)
		until Character:FindFirstChildOfClass("Humanoid")

		ServiceConnections[#ServiceConnections + 1] = Character:FindFirstChildOfClass("Humanoid").Changed:Connect(function()
			self:Set(Object, Character:FindFirstChildOfClass("Humanoid").Sit or Character:FindFirstChildOfClass("Humanoid").Health <= 0)
		end)
	end),

	Init = LPH_NO_VIRTUALIZE(function(self, _DefaultSize)
		assert(self, "X-RO_HITBOX.Init > Critical error, \"self\" parameter is unassigned.")

		local ServiceConnections = self.ServiceConnections

		DefaultSize = _DefaultSize or DefaultSize

		assert(DefaultSize, "X-RO_HITBOX.Init > Critical error, \"DefaultSize\" parameter is unassigned.")
		assert(typeof(DefaultSize) == "Vector3", "X-RO_HITBOX.Init > Critical error, parameter \"DefaultSize\" is not of type \"Vector3\".")

		ServiceConnections[#ServiceConnections + 1] = Players.PlayerAdded:Connect(function(Player)
			repeat
				wait(0)
			until Player.Character

			self:Wrap(Player)
		end)

		for _, Player in next, Players:GetPlayers() do
			if Player == Players.LocalPlayer then
				continue
			end

			repeat
				wait(0)
			until Player.Character

			self:Wrap(Player)
		end
	end),

	Exit = LPH_NO_VIRTUALIZE(function(self)
		self.Config.Enabled = false
		self:Update()

		for _, Value in next, self.ServiceConnections do
			pcall(Value.Disconnect, Value)
		end
	end)
}

return Module