--[[

	X-Ro - Tha Bronx 2

]]

if not XRO_LOADING or not game.PlaceId == 9874911474 or not game.PlaceId == 13453616108 then
	return warn("X-RO_THA_BRONX_2 > Authentication failed (possible tampering), execution terminated.")
end

local Start = tick()

--// Luraph Macros

if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(...)
		return ...
	end

	LPH_JIT_MAX = LPH_JIT_MAX or function(...)
		return ...
	end
end

--// Cache

local Support = hookmetamethod and newcclosure and checkcaller and getcallingscript and getnamecallmethod
local RequireSupport = type(select(2, pcall(require, game:GetService("ReplicatedStorage").BlacklistedMarketTools))) == "table"
local GetREnvSupport = type(select(2, pcall(function() return getrenv().shared.Wokeness end))) == "number"

--[[

if Support then -- Adonis Anti-Cheat Bypass
	for Index, Value in next, getgc(true) do
		if pcall(function() return rawget(Value, "indexInstance") end) and type(rawget(Value, "indexInstance")) == "table" and (rawget(Value, "indexInstance"))[1] == "kick" then
			Value.tvk = {"kick", function()
				return workspace:WaitForChild("")
			end}
		end
	end
end

]]

local cloneref = cloneref or LPH_NO_VIRTUALIZE(function(...)
	return ...
end)

local _fireproximityprompt, mouse1click, getrenv, getgenv, getgc, hookfunction, identifyexecutor = fireproximityprompt, mouse1click, getrenv, getgenv, getgc, hookfunction, identifyexecutor
local Vector3zero, CFramenew = Vector3.zero, CFrame.new
local stringmatch, stringgsub = string.match, string.gsub
local wait, spawn, delay = task.wait, task.spawn, task.delay
local tick, newproxy, getmetatable, next, select = tick, newproxy, getmetatable, next, select
local mathrandom = math.random
local getinfo = debug.getinfo

--// References

local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

fireproximityprompt = LPH_NO_VIRTUALIZE(function(Prompt, DisableOrienting)
	if not DisableOrienting then
		Camera.CFrame = CFramenew(Camera.CFrame.Position, Prompt.Parent.CFrame.Position)
	end

	_fireproximityprompt(Prompt)
end)

local Backpack = LocalPlayer:FindFirstChild("Backpack")

local Dollas = workspace:WaitForChild("Dollas")
local DirtPiles = workspace:WaitForChild("DirtPiles")
local Storage = workspace:WaitForChild("Storage")
local Washers = workspace:WaitForChild("Washerr")

local BronxPawningGUI = LocalPlayer.PlayerGui["Bronx PAWNING"]

local PawnRemote = ReplicatedStorage:WaitForChild("PawnRemote")
local ShopRemote = ReplicatedStorage:WaitForChild("ShopRemote")
local ExoticShopRemote = ReplicatedStorage:WaitForChild("ExoticShopRemote")
local BankProcessRemote = ReplicatedStorage:WaitForChild("BankProcessRemote")
local BankAction = ReplicatedStorage:WaitForChild("BankAction")
local DamagePlayer = ReplicatedStorage:WaitForChild("DamagePlayer")
local RespawnRE = ReplicatedStorage:WaitForChild("RespawnRE")
local BackpackRemote = ReplicatedStorage:WaitForChild("BackpackRemote")
local ListWeaponRemote = ReplicatedStorage:WaitForChild("ListWeaponRemote")
local BuyItemRemote = ReplicatedStorage:WaitForChild("BuyItemRemote")
local FSpamRemote = ReplicatedStorage:WaitForChild("FSpamRemote")
local Inventory = ReplicatedStorage:WaitForChild("Inventory")

return function(TB2Connections, ThaBronxTab, SendNotification, FlySettings, Aimbot)

	--// Sections

	local TBFarmsSection = ThaBronxTab:CreateSection("Farms")
	local TBCombat = Support and ThaBronxTab:CreateSection("Combat")
	local TBMods = ThaBronxTab:CreateSection("Character Modifications")
	local TBMisc = ThaBronxTab:CreateSection("Miscellaneous")
	local TBPurchaseItems = ThaBronxTab:CreateSection("Quick Shop")
	local TBLocationsSection = ThaBronxTab:CreateSection("Teleports")

	--// Variables

	local Debounce = false
	local CleaningDebounce = false
	local CashAmountInput = 0
	local LastCookedRice = tick()
	local LastReceivedGrass = tick()
	local Threshold = 15
	local BeamProperties = {
		FaceCamera = true,
		Enabled = true,
		ZOffset = -1,
		TextureMode = Enum.TextureMode.Wrap,
		TextureSpeed = 8,
		LightEmission = 1,
		LightInfluence = 1,
		TextureLength = 12
	}

	local ThaBronxConfig = {
		Collecting = false,
		LootBags = false,
		MopJob = false,
		InstantPrompts = false,
		DisableScreenEffects = false,
		CameraBobbing = false,
		PickUpDrops = false,
		AutoBuyRice = false,
		AutoBuySeeds = false,
		GodMode = false,
		InstantRevive = false,
		NoJumpCooldown = false,
		AutoCookRice = false,
		AutoPlantSeeds = false,
		AutoSellRice = false,
		AutoSellGrass = false,
		InstantRespawn = false,
		InfiniteSleep = false,
		InfiniteHunger = false,
		NoRentPay = false,
		NoFallDamage = false,
		AutoDuplicate = false,
		StoreDupe = true,

		Modifications = newproxy(true),
		_Modifications = {
			InfiniteAmmo = false,
			FastFireRate = false,
			FullAuto = false,
			--OneTap = false,
			--NoRecoil = false,
			NoSpread = false,
			NoJam = false,
			InstantReload = false,
			InstantEquip = false,
			Lifesteal = false,
		},

		BulletTracers = {
			Enabled = false,
			Color = Color3.fromRGB(150, 50, 250),
			Transparency = 0.7,
			Thickness = 0.1,
			Lifetime = 2,
			Fade = false,
			RainbowColor = false
		},

		SilentAim = {
			Enabled = false,
			AutoShoot = false,
			WallCheck = false,
			SafeZone = false,
			HitChance = 100
		}
	}

	local OldWeaponValues = {}
	local Items, Wrapped, SilentAimWrapped, ItemsWrapped = {}, {}, {}, false

	local Locations = {
		["Gun Shop (Safe Zone)"] = CFramenew(92990, 122100, 16985),
		["Second Gun Shop (Safe Zone)"] = CFramenew(66200, 123615, 5750),
		["Car Dealer (Safe Zone)"] = CFramenew(-443, 253, -1251),
		["Hotel"] = CFramenew(-1000, 255, -565),
		["IceBox"] = CFramenew(-197, 283, -1257),
		["DripStore (Safe Zone)"] = CFramenew(67460, 10490, 555),
		["Deli Market"] = CFramenew(-895, 255, -830),
		["Laundromat (Safe Zone)"] = CFramenew(-975, 255, -690),
		["Captial One Bank"] = CFramenew(-185, 283, -1222),
		["Exotic Dealer / Grass House (Safe Zone)"] = CFramenew(-1520, 272, -984),
		["Coffee Shop (Safe Zone)"] = CFramenew(-1610, 255, -1135),
		["Basketball Court (Safe Zone)"] = CFramenew(-1055, 250, -500),
		["Rice Seller (Safe Zone)"] = CFramenew(36890, 14075, 5850),
		["Roof Top / Bank Tools (Safe Zone)"] = CFramenew(-477, 325, -568),
		["Rice Buyer [Sewer] (Safe Zone)"] = CFramenew(81065, 133135, 170),
		["Casino (Safe Zone)"] = CFramenew(92135, 121860, -16155),
		["Studio (Safe Zone)"] = CFramenew(72420, 128855, -1080),
		["Grass Buyer"] = CFramenew(-630, 253, -759),
		["Second IceBox (Safe Zone)"] = CFramenew(-747, 254, -1034),
		["Domino's"] = CFramenew(-745, 253, -945),
		["Switch Shop (Safe Zone)"] = CFramenew(60838, 87609, -351)
	}

	--// Functions

	local GetCharacter = LPH_NO_VIRTUALIZE(function()
		return LocalPlayer.Character or workspace:FindFirstChild(LocalPlayer.Name)
	end)

	local GetAllTools = LPH_NO_VIRTUALIZE(function(LocalToolsOnly)
		local Result = {}

		for _, Value in next, {not LocalToolsOnly and Lighting, LocalPlayer.Backpack, GetCharacter()} do
			if type(Value) == "userdata" then
				for _, _Value in next, Value:GetChildren() do
					Result[#Result + 1] = _Value
				end
			end
		end

		return Result
	end)

	local GetBalance = LPH_NO_VIRTUALIZE(function(Dirty)
		if not Dirty then
			return LocalPlayer.stored.Money.Value
		else
			return LocalPlayer.stored.DirtyMoney.Value
		end
	end)

	local FirePrompt = LPH_NO_VIRTUALIZE(function(Prompt)
		Prompt.HoldDuration = 0
		Prompt.RequiresLineOfSight = false
		fireproximityprompt(Prompt)
		wait(0)
	end)

	local GetRainbowColor = LPH_NO_VIRTUALIZE(function()
		return Color3.fromHSV(tick() % 2.5, 1, 1)
	end)

	local Teleport = LPH_NO_VIRTUALIZE(function(NewCFrame)
		local Character = GetCharacter()

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not Humanoid or Humanoid.Health <= 0 then
			return
		end

		if Humanoid.MoveDirection ~= Vector3zero then
			SendNotification("X-Ro | Tha Bronx 2", "Waiting for the character to stop running before teleporting.", 3)
		end

		repeat
			wait(0)
		until Humanoid.MoveDirection == Vector3zero

		--// Clipping Check

		--[[
		local OldCanCollides = {}
		local Index = 0

		for _, Value in next, HumanoidRootPart:GetTouchingParts() do
			Index += 1

			OldCanCollides[Index] = Value.CanCollide

			Value.CanCollide = false

			SendNotification("", Value.Name, 2)

			delay(1, function()
				Value.CanCollide = OldCanCollides[Index]
			end)
		end
		]]

		HumanoidRootPart.CFrame = NewCFrame
		HumanoidRootPart.CFrame = CFramenew(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y + 0.5, HumanoidRootPart.Position.Z)
	end)

	local HouseRob = LPH_JIT_MAX(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local Available = false
		local FolderWithItems

		for Index = 1, 3 do
			for _, Value in next, workspace.HouseRobb:GetChildren() do
				if not Value:IsA("Folder") or Value.Name == "HardDoor" then
					continue
				end

				Available, FolderWithItems = Value.Door.WoodenDoor.Transparency == 0, Value

				if Available then
					break
				end
			end

			if Available then
				Debounce = true

				local OldNoClipValue = XRO_NoClip

				XRO_NoClip = true

				local WoodenDoor = FolderWithItems.Door.WoodenDoor
				local Prompt = WoodenDoor:FindFirstChildOfClass("ProximityPrompt")

				repeat
					Teleport(CFramenew(WoodenDoor.Position.X - 2.5, WoodenDoor.Position.Y + 2.5, WoodenDoor.Position.Z)) -- Offset coordinates so we don't glitch through the door.
					FirePrompt(Prompt) -- Break door
				until FolderWithItems.Door.WoodenDoor.Transparency > 0

				local Profit = 0

				workspace.HouseRobb["Cafeteria Table"].CanCollide = false

				for _, _Value in next, {"TakeMoney", "TakeTool"} do
					repeat
						wait(0)
					until FolderWithItems:FindFirstChild(_Value)

					for _, Value in next, FolderWithItems[_Value]:GetChildren() do
						Prompt = (_Value == "TakeMoney" and Value or Value.SugarBox):FindFirstChildOfClass("ProximityPrompt")

						Prompt.Parent.CanCollide = false

						repeat
							Teleport(Prompt.Parent.CFrame)
							FirePrompt(Prompt) -- Take Money / Tool
						until Prompt.Parent.Transparency > 0

						Profit += Prompt.Parent.Name == "MoneyGrab" and 300 or 0
					end
				end

				Available = false

				XRO_NoClip = OldNoClipValue

				SendNotification("X-Ro | Tha Bronx 2", "("..tostring(Index).." / 3) House robbing done, made $"..tostring(Profit), 2)
			else
				SendNotification("X-Ro | Tha Bronx 2", "("..tostring(Index).." / 3) House robbing unavailable. ", 2)
			end
		end

		Teleport(OldCFrame); Debounce = false
	end)

	local CollectLootable = LPH_JIT_MAX(function(Object)
		repeat
			wait(0) -- Wait until the function in action finishes before collecting the cash / loot bag
		until not Debounce

		if not Object:IsDescendantOf(workspace) then -- Check if the cash / loot bag is still available after the previous function finishes
			return
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame
		local ProximityPrompt = Object:FindFirstChildOfClass("ProximityPrompt")

		--local OldNoClipValue = XRO_NoClip

		--XRO_NoClip = true

		repeat
			if not Object or not Object:IsDescendantOf(workspace) or not Object.CFrame then
				SendNotification("X-Ro | Tha Bronx 2", "Critical error, the object that was selected to be collected is corrupted! Action canceled.", 4)
				break
			end

			Teleport(Object.CFrame)
			FirePrompt(ProximityPrompt)
		until not Object:IsDescendantOf(workspace)

		--XRO_NoClip = OldNoClipValue

		Teleport(OldCFrame); Debounce = false
	end)

	local SearchDumpsters = LPH_JIT_MAX(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		Debounce = true

		Backpack = LocalPlayer:FindFirstChild("Backpack")

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local OldNoClipValue, OldFlyValue = XRO_NoClip, FlySettings.Enabled

		XRO_NoClip = true
		FlySettings.Enabled = true

		local OldBackpackSize = #Backpack:GetChildren()

		for _, Value in next, workspace:GetDescendants() do
			if not Value:IsA("ProximityPrompt") then
				continue
			end

			local PreviousBackpackSize = #Backpack:GetChildren()

			if Value.Parent and Value.Parent.Name == "DumpsterPromt" and Value.ActionText == "Search" then
				local Tries = 0

				repeat
					if HumanoidRootPart.Parent:FindFirstChildOfClass("Humanoid").Health <= 0 then
						SendNotification("X-Ro | Tha Bronx 2", "Critical error, action canceled early.", 2)
						break
					end

					Teleport(Value.Parent.CFrame)
					Value.HoldDuration = 0
					fireproximityprompt(Value)
					Tries += 1; wait(0)
				until Tries > 5 or #Backpack:GetChildren() > PreviousBackpackSize
			end
		end

		local ItemsFound = #Backpack:GetChildren() - OldBackpackSize

		SendNotification("X-Ro | Tha Bronx 2", ItemsFound > 0 and "Found "..tostring(ItemsFound).." items!" or "No items found during search!", 2)

		FlySettings.Enabled = OldFlyValue
		XRO_NoClip = OldNoClipValue

		Teleport(OldCFrame); Debounce = false
	end)

	local SellPawn = LPH_JIT_MAX(function()
		Backpack = LocalPlayer:FindFirstChild("Backpack")

		local _Items, OldBalance = #Backpack:GetChildren(), GetBalance()

		for _, Value in next, BronxPawningGUI.Frame.Holder.List:GetChildren() do
			if not Value:IsA("Frame") then
				continue
			end

			local Index = Value.Item.Text

			while LocalPlayer.Backpack:FindFirstChild(Index) do
				PawnRemote:FireServer(Index); wait(0) -- Sell item
			end
		end

		_Items -= #Backpack:GetChildren()

		SendNotification("X-Ro | Tha Bronx 2", _Items > 0 and "Sold "..tostring(_Items).." items and made $"..tostring(GetBalance() - OldBalance).."!" or "No items to sell!", 2)
	end)

	local FarmMopJob = LPH_JIT_MAX(function()
		if not ThaBronxConfig.MopJob then
			return
		end

		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		--// Start Job

		if not Backpack:FindFirstChild("Mop") or not GetCharacter():FindFirstChild("Mop") then
			Teleport(CFramenew(-741, 254, -1008))

			local Prompt = workspace:FindFirstChild("Janitor Bucket").ProxPart:FindFirstChildOfClass("ProximityPrompt")

			for _ = 1, 5 do
				FirePrompt(Prompt)
			end

			if Backpack:FindFirstChild("Mop") then
				GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Backpack:FindFirstChild("Mop"))
			end
		end

		--// Mop

		while ThaBronxConfig.MopJob and wait(0) do
			for _, Value in next, DirtPiles:GetChildren() do
				if Value.Parent ~= DirtPiles then
					continue
				end

				Prompt = Value:FindFirstChild("Attachment")

				if Prompt then
					Prompt = Prompt:FindFirstChildOfClass("ProximityPrompt")
				else
					continue
				end

				repeat
					Teleport(CFramenew(Value.Position.X, Value.Position.Y + 2, Value.Position.Z))
					FirePrompt(Prompt)
					ReplicatedStorage.DirtHandler:FireServer("CleanPile"); wait(0)
				until Value.Parent ~= DirtPiles or not ThaBronxConfig.MopJob

				break
			end
		end

		Teleport(OldCFrame); Debounce = false
	end)

	local CleanMoney = LPH_JIT_MAX(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		if CleaningDebounce then
			return SendNotification("X-Ro | Tha Bronx 2", "Your money is already being cleaned, please be patient!", 4)
		end

		if GetBalance(true) <= 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "No money to clean!", 4)
		end

		Debounce, CleaningDebounce = true, true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local CurrentAction, Prompt

		for _, Value in next, Washers:GetChildren() do
			if Value.Name == "Washers" and Value.Wa:FindFirstChildOfClass("ProximityPrompt").Enabled then
				CurrentAction, Prompt = Value.Wa, Value.Wa:FindFirstChildOfClass("ProximityPrompt")
				break
			end
		end

		local OldNoClipValue = XRO_NoClip
		local Position = CurrentAction.CFrame.Position

		XRO_NoClip = true

		--// Wash Money

		repeat
			Teleport(CFramenew(Position.X, 253, Position.Z + 3))
			FirePrompt(Prompt)
		until not Prompt.Enabled

		Debounce, XRO_NoClip = false, OldNoClipValue

		Teleport(OldCFrame) -- Go back until the money is washed

		--// Grab Washed Money

		repeat
			wait(0)
		until (Prompt.ObjectText == "Grab Money" and Prompt.ActionText == LocalPlayer.Name) and not Debounce and GetCharacter() and GetCharacter():FindFirstChildOfClass("Humanoid").Health > 0

		OldCFrame = HumanoidRootPart.CFrame

		repeat
			Teleport(CFramenew(Position.X, 253, Position.Z + 3)) -- Teleport back to washer
			FirePrompt(Prompt)
		until Prompt.ObjectText == "Wash Money"

		OldNoClipValue = XRO_NoClip

		Debounce, XRO_NoClip = true, true

		--// Dry Money

		for _, Value in next, Washers:GetChildren() do
			if Value.Name == "Dryer" and Value.Wa:FindFirstChildOfClass("ProximityPrompt").Enabled then
				CurrentAction, Prompt = Value.Wa, Value.Wa:FindFirstChildOfClass("ProximityPrompt")
				break
			end
		end

		Position = CurrentAction.CFrame.Position

		repeat
			Teleport(CFramenew(Position.X, Position.Y, Position.Z - 3))
			FirePrompt(Prompt)
		until not Prompt.Enabled

		Debounce, XRO_NoClip = false, OldNoClipValue

		Teleport(OldCFrame) -- Go back until the money is dried

		--// Grab Dried Money

		repeat
			wait(0)
		until (Prompt.ObjectText == "Grab Money" and Prompt.ActionText == LocalPlayer.Name) and not Debounce and GetCharacter() and GetCharacter():FindFirstChildOfClass("Humanoid").Health > 0

		OldCFrame = HumanoidRootPart.CFrame

		repeat
			if GetCharacter():FindFirstChildOfClass("Humanoid").Health <= 0 then
				return SendNotification("X-Ro | Tha Bronx 2", "Critical error occured. Couldn't pick up dried money!", 4)
			end

			Teleport(CFramenew(Position.X, 253, Position.Z - 3)) -- Teleport back to dryer
			FirePrompt(Prompt)
		until Prompt.ObjectText == "Dry Money"

		OldNoClipValue = XRO_NoClip

		Debounce, CleaningDebounce, XRO_NoClip = true, true, true

		--// Deposit Dried Money

		Prompt = workspace.SellDirtyMoney.Prompt

		repeat
			if Backpack:FindFirstChild("CleanedMoney") then
				GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Backpack:FindFirstChild("CleanedMoney"))
			end

			Teleport(CFramenew(-182.46022, 283.632874, -1201.07849, -0.0125604281, -9.75196901e-09, -0.999921143, -1.77800104e-08, 1, -9.52939594e-09, 0.999921143, 1.76589143e-08, -0.0125604281))
			FirePrompt(Prompt)
		until not Backpack:FindFirstChild("CleanedMoney") and not GetCharacter():FindFirstChild("CleanedMoney")

		XRO_NoClip = OldNoClipValue

		for _ = 1, 5 do
			Teleport(OldCFrame)
		end

		Debounce, CleaningDebounce = false, false
	end)

	local DuplicateItem = LPH_JIT_MAX(function(RetrieveItem)
		if not GetCharacter():FindFirstChildOfClass("Tool") then
			return SendNotification("X-Ro | Tha Bronx 2", "You must equip an item before running this action!", 3)
		end

		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		Debounce = true

		local GunName = GetCharacter():FindFirstChildOfClass("Tool").Name

		GetCharacter():FindFirstChildOfClass("Humanoid"):UnequipTools()

		local Safe = workspace["1# Map"]["2 Crosswalks"].Safes:GetChildren()[13]
		local OldCFrame = GetCharacter():FindFirstChild("HumanoidRootPart").CFrame

		Teleport(Safe.Union.CFrame)

		wait(0.5)

		spawn(function()
			BackpackRemote:InvokeServer("Store", GunName)
		end)

		spawn(function()
			Inventory:FireServer("Change", GunName, "Backpack", Safe)
		end)

		--[[

		wait(0.5); Teleport(OldCFrame);

		wait(1.2)

		BackpackRemote:InvokeServer("Grab", GunName)

		Debounce = false

		SendNotification("X-Ro | Tha Bronx 2", "Your duped item is in your safe!", 5)

		]]

		wait(2)

		BackpackRemote:InvokeServer("Grab", GunName)

		if RetrieveItem or ThaBronxConfig.StoreDupe then
			Inventory:FireServer("Change", GunName, "Inv", Safe)
		end

		wait(0.5); Teleport(OldCFrame); Debounce = false

		if not RetrieveItem and not ThaBronxConfig.StoreDupe then
			SendNotification("X-Ro | Tha Bronx 2", "The duplicated item is in your safe!", 5)
		end
	end)

	local BuyRice = LPH_JIT_MAX(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		if tonumber(stringmatch(workspace.GUNS.RiceBag.Over.Sign.SurfaceGui.SIGN.Text, "%d+")) == 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "No rice bags available!", 2)
		end


		if (GetBalance() - 3500) < 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "Insufficient funds!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local Prompt = workspace.GUNS.RiceBag.Over.Sign:FindFirstChildOfClass("ProximityPrompt")

		Backpack = LocalPlayer:FindFirstChild("Backpack")

		local OldBackpackSize = #Backpack:GetChildren()

		repeat
			Teleport(CFramenew(36890.332, 14073.4951, 5841.46289, 0.00953349005, 5.16230116e-08, -0.999954581, 7.45054223e-08, 1, 5.23356896e-08, 0.999954581, -7.50009761e-08, 0.00953349005))

			FirePrompt(Prompt)

			if tonumber(stringmatch(workspace.GUNS.RiceBag.Over.Sign.SurfaceGui.SIGN.Text, "%d+")) == 0 or HumanoidRootPart.Parent:FindFirstChildOfClass("Humanoid").Health <= 0 then
				SendNotification("X-Ro | Tha Bronx 2", "Critical error occured, please retry the action!", 2); break
			end
		until #Backpack:GetChildren() > OldBackpackSize

		Teleport(OldCFrame); Debounce = false
	end)

	local CookRice = LPH_NO_VIRTUALIZE(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		Backpack = LocalPlayer:FindFirstChild("Backpack")

		local Tool

		for _, Value in next, Backpack:GetChildren() do
			if Value:IsA("Tool") and Value.Name == "RiceBag" then
				Tool = Value; break
			end
		end

		Tool = Tool or GetCharacter():FindFirstChild("RiceBag")

		if not Tool then
			return SendNotification("X-Ro | Tha Bronx 2", "You don't own any rice bags!", 2)
		end

		local Available, Stoves = 0, {}

		for _, Value in next, workspace["No-Steal Pots"]:GetChildren() do
			local _Value = Value.Pront.CookPart

			if _Value.Fire1.ParticleEmitter.Enabled or _Value:FindFirstChildOfClass("ProximityPrompt").ActionText == "Pick Up!" then
				continue
			end

			Available +=  1
			Stoves[#Stoves + 1] = _Value
		end

		if Available == 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "No stoves available!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local RiceToCook, RiceCooked = 0, 0

		for _, Value in next, Stoves do
			if Value.Fire1.ParticleEmitter.Enabled then
				continue
			end

			Teleport(Value.CFrame)

			if not GetCharacter():FindFirstChild("RiceBag") then
				if Backpack:FindFirstChild("RiceBag") then
					GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Backpack:FindFirstChild("RiceBag"))
				else
					break
				end
			end

			local Prompt = Value:FindFirstChildOfClass("ProximityPrompt")

			local TimeElapsed = tick()

			repeat
				if Prompt.ActionText == "Pick Up!" or Value.Fire1.ParticleEmitter.Enabled then
					SendNotification("X-Ro | Tha Bronx 2", "Critical error! Someone took the selected stove. Index: "..tostring(RiceToCook), 4)
				end

				if (tick() - TimeElapsed) >= 3 then
					SendNotification("X-Ro | Tha Bronx 2", "Action exhausted (critical error), cook rice failed. Index: "..tostring(RiceToCook), 4)
				end

				FirePrompt(Prompt) -- Cook rice
			until Value.Fire1.ParticleEmitter.Enabled or Prompt.ActionText == "Pick Up!" or Value.Fire1.ParticleEmitter.Enabled or (tick() - TimeElapsed) >= 3

			RiceToCook += 1

			spawn(function()
				repeat
					wait(0)
				until not Debounce and GetCharacter() and GetCharacter():FindFirstChildOfClass("Humanoid").Health > 0 and Prompt.ActionText == "Pick Up!"

				Debounce = true

				HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
				OldCFrame = HumanoidRootPart.CFrame

				TimeElapsed = tick()

				repeat
					if (tick() - TimeElapsed) >= 3 then
						SendNotification("X-Ro | Tha Bronx 2", "Action exhausted (critical error), cook rice failed. Index: "..tostring(RiceCooked), 4)
					end

					Teleport(Value.CFrame)
					FirePrompt(Prompt) -- Pick up rice
				until Prompt.ActionText ~= "Pick Up!" or (tick() - TimeElapsed) >= 3

				Teleport(OldCFrame); Debounce = false

				RiceCooked += 1

				SendNotification("X-Ro | Tha Bronx 2", "Successfully cooked "..tostring(RiceCooked).." / "..tostring(RiceToCook).." rice bags.", 3)
			end)
		end

		Teleport(OldCFrame); Debounce = false
	end)

	local SellRice = LPH_NO_VIRTUALIZE(function()
		if (tick() - LastCookedRice) < Threshold then
			SendNotification("X-Ro | Tha Bronx 2", "Sell Rice delayed until anti-cheat duration threshold has passed, please wait!", 4)

			repeat
				wait(1)
			until (tick() - LastCookedRice) >= Threshold and not Debounce
		end

		if (tick() - LastCookedRice) < Threshold then
			return
		end

		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		GetCharacter():FindFirstChildOfClass("Humanoid"):UnequipTools()

		local Amount = 0
		local Tools = {}

		for _, Value in next, LocalPlayer:FindFirstChild("Backpack"):GetChildren() do
			if Value:IsA("Tool") and stringmatch(Value.Name, "Rice") and Value.Name ~= "RiceBag" then
				Amount += 1
				Tools[#Tools + 1] = Value
			end
		end

		if Amount == 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "No rice to sell!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local OldNoClipValue = XRO_NoClip

		XRO_NoClip = true

		Teleport(CFramenew(81062.3828, 133132.953, 167.078979, -0.999821424, -4.34790959e-09, 0.0188986398, -4.39821335e-09, 1, -2.6202005e-09, -0.0188986398, -2.70285283e-09, -0.999821424))

		local Prompt = workspace.Sell:FindFirstChildOfClass("ProximityPrompt")

		local OldBalance = GetBalance(true)

		for _, Value in next, Tools do
			repeat
				GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Value); wait(0)
			until GetCharacter():FindFirstChildOfClass("Tool") == Value

			repeat
				FirePrompt(Prompt) -- Sell rice
			until Value.Parent ~= GetCharacter()
		end

		SendNotification("X-Ro | Tha Bronx 2", "Made $"..tostring(GetBalance(true) - OldBalance).." from selling rice!", 2)

		XRO_NoClip = OldNoClipValue
		Teleport(OldCFrame); Debounce = false
	end)

	local SwipeCards = LPH_JIT_MAX(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		Backpack = LocalPlayer:FindFirstChild("Backpack")

		if not Backpack:FindFirstChild("Card") or not GetCharacter():FindFirstChild("Card") then
			return SendNotification("X-Ro | Tha Bronx 2", "You don't own any cards!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local OldNoClipValue, OldFlyValue = XRO_NoClip, FlySettings.Enabled

		XRO_NoClip = true
		FlySettings.Enabled = true

		for _, Value in next, workspace.Robbables:GetChildren() do
			if not GetCharacter():FindFirstChild("Card") then
				if Backpack:FindFirstChild("Card") then
					GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Backpack:FindFirstChild("Card"))
				else
					break
				end
			end

			local Prompt = Value:FindFirstChildOfClass("ProximityPrompt")

			local Tries = 0

			repeat
				Teleport(Value.CFrame)
				FirePrompt(Prompt) -- Swipe Card
				Tries += 1

				if stringmatch(GetCharacter():FindFirstChildOfClass("Tool").Name, "Cash") then
					break
				end
			until Tries >= 10 or not GetCharacter():FindFirstChildOfClass("Tool")

			if Tries >= 10 then
				continue -- ATM is unavailable
			end

			--// Return Cash

			repeat
				wait(0)
			until stringmatch(GetCharacter():FindFirstChildOfClass("Tool").Name, "Cash") or stringmatch(Backpack:FindFirstChildOfClass("Tool").Name, "Cash")

			local Cash

			for _, _Value in next, Backpack:GetChildren() do
				if _Value:IsA("Tool") and stringmatch(_Value.Name, "Cash") then
					Cash = Value
					break
				end
			end

			if Cash then
				GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Cash)
			end

			Value = workspace["Card Cash Giver"]

			Teleport(Value.CFrame)
			Prompt = Value:FindFirstChildOfClass("ProximityPrompt")

			local OldBalance = GetBalance()

			repeat
				FirePrompt(Prompt) -- Deposit Cash
			until GetBalance() > OldBalance
		end

		Teleport(OldCFrame); Debounce = false

		FlySettings.Enabled = OldFlyValue
		XRO_NoClip = OldNoClipValue
	end)

	local RobStudio = LPH_JIT_MAX(function()
		local Robbed, OldBalance = 0, GetBalance()

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		for _, Prompt in next, workspace.StudioPay.Money:GetDescendants() do
			if not Prompt:IsA("ProximityPrompt") or not Prompt.Enabled then
				continue
			end

			if Prompt.ObjectText == "$7900" then
				Teleport(CFramenew(93425.4297, 14484.7207, 561.066162, 0.0331067592, 3.84856769e-09, -0.999451816, -1.8149894e-08, 1, 3.24946492e-09, 0.999451816, 1.80323649e-08, 0.0331067592))
			elseif Prompt.ObjectText == "$3350" then
				Teleport(CFramenew(93421.6641, 14484.7207, 561.143677, 0.0108167073, 7.01139271e-08, 0.999941468, -9.69442198e-08, 1, -6.90693511e-08, -0.999941468, -9.61914424e-08, 0.0108167073))
			elseif Prompt.ObjectText == "$16000" then
				Teleport(CFramenew(93421.1016, 14484.7197, 565.176697, 0.0123346373, 8.85432438e-09, 0.999923944, -1.87503737e-08, 1, -8.62370175e-09, -0.999923944, -1.86425773e-08, 0.0123346373))
			end

			repeat
				FirePrompt(Prompt)
			until not Prompt.Enabled

			Robbed += 1
		end

		if Robbed > 0 then
			Teleport(OldCFrame)
		end

		SendNotification("X-Ro | Tha Bronx 2", Robbed > 0 and "Robbery successful! ("..tostring(Robbed).." / 3) Made $"..tostring(GetBalance() - OldBalance).."!" or "\"On The Radar\" studio rob is unavailable.", 3)
	end)

	local PlantSeeds = LPH_NO_VIRTUALIZE(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		Backpack = LocalPlayer:FindFirstChild("Backpack")

		local Tool

		for _, Value in next, Backpack:GetChildren() do
			if Value:IsA("Tool") and Value.Name == "Seeds" then
				Tool = Value; break
			end
		end

		Tool = Tool or GetCharacter():FindFirstChild("Seeds")

		if not Tool then
			return SendNotification("X-Ro | Tha Bronx 2", "You don't own any seeds!", 2)
		end

		local Available, Pots = 0, {}

		for _, Value in next, workspace.PLANTS:GetChildren() do
			local _Value = Value.PlantPromt

			if _Value:FindFirstChildOfClass("ProximityPrompt").ActionText == "Recieve" then
				continue
			end

			Available += 1
			Pots[#Pots + 1] = _Value
		end

		if Available == 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "No pots available!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local GrassToPlant, GrassPlanted = 0, 0

		for _, Value in next, Pots do
			if GrassToPlant == 7 then
				SendNotification("X-Ro | Tha Bronx 2", "Maximum number of seeds (7) are planted.", 4)
				break
			end

			local Prompt = Value:FindFirstChildOfClass("ProximityPrompt")

			if not Prompt.Enabled then
				continue
			end

			if not GetCharacter():FindFirstChild("Seeds") then
				if Backpack:FindFirstChild("Seeds") then
					GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Backpack:FindFirstChild("Seeds"))
				else
					break
				end
			end

			local TimeElapsed = tick()

			repeat
				wait(0) -- Prevent crashing

				if Prompt.ActionText == "Recieve" then
					SendNotification("X-Ro | Tha Bronx 2", "Critical error! Someone took the selected pot. Index: "..tostring(GrassToPlant), 4)
				end

				if (tick() - TimeElapsed) >= 3 then
					SendNotification("X-Ro | Tha Bronx 2", "Action exhausted, pot on cooldown or exceeded active pots? Index: "..tostring(GrassToPlant), 4)
				end

				Teleport(Value.CFrame)
				FirePrompt(Prompt) -- Plant Seeds
			until not Prompt.Enabled or Prompt.ActionText == "Recieve" or (tick() - TimeElapsed) >= 3

			GrassToPlant += 1

			spawn(function()
				repeat
					wait(0)
				until not Debounce and GetCharacter() and GetCharacter():FindFirstChildOfClass("Humanoid").Health > 0 and Prompt.ActionText == "Recieve" and Prompt.Enabled

				Debounce = true

				HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
				OldCFrame = HumanoidRootPart.CFrame

				repeat
					Teleport(Value.CFrame)
					FirePrompt(Prompt) -- Pick up grass
				until Prompt.ActionText ~= "Recieve"

				Teleport(OldCFrame); Debounce = false

				GrassPlanted += 1

				SendNotification("X-Ro | Tha Bronx 2", "Picked up "..tostring(GrassPlanted).." / "..tostring(GrassToPlant).." fully grown grass.", 3)
			end)
		end

		Teleport(OldCFrame); Debounce = false
	end)

	local BuySeeds = LPH_JIT_MAX(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		if tonumber(stringmatch(workspace.GUNS.Seeds.Over.Sign.SurfaceGui.SIGN.Text, "%d+")) == 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "No seeds available!", 2)
		end

		if (GetBalance() - 1000) < 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "Insufficient funds!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		local Prompt = workspace.GUNS.Seeds.Bag:FindFirstChildOfClass("ProximityPrompt")

		Backpack = LocalPlayer:FindFirstChild("Backpack")

		local OldBackpackSize = #Backpack:GetChildren()

		repeat
			Teleport(CFramenew(-1541.31909, 282.439026, -984.754456, 0.0237076972, -2.90279782e-08, -0.999718904, 7.62883001e-09, 1, -2.88552275e-08, 0.999718904, -6.94259494e-09, 0.0237076972))

			FirePrompt(Prompt)

			if tonumber(stringmatch(workspace.GUNS.Seeds.Over.Sign.SurfaceGui.SIGN.Text, "%d+")) == 0 or HumanoidRootPart.Parent:FindFirstChildOfClass("Humanoid").Health <= 0 then
				SendNotification("X-Ro | Tha Bronx 2", "Critical error occured, please retry the action!", 2); break
			end
		until #Backpack:GetChildren() > OldBackpackSize

		Teleport(OldCFrame); Debounce = false
	end)

	local SellGrass = LPH_NO_VIRTUALIZE(function()
		if (tick() - LastReceivedGrass) < Threshold then
			SendNotification("X-Ro | Tha Bronx 2", "Sell Grass delayed until anti-cheat duration threshold has passed, please wait!", 4)

			repeat
				wait(1)
			until (tick() - LastReceivedGrass) >= Threshold and not Debounce
		end

		if (tick() - LastReceivedGrass) < Threshold then
			return
		end

		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		GetCharacter():FindFirstChildOfClass("Humanoid"):UnequipTools()

		local Amount = 0
		local Tools = {}

		for _, Value in next, LocalPlayer:FindFirstChild("Backpack"):GetChildren() do
			if Value:IsA("Tool") and stringmatch(Value.Name, "RapidGrassPatch") then -- Names are prefixed with the size: (S)mall; (M)edium; (L)arge
				Amount += 1
				Tools[#Tools + 1] = Value
			end
		end

		if Amount == 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "No grass to sell!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		Teleport(CFramenew(-630, 253, -759))

		local Prompt = workspace.PlantSeller:FindFirstChildOfClass("ProximityPrompt")

		local OldBalance = GetBalance(true)

		for _, Value in next, Tools do
			repeat
				GetCharacter():FindFirstChildOfClass("Humanoid"):EquipTool(Value); wait(0)
			until GetCharacter():FindFirstChildOfClass("Tool") == Value

			repeat
				FirePrompt(Prompt) -- Sell grass
			until Value.Parent ~= GetCharacter()
		end

		SendNotification("X-Ro | Tha Bronx 2", "Made $"..tostring(GetBalance(true) - OldBalance).." from selling grass!", 2)

		Teleport(OldCFrame); Debounce = false
	end)

	local CollectGrass = LPH_NO_VIRTUALIZE(function()
		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		Debounce = true

		local Collected = 0

		for _, Value in next, workspace.PLANTS:GetChildren() do
			local _Value = Value.PlantPromt
			local Prompt = _Value:FindFirstChildOfClass("ProximityPrompt")

			if Prompt.ActionText == "Recieve" and Prompt.Enabled then
				Collected += 1

				repeat
					if Prompt.ActionText ~= "Recieve" then
						break -- In case someone collects it
					end

					Teleport(Value.CFrame)
					FirePrompt(Prompt) -- Pick up grass
				until Prompt.ActionText ~= "Recieve"
			end
		end

		SendNotification("X-Ro | Tha Bronx 2", Collected > 0 and "Collected "..tostring(Collected).." grass patches." or "No grass patches available!", 4)

		Teleport(OldCFrame); Debounce = false
	end)

	local ModWeapon = LPH_JIT_MAX(function(Weapon)

		--// Fetch Module

		local Module = Weapon:FindFirstChildOfClass("ModuleScript")
		local OldConfig = OldWeaponValues[Weapon.Name]

		if Module and Module.Name == "Setting" then
			Module = require(Module)
		else
			return
		end

		--// Infinite Ammo

		Module.Ammo = ThaBronxConfig._Modifications.InfiniteAmmo and 9e9 or OldConfig.Ammo
		Module.MaxAmmo = ThaBronxConfig._Modifications.InfiniteAmmo and 9e9 or OldConfig.MaxAmmo
		Module.AmmoPerMag = ThaBronxConfig._Modifications.InfiniteAmmo and 9e9 or OldConfig.AmmoPerMag

		if ThaBronxConfig._Modifications.InfiniteAmmo then
			Module.LimitedAmmoEnabled = false
		else
			Module.LimitedAmmoEnabled = OldConfig.LimitedAmmoEnabled
		end

		--// Fast Fire Rate

		Module.FireRate = ThaBronxConfig._Modifications.FastFireRate and 0 or OldConfig.FireRate

		--// Full Auto

		Module.Auto = ThaBronxConfig._Modifications.FullAuto or OldConfig.Auto

		--// One Tap

		--rawset(Module, "BaseDamage", ThaBronxConfig._Modifications.OneTap and 100 or OldConfig["BaseDamage"])

		--// Life Steal

		if Module.Lifesteal then -- Some weapons don't have this property.
			Module.Lifesteal = ThaBronxConfig._Modifications.Lifesteal and 100 or OldConfig.Lifesteal
		end

		--// Instant Reload

		Module.ReloadTime = ThaBronxConfig._Modifications.InstantReload and 0 or OldConfig.ReloadTime

		--// Instant Equip

		Module.EquipTime = ThaBronxConfig._Modifications.InstantEquip and 0 or OldConfig.EquipTime

		--// No Recoil

		--[[

		if Module.CameraRecoilingEnabled then -- Some weapons don't have this property.
			Module.CameraRecoilingEnabled = ThaBronxConfig._Modifications.NoRecoil and false or OldConfig.CameraRecoilingEnabled
		end

		Module.Recoil = ThaBronxConfig._Modifications.NoRecoil and 0 or OldConfig.Recoil
		Module.RecoilDamper = ThaBronxConfig._Modifications.NoRecoil and 0 or OldConfig.RecoilDamper
		Module.RecoilSpeed = ThaBronxConfig._Modifications.NoRecoil and 0 or OldConfig.RecoilSpeed

		]]

		--// No Spread

		Module.SpreadX = ThaBronxConfig._Modifications.NoSpread and 0 or OldConfig.SpreadX
		Module.SpreadY = ThaBronxConfig._Modifications.NoSpread and 0 or OldConfig.SpreadY

		--// No Jam

		Module.JamChance = ThaBronxConfig._Modifications.NoJam and 0 or OldConfig.JamChance

		--SendNotification("X-Ro | Tha Bronx 2", "Modded gun: "..Weapon.Name, 2)
	end)

	local ModWeapons = LPH_NO_VIRTUALIZE(function()
		for _, Weapon in next, GetAllTools(true) do
			if Weapon:IsA("Tool") then
				spawn(ModWeapon, Weapon)
			end
		end
	end)

	local CreateBeam = LPH_NO_VIRTUALIZE(function(Origin, End)
		local Settings = ThaBronxConfig.BulletTracers

		local OriginAtt = Instance.new("Attachment")
		OriginAtt.Parent = workspace.Terrain
		OriginAtt.Position = Origin

		local EndAtt = Instance.new("Attachment")
		EndAtt.Parent = workspace.Terrain
		EndAtt.Position = End

		local Beam = Instance.new("Beam")
		Beam.Attachment0 = OriginAtt
		Beam.Attachment1 = EndAtt
		Beam.Transparency = NumberSequence.new(Settings.Transparency, Settings.Transparency)
		Beam.Color = ColorSequence.new(Settings.Color, Settings.Color)
		Beam.Width0 = Settings.Thickness
		Beam.Width1 = Settings.Thickness

		for Property, PropertyValue in next, BeamProperties do
			Beam[Property] = PropertyValue
		end

		Beam.Parent = workspace

		delay(Settings.Lifetime, function()
			Beam:Destroy()
			OriginAtt:Destroy()
			EndAtt:Destroy()
		end)

		if Settings.RainbowColor then
			spawn(function()
				while wait(0) do
					if not Beam then
						break
					end

					Beam.Color = ColorSequence.new(GetRainbowColor())
				end
			end)
		end

		if Settings.Fade then
			spawn(function()
				for Step = Settings.Transparency, 1, ((1 - Settings.Transparency) * 0.1) do
					if not Beam then
						break
					end

					Beam.Transparency = NumberSequence.new(Step, Step)
					wait(Settings.Lifetime * 0.1)
				end
			end)
		end
	end)

	local OnBullet = LPH_NO_VIRTUALIZE(function(Old, ...)

		local Tool = GetCharacter():FindFirstChildOfClass("Tool")
		local Handle = Tool and Tool:FindFirstChild("Handle")

		--// Silent Aim

		if ThaBronxConfig.SilentAim.Enabled and (100 * mathrandom()) < ThaBronxConfig.SilentAim.HitChance and Aimbot and Aimbot.GetClosestPlayer then
			local ClosestPlayer = Aimbot.GetClosestPlayer(ThaBronxConfig.SilentAim.WallCheck, ThaBronxConfig.SilentAim.SafeZone)
			local Character = ClosestPlayer and ClosestPlayer.Character
			local HitPart = Character and Character:FindFirstChild(Aimbot.Settings.LockPart)

			if HitPart then
				if ThaBronxConfig.BulletTracers.Enabled and Handle then
					spawn(CreateBeam, Handle.Position, HitPart.Position)
				end

				return HitPart.Position
			end
		end

		if ThaBronxConfig.BulletTracers.Enabled and Handle then
			spawn(CreateBeam, Handle.Position, Old(...))
		end

		return Old(...)
	end)

	local ToolChecks = LPH_NO_VIRTUALIZE(function(Value)
		repeat
			wait(0)
		until not Debounce

		if Value.Parent ~= LocalPlayer.Backpack then
			if Value.Parent ~= GetCharacter() then
				return
			end
		end

		if Value:IsA("Tool") then

			--[[
			local AutoDupe = function()
				if ThaBronxConfig.AutoDuplicate then
					local Humanoid = GetCharacter():FindFirstChildOfClass("Humanoid")

					Humanoid:UnequipTools()
					Humanoid:EquipTool(Value)
					DuplicateItem(true)
				end
			end
			]]

			spawn(function()
				if Value.Name == "RiceBag" and ThaBronxConfig.AutoCookRice then
					CookRice()
				elseif Value.Name == "Seeds" and ThaBronxConfig.AutoPlantSeeds then
					PlantSeeds()
				elseif stringmatch(Value.Name, "Rice") and Value.Name ~= "RiceBag" then -- Finished "RiceBag" product (sellable item)
					LastCookedRice = tick()

					if ThaBronxConfig.AutoSellRice then
						--[[AutoDupe();]] SellRice()
					end
				elseif stringmatch(Value.Name, "RapidGrassPatch") and ThaBronxConfig.AutoSellGrass then -- Finished "Seeds" product (sellable item)
					LastReceivedGrass = tick()

					if ThaBronxConfig.AutoSellGrass then
						--[[AutoDupe();]] SellGrass()
					end
				else
					ModWeapon(Value)
				end
			end)

			--// Silent Aim

			local GunClient = Value:FindFirstChild("GunScript_Local")

			if GunClient then
				if not SilentAimWrapped[GunClient:GetDebugId()] then -- Filter out guns that are already hooked (to prevent crashing).
					for _, _Value in next, getgc() do
						if type(_Value) == "function" then
							local FunctionEnvironment = getfenv(_Value)
							local Script = FunctionEnvironment.script

							if not Script or not Script.Parent or Script ~= GunClient or not Script.Parent.Parent == GetCharacter() then
								continue -- Filter out nil instances (destroyed weapons).
							end

							if Script.Name == "GunScript_Local" and getinfo(_Value).name == "Get3DPosition" then
								local Old; Old = hookfunction(_Value, function(...)
									return OnBullet(Old, ...)
								end)

								SilentAimWrapped[GunClient:GetDebugId()] = true
							end
						end
					end
				end
			end
		end
	end)

	local PurchaseItem = LPH_JIT_MAX(function(Object)
		if #Object ~= 2 then
			return SendNotification("X-Ro | Tha Bronx 2", "Critical error occured, action canceled!", 2)
		end

		if Debounce then
			return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
		end

		if (GetBalance() - Object[2]) < 0 then
			return SendNotification("X-Ro | Tha Bronx 2", "Insufficient funds!", 2)
		end

		Debounce = true

		local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
		local OldCFrame = HumanoidRootPart.CFrame

		Backpack = LocalPlayer:FindFirstChild("Backpack")

		local OldBackpackSize = #Backpack:GetChildren()

		local TimeElapsed = tick()

		repeat
			if (tick() - TimeElapsed) >= 3 then
				SendNotification("X-Ro | Tha Bronx 2", "Action exhausted (critical error), purchase item failed.", 4)
			end

			Teleport(Object[1].Parent.CFrame)
			FirePrompt(Object[1])
		until #Backpack:GetChildren() > OldBackpackSize or (tick() - TimeElapsed) >= 3

		Teleport(OldCFrame); Debounce = false
	end)

	--// Backend

	if Support then
		spawn(LPH_NO_VIRTUALIZE(function() -- Auto Shoot
			repeat
				wait(0)
			until XRO_TB2_LOADED

			while wait(0.5) and Aimbot and Aimbot.GetClosestPlayer do
				if not GetCharacter() then
					continue
				end

				local Tool = GetCharacter():FindFirstChildOfClass("Tool")

				if Tool and Tool:FindFirstChild("GunScript_Local") and ThaBronxConfig.SilentAim.AutoShoot and ThaBronxConfig.SilentAim.Enabled then
					if Aimbot.GetClosestPlayer(ThaBronxConfig.SilentAim.WallCheck, ThaBronxConfig.SilentAim.SafeZone) then
						repeat
							mouse1click(); wait(0) -- Shoot
						until not Aimbot.GetClosestPlayer(ThaBronxConfig.SilentAim.WallCheck) -- Keep shooting until the player is not in your FOV or dead.
					end
				end

				if not XRO_TB2_LOADED then
					break
				end
			end
		end))
	end

	spawn(LPH_NO_VIRTUALIZE(function()
		for _, Value in next, workspace.GUNS:GetChildren() do
			if Wrapped[Value.Name] then
				continue
			end

			if not Value:IsA("Model") or not Value:FindFirstChild("Price") then
				continue
			end

			if Value:FindFirstChild("GamepassID") and not MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, Value:FindFirstChild("GamepassID").Value) then
				continue -- If the user does not own the game pass required for the item, we won't wrap the item
			end

			local Prompt

			for _, _Value in next, Value:GetDescendants() do
				if _Value:IsA("ProximityPrompt") then
					Prompt = _Value
					break
				end
			end

			if not Prompt then
				continue
			end

			if Value.Price.Value <= 0 then -- Some role is usually needed for these "free" tools, for example the police tools
				continue
			end

			Items[Value.Name.." ($"..tostring(Value.Price.Value)..")"] = {Prompt, Value.Price.Value}
			Wrapped[Value.Name] = true
		end

		ItemsWrapped = true
	end))

	spawn(LPH_NO_VIRTUALIZE(function()
		while wait(180) do
			CleaningDebounce = false -- In case "Clean Money" process chokes
		end
	end))

	spawn(LPH_NO_VIRTUALIZE(function()
		while wait(60) do
			Debounce = false -- In case some process chokes
		end
	end))

	spawn(LPH_JIT_MAX(function() -- Manual purchasing (with teleporting & firing prompts)
		repeat
			wait(0)
		until XRO_TB2_LOADED

		while wait(3) do
			if ThaBronxConfig.AutoBuyRice and tonumber(stringmatch(workspace.GUNS.RiceBag.Over.Sign.SurfaceGui.SIGN.Text, "%d+")) > 0 then
				BuyRice()
			end

			if ThaBronxConfig.AutoBuySeeds and tonumber(stringmatch(workspace.GUNS.Seeds.Over.Sign.SurfaceGui.SIGN.Text, "%d+")) > 0 then
				BuySeeds()
			end

			if ThaBronxConfig.InfiniteSleep and GetREnvSupport then
				getrenv().shared.Wokeness = 100
			end

			if not XRO_TB2_LOADED then
				break
			end
		end
	end))

	spawn(LPH_JIT_MAX(function() -- Remote purchasing (from the Exotic Dealer)
		repeat
			wait(0)
		until XRO_TB2_LOADED

		while wait(1) do
			if ThaBronxConfig.AutoBuyRice then
				ExoticShopRemote:InvokeServer("RiceBag")
			end

			if ThaBronxConfig.AutoBuySeeds then
				ExoticShopRemote:InvokeServer("Seeds")
			end

			if not XRO_TB2_LOADED then
				break
			end
		end
	end))

	spawn(function()
		repeat
			wait(0)
		until XRO_TB2_LOADED

		while wait(0) do
			if ThaBronxConfig.GodMode and XRO_TB2_LOADED then
				DamagePlayer:InvokeServer(-1 / 0)
			end
		end
	end)

	TB2Connections["ThaBronx2_CharacterAdded"] = LocalPlayer.CharacterAdded:Connect(LPH_JIT_MAX(function(Character)
		repeat
			wait(1)
		until Character:FindFirstChild("CameraBobbing") and Character:FindFirstChild("LowHealthEffect") and Character:FindFirstChild("deathClient")

		repeat
			wait(1)
		until LocalPlayer.PlayerGui:FindFirstChild("BloodGui") and LocalPlayer.PlayerGui:FindFirstChild("LowHealthT") and LocalPlayer.PlayerGui:FindFirstChild("CloseRangeBlood")

		for _, Value in next, LocalPlayer.PlayerGui:GetChildren() do
			if Value.Name == "BloodGui" or Value.Name == "LowHealthT" or Value.Name == "CloseRangeBlood" then
				Value.Enabled = not ThaBronxConfig.DisableScreenEffects

				TB2Connections[Value.Name.."_Changed"] = Value.Changed:Connect(function(Property)
					if Property == "Enabled" then
						Value.Parent.Enabled = not ThaBronxConfig.DisableScreenEffects
					end
				end)

				if Value.Name == "LowHealthT" then
					Value = Value:FindFirstChildOfClass("Frame")

					TB2Connections["InstantRevive"] = Value.Changed:Connect(function(Property)
						if Property == "Visible" and Value.Visible and ThaBronxConfig.InstantRevive then
							repeat
								FSpamRemote:FireServer(); wait(0)
							until not Value.Visible
						end
					end)
				end
			elseif Value.Name == "Run" then
				Value.Frame.Frame.Frame.StaminaBarScript.Disabled = ThaBronxConfig.InfiniteStamina
			elseif Value.Name == "Hunger" then
				Value.Frame.Frame.Frame.HungerBarScript.Disabled = ThaBronxConfig.InfiniteHunger
			elseif Value.Name == "SleepGui" then
				Value.Frame.sleep.SleepBar.sleepScript.Disabled = ThaBronxConfig.InfiniteSleep
			elseif Value.Name == "RentGui" then
				Value.LocalScript.Disabled = ThaBronxConfig.NoRentPay
			end
		end

		Character:FindFirstChild("LowHealthEffect").Enabled = not ThaBronxConfig.DisableScreenEffects
		Character:FindFirstChild("deathClient").Enabled = not ThaBronxConfig.DisableScreenEffects
		Character:FindFirstChild("FallDamageRagdoll").Enabled = not ThaBronxConfig.NoFallDamage

		Character:FindFirstChild("CameraBobbing").Enabled = not ThaBronxConfig.CameraBobbing

		pcall(function()
			TB2Connections["LowHealthEffect_Changed"] = Character:WaitForChild("LowHealthEffect", true).Changed:Connect(function()
				Character:FindFirstChild("LowHealthEffect").Enabled = not ThaBronxConfig.DisableScreenEffects
			end)

			TB2Connections["deathClient_Changed"] = Character:FindFirstChild("deathClient").Changed:Connect(function()
				Character:FindFirstChild("deathClient").Enabled = not ThaBronxConfig.DisableScreenEffects
			end)

			TB2Connections["FallDamageRagdoll_Changed"] = Character:FindFirstChild("FallDamageRagdoll").Changed:Connect(function()
				Character:FindFirstChild("FallDamageRagdoll").Enabled = not ThaBronxConfig.NoFallDamage
			end)

			TB2Connections["CameraBobbing_Changed"] = Character:FindFirstChild("CameraBobbing").Changed:Connect(function()
				Character:FindFirstChild("CameraBobbing").Enabled = not ThaBronxConfig.CameraBobbing
			end)

			LocalPlayer.PlayerGui:WaitForChild("JumpDebounce", true):FindFirstChildOfClass("LocalScript").Enabled = not ThaBronxConfig.NoJumpCooldown

			TB2Connections["Backpack_ChildAdded"] = LocalPlayer.Backpack.ChildAdded:Connect(ToolChecks)
			TB2Connections["Character_ChildAdded"] = Character.ChildAdded:Connect(ToolChecks)

			TB2Connections["Humanoid_Died"] = Character:FindFirstChildOfClass("Humanoid").Died:Connect(function()
				if ThaBronxConfig.InstantRespawn then
					RespawnRE:FireServer()
				end
			end)
		end)
	end))

	TB2Connections["Backpack_ChildAdded"] = LocalPlayer.Backpack.ChildAdded:Connect(ToolChecks)
	TB2Connections["Character_ChildAdded"] = GetCharacter().ChildAdded:Connect(ToolChecks)

	TB2Connections["Humanoid_Died"] = GetCharacter():FindFirstChildOfClass("Humanoid").Died:Connect(function()
		if ThaBronxConfig.InstantRespawn then
			RespawnRE:FireServer()
		end
	end)

	TB2Connections["ThaBronx2_Dollas_ChildAdded"] = Dollas.ChildAdded:Connect(LPH_JIT_MAX(function(Cash)
		if ThaBronxConfig.Collecting then
			CollectLootable(Cash)
		end
	end))

	TB2Connections["ThaBronx2_Storage_ChildAdded"] = Storage.ChildAdded:Connect(LPH_JIT_MAX(function(Bag)
		if ThaBronxConfig.LootBags and MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, 103359921) and Bag.Name == "Baggy" then
			CollectLootable(Bag)
		end
	end))

	TB2Connections["ThaBronx2_Workspace_ChildAdded"] = workspace.ChildAdded:Connect(LPH_JIT_MAX(function(Tool)
		if ThaBronxConfig.PickUpDrops and Tool:IsA("Tool") then
			for _, Value in next, Tool:GetDescendants() do
				if Value:IsA("ProximityPrompt") and Value.ActionText == "Pick Up" then
					CollectLootable(Value.Parent)
				end
			end
		end
	end))

	TB2Connections["ThaBronx2_Prompt_Began"] = ProximityPromptService.PromptButtonHoldBegan:Connect(LPH_JIT_MAX(function(Prompt)
		if not ThaBronxConfig.InstantPrompts then
			return
		end

		local Old = Prompt.HoldDuration

		Prompt.HoldDuration = 0
		Prompt:InputHoldBegin()
		Prompt:InputHoldEnd()
		fireproximityprompt(Prompt, true); wait(0.25)

		Prompt.HoldDuration = Old
	end))

	if Support then
		for _, Weapon in next, GetAllTools() do -- Cache old weapon values
			if Weapon:IsA("Tool") then
				local Module = Weapon:FindFirstChildOfClass("ModuleScript")

				if Module and Module.Name == "Setting" then
					Module = require(Module)
				end

				if type(Module) == "table" and not OldWeaponValues[Weapon.Name] then
					OldWeaponValues[Weapon.Name] = {}

					local OldConfig = OldWeaponValues[Weapon.Name]

					for Index, Value in next, Module do
						OldConfig[Index] = Value
					end
				end
			end
		end
	end

	local ConfigMetatable = getmetatable(ThaBronxConfig.Modifications)

	ConfigMetatable.__index = LPH_NO_VIRTUALIZE(function(...)
		return ThaBronxConfig._Modifications[select(2, ...)]
	end)

	ConfigMetatable.__newindex = LPH_NO_VIRTUALIZE(function(...)
		local Index, Value = select(2, ...) -- Ignore 1st argument - "self"

		ThaBronxConfig._Modifications[Index] = Value; ModWeapons() -- Auto Update
	end)

	--// Farming

	TBFarmsSection:CreateToggle({
		Name = "Collect Dropped Cash",
		Flag = "TB2_Collecting_Enabled",
		Default = ThaBronxConfig.Collecting,
		NoExecute = true,
		Callback = LPH_JIT_MAX(function(Value)
			ThaBronxConfig.Collecting = Value

			if Value then
				for _, Cash in next, Dollas:GetChildren() do
					CollectLootable(Cash)
				end
			end
		end)
	})

	TBFarmsSection:CreateToggle({
		Name = "Pick Up Dropped Items",
		Flag = "TB2_PickUpDrops_Enabled",
		Default = ThaBronxConfig.PickUpDrops,
		NoExecute = true,
		Callback = LPH_JIT_MAX(function(Value)
			ThaBronxConfig.PickUpDrops = Value

			if Value then
				for _, Tool in next, workspace:GetChildren() do
					if Tool:IsA("Tool") then
						for _, _Value in next, Tool:GetDescendants() do
							if _Value:IsA("ProximityPrompt") and _Value.ActionText == "Pick Up" then
								CollectLootable(_Value.Parent)
							end
						end
					end
				end
			end
		end)
	})

	TBFarmsSection:CreateToggle({
		Name = "Loot Bags",
		Flag = "TB2_Looting_Enabled",
		Default = ThaBronxConfig.LootBags,
		NoExecute = true,
		Callback = LPH_JIT_MAX(function(Value)
			ThaBronxConfig.LootBags = Value

			if not Value then
				return
			end

			if MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, 103359921) then
				for _, Bag in next, Storage:GetChildren() do
					CollectLootable(Bag)
				end
			else
				SendNotification("X-Ro | Tha Bronx 2", "You must own the \"Looting\" gamepass to use this feature!", 2)
			end
		end)
	})

	TBFarmsSection:CreateToggle({
		Name = "Autofarm Mop Job",
		Flag = "TB2_AutofarmMopJob_Enabled",
		Default = ThaBronxConfig.MopJob,
		NoExecute = true,
		Callback = function(Value)
			ThaBronxConfig.MopJob = Value; FarmMopJob()
		end
	})

	TBFarmsSection:CreateToggle({
		Name = "Auto Buy Rice",
		Flag = "TB2_AutoBuyRice_Enabled",
		Default = ThaBronxConfig.AutoBuyRice,
		NoExecute = true,
		Callback = function(Value)
			ThaBronxConfig.AutoBuyRice = Value
		end
	})

	TBFarmsSection:CreateToggle({
		Name = "Auto Buy Seeds",
		Flag = "TB2_AutoBuySeeds_Enabled",
		Default = ThaBronxConfig.AutoBuySeeds,
		NoExecute = true,
		Callback = function(Value)
			ThaBronxConfig.AutoBuySeeds = Value
		end
	})

	TBFarmsSection:CreateButton({
		Name = "Search Dumpsters",
		Callback = SearchDumpsters
	})

	TBFarmsSection:CreateButton({
		Name = "Swipe Cards",
		Callback = SwipeCards
	})

	TBFarmsSection:CreateButton({
		Name = "Rob House",
		Callback = HouseRob
	})

	TBFarmsSection:CreateButton({
		Name = "Rob \"On The Radar\" Studio",
		Callback = RobStudio
	})

	TBFarmsSection:CreateButton({
		Name = "Sell Pawn (Items)",
		Callback = SellPawn
	})

	TBFarmsSection:CreateToggle({
		Name = "Auto Sell Rice",
		Flag = "TB2_AutoSellRice",
		Default = ThaBronxConfig.AutoSellRice,
		Callback = function(Value)
			ThaBronxConfig.AutoSellRice = Value

			if Value then
				SellRice()
			end
		end
	})

	TBFarmsSection:CreateToggle({
		Name = "Auto Sell Grass",
		Flag = "TB2_AutoSellGrass",
		Default = ThaBronxConfig.AutoSellGrass,
		Callback = function(Value)
			ThaBronxConfig.AutoSellGrass = Value

			if Value then
				SellGrass()
			end
		end
	})

	TBFarmsSection:CreateButton({
		Name = "Sell Rice",
		Callback = SellRice
	})

	TBFarmsSection:CreateButton({
		Name = "Sell Grass",
		Callback = SellGrass
	})

	--// Combat

	if TBCombat then
		TBCombat:CreateToggle({
			Name = "Silent Aim",
			Flag = "TB2_SilentAim",
			Default = ThaBronxConfig.SilentAim.Enabled,
			NoExecute = true,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.SilentAim.Enabled = Value
			end)
		})

		TBCombat:CreateToggle({
			Name = "Auto Shoot (Rage)",
			Flag = "TB2_AutoShoot",
			Default = ThaBronxConfig.SilentAim.AutoShoot,
			NoExecute = true,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.SilentAim.AutoShoot = Value
			end)
		})

		TBCombat:CreateToggle({
			Name = "Wall Check",
			Flag = "TB2_SilentAim_WallCheck",
			Default = ThaBronxConfig.SilentAim.WallCheck,
			NoExecute = true,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.SilentAim.WallCheck = Value
			end)
		})

		TBCombat:CreateToggle({
			Name = "Safe Zone Check",
			Flag = "TB2_SilentAim_SafeZone",
			Default = ThaBronxConfig.SilentAim.SafeZone,
			NoExecute = true,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.SilentAim.SafeZone = Value
			end)
		})

		TBCombat:CreateSlider({
			Name = "Hit Chance (%)",
			Flag = "TB2_SilentAim_HitChance",
			Default = ThaBronxConfig.SilentAim.HitChance,
			Min = 1,
			Max = 100,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.SilentAim.HitChance = Value
			end)
		})

		TBCombat:CreateLabel("Bullet Tracers")

		TBCombat:CreateToggle({
			Name = "Enabled",
			Flag = "TB2_BulletTracer_Enabled",
			Default = ThaBronxConfig.BulletTracers.Enabled,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.BulletTracers.Enabled = Value
			end)
		})

		TBCombat:CreateToggle({
			Name = "Fade",
			Flag = "TB2_BulletTracer_Fade",
			Default = ThaBronxConfig.BulletTracers.Fade,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.BulletTracers.Fade = Value
			end)
		})

		TBCombat:CreateToggle({
			Name = "Rainbow Color",
			Flag = "TB2_BulletTracer_RainbowColor",
			Default = ThaBronxConfig.BulletTracers.RainbowColor,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.BulletTracers.RainbowColor = Value
			end)
		})

		TBCombat:CreateSlider({
			Name = "Lifetime",
			Flag = "TB2_BulletTracer_Lifetime",
			Min = 0,
			Max = 5,
			Default = ThaBronxConfig.BulletTracers.Lifetime,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.BulletTracers.Lifetime = Value
			end)
		})

		TBCombat:CreateColorpicker({
			Name = "Color",
			Flag = "TB2_BulletTracer_Color",
			Default = ThaBronxConfig.BulletTracers.Color,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.BulletTracers.Color = Value
			end)
		})

		TBCombat:CreateSlider({
			Name = "Transparency",
			Flag = "TB2_BulletTracer_Transparency",
			Min = 0,
			Max = 1,
			Default = ThaBronxConfig.BulletTracers.Transparency,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.BulletTracers.Transparency = Value
			end)
		})

		TBCombat:CreateSlider({
			Name = "Thickness",
			Flag = "TB2_BulletTracer_Thickness",
			Min = 0,
			Max = 1,
			Default = ThaBronxConfig.BulletTracers.Thickness,
			Callback = LPH_NO_VIRTUALIZE(function(Value)
				ThaBronxConfig.BulletTracers.Thickness = Value
			end)
		})
	else
		warn("X-RO_THA_BRONX_2 > Your script executor does not support the silent aim features!")
	end

	--// Quick Shop

	TBPurchaseItems:CreateLabel("Remote Purchasing")

	TBPurchaseItems:CreateButton({
		Name = "Purchase Water ($10)",
		Callback = LPH_JIT_MAX(function()
			ShopRemote:InvokeServer("Water")
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Juice ($25)",
		Callback = LPH_JIT_MAX(function()
			ShopRemote:InvokeServer("GreenAppleJuice")
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Shiesty ($150)",
		Callback = LPH_JIT_MAX(function()
			ShopRemote:InvokeServer("Shiesty")
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Gloves ($10)",
		Callback = LPH_JIT_MAX(function()
			ShopRemote:InvokeServer("BlackGloves")
		end)
	})

	TBPurchaseItems:CreateLabel("Exotic Dealer")

	TBPurchaseItems:CreateButton({
		Name = "Purchase Grape Drank ($500)",
		Callback = LPH_JIT_MAX(function()
			ExoticShopRemote:InvokeServer("GrapeDrank")
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Rice ($2900)",
		Callback = LPH_JIT_MAX(function()
			ExoticShopRemote:InvokeServer("RiceBag")
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Seeds ($1000)",
		Callback = LPH_JIT_MAX(function()
			ExoticShopRemote:InvokeServer("Seeds")
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Fake Card ($700)",
		Callback = LPH_JIT_MAX(function()
			ExoticShopRemote:InvokeServer("FakeCard")
		end)
	})

	TBPurchaseItems:CreateLabel("Manual Purchasing")

	TBPurchaseItems:CreateButton({
		Name = "Purchase Rice ($3500)",
		Callback = BuyRice
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Seeds ($1000)",
		Callback = BuySeeds
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase G2C ($1250)",
		Callback = LPH_JIT_MAX(function()
			if Debounce then
				return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
			end

			if (GetBalance() - 1250) < 0 then
				return SendNotification("X-Ro | Tha Bronx 2", "Insufficient funds!", 2)
			end

			Debounce = true

			local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
			local OldCFrame = HumanoidRootPart.CFrame

			local Prompt = workspace.GUNS.G2C["45"]:FindFirstChildOfClass("ProximityPrompt")

			Backpack = LocalPlayer:FindFirstChild("Backpack")

			local OldBackpackSize = #Backpack:GetChildren()

			repeat
				Teleport(CFramenew(92971.4688, 122097.953, 17007.166, -9.12696194e-08, 9.6977999e-09, -1, 5.55873889e-08, 1, 9.69779457e-09, 1, -5.55873889e-08, -9.12696194e-08))
				FirePrompt(Prompt)
			until #Backpack:GetChildren() > OldBackpackSize

			Teleport(OldCFrame); Debounce = false
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase .9mm ($20)",
		Callback = LPH_JIT_MAX(function()
			if Debounce then
				return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
			end

			if (GetBalance() - 20) < 0 then
				return SendNotification("X-Ro | Tha Bronx 2", "Insufficient funds!", 2)
			end

			Debounce = true

			local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
			local OldCFrame = HumanoidRootPart.CFrame

			local Prompt = workspace.GUNS[".9mm"].Sign:FindFirstChildOfClass("ProximityPrompt")

			Backpack = LocalPlayer:FindFirstChild("Backpack")

			local OldBackpackSize = #Backpack:GetChildren()

			repeat
				Teleport(Prompt.Parent.CFrame)
				FirePrompt(Prompt)
			until #Backpack:GetChildren() > OldBackpackSize

			Teleport(OldCFrame); Debounce = false
		end)
	})

	TBPurchaseItems:CreateButton({
		Name = "Purchase Bag ($500)",
		Callback = LPH_JIT_MAX(function()
			if Debounce then
				return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
			end

			if (GetBalance() - 500) < 0 then
				return SendNotification("X-Ro | Tha Bronx 2", "Insufficient funds!", 2)
			end

			Debounce = true

			local HumanoidRootPart = GetCharacter():FindFirstChild("HumanoidRootPart")
			local OldCFrame = HumanoidRootPart.CFrame

			local Prompt = workspace.GUNS.Bag.Bag:FindFirstChildOfClass("ProximityPrompt")

			Backpack = LocalPlayer:FindFirstChild("Backpack")

			local OldBackpackSize = #Backpack:GetChildren()

			repeat
				Teleport(Prompt.Parent.CFrame)
				FirePrompt(Prompt)
			until #Backpack:GetChildren() > OldBackpackSize

			Teleport(OldCFrame); Debounce = false
		end)
	})

	TBPurchaseItems:CreateLabel("Other Items (Manual Purchasing)")

	spawn(LPH_NO_VIRTUALIZE(function()
		repeat
			wait(0)
		until ItemsWrapped

		local Table = {}

		for Index, _ in next, Items do
			Table[#Table + 1] = Index
		end

		local Dropdown = TBPurchaseItems:CreateDropdown({
			Name = "Select Item / Weapon",
			Content = Table
		})

		TBPurchaseItems:CreateButton({
			Name = "Purchase Selected Item",
			Callback = function()
				local Value = Dropdown:GetOption()

				if Value == "..." then
					return SendNotification("X-Ro | Tha Bronx 2", "Please select an item first!", 2)
				end

				PurchaseItem(Items[Value])
			end
		})
	end))

	--// Player Modifications

	TBMods:CreateToggle({
		Name = "Instant Interact",
		Flag = "TB2_InstantPrompt_Enabled",
		Default = ThaBronxConfig.InstantPrompts,
		NoExecute = true,
		Callback = function(Value)
			ThaBronxConfig.InstantPrompts = Value
		end
	})

	TBMods:CreateToggle({
		Name = "Disable Camera Bobbing",
		Flag = "TB2_Camera_Bobbing",
		Default = ThaBronxConfig.CameraBobbing,
		NoExecute = true,
		Callback = function(Value)
			ThaBronxConfig.CameraBobbing = Value

			GetCharacter():FindFirstChild("CameraBobbing").Enabled = not ThaBronxConfig.CameraBobbing
		end
	})

	TBMods:CreateToggle({
		Name = "Disable Blood / Death Effects",
		Flag = "TB2_Health_Effects",
		Default = ThaBronxConfig.DisableScreenEffects,
		NoExecute = true,
		Callback = LPH_JIT_MAX(function(Value)
			ThaBronxConfig.DisableScreenEffects = Value

			local Character = GetCharacter()

			for _, _Value in next, LocalPlayer.PlayerGui:GetChildren() do
				if _Value.Name == "BloodGui" or _Value.Name == "LowHealthT" or _Value.Name == "CloseRangeBlood" then
					_Value.Enabled = not ThaBronxConfig.DisableScreenEffects
				end
			end

			Character:FindFirstChild("LowHealthEffect").Enabled = not ThaBronxConfig.DisableScreenEffects
			Character:FindFirstChild("deathClient").Enabled = not ThaBronxConfig.DisableScreenEffects
		end)
	})

	TBMods:CreateToggle({
		Name = "No Jump Cooldown",
		Flag = "TB2_NoJumpCooldown",
		Default = ThaBronxConfig.NoJumpCooldown,
		NoExecute = true,
		Callback = function(Value)
			ThaBronxConfig.NoJumpCooldown = Value

			LocalPlayer.PlayerGui:WaitForChild("JumpDebounce", true):FindFirstChildOfClass("LocalScript").Enabled = not ThaBronxConfig.NoJumpCooldown
		end
	})

	TBMods:CreateToggle({
		Name = "Instant Revive",
		Flag = "TB2_InstantRevive",
		Default = ThaBronxConfig.InstantRevive,
		NoExecute = true,
		Callback = LPH_JIT_MAX(function(Value)
			ThaBronxConfig.InstantRevive = Value

			local Dead = LocalPlayer.PlayerGui:WaitForChild("LowHealthT", true):FindFirstChildOfClass("Frame")

			if Value and Dead then
				TB2Connections["InstantRevive"] = Dead.Changed:Connect(function(Property)
					if Property == "Visible" and Dead.Visible and ThaBronxConfig.InstantRevive then
						repeat
							FSpamRemote:FireServer(); wait(0)
						until not Dead.Visible
					end
				end)
			end
		end)
	})

	TBMods:CreateToggle({
		Name = "Infinite Health / God Mode",
		Flag = "TB2_GodMode",
		Default = ThaBronxConfig.GodMode,
		NoExecute = true,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.GodMode = Value
		end)
	})

	TBMods:CreateToggle({
		Name = "Infinite Sleep",
		Flag = "TB2_InfiniteSleep",
		Default = ThaBronxConfig.InfiniteSleep,
		NoExecute = true,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.InfiniteSleep = Value

			if not GetREnvSupport then -- Support for executors without "getrenv", impractical alternative.
				LocalPlayer.PlayerGui.SleepGui.Frame.sleep.SleepBar.sleepScript.Disabled = Value
			end
		end)
	})

	TBMods:CreateToggle({
		Name = "Infinite Hunger",
		Flag = "TB2_InfiniteHunger",
		Default = ThaBronxConfig.InfiniteHunger,
		NoExecute = true,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.InfiniteHunger = Value

			LocalPlayer.PlayerGui.Hunger.Frame.Frame.Frame.HungerBarScript.Disabled = Value
		end)
	})

	TBMods:CreateToggle({
		Name = "Infinite Stamina",
		Flag = "TB2_InfiniteStamina",
		Default = ThaBronxConfig.InfiniteStamina,
		NoExecute = true,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.InfiniteStamina = Value

			LocalPlayer.PlayerGui.Run.Frame.Frame.Frame.StaminaBarScript.Disabled = Value
		end)
	})

	TBMods:CreateToggle({
		Name = "No Rent Pay",
		Flag = "TB2_NoRentPay",
		Default = ThaBronxConfig.NoRentPay,
		NoExecute = true,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.NoRentPay = Value

			LocalPlayer.PlayerGui.RentGui.LocalScript.Disabled = Value
		end)
	})

	TBMods:CreateToggle({
		Name = "No Fall Damage",
		Flag = "TB2_NoFallDamage",
		Default = ThaBronxConfig.NoFallDamage,
		NoExecute = true,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.NoFallDamage = Value

			if GetCharacter() then
				GetCharacter():WaitForChild("FallDamageRagdoll", true).Disabled = Value
			end
		end)
	})

	TBMods:CreateToggle({
		Name = "Instant Respawn",
		Flag = "TB2_InstantRespawn",
		Default = ThaBronxConfig.InstantRespawn,
		NoExecute = true,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.InstantRespawn = Value
		end)
	})

	if RequireSupport then
		TBMods:CreateLabel("Weapon Modifications / Gun Mods")

		for Index, _ in next, ThaBronxConfig._Modifications do
			TBMods:CreateToggle({
				Name = stringgsub(Index, "(%l)(%u)", LPH_NO_VIRTUALIZE(function(...)
					return select(1, ...).." "..select(2, ...)
				end)),
				Flag = "TB2_"..Index,
				Callback = LPH_NO_VIRTUALIZE(function(Value)
					ThaBronxConfig.Modifications[Index] = Value
				end)
			})
		end
	else
		warn("X-RO_THA_BRONX_2 > Your script executor does not support the weapon modification features (gun mods)!")
	end

	--// Miscellaneous

	TBMisc:CreateButton({
		Name = "Duplicate Item (Bag)",
		Callback = LPH_JIT_MAX(function()
			if not GetCharacter():FindFirstChildOfClass("Tool") then
				return SendNotification("X-Ro | Tha Bronx 2", "You must equip the desired gun before running this action!", 3)
			end

			if not LocalPlayer.Backpack:FindFirstChild("Bag") then
				return SendNotification("X-Ro | Tha Bronx 2", "You must own a bag ($500) to perform this action!", 3)
			end

			if Debounce then
				return SendNotification("X-Ro | Tha Bronx 2", "There is a different function currently in action, please wait until it finishes!", 4)
			end

			Debounce = true

			local GunName = GetCharacter():FindFirstChildOfClass("Tool").Name

			GetCharacter():FindFirstChildOfClass("Humanoid"):UnequipTools()

			spawn(function()
				BackpackRemote:InvokeServer("Store", GunName)
			end)

			spawn(function()
				ListWeaponRemote:FireServer(GunName, 100000)
			end)

			wait(0.2)

			BuyItemRemote:FireServer(GunName, "Remove")

			wait(1.5)

			BackpackRemote:InvokeServer("Grab", GunName)

			Debounce = false
		end)
	})

	TBMisc:CreateButton({
		Name = "Duplicate Item (Safe)",
		Callback = DuplicateItem
	})

	TBMisc:CreateToggle({
		Name = "Store Duplicated Item In Safe",
		Flag = "TB2_StoreDupe",
		Default = ThaBronxConfig.StoreDupe,
		Callback = function(Value)
			ThaBronxConfig.StoreDupe = Value
		end
	})

	TBMisc:CreateButton({
		Name = "Clean Money",
		Callback = CleanMoney
	})

	TBMisc:CreateButton({
		Name = "Cook Rice",
		Callback = CookRice
	})

	TBMisc:CreateButton({
		Name = "Plant Seeds",
		Callback = PlantSeeds
	})

	TBMisc:CreateButton({
		Name = "Collect / Steal Grass",
		Callback = CollectGrass
	})

	TBMisc:CreateButton({
		Name = "Teleport To Closest Safe",
		Callback = LPH_NO_VIRTUALIZE(function()
			if not Debounce then
				Teleport(workspace["1# Map"]["2 Crosswalks"].Safes.Safe.Union.CFrame)
			else
				SendNotification("X-Ro | Tha Bronx 2", "Couldn't teleport to a safe, there is a different function in action!", 3)
			end
		end)
	})

	TBMisc:CreateButton({
		Name = "Store Item In Safe",
		Callback = LPH_NO_VIRTUALIZE(function()
			if Debounce then
				return SendNotification("X-Ro | Tha Bronx 2", "Couldn't store item, there is a different function in action!", 3)
			end

			local Item = GetCharacter():FindFirstChildOfClass("Tool")

			if not Item then
				return SendNotification("X-Ro | Tha Bronx 2", "You must equip an item before running this action!", 2)
			end

			Debounce = true

			local Name = Item.Name
			GetCharacter():FindFirstChildOfClass("Humanoid"):UnequipTools()

			local Safe = workspace["1# Map"]["2 Crosswalks"].Safes.Safe
			local OldCFrame = GetCharacter():FindFirstChild("HumanoidRootPart").CFrame

			Teleport(Safe.Union.CFrame)

			wait(0.5)

			Inventory:FireServer("Change", Name, "Backpack", Safe)

			Teleport(OldCFrame); Debounce = false
		end)
	})

	TBMisc:CreateButton({
		Name = "Open / Close Market",
		Callback = LPH_NO_VIRTUALIZE(function()
			local GUI = LocalPlayer.PlayerGui:FindFirstChild("Bronx Market 2")

			if GUI then
				GUI.Enabled = not GUI.Enabled
			end
		end)
	})

	TBMisc:CreateToggle({
		Name = "Auto Cook Rice",
		Flag = "TB2_AutoCookRice",
		Default = ThaBronxConfig.AutoCookRice,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.AutoCookRice = Value

			if Value then
				CookRice()
			end
		end)
	})

	TBMisc:CreateToggle({
		Name = "Auto Plant Seeds",
		Flag = "TB2_AutoPlantSeeds",
		Default = ThaBronxConfig.AutoPlantSeeds,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.AutoPlantSeeds = Value

			if Value then
				PlantSeeds()
			end
		end)
	})

	--[[
	TBMisc:CreateToggle({
		Name = "Auto Duplicate Rice / Grass",
		Flag = "TB2_AutoDuplicate",
		Default = ThaBronxConfig.AutoDuplicate,
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			ThaBronxConfig.AutoDuplicate = Value
		end)
	})
	]]

	TBMisc:CreateTextBox({
		Name = "Amount (Cash) - Max: $30,000",
		Flag = "TB2_Cash_Amount",
		Placeholder = "[<ENTER_$_AMOUNT>]",
		Callback = LPH_NO_VIRTUALIZE(function(Value)
			CashAmountInput = stringgsub(Value, "%D+", "")
		end)
	})

	TBMisc:CreateButton({
		Name = "Drop Amount",
		Callback = LPH_NO_VIRTUALIZE(function()
			if tonumber(CashAmountInput) then
				BankProcessRemote:InvokeServer("Drop", CashAmountInput)
			else
				SendNotification("X-Ro | Tha Bronx 2", "Please input a natural number!", 2)
			end
		end)
	})

	TBMisc:CreateButton({
		Name = "Withdraw Amount",
		Callback = LPH_NO_VIRTUALIZE(function()
			if tonumber(CashAmountInput) then
				BankAction:FireServer("with", CashAmountInput)
			else
				SendNotification("X-Ro | Tha Bronx 2", "Please input a natural number!", 2)
			end
		end)
	})

	TBMisc:CreateButton({
		Name = "Deposit Amount",
		Callback = LPH_NO_VIRTUALIZE(function()
			if tonumber(CashAmountInput) then
				BankAction:FireServer("depo", CashAmountInput)
			else
				SendNotification("X-Ro | Tha Bronx 2", "Please input a natural number!", 2)
			end
		end)
	})

	--// Locations

	for Index, Value in next, Locations do
		if not stringmatch(Index, "(Safe Zone)") then
			TBLocationsSection:CreateButton({
				Name = Index,
				Callback = LPH_NO_VIRTUALIZE(function()
					Teleport(Value)
				end)
			})
		end
	end

	TBLocationsSection:CreateLabel("Safe Zones")

	for Index, Value in next, Locations do
		if stringmatch(Index, "(Safe Zone)") then
			TBLocationsSection:CreateButton({
				Name = stringgsub(Index, " %(Safe Zone%)", ""),
				Callback = LPH_NO_VIRTUALIZE(function()
					Teleport(Value)
				end)
			})
		end
	end

	--// End

	if GetREnvSupport then
		--spawn(LPH_NO_VIRTUALIZE(function()
			getrenv()._G.Notify("X-Ro | Tha Bronx 2 - loaded successfully in "..tostring(math.floor(tick() - Start)).." seconds. ("..identifyexecutor()..")")
			getrenv().shared.WarnPlayer("Thank you for using X-Ro, "..LocalPlayer.Name.."!")
		--end))
	end

	getgenv().XRO_TB2_LOADED = true
end