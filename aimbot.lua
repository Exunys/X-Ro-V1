--[[

	X-Ro - Aimbot Module

]]

--// Luraph Macros

if LPH_OBFUSCATED == nil then
	LPH_NO_VIRTUALIZE = function(...)
		return ...
	end

	LPH_JIT_MAX = function(...)
		return ...
	end
end

--// Cache

local game, workspace = game, workspace
local getrawmetatable, pcall, next, tick = getrawmetatable, pcall, next, tick
local Vector2new, Vector3zero, CFramenew, Color3fromRGB, Color3fromHSV, Drawingnew, TweenInfonew = Vector2.new, Vector3.zero, CFrame.new, Color3.fromRGB, Color3.fromHSV, Drawing and Drawing.new, TweenInfo.new
local mousemoverel, tablefind, tableremove, tableinsert, stringlower, stringsub, mathclamp, mathmax = mousemoverel or (Input and Input.MouseMove), table.find, table.remove, table.insert, string.lower, string.sub, math.clamp, math.max
local mouse1press, mouse1release, taskwait = mouse1press, mouse1release, task.wait

local GameMetatable = getrawmetatable and getrawmetatable(game) or {
	-- Auxillary functions - if the executor doesn't support "getrawmetatable".

	__index = LPH_NO_VIRTUALIZE(function(self, Index)
		return self[Index]
	end),

	__newindex = LPH_NO_VIRTUALIZE(function(self, Index, Value)
		self[Index] = Value
	end)
}

local __index = GameMetatable.__index
local __newindex = GameMetatable.__newindex

local getrenderproperty, setrenderproperty = getrenderproperty or __index, setrenderproperty or __newindex

local GetService = __index(game, "GetService")

--// Services

local RunService = GetService(game, "RunService")
local UserInputService = GetService(game, "UserInputService")
local TweenService = GetService(game, "TweenService")
local Players = GetService(game, "Players")

--// Service Methods

local LocalPlayer = __index(Players, "LocalPlayer")
local Camera = __index(workspace, "CurrentCamera")

local FindFirstChild, FindFirstChildOfClass = __index(game, "FindFirstChild"), __index(game, "FindFirstChildOfClass")
local GetDescendants = __index(game, "GetDescendants")
local GetChildren = __index(game, "GetChildren")
local IsA = __index(game, "IsA")
local WorldToViewportPoint = __index(Camera, "WorldToViewportPoint")
local GetPartsObscuringTarget = __index(Camera, "GetPartsObscuringTarget")
local GetMouseLocation = __index(UserInputService, "GetMouseLocation")
local GetPlayers = __index(Players, "GetPlayers")
local GetPlayerFromCharacter = __index(Players, "GetPlayerFromCharacter")
local Mouse = __index(LocalPlayer, "GetMouse")(LocalPlayer)
local CameraViewportSize = __index(Camera, "ViewportSize")

--// Variables

local ThaBronx = game.PlaceId == 9874911474 or game.PlaceId == 13453616108
local SafeZones = ThaBronx and workspace.NewSafeZone.Zones
local SafePlayers = {}

local RequiredDistance, Typing, Running, ServiceConnections, Animation, OriginalSensitivity = 2000, false, false, {}
local Connect, Disconnect = __index(game, "DescendantAdded").Connect

local ESP_Environment

do
	local TemporaryConnection = Connect(__index(game, "DescendantAdded"), function() end)
	Disconnect = TemporaryConnection.Disconnect
	Disconnect(TemporaryConnection)
end

--// Environment

local Environment = {
	DeveloperSettings = {
		UpdateMode = "RenderStepped",
		TeamCheckOption = "TeamColor",
		RainbowSpeed = 1 -- Bigger = Slower
	},

	Settings = {
		Enabled = true,

		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false,

		OffsetToMoveDirection = false,
		OffsetIncrement = 15,

		Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
		Sensitivity2 = 1, -- mousemoverel Sensitivity

		LockMode = 2, -- 1 = CFrame; 2 = mousemoverel
		LockPart = "Head", -- Body part to lock on

		TriggerKey = Enum.UserInputType.MouseButton2,
		Toggle = false
	},

	Triggerbot = {
		Enabled = false,

		TeamCheck = false,
		AliveCheck = true,
		AimLockedCheck = false,

		Delay = 0 -- Time it takes for the trigger bot to react / click (seconds).
	},

	ClosestPlayerTracer = {
		Enabled = true,
		Position = 3, -- 1 = Bottom; 2 = Center; 3 = Mouse

		Transparency = 0.9,
		Thickness = 1,

		RainbowColor = false,
		Color = Color3fromRGB(150, 150, 255)
	},

	FOVSettings = {
		Enabled = true,
		Visible = true,

		Radius = 180,
		NumSides = 60,

		Thickness = 1,
		Transparency = 1,
		Filled = false,

		RainbowColor = false,
		RainbowOutlineColor = false,
		Color = Color3fromRGB(0, 150, 90),
		OutlineColor = Color3fromRGB(0, 0, 0),
		LockedColor = Color3fromRGB(255, 150, 150)
	},

	Blacklisted = {},
	FOVCircleOutline = Drawingnew("Circle"),
	FOVCircle = Drawingnew("Circle"),
	Tracer = Drawingnew("Line")
}

repeat
	taskwait(0)
until Environment and Environment.FOVCircle and Environment.FOVCircleOutline

setrenderproperty(Environment.FOVCircle, "Visible", false)
setrenderproperty(Environment.FOVCircleOutline, "Visible", false)

--// Core Functions

local FixUsername = LPH_NO_VIRTUALIZE(function(String)
	for _, Value in next, GetPlayers(Players) do
		local Name = __index(Value, "Name")

		if stringsub(stringlower(Name), 1, #String) == stringlower(String) then
			return Name
		end
	end
end)

local GetRainbowColor = LPH_NO_VIRTUALIZE(function()
	local RainbowSpeed = Environment.DeveloperSettings.RainbowSpeed

	return Color3fromHSV(tick() % RainbowSpeed / RainbowSpeed, 1, 1)
end)

local ConvertVector = LPH_NO_VIRTUALIZE(function(Vector)
	return Vector2new(Vector.X, Vector.Y)
end)

local CancelLock = LPH_NO_VIRTUALIZE(function()
	Environment.Locked = nil

	setrenderproperty(Environment.FOVCircle, "Color", Environment.FOVSettings.Color)
	__newindex(UserInputService, "MouseDeltaSensitivity", OriginalSensitivity)

	if Animation then
		Animation:Cancel()
	end

	setrenderproperty(Environment.Tracer, "Visible", Environment.ClosestPlayerTracer.Enabled)
end)

local CheckPlayersInSafeZones = LPH_JIT_MAX(function()
	if ThaBronx then -- Tha Bronx 2 Check
		SafePlayers = {}

		for _, Player in next, GetPlayers(Players) do
			local Character = __index(Player, "Character")
			local HumanoidRootPart = Character and FindFirstChild(Character, "HumanoidRootPart")

			if not HumanoidRootPart then
				continue
			end

			for _, Zone in next, GetChildren(SafeZones) do
				if IsA(Zone, "Part") then
					local Distance = (__index(HumanoidRootPart, "Position") - __index(Zone, "Position")).Magnitude
					local ZoneSize = __index(Zone, "Size")
					local Threshold = mathmax(ZoneSize.X, ZoneSize.Y, ZoneSize.Z) / 2

					if Distance <= Threshold then
						tableinsert(SafePlayers, __index(Player, "Name"))
					end
				end
			end
		end
	end
end)

local GetClosestPlayer = LPH_NO_VIRTUALIZE(function(Aux, WallCheck, SafeZone)
	local Settings = Environment.Settings
	local LockPart = Settings.LockPart

	if not Environment.Locked or Aux then
		RequiredDistance = Environment.FOVSettings.Enabled and Environment.FOVSettings.Radius or 2000
		Required3DDistance = 10000

		for _, Value in next, GetPlayers(Players) do
			local Character = __index(Value, "Character")
			local Humanoid = Character and FindFirstChildOfClass(Character, "Humanoid")

			if Value ~= LocalPlayer and not tablefind(Environment.Blacklisted, __index(Value, "Name")) and Character and FindFirstChild(Character, LockPart) and Humanoid then
				local PartPosition, TeamCheckOption = __index(Character[LockPart], "Position"), Environment.DeveloperSettings.TeamCheckOption

				if Settings.TeamCheck and __index(Value, TeamCheckOption) == __index(LocalPlayer, TeamCheckOption) then
					continue
				end

				if Settings.AliveCheck and __index(Humanoid, "Health") <= 0 then
					continue
				end

				if Settings.WallCheck or Aux and WallCheck then
					local BlacklistTable = GetDescendants(__index(LocalPlayer, "Character"))

					for _, _Value in next, GetDescendants(Character) do
						BlacklistTable[#BlacklistTable + 1] = _Value
					end

					if #GetPartsObscuringTarget(Camera, {PartPosition}, BlacklistTable) > 0 then
						continue
					end
				end

				if Aux and SafeZone and ThaBronx and tablefind(SafePlayers, __index(Value, "Name")) then -- Tha Bronx 2 - Silent Aim: Safe Zone Check
					continue
				end

				local Vector, OnScreen, Distance = WorldToViewportPoint(Camera, PartPosition)
				Vector = ConvertVector(Vector)
				Distance = (GetMouseLocation(UserInputService) - Vector).Magnitude

				local _3DDistance = (__index(Camera, "CFrame").Position - PartPosition).Magnitude

				if Distance < RequiredDistance and _3DDistance < Required3DDistance and OnScreen then
					RequiredDistance, Required3DDistance, Environment.Locked = Distance, _3DDistance, not Aux and Value

					return Aux and Value
				end
			end
		end
	elseif (GetMouseLocation(UserInputService) - ConvertVector(WorldToViewportPoint(Camera, __index(__index(__index(Environment.Locked, "Character"), LockPart), "Position")))).Magnitude > RequiredDistance then
		CancelLock()
	end
end)

local Load = function(ESP)
	if not ESP or not ESP.GetCameraCFrame then
		return warn("X-RO_AIMBOT > Critical error - Couldn't fetch crucial assets to launch!")
	end

	ESP_Environment = ESP

	OriginalSensitivity = __index(UserInputService, "MouseDeltaSensitivity")

	local Settings, Triggerbot, Tracer, FOVCircle, FOVCircleOutline, TracerSettings, FOVSettings, Offset = Environment.Settings, Environment.Triggerbot, Environment.Tracer, Environment.FOVCircle, Environment.FOVCircleOutline, Environment.ClosestPlayerTracer, Environment.FOVSettings
	local OffsetToMoveDirection, LockPart = Settings.OffsetToMoveDirection, Settings.LockPart

	local DeveloperSettings = Environment.DeveloperSettings
	local UpdateMode = DeveloperSettings.UpdateMode
	local TeamCheckOption = DeveloperSettings.TeamCheckOption

	if ThaBronx then
		spawn(LPH_NO_VIRTUALIZE(function()
			while taskwait(1) do
				CheckPlayersInSafeZones()
			end
		end))
	end

	if mouse1press and mouse1release then
		ServiceConnections.Triggerbot = Connect(__index(RunService, UpdateMode), LPH_NO_VIRTUALIZE(function()
			if Triggerbot.Enabled and Mouse.Target then
				local Character = Mouse.Target.Parent
				local Humanoid = FindFirstChildOfClass(Character, "Humanoid")
				local Player = GetPlayerFromCharacter(Players, Character)

				if Character and Humanoid and Player then
					if Triggerbot.TeamCheck and __index(Player, TeamCheckOption) == __index(LocalPlayer, TeamCheckOption) then
						return
					end

					if Triggerbot.AliveCheck and __index(Humanoid, "Health") <= 0 then
						return
					end

					if Triggerbot.AimLockedCheck and not Environment.Locked then
						return
					end

					if Triggerbot.Delay ~= 0 then
						taskwait(Triggerbot.Delay)
					end

					mouse1press(); taskwait(0); mouse1release()
				end
			end
		end))
	else
		warn("X-RO_AIMBOT > Your script execution software does not support this module's trigger bot feature.")
	end

	ServiceConnections.UpdateTracer = Connect(__index(RunService, UpdateMode), LPH_NO_VIRTUALIZE(function()
		local ClosestPlayer = TracerSettings.Enabled and Settings.Enabled and GetClosestPlayer(true)

		if ClosestPlayer then
			setrenderproperty(Tracer, "Visible", true)

			for Index, Value in next, TracerSettings do
				if Index == "Color" then
					continue
				end

				if pcall(getrenderproperty, Tracer, Index) then
					setrenderproperty(Tracer, Index, Value)
				end
			end

			setrenderproperty(Tracer, "Color", TracerSettings.RainbowColor and GetRainbowColor() or TracerSettings.Color)

			--[[
			if TracerSettings.Position == 1 then
				setrenderproperty(Tracer, "From", Vector2new(CameraViewportSize.X / 2, CameraViewportSize.Y))
			elseif TracerSettings.Position == 2 then
				setrenderproperty(Tracer, "From", CameraViewportSize / 2)
			elseif TracerSettings.Position == 3 then
				setrenderproperty(Tracer, "From", GetMouseLocation(UserInputService))
			else
				TracerSettings.Position = 3
			end
			]]

			setrenderproperty(Tracer, "From", GetMouseLocation(UserInputService))
			setrenderproperty(Tracer, "To", ConvertVector(WorldToViewportPoint(Camera, __index(__index(ClosestPlayer, "Character")[Settings.LockPart], "Position"))))
		else
			setrenderproperty(Tracer, "Visible", false)
		end
	end))

	ServiceConnections.RenderSteppedConnection = Connect(__index(RunService, UpdateMode), LPH_NO_VIRTUALIZE(function()
		if FOVSettings.Enabled and Settings.Enabled then
			for Index, Value in next, FOVSettings do
				if Index == "Color" then
					continue
				end

				if pcall(getrenderproperty, FOVCircle, Index) then
					setrenderproperty(FOVCircle, Index, Value)
					setrenderproperty(FOVCircleOutline, Index, Value)
				end
			end

			setrenderproperty(FOVCircle, "Color", (Environment.Locked and FOVSettings.LockedColor) or FOVSettings.RainbowColor and GetRainbowColor() or FOVSettings.Color)
			setrenderproperty(FOVCircleOutline, "Color", FOVSettings.RainbowOutlineColor and GetRainbowColor() or FOVSettings.OutlineColor)

			setrenderproperty(FOVCircleOutline, "Thickness", FOVSettings.Thickness + 1)
			setrenderproperty(FOVCircle, "Position", GetMouseLocation(UserInputService))
			setrenderproperty(FOVCircleOutline, "Position", GetMouseLocation(UserInputService))
		else
			setrenderproperty(FOVCircle, "Visible", false)
			setrenderproperty(FOVCircleOutline, "Visible", false)
		end

		if Running and Settings.Enabled then
			GetClosestPlayer()

			Offset = OffsetToMoveDirection and __index(FindFirstChildOfClass(__index(Environment.Locked, "Character"), "Humanoid"), "MoveDirection") * (mathclamp(Settings.OffsetIncrement, 1, 30) / 10) or Vector3zero

			if Environment.Locked then
				local LockedPosition_Vector3 = __index(__index(Environment.Locked, "Character")[LockPart], "Position")
				local LockedPosition = WorldToViewportPoint(Camera, LockedPosition_Vector3 + Offset)

				if Settings.LockMode == 2 then
					mousemoverel((LockedPosition.X - GetMouseLocation(UserInputService).X) / Settings.Sensitivity2, (LockedPosition.Y - GetMouseLocation(UserInputService).Y) / Settings.Sensitivity2)
				else
					if Settings.Sensitivity > 0 then
						Animation = TweenService:Create(Camera, TweenInfonew(Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFramenew(Camera.CFrame.Position, LockedPosition_Vector3 + Offset)})
						Animation:Play()
					else
						__newindex(Camera, "CFrame", CFramenew(Camera.CFrame.Position, LockedPosition_Vector3 + Offset))
					end

					ESP.GetCameraCFrame()

					__newindex(UserInputService, "MouseDeltaSensitivity", 0)
				end

				setrenderproperty(FOVCircle, "Color", FOVSettings.LockedColor)
				setrenderproperty(Tracer, "Visible", false)
			end
		end
	end))

	ServiceConnections.InputBeganConnection = Connect(__index(UserInputService, "InputBegan"), LPH_NO_VIRTUALIZE(function(Input)
		local TriggerKey, Toggle = Settings.TriggerKey, Settings.Toggle

		if Typing then
			return
		end

		if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == TriggerKey or Input.UserInputType == TriggerKey then
			if Toggle then
				Running = not Running

				if not Running then
					CancelLock()
				end
			else
				Running = true
			end
		end
	end))

	ServiceConnections.InputEndedConnection = Connect(__index(UserInputService, "InputEnded"), LPH_NO_VIRTUALIZE(function(Input)
		local TriggerKey, Toggle = Settings.TriggerKey, Settings.Toggle

		if Toggle or Typing then
			return
		end

		if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == TriggerKey or Input.UserInputType == TriggerKey then
			Running = false
			CancelLock()
		end
	end))
end

--// Typing Check

ServiceConnections.TypingStartedConnection = Connect(__index(UserInputService, "TextBoxFocused"), function()
	Typing = true
end)

ServiceConnections.TypingEndedConnection = Connect(__index(UserInputService, "TextBoxFocusReleased"), function()
	Typing = false
end)

--// Functions

repeat
	taskwait(0)
until Environment and Load

LPH_NO_VIRTUALIZE(function()
	function Environment.Exit(self) -- METHOD | Environment:Exit(<void>)
		assert(self, "X-RO_AIMBOT.Exit: Missing parameter #1 \"self\" <table>.")

		for Index, _ in next, ServiceConnections do
			pcall(Disconnect, ServiceConnections[Index])
		end

		Load = nil; ConvertVector = nil; CancelLock = nil; GetClosestPlayer = nil; GetRainbowColor = nil; FixUsername = nil

		self.FOVCircle:Remove()
		self.FOVCircleOutline:Remove()
		self.Tracer:Remove()

		Environment = nil
	end

	function Environment.Restart() -- Environment.Restart(<void>)
		if not ESP_Environment then
			return
		end

		for Index, _ in next, ServiceConnections do
			pcall(Disconnect, ServiceConnections[Index])
		end

		Load(ESP_Environment)
	end

	function Environment.Blacklist(self, Username) -- Environment:Blacklist(<string> Player Name)
		assert(self, "X-RO_AIMBOT.Blacklist: Missing parameter #1 \"self\" <table>.")
		assert(Username, "X-RO_AIMBOT.Blacklist: Missing parameter #2 \"Username\" <string>.")

		Username = FixUsername(Username)

		assert(self, "X-RO_AIMBOT.Blacklist: User "..Username.." couldn't be found.")

		self.Blacklisted[#self.Blacklisted + 1] = Username
	end

	function Environment.Whitelist(self, Username) -- Environment:Whitelist(<string> Player Name)
		assert(self, "X-RO_AIMBOT.Whitelist: Missing parameter #1 \"self\" <table>.")
		assert(Username, "X-RO_AIMBOT.Whitelist: Missing parameter #2 \"Username\" <string>.")

		Username = FixUsername(Username)

		assert(Username, "X-RO_AIMBOT.Whitelist: User "..Username.." couldn't be found.")

		local Index = tablefind(self.Blacklisted, Username)

		assert(Index, "X-RO_AIMBOT.Whitelist: User "..Username.." is not blacklisted.")

		tableremove(self.Blacklisted, Index)
	end

	function Environment.GetClosestPlayer(...) -- Environment.GetClosestPlayer(<boolean> Wall Check, <boolean> Safe Zone (Tha Bronx 2))
		return GetClosestPlayer(true, ...)
	end

	Environment.Load = Load -- Environment.Load()
end)()

repeat
	taskwait(0)
until Environment and Environment.Load

return Environment