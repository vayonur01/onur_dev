-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- VARIABLES
local flySpeed = 1
local walkSpeed = 16
local jumpValue = 50
local flying, noclip = false, false
local individualESP = {} 

-- GUI HELPER
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local function round(o, r)
	local c = Instance.new("UICorner", o)
	c.CornerRadius = UDim.new(0, r or 10)
end

------------------------------------------------
-- MAIN FRAME
------------------------------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 480, 0, 450)
Main.Position = UDim2.new(0.5, -240, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
round(Main)

local strokeMain = Instance.new("UIStroke", Main)
strokeMain.Thickness = 2
task.spawn(function()
	while true do
		RunService.RenderStepped:Wait()
		strokeMain.Color = Color3.fromHSV(tick()%5/5, 1, 1)
	end
end)

local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Text = "Premium Hub | emreonrwp"
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.TextColor3 = Color3.new(1, 1, 1)
Header.Active = true
round(Header)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, -140)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -150, 1, -55)
Container.Position = UDim2.new(0, 140, 0, 45)
Container.BackgroundTransparency = 1

------------------------------------------------
-- DRAG LOGIC (FIXED)
------------------------------------------------
local function makeDraggable(obj, target)
	target = target or obj
	local dragging, dragStart, startPos
	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

------------------------------------------------
-- TABS & SEARCH
------------------------------------------------
local Tabs = {}
local function createTab(name)
	local page = Instance.new("Frame", Container)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1, 0, 0, 35); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btn.TextColor3 = Color3.new(1, 1, 1); round(btn, 6)
	btn.MouseButton1Click:Connect(function() for _, p in pairs(Tabs) do p.Visible = false end page.Visible = true end)
	Tabs[name] = page; return page
end

local charTabRaw = createTab("Karakter")
local charTab = Instance.new("ScrollingFrame", charTabRaw)
charTab.Size = UDim2.new(1,0,1,0); charTab.BackgroundTransparency = 1; charTab.ScrollBarThickness = 2
Instance.new("UIListLayout", charTab).Padding = UDim.new(0, 10)

local playerTabRaw = createTab("Oyuncular")
charTabRaw.Visible = true

local SearchBox = Instance.new("TextBox", playerTabRaw)
SearchBox.Size = UDim2.new(0.95, 0, 0, 30); SearchBox.PlaceholderText = "Oyuncu Ara..."; SearchBox.Text = ""; SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35); SearchBox.TextColor3 = Color3.new(1, 1, 1); round(SearchBox, 6)

local playerListScroll = Instance.new("ScrollingFrame", playerTabRaw)
playerListScroll.Size = UDim2.new(1, 0, 1, -40); playerListScroll.Position = UDim2.new(0, 0, 0, 40); playerListScroll.BackgroundTransparency = 1; playerListScroll.ScrollBarThickness = 2
local plLayout = Instance.new("UIListLayout", playerListScroll); plLayout.Padding = UDim.new(0, 8)

------------------------------------------------
-- SLIDER LOGIC (100% FIXED)
------------------------------------------------
local function createSlider(parent, text, default, min, max, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(0.95, 0, 0, 50); holder.BackgroundTransparency = 1
	
	local lbl = Instance.new("TextLabel", holder)
	lbl.Text = text..": "..default; lbl.Size = UDim2.new(1,0,0,20); lbl.TextColor3 = Color3.new(1,1,1); lbl.BackgroundTransparency = 1
	
	local sld = Instance.new("Frame", holder)
	sld.Size = UDim2.new(1,0,0,6); sld.Position = UDim2.new(0,0,0,30); sld.BackgroundColor3 = Color3.fromRGB(60,60,60); round(sld)
	
	local knb = Instance.new("TextButton", sld)
	knb.Size = UDim2.new(0,16,0,16); knb.Text = ""; knb.BackgroundColor3 = Color3.new(1,1,1); round(knb, 100)
	
	local initialRel = math.clamp((default - min) / (max - min), 0, 1)
	knb.Position = UDim2.new(initialRel, -8, 0.5, -8)

	local dragging = false

	local function move()
		local mousePos = UIS:GetMouseLocation().X
		local relativeX = math.clamp((mousePos - sld.AbsolutePosition.X) / sld.AbsoluteSize.X, 0, 1)
		knb.Position = UDim2.new(relativeX, -8, 0.5, -8)
		local val = math.floor(min + (relativeX * (max - min)))
		lbl.Text = text..": "..val
		callback(val)
	end

	knb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move() end
	end)
end

------------------------------------------------
-- CHARACTER FEATURES
------------------------------------------------
createSlider(charTab, "WalkSpeed", 16, 16, 250, function(v)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end
end)

createSlider(charTab, "JumpPower", 50, 0, 500, function(v)
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then if hum.UseJumpPower then hum.JumpPower = v else hum.JumpHeight = v/2 end end
end)

local function createToggle(parent, text, cb)
	local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.95, 0, 0, 35); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); round(b, 6)
	b.MouseButton1Click:Connect(function() cb(b) end)
end

local bv, bg, flyConn
createToggle(charTab, "Fly: Kapalı", function(b)
	flying = not flying; b.Text = flying and "Fly: Açık" or "Fly: Kapalı"
	if flying then
		local char = LocalPlayer.Character; local root = char.HumanoidRootPart; char.Humanoid.PlatformStand = true
		bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1e6,1e6,1e6)
		bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
		flyConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera; local dir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
			bv.Velocity = dir.Magnitude > 0 and dir.Unit * (flySpeed * 60) or Vector3.zero; bg.CFrame = cam.CFrame
		end)
	else
		if flyConn then flyConn:Disconnect() end; if bv then bv:Destroy() end; if bg then bg:Destroy() end
		if LocalPlayer.Character then LocalPlayer.Character.Humanoid.PlatformStand = false end
	end
end)

createToggle(charTab, "Noclip: Kapalı", function(b) noclip = not noclip; b.Text = noclip and "Noclip: Açık" or "Noclip: Kapalı" end)

------------------------------------------------
-- PLAYER LIST & INDIVIDUAL ESP
------------------------------------------------
local function updatePlayerList()
	for _, v in pairs(playerListScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
	local searchText = SearchBox.Text:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and (p.DisplayName:lower():find(searchText) or p.Name:lower():find(searchText)) then
			local row = Instance.new("Frame", playerListScroll); row.Size = UDim2.new(0.95, 0, 0, 50); row.BackgroundColor3 = Color3.fromRGB(30, 30, 30); round(row, 6)
			local img = Instance.new("ImageLabel", row); img.Size = UDim2.new(0, 40, 0, 40); img.Position = UDim2.new(0, 5, 0.5, -20); img.BackgroundTransparency = 1; round(img, 100)
			pcall(function() img.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
			local nameBtn = Instance.new("TextButton", row); nameBtn.Size = UDim2.new(0.4, 0, 1, 0); nameBtn.Position = UDim2.new(0, 50, 0, 0); nameBtn.Text = p.DisplayName; nameBtn.TextColor3 = Color3.new(1,1,1); nameBtn.BackgroundTransparency = 1; nameBtn.TextXAlignment = Enum.TextXAlignment.Left; nameBtn.Font = Enum.Font.SourceSansBold
			nameBtn.MouseButton1Click:Connect(function() if p.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end)
			local espBtn = Instance.new("TextButton", row); espBtn.Size = UDim2.new(0, 80, 0, 25); espBtn.Position = UDim2.new(1, -90, 0.5, -12); espBtn.Text = individualESP[p] and "ESP: ON" or "ESP: OFF"; espBtn.BackgroundColor3 = individualESP[p] and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(150, 40, 40); espBtn.TextColor3 = Color3.new(1, 1, 1); round(espBtn, 15)
			espBtn.MouseButton1Click:Connect(function()
				if individualESP[p] then
					individualESP[p]:Destroy(); individualESP[p] = nil; espBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40); espBtn.Text = "ESP: OFF"
				else
					if p.Character then
						local h = Instance.new("Highlight", p.Character); h.FillTransparency = 0.5; individualESP[p] = h; espBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40); espBtn.Text = "ESP: ON"
					end
				end
			end)
		end
	end
	playerListScroll.CanvasSize = UDim2.new(0, 0, 0, plLayout.AbsoluteContentSize.Y + 20)
end
SearchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)
Players.PlayerAdded:Connect(updatePlayerList); Players.PlayerRemoving:Connect(updatePlayerList); updatePlayerList()

------------------------------------------------
-- BOTTOM BUTTONS & TOGGLE
------------------------------------------------
local function createQuickBtn(text, pos, color, cb)
	local b = Instance.new("TextButton", Main); b.Size = UDim2.new(0, 120, 0, 35); b.Position = pos; b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1); round(b, 6); b.MouseButton1Click:Connect(cb)
end
createQuickBtn("Menüyü Gizle", UDim2.new(0, 10, 1, -85), Color3.fromRGB(40, 40, 40), function() Main.Visible = false end)
createQuickBtn("Çıkış", UDim2.new(0, 10, 1, -45), Color3.fromRGB(120, 40, 40), function() ScreenGui:Destroy() end)

local ToggleIcon = Instance.new("TextButton", ScreenGui); ToggleIcon.Size = UDim2.new(0, 60, 0, 60); ToggleIcon.Position = UDim2.new(0, 20, 0.5, -30); ToggleIcon.Text = "≡"; ToggleIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30); ToggleIcon.TextColor3 = Color3.new(1, 1, 1); ToggleIcon.TextScaled = true; round(ToggleIcon, 100)
ToggleIcon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

makeDraggable(Header, Main); makeDraggable(ToggleIcon)

RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
	end
end)
RunService.RenderStepped:Connect(function()
	local c = Color3.fromHSV(tick()%5/5, 1, 1)
	for p, highlight in pairs(individualESP) do if highlight and highlight.Parent then highlight.FillColor = c else individualESP[p] = nil end end
end)
