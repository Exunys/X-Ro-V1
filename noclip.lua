if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = function(...)
		return ...
	end
end

LPH_NO_VIRTUALIZE(function()
	getgenv().XRO_NoClip = false

	local cloneref = cloneref or function(...)
		return(...)
	end

	local RunService = cloneref(game:GetService("RunService"))
	local Players = cloneref(game:GetService("Players"))
	local LocalPlayer = Players.LocalPlayer

	local CachedParts, RunLoops = {}, {StepTable = {}}

	function RunLoops:BindToStepped(Name, Closure)
		if not RunLoops.StepTable[Name] then
			RunLoops.StepTable[Name] = RunService.Stepped:Connect(Closure)
		end
	end

	function RunLoops:UnbindFromStepped(Name)
		if RunLoops.StepTable[Name] then
			RunLoops.StepTable[Name]:Disconnect()
			RunLoops.StepTable[Name] = nil
		end
	end

	local function IsAlive(Player, HeadCheck)
		Player = Player or LocalPlayer

		if Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and (not HeadCheck or Player.Character:FindFirstChild("Head")) then
			return true
		else
			return false
		end
	end

	RunService.RenderStepped:Connect(function()
		if XRO_NoClip and IsAlive() then
			if not RunLoops.StepTable.NoClip then
				RunLoops:BindToStepped("NoClip", function()
					for Index, Value in next, LocalPlayer.Character:GetChildren() do
						if Value:IsA("BasePart") and Value.CanCollide then
							CachedParts[Index] = Value
							Value.CanCollide = false
						end
					end
				end)
			end
		else
			for _, Part in next, CachedParts do
				if Part:IsA("BasePart") then
					Part.CanCollide = true
				end
			end

			CachedParts = {}

			RunLoops:UnbindFromStepped("NoClip")
		end

		task.wait(0.05)
	end)
end)()