-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- VARIABLES
local flySpeed = 1
local walkSpeed = 16
local jumpValue = 7
local flying = false
local noclip = false
local espEnabled = false
local shiftlock = false
local shiftConn

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local function round(o, r)
	local c = Instance.new("UICorner", o)
	c.CornerRadius = UDim.new(0, r or 10)
end

------------------------------------------------
-- MAIN
------------------------------------------------
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,320,0,650)
Main.Position = UDim2.new(0.5,-160,0.5,-325)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
round(Main)

local strokeMain = Instance.new("UIStroke", Main)
strokeMain.Thickness = 2

task.spawn(function()
	while true do
		RunService.RenderStepped:Wait()
		strokeMain.Color = Color3.fromHSV(tick()%5/5,1,1)
	end
end)

------------------------------------------------
-- HEADER DRAG
------------------------------------------------
local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,40)
Header.Text = "Instagram: emreonrwp"
Header.BackgroundColor3 = Color3.fromRGB(30,30,30)
Header.TextColor3 = Color3.new(1,1,1)
Header.Active = true
round(Header)

local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

------------------------------------------------
-- FLOAT BUTTON
------------------------------------------------
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0,60,0,60)
ToggleBtn.Position = UDim2.new(0,20,0.5,-30)
ToggleBtn.Text = "≡"
ToggleBtn.TextScaled = true
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Draggable = true
round(ToggleBtn,100)

ToggleBtn.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

------------------------------------------------
-- SLIDER
------------------------------------------------
local function createSlider(yPos, text, default, callback)
	local label = Instance.new("TextLabel", Main)
	label.Position = UDim2.new(0.05,0,yPos,0)
	label.Size = UDim2.new(0.9,0,0,25)
	label.Text = text..": "..default
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1

	local slider = Instance.new("Frame", Main)
	slider.Size = UDim2.new(0.9,0,0,6)
	slider.Position = UDim2.new(0.05,0,yPos+0.06,0)
	slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
	round(slider,10)

	local knob = Instance.new("Frame", slider)
	knob.Size = UDim2.new(0,16,0,16)
	knob.Position = UDim2.new(0,0,-0.5,0)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	round(knob,100)

	local dragging = false

	local function update(input)
		local rel = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
		knob.Position = UDim2.new(rel,-8,-0.5,0)
		local val = math.floor(1 + rel*99)
		label.Text = text..": "..val
		callback(val)
	end

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input)
		end
	end)
end

createSlider(0.12,"WalkSpeed",16,function(v)
	walkSpeed=v
	local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed=v end
end)

createSlider(0.25,"FlySpeed",1,function(v)
	flySpeed=v
end)

createSlider(0.33,"Jump",7,function(v)
	jumpValue=v
	local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then
		if hum.UseJumpPower then
			hum.JumpPower=v
		else
			hum.JumpHeight=v/2
		end
	end
end)

------------------------------------------------
-- SHIFTLOCK
------------------------------------------------
local function enableShiftLock()
	local char = LocalPlayer.Character
	if not char then return end

	local hum = char:FindFirstChild("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")

	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
	hum.AutoRotate = false

	shiftConn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local look = cam.CFrame.LookVector
		root.CFrame = CFrame.new(root.Position, root.Position + Vector3.new(look.X,0,look.Z))
	end)
end

local function disableShiftLock()
	local char = LocalPlayer.Character
	if not char then return end

	local hum = char:FindFirstChild("Humanoid")
	UIS.MouseBehavior = Enum.MouseBehavior.Default
	if hum then hum.AutoRotate = true end

	if shiftConn then shiftConn:Disconnect() end
end

local ShiftBtn = Instance.new("TextButton",Main)
ShiftBtn.Size=UDim2.new(0.9,0,0,35)
ShiftBtn.Position=UDim2.new(0.05,0,0.41,0)
ShiftBtn.Text="ShiftLock: Kapalı"
round(ShiftBtn)

local function updateShift()
	ShiftBtn.Text = "ShiftLock: "..(shiftlock and "Açık" or "Kapalı")
end

ShiftBtn.MouseButton1Click:Connect(function()
	shiftlock = not shiftlock
	if shiftlock then enableShiftLock() else disableShiftLock() end
	updateShift()
end)

UIS.InputBegan:Connect(function(input,g)
	if g then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		shiftlock = not shiftlock
		if shiftlock then enableShiftLock() else disableShiftLock() end
		updateShift()
	end
end)

------------------------------------------------
-- FLY
------------------------------------------------
local bv,bg,flyConn

local function stopFly()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")

	if flyConn then flyConn:Disconnect() end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end

	if hum then
		hum.PlatformStand = false
		hum.WalkSpeed = walkSpeed

		if hum.UseJumpPower then
			hum.JumpPower = jumpValue
		else
			hum.JumpHeight = jumpValue/2
		end
	end
end

local function startFly()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	hum.PlatformStand = true
	hum.WalkSpeed = 0

	if hum.UseJumpPower then
		hum.JumpPower = 0
	else
		hum.JumpHeight = 0
	end

	bv = Instance.new("BodyVelocity", root)
	bv.MaxForce = Vector3.new(1e6,1e6,1e6)

	bg = Instance.new("BodyGyro", root)
	bg.MaxTorque = Vector3.new(1e6,1e6,1e6)

	flyConn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

		bv.Velocity = dir.Magnitude>0 and dir.Unit*(flySpeed*60) or Vector3.zero
		bg.CFrame = cam.CFrame
	end)
end

local FlyBtn = Instance.new("TextButton",Main)
FlyBtn.Size=UDim2.new(0.9,0,0,35)
FlyBtn.Position=UDim2.new(0.05,0,0.47,0)
FlyBtn.Text="Fly"
round(FlyBtn)

FlyBtn.MouseButton1Click:Connect(function()
	flying=not flying
	if flying then startFly() else stopFly() end
end)

------------------------------------------------
-- NOCLIP
------------------------------------------------
RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

local NoclipBtn = Instance.new("TextButton",Main)
NoclipBtn.Size=UDim2.new(0.9,0,0,35)
NoclipBtn.Position=UDim2.new(0.05,0,0.55,0)
NoclipBtn.Text="Noclip"
round(NoclipBtn)

NoclipBtn.MouseButton1Click:Connect(function()
	noclip=not noclip
end)

------------------------------------------------
-- ESP
------------------------------------------------
local espObjects = {}

local function createESP(p)
	if p==LocalPlayer then return end
	if p.Character then
		local h=Instance.new("Highlight",p.Character)
		h.FillTransparency=1
		espObjects[p]=h
	end
end

local function enableESP()
	for _,p in pairs(Players:GetPlayers()) do createESP(p) end
end

local function disableESP()
	for _,v in pairs(espObjects) do v:Destroy() end
	espObjects={}
end

task.spawn(function()
	while true do
		RunService.RenderStepped:Wait()
		if espEnabled then
			local c=Color3.fromHSV(tick()%5/5,1,1)
			for _,v in pairs(espObjects) do v.OutlineColor=c end
		end
	end
end)

local ESPBtn = Instance.new("TextButton",Main)
ESPBtn.Size=UDim2.new(0.9,0,0,35)
ESPBtn.Position=UDim2.new(0.05,0,0.63,0)
ESPBtn.Text="ESP"
round(ESPBtn)

ESPBtn.MouseButton1Click:Connect(function()
	espEnabled=not espEnabled
	if espEnabled then enableESP() else disableESP() end
end)

------------------------------------------------
-- HIDE + EXIT
------------------------------------------------
local HideBtn = Instance.new("TextButton",Main)
HideBtn.Size=UDim2.new(0.9,0,0,35)
HideBtn.Position=UDim2.new(0.05,0,0.85,0)
HideBtn.Text="Menüyü Gizle"
round(HideBtn)

HideBtn.MouseButton1Click:Connect(function()
	Main.Visible=false
end)

local ExitBtn = Instance.new("TextButton",Main)
ExitBtn.Size=UDim2.new(0.9,0,0,35)
ExitBtn.Position=UDim2.new(0.05,0,0.92,0)
ExitBtn.Text="Çıkış"
round(ExitBtn)

ExitBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
