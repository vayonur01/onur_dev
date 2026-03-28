-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local selectedFont = Enum.Font.FredokaOne
local flySpeed = 50
local spinPower = 16 
local noclip, flying, spinning = false, false, false
local spinVelocity = nil
local individualESP = {} 

-- GUI BASE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumHub_V7_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local function round(o, r)
	local c = Instance.new("UICorner", o)
	c.CornerRadius = UDim.new(0, r or 10)
end

------------------------------------------------
-- LOGIN SYSTEM
------------------------------------------------
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 320, 0, 200)
LoginFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
LoginFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LoginFrame.BorderSizePixel = 0
round(LoginFrame)

local LoginStroke = Instance.new("UIStroke", LoginFrame)
LoginStroke.Thickness = 2
LoginStroke.Color = Color3.fromRGB(80, 80, 80)

local LoginHeader = Instance.new("TextLabel", LoginFrame)
LoginHeader.Size = UDim2.new(1, 0, 0, 45)
LoginHeader.Text = "VayOnur Hub Login"
LoginHeader.TextColor3 = Color3.new(1, 1, 1)
LoginHeader.Font = selectedFont
LoginHeader.TextSize = 20
LoginHeader.BackgroundTransparency = 1

local PasswordBox = Instance.new("TextBox", LoginFrame)
PasswordBox.Size = UDim2.new(0.85, 0, 0, 45)
PasswordBox.Position = UDim2.new(0.075, 0, 0.4, 0)
PasswordBox.PlaceholderText = "Enter Code..."
PasswordBox.Text = ""
PasswordBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PasswordBox.TextColor3 = Color3.new(1, 1, 1)
PasswordBox.Font = selectedFont
PasswordBox.TextSize = 16
round(PasswordBox, 8)

local LoginBtn = Instance.new("TextButton", LoginFrame)
LoginBtn.Size = UDim2.new(0.85, 0, 0, 45)
LoginBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
LoginBtn.Text = "LOGIN"
LoginBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
LoginBtn.TextColor3 = Color3.new(1, 1, 1)
LoginBtn.Font = selectedFont
LoginBtn.TextSize = 18
round(LoginBtn, 8)

local Status = Instance.new("TextLabel", LoginFrame)
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0.15, 0)
Status.Text = "Waiting for Code..."
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 11
Status.BackgroundTransparency = 1

------------------------------------------------
-- MAIN WINDOW & ICON
------------------------------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 520, 0, 550)
Main.Position = UDim2.new(0.5, -260, 0.5, -275)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Visible = false 
round(Main)

local strokeMain = Instance.new("UIStroke", Main)
strokeMain.Thickness = 2

local ToggleIcon = Instance.new("TextButton", ScreenGui)
ToggleIcon.Size = UDim2.new(0, 65, 0, 65)
ToggleIcon.Position = UDim2.new(0, 20, 0.5, -32)
ToggleIcon.Text = "≡"
ToggleIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleIcon.TextColor3 = Color3.new(1, 1, 1)
ToggleIcon.Font = selectedFont
ToggleIcon.TextScaled = true
ToggleIcon.Visible = false 
round(ToggleIcon, 100)

local strokeToggle = Instance.new("UIStroke", ToggleIcon)
strokeToggle.Thickness = 3
strokeToggle.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

------------------------------------------------
-- AUTH LOGIC (MODIFIED MESSAGES)
------------------------------------------------
LoginBtn.MouseButton1Click:Connect(function()
	Status.Text = "Checking..."
	Status.TextColor3 = Color3.new(1, 1, 1)
	
	local success, result = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/vayonur01/onur_dev/main/README.md")
	end)
	
	if success then
		local cleanPassword = result:gsub("%s+", "") 
		if PasswordBox.Text == cleanPassword then
			Status.Text = "Opening..." -- Updated from Login Successful
			Status.TextColor3 = Color3.new(0, 1, 0)
			task.wait(0.5)
			LoginFrame:Destroy()
			Main.Visible = true
			ToggleIcon.Visible = true
		else
			Status.Text = "Error!" -- Updated from Incorrect Password
			Status.TextColor3 = Color3.new(1, 0, 0)
		end
	else
		Status.Text = "Connection Error!"
		Status.TextColor3 = Color3.new(1, 0.5, 0)
	end
end)

------------------------------------------------
-- MENU CONTENT
------------------------------------------------
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1, 0, 0, 45)
Header.Text = "  VayOnur Hub | By Onur_dev"
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.TextColor3 = Color3.new(1, 1, 1)
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Font = selectedFont
Header.TextSize = 22
round(Header)

local function createTopBtn(text, color, pos, cb)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(0, 30, 0, 30); b.Position = pos; b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1); b.Font = selectedFont; b.TextSize = 18; b.ZIndex = 5; round(b, 100)
	b.MouseButton1Click:Connect(cb)
end
createTopBtn("X", Color3.fromRGB(180, 50, 50), UDim2.new(1, -40, 0, 7), function() ScreenGui:Destroy() end)
createTopBtn("-", Color3.fromRGB(60, 60, 60), UDim2.new(1, -80, 0, 7), function() Main.Visible = false end)

local UserInfo = Instance.new("Frame", Main)
UserInfo.Size = UDim2.new(0, 140, 0, 50); UserInfo.Position = UDim2.new(0, 10, 1, -60); UserInfo.BackgroundTransparency = 1
local UserImg = Instance.new("ImageLabel", UserInfo)
UserImg.Size = UDim2.new(0, 45, 0, 45); UserImg.Position = UDim2.new(0, 0, 0.5, -22); UserImg.BackgroundColor3 = Color3.fromRGB(35, 35, 35); round(UserImg, 100)
local UserName = Instance.new("TextLabel", UserInfo)
UserName.Size = UDim2.new(1, -50, 1, 0); UserName.Position = UDim2.new(0, 55, 0, 0); UserName.Text = LocalPlayer.DisplayName; UserName.TextColor3 = Color3.new(1, 1, 1); UserName.Font = selectedFont; UserName.TextSize = 14; UserName.TextXAlignment = Enum.TextXAlignment.Left; UserName.BackgroundTransparency = 1

task.spawn(function()
	local content, isLoaded = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	if isLoaded then UserImg.Image = content end
end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 130, 1, -160); Sidebar.Position = UDim2.new(0, 10, 0, 60); Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -160, 1, -70); Container.Position = UDim2.new(0, 150, 0, 60); Container.BackgroundTransparency = 1

local Tabs = {}
local function createTab(name)
	local page = Instance.new("Frame", Container); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = false
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.new(1, 0, 0, 40); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = selectedFont; btn.TextSize = 18; round(btn, 6)
	btn.MouseButton1Click:Connect(function() for _, p in pairs(Tabs) do p.Visible = false end page.Visible = true end)
	Tabs[name] = page; return page
end

local charTabRaw = createTab("Character")
local charTab = Instance.new("ScrollingFrame", charTabRaw); charTab.Size = UDim2.new(1,0,1,0); charTab.BackgroundTransparency = 1; charTab.ScrollBarThickness = 2; charTab.CanvasSize = UDim2.new(0,0,0,850)
Instance.new("UIListLayout", charTab).Padding = UDim.new(0, 12)
local playerTabRaw = createTab("Players")
charTabRaw.Visible = true

------------------------------------------------
-- PLAYER LIST & ESP LOGIC
------------------------------------------------
local function removeESP(p) if individualESP[p] then individualESP[p]:Destroy(); individualESP[p] = nil end end
local function applyESP(p)
	if p == LocalPlayer or not p.Character then return end
	removeESP(p); local h = Instance.new("Highlight", p.Character); h.FillTransparency = 0.5; h.OutlineColor = Color3.new(1,1,1); individualESP[p] = h
end

local allEspBtn = Instance.new("TextButton", playerTabRaw)
allEspBtn.Size = UDim2.new(0.95, 0, 0, 35); allEspBtn.Text = "Toggle All ESP"; allEspBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); allEspBtn.TextColor3 = Color3.new(1, 1, 1); allEspBtn.Font = selectedFont; allEspBtn.TextSize = 16; round(allEspBtn, 6)

local SearchBox = Instance.new("TextBox", playerTabRaw)
SearchBox.Size = UDim2.new(0.95, 0, 0, 35); SearchBox.Position = UDim2.new(0,0,0,40); SearchBox.PlaceholderText = "Search Player..."; SearchBox.Text = ""; SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35); SearchBox.TextColor3 = Color3.new(1, 1, 1); SearchBox.Font = selectedFont; SearchBox.TextSize = 16; round(SearchBox, 6)

local pScroll = Instance.new("ScrollingFrame", playerTabRaw)
pScroll.Size = UDim2.new(1, 0, 1, -85); pScroll.Position = UDim2.new(0, 0, 0, 85); pScroll.BackgroundTransparency = 1; pScroll.ScrollBarThickness = 2
local plLayout = Instance.new("UIListLayout", pScroll); plLayout.Padding = UDim.new(0, 8)

local function updatePlayerList()
	for _, v in pairs(pScroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
	local sText = SearchBox.Text:lower()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and (sText == "" or p.DisplayName:lower():find(sText)) then
			local row = Instance.new("Frame", pScroll); row.Size = UDim2.new(0.95, 0, 0, 55); row.BackgroundColor3 = Color3.fromRGB(30, 30, 30); round(row, 6)
			local pImg = Instance.new("ImageLabel", row); pImg.Size = UDim2.new(0, 45, 0, 45); pImg.Position = UDim2.new(0, 5, 0.5, -22); pImg.BackgroundColor3 = Color3.fromRGB(40, 40, 40); round(pImg, 100)
			task.spawn(function() local content, isLoaded = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) if isLoaded then pImg.Image = content end end)
			local nameLbl = Instance.new("TextLabel", row); nameLbl.Size = UDim2.new(0.3, 0, 1, 0); nameLbl.Position = UDim2.new(0, 55, 0, 0); nameLbl.Text = p.DisplayName; nameLbl.TextColor3 = Color3.new(1,1,1); nameLbl.Font = selectedFont; nameLbl.TextSize = 12; nameLbl.BackgroundTransparency = 1; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
			local tpBtn = Instance.new("TextButton", row); tpBtn.Size = UDim2.new(0, 50, 0, 30); tpBtn.Position = UDim2.new(1, -145, 0.5, -15); tpBtn.Text = "TP"; tpBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 180); tpBtn.TextColor3 = Color3.new(1, 1, 1); tpBtn.Font = selectedFont; tpBtn.TextSize = 11; round(tpBtn, 6)
			tpBtn.MouseButton1Click:Connect(function() if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end end)
			local pEspBtn = Instance.new("TextButton", row); pEspBtn.Size = UDim2.new(0, 80, 0, 30); pEspBtn.Position = UDim2.new(1, -90, 0.5, -15); pEspBtn.Font = selectedFont; pEspBtn.TextSize = 11; round(pEspBtn, 15); pEspBtn.TextColor3 = Color3.new(1, 1, 1)
			if individualESP[p] then pEspBtn.Text = "ESP: ON"; pEspBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40) else pEspBtn.Text = "ESP: OFF"; pEspBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40) end
			pEspBtn.MouseButton1Click:Connect(function() 
				if individualESP[p] then removeESP(p) else applyESP(p) end 
				updatePlayerList() 
			end)
		end
	end
	pScroll.CanvasSize = UDim2.new(0,0,0, plLayout.AbsoluteContentSize.Y + 10)
end

allEspBtn.MouseButton1Click:Connect(function()
	local activeCount = 0; for _ in pairs(individualESP) do activeCount += 1 end
	if activeCount > 0 then for _, p in pairs(Players:GetPlayers()) do removeESP(p) end else for _, p in pairs(Players:GetPlayers()) do applyESP(p) end end
	updatePlayerList() 
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)
Players.PlayerAdded:Connect(updatePlayerList); Players.PlayerRemoving:Connect(function(p) removeESP(p) updatePlayerList() end); updatePlayerList()

------------------------------------------------
-- CHARACTER TOOLS (SLIDERS/TOGGLES)
------------------------------------------------
local function createSlider(parent, text, default, min, max, callback)
	local holder = Instance.new("Frame", parent); holder.Size = UDim2.new(0.95, 0, 0, 60); holder.BackgroundTransparency = 1
	local lbl = Instance.new("TextLabel", holder); lbl.Text = text..": "..default; lbl.Size = UDim2.new(1,0,0,25); lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = selectedFont; lbl.TextSize = 16; lbl.BackgroundTransparency = 1
	local sld = Instance.new("Frame", holder); sld.Size = UDim2.new(1,0,0,8); sld.Position = UDim2.new(0,0,0,35); sld.BackgroundColor3 = Color3.fromRGB(60,60,60); round(sld)
	local knb = Instance.new("TextButton", sld); knb.Size = UDim2.new(0,18,0,18); knb.Text = ""; knb.BackgroundColor3 = Color3.new(1,1,1); round(knb, 100)
	local function upPos(v) local r = math.clamp((v - min) / (max - min), 0, 1); knb.Position = UDim2.new(r, -9, 0.5, -9); lbl.Text = text..": "..v end
	upPos(default); local drag = false
	knb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
	UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
		local r = math.clamp((UIS:GetMouseLocation().X - sld.AbsolutePosition.X) / sld.AbsoluteSize.X, 0, 1)
		local v = math.floor(min + (r * (max - min))); upPos(v); callback(v)
	end end)
	return upPos
end

local upWS = createSlider(charTab, "WalkSpeed", 16, 16, 300, function(v) if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v end end)
local upJP = createSlider(charTab, "JumpPower", 50, 0, 500, function(v) 
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then if hum.UseJumpPower then hum.JumpPower = v else hum.JumpHeight = v/2 end end
end)
local upFS = createSlider(charTab, "Fly Speed", 50, 10, 500, function(v) flySpeed = v end)
local upSP = createSlider(charTab, "Spin Speed", 16, 0, 500, function(v) spinPower = v if spinVelocity then spinVelocity.AngularVelocity = Vector3.new(0, spinPower, 0) end end)

local ResetFrame = Instance.new("Frame", charTab); ResetFrame.Size = UDim2.new(0.95, 0, 0, 35); ResetFrame.BackgroundTransparency = 1
Instance.new("UIListLayout", ResetFrame).FillDirection = Enum.FillDirection.Horizontal; ResetFrame.UIListLayout.Padding = UDim.new(0, 5); ResetFrame.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createResetBtn(text, cb)
	local b = Instance.new("TextButton", ResetFrame); b.Size = UDim2.new(0.24, 0, 1, 0); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(45, 45, 45); b.TextColor3 = Color3.new(1, 1, 1); b.Font = selectedFont; b.TextSize = 9; round(b, 6); b.MouseButton1Click:Connect(cb)
end
createResetBtn("Speed RST", function() if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = 16 end; upWS(16) end)
createResetBtn("Jump RST", function() if LocalPlayer.Character then local hum=LocalPlayer.Character.Humanoid; if hum.UseJumpPower then hum.JumpPower=50 else hum.JumpHeight=7.2 end end; upJP(50) end)
createResetBtn("Fly RST", function() flySpeed = 50; upFS(50) end)
createResetBtn("Spin RST", function() spinPower = 16; upSP(16) end)

local function createToggle(parent, text_off, text_on, cb)
	local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.95, 0, 0, 40); b.Text = text_off; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.new(1,1,1); b.Font = selectedFont; b.TextSize = 16; round(b, 6)
	local state = false
	b.MouseButton1Click:Connect(function() 
		state = not state
		b.Text = state and text_on or text_off
		cb(state) 
	end)
end

createToggle(charTab, "Fly: Disabled", "Fly: Enabled", function(s)
	flying = s
	local char = LocalPlayer.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	if flying then
		char.Humanoid.PlatformStand = true
		bv = Instance.new("BodyVelocity", char.HumanoidRootPart); bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge); bv.Velocity = Vector3.zero
		bg = Instance.new("BodyGyro", char.HumanoidRootPart); bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); bg.P = 15000; bg.CFrame = char.HumanoidRootPart.CFrame
		flyConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera; local moveDir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
			bg.CFrame = cam.CFrame
			bv.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.zero
		end)
	else
		if flyConn then flyConn:Disconnect() end; if bv then bv:Destroy() end; if bg then bg:Destroy() end
		if LocalPlayer.Character then LocalPlayer.Character.Humanoid.PlatformStand = false end
	end
end)

createToggle(charTab, "Noclip: Disabled", "Noclip: Enabled", function(s) noclip = s end)

createToggle(charTab, "Spin: Disabled", "Spin: Enabled", function(s)
	spinning = s
	local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
	if spinning then
		if root then
			spinVelocity = Instance.new("AngularVelocity", root); spinVelocity.Name = "SpinForce"
			spinVelocity.MaxTorque = math.huge; spinVelocity.AngularVelocity = Vector3.new(0, spinPower, 0); spinVelocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
			local att = root:FindFirstChild("RootAttachment") or Instance.new("Attachment", root); spinVelocity.Attachment0 = att
		end
	else
		local force = root and root:FindFirstChild("SpinForce"); if force then force:Destroy() end; spinVelocity = nil
	end
end)

------------------------------------------------
-- DRAG & RAINBOW
------------------------------------------------
local function makeDraggableWithLogic(obj, target)
	target = target or obj; local drag, start, pos, startTime
	obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; startTime = tick(); start = i.Position; pos = target.Position end end)
	UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start; target.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y) end end)
	UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false; if tick() - startTime < 0.2 then Main.Visible = not Main.Visible end end end)
end
makeDraggableWithLogic(ToggleIcon)

local function simpleDrag(obj, target)
	local d, s, p; obj.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true; s=i.Position; p=target.Position end end)
	UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta=i.Position-s; target.Position=UDim2.new(p.X.Scale, p.X.Offset+delta.X, p.Y.Scale, p.Y.Offset+delta.Y) end end)
	UIS.InputEnded:Connect(function(i) if d then d=false end end)
end
simpleDrag(Header, Main)

RunService.RenderStepped:Connect(function()
	local rainbow = Color3.fromHSV(tick()%5/5, 1, 1)
	strokeMain.Color = rainbow
	strokeToggle.Color = rainbow
	if LoginFrame then LoginStroke.Color = rainbow end
	if noclip and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
	for p, h in pairs(individualESP) do if h and h.Parent then h.FillColor = rainbow else individualESP[p] = nil end end
end)
