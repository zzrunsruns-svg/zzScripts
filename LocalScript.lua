-- ZzUILibrary (injectable, single-file)
-- API:
--   local Lib = loadstring(game:HttpGet(".../ZzUILibrary.lua"))()
--   local Win = Lib:CreateWindow({ Name = "Game Name Hub" })
--   local Tab = Win:CreateTab("Player")
--   Tab:AddButton("Set Walkspeed", function() print("Clicked!") end)
--   Tab:AddToggle("Toggle Noclip","Travel through walls", function(state) print("Noclip:", state) end)

local UIS = game:GetService("UserInputService")
local CG = game:GetService("CoreGui")
local LP = game:GetService("Players").LocalPlayer

-- Safe parent into CoreGui / gethui
local function mount_gui(gui)
	gui.Name = "ZzUILibrary"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	pcall(function()
		if gethui then
			gui.Parent = gethui()
			return
		end
	end)
	if not gui.Parent then
		gui.Parent = CG
	end
end

-- ========= build base UI from your “Gui to Lua” dump (turned into a function) =========
local function BuildBase()
	local ZzUILibrary = Instance.new("ScreenGui")
	mount_gui(ZzUILibrary)

	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.Parent = ZzUILibrary
	Window.AnchorPoint = Vector2.new(0.5, 0.5)
	Window.BackgroundColor3 = Color3.fromRGB(179, 179, 179)
	Window.BorderSizePixel = 0
	Window.Position = UDim2.new(0.5, 0, 0.5, 0)
	Window.Size = UDim2.new(0.540, 0, 0.770, 0)
	Window.Draggable = true

	-- Top bar
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Parent = Window
	TopBar.AnchorPoint = Vector2.new(0.5, 0.5)
	TopBar.BackgroundColor3 = Color3.fromRGB(61,61,61)
	TopBar.BorderSizePixel = 0
	TopBar.Position = UDim2.new(0.499, 0, 0.04, 0)
	TopBar.Size = UDim2.new(1.001, 0, 0.08, 0)

	local HubName = Instance.new("TextLabel")
	HubName.Name = "HubName"
	HubName.Parent = TopBar
	HubName.BackgroundTransparency = 1
	HubName.Position = UDim2.new(0.013, 0, 0, 0)
	HubName.Size = UDim2.new(0.7, 0, 1, 0)
	HubName.Font = Enum.Font.SourceSans
	HubName.Text = "Game Name Hub"
	HubName.TextColor3 = Color3.fromRGB(223,223,223)
	HubName.TextSize = 22
	HubName.TextXAlignment = Enum.TextXAlignment.Left

	-- Sidebar container
	local SideBarElements = Instance.new("ScrollingFrame")
	SideBarElements.Name = "SideBarElements"
	SideBarElements.Parent = Window
	SideBarElements.Active = true
	SideBarElements.BackgroundColor3 = Color3.fromRGB(63,63,63)
	SideBarElements.BorderSizePixel = 0
	SideBarElements.Position = UDim2.new(0, 0, 0.079, 0)
	SideBarElements.Size = UDim2.new(0.315, 0, 0.921, 0)
	SideBarElements.CanvasSize = UDim2.new(0, 0, 5, 0)
	SideBarElements.ScrollBarThickness = 4
	SideBarElements.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

	local UIL_Side = Instance.new("UIListLayout")
	UIL_Side.Parent = SideBarElements
	UIL_Side.SortOrder = Enum.SortOrder.LayoutOrder
	UIL_Side.Padding = UDim.new(0.004, 0)

	local UIP_Side = Instance.new("UIPadding")
	UIP_Side.Parent = SideBarElements
	UIP_Side.PaddingLeft = UDim.new(0.105, 0)
	UIP_Side.PaddingTop = UDim.new(0.005, 0)

	-- Sidebar button template (smaller height)
	local SideBarButtonTemplate = Instance.new("TextButton")
	SideBarButtonTemplate.Name = "SideBarButtonTemplate"
	SideBarButtonTemplate.Parent = SideBarElements
	SideBarButtonTemplate.BackgroundColor3 = Color3.fromRGB(85,85,85)
	SideBarButtonTemplate.BorderSizePixel = 0
	SideBarButtonTemplate.Size = UDim2.new(0.85, 0, 0, 28)
	SideBarButtonTemplate.Font = Enum.Font.SourceSans
	SideBarButtonTemplate.Text = "Template"
	SideBarButtonTemplate.TextColor3 = Color3.fromRGB(218,218,218)
	SideBarButtonTemplate.TextSize = 17
	local sbCorner = Instance.new("UICorner")
	sbCorner.CornerRadius = UDim.new(0.25, 0)
	sbCorner.Parent = SideBarButtonTemplate
	SideBarButtonTemplate.Visible = false -- keep as template

	-- Add this inside the BuildBase function after ToggleElementTemplate is created (same parent: PageTemplate)

	-- Pages container (we’ll create one ScrollingFrame per tab here)
	local PagesHolder = Instance.new("Frame")
	PagesHolder.Name = "PagesHolder"
	PagesHolder.Parent = Window
	PagesHolder.BackgroundTransparency = 1
	PagesHolder.Position = UDim2.new(0.313, 0, 0.079, 0)
	PagesHolder.Size = UDim2.new(0.687, 0, 0.921, 0)

	-- Page template (ScrollingFrame with layout/padding)
	local PageTemplate = Instance.new("ScrollingFrame")
	PageTemplate.Name = "PageTemplate"
	PageTemplate.Parent = PagesHolder
	PageTemplate.Active = true
	PageTemplate.BackgroundColor3 = Color3.fromRGB(53,53,53)
	PageTemplate.BorderSizePixel = 0
	PageTemplate.Size = UDim2.new(1, 0, 1, 0)
	PageTemplate.CanvasSize = UDim2.new(0, 0, 5, 0)
	PageTemplate.ScrollBarThickness = 4
	local UIL_Page = Instance.new("UIListLayout")
	UIL_Page.Parent = PageTemplate
	UIL_Page.SortOrder = Enum.SortOrder.LayoutOrder
	UIL_Page.Padding = UDim.new(0.01, 0)
	local UIP_Page = Instance.new("UIPadding")
	UIP_Page.Parent = PageTemplate
	UIP_Page.PaddingLeft = UDim.new(0.06, 0)
	UIP_Page.PaddingTop = UDim.new(0.005, 0)

	
	local TextBoxElementTemplate = Instance.new("TextBox")
	TextBoxElementTemplate.Name = "TextBoxElementTemplate"
	TextBoxElementTemplate.Parent = PageTemplate
	TextBoxElementTemplate.BackgroundColor3 = Color3.fromRGB(74, 74, 74)
	TextBoxElementTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBoxElementTemplate.BorderSizePixel = 0
	TextBoxElementTemplate.Size = UDim2.new(0.85, 0, 0, 36)
	TextBoxElementTemplate.Font = Enum.Font.SourceSans
	TextBoxElementTemplate.PlaceholderColor3 = Color3.fromRGB(236, 236, 236)
	TextBoxElementTemplate.PlaceholderText = "Enter text..."
	TextBoxElementTemplate.Text = ""
	TextBoxElementTemplate.TextColor3 = Color3.fromRGB(236, 236, 236)
	TextBoxElementTemplate.TextSize = 20
	TextBoxElementTemplate.ClearTextOnFocus = false
	TextBoxElementTemplate.Visible = false -- template



	-- Button element template (smaller height)
	local ButtonElementTemplate = Instance.new("TextButton")
	ButtonElementTemplate.Name = "ButtonElementTemplate"
	ButtonElementTemplate.Parent = PageTemplate
	ButtonElementTemplate.BackgroundColor3 = Color3.fromRGB(72,72,72)
	ButtonElementTemplate.BorderSizePixel = 0
	ButtonElementTemplate.Size = UDim2.new(0.85, 0, 0, 28)
	ButtonElementTemplate.Font = Enum.Font.SourceSans
	ButtonElementTemplate.Text = "Button"
	ButtonElementTemplate.TextColor3 = Color3.fromRGB(218,218,218)
	ButtonElementTemplate.TextSize = 17
	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0.25, 0)
	bCorner.Parent = ButtonElementTemplate
	ButtonElementTemplate.Visible = false -- template

	-- Toggle element template (smaller height)
	local ToggleElementTemplate = Instance.new("Frame")
	ToggleElementTemplate.Name = "ToggleElementTemplate"
	ToggleElementTemplate.Parent = PageTemplate
	ToggleElementTemplate.BackgroundColor3 = Color3.fromRGB(72,72,72)
	ToggleElementTemplate.BorderSizePixel = 0
	ToggleElementTemplate.Size = UDim2.new(0.85, 0, 0, 55)
	local tCorner = Instance.new("UICorner")
	tCorner.CornerRadius = UDim.new(0.1, 0)
	tCorner.Parent = ToggleElementTemplate

	local ToggleTitle = Instance.new("TextLabel")
	ToggleTitle.Name = "ToggleTitle"
	ToggleTitle.Parent = ToggleElementTemplate
	ToggleTitle.BackgroundTransparency = 1
	ToggleTitle.Position = UDim2.new(0.013, 0, 0, 0)
	ToggleTitle.Size = UDim2.new(0.7, 0, 0.32, 0)
	ToggleTitle.Font = Enum.Font.SourceSansBold
	ToggleTitle.Text = "Toggle"
	ToggleTitle.TextColor3 = Color3.fromRGB(223,223,223)
	ToggleTitle.TextSize = 15
	ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
	ToggleTitle.TextWrapped = true

	local ToggleDescription = Instance.new("TextLabel")
	ToggleDescription.Name = "ToggleDescription"
	ToggleDescription.Parent = ToggleElementTemplate
	ToggleDescription.BackgroundTransparency = 1
	ToggleDescription.Position = UDim2.new(0.033, 0, 0.293, 0)
	ToggleDescription.Size = UDim2.new(0.80, 0, 0.70, 0)
	ToggleDescription.Font = Enum.Font.SourceSans
	ToggleDescription.Text = "Description"
	ToggleDescription.TextColor3 = Color3.fromRGB(223,223,223)
	ToggleDescription.TextSize = 15
	ToggleDescription.TextWrapped = true
	ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
	ToggleDescription.TextYAlignment = Enum.TextYAlignment.Top

	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Name = "ToggleButton"
	ToggleButton.Parent = ToggleElementTemplate
	ToggleButton.BackgroundColor3 = Color3.fromRGB(117,117,117)
	ToggleButton.BorderSizePixel = 0
	ToggleButton.Position = UDim2.new(0.861, 0, 0.289, 0)
	ToggleButton.Size = UDim2.new(0, 35, 0, 31)
	ToggleButton.Text = " "
	ToggleButton.TextColor3 = Color3.fromRGB(218,218,218)
	ToggleButton.TextSize = 17
	local tbCorner = Instance.new("UICorner")
	tbCorner.CornerRadius = UDim.new(0.5, 0)
	tbCorner.Parent = ToggleButton
	ToggleElementTemplate.Visible = false -- template

	-- Mobile toggle button (visible)
	local MobileToggle = Instance.new("TextButton")
	MobileToggle.Name = "MobileToggle"
	MobileToggle.Parent = ZzUILibrary
	MobileToggle.BackgroundColor3 = Color3.fromRGB(66,66,66)
	MobileToggle.BorderSizePixel = 0
	MobileToggle.Position = UDim2.new(0.9247, 0, 0.1931, 0)
	MobileToggle.Size = UDim2.new(0.0601, 0, 0.0400, 0)
	MobileToggle.Font = Enum.Font.SourceSans
	MobileToggle.Text = "Toggle UI"
	MobileToggle.TextColor3 = Color3.fromRGB(255,99,51)
	MobileToggle.TextScaled = true
	local mtCorner = Instance.new("UICorner")
	mtCorner.CornerRadius = UDim.new(0.25, 0)
	mtCorner.Parent = MobileToggle

	-- Helper: drag window by top bar
	local dragging, dragStart, startPos
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Window.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	-- show/hide
	local visible = true
	local function setVisible(v)
		visible = v
		Window.Visible = v
	end
	MobileToggle.MouseButton1Click:Connect(function() setVisible(not visible) end)
	UIS.InputBegan:Connect(function(i,gp)
		if gp then return end
		if i.KeyCode == Enum.KeyCode.RightShift then
			setVisible(not visible)
		end
	end)

	return ZzUILibrary, Window, TopBar, HubName, SideBarElements, SideBarButtonTemplate, PagesHolder, PageTemplate, ButtonElementTemplate, ToggleElementTemplate
end
-- ========= end base build =========

-- auto-resize canvas to content
local function auto_canvas(sf)
	local uil = sf:FindFirstChildOfClass("UIListLayout")
	if not uil then return end
	local function update()
		sf.CanvasSize = UDim2.new(0,0,0, uil.AbsoluteContentSize.Y + 20)
	end
	update()
	uil:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
end

-- color helpers
local COLOR = {
	SidebarIdle = Color3.fromRGB(85,85,85),
	SidebarActive = Color3.fromRGB(110,110,110),
	ButtonIdle = Color3.fromRGB(72,72,72),
	ToggleOff = Color3.fromRGB(117,117,117),
	ToggleOn = Color3.fromRGB(15, 173, 221)
}

-- Window/Tab objects
local WindowMT = {}
WindowMT.__index = WindowMT

local TabMT = {}
TabMT.__index = TabMT

-- Library table
local Library = {}
Library.__index = Library

function Library:CreateWindow(opts)
	opts = opts or {}
	local gui, root, topbar, hubName, sideContainer, sideBtnTemplate, pagesHolder, pageTemplate, buttonTemplate, toggleTemplate = BuildBase()
	hubName.Text = tostring(opts.Name or "Game Name Hub")

	auto_canvas(sideContainer)

	local self = setmetatable({
		_Gui = gui,
		_Root = root,
		_Side = sideContainer,
		_SideBtnTemplate = sideBtnTemplate,
		_PagesHolder = pagesHolder,
		_PageTemplate = pageTemplate,
		_ButtonTemplate = buttonTemplate,
		_ToggleTemplate = toggleTemplate,
		_Tabs = {},
		_ActiveTab = nil
	}, WindowMT)

	-- keep templates hidden / out of layout
	pageTemplate.Visible = false
	buttonTemplate.Visible = false
	toggleTemplate.Visible = false
	sideBtnTemplate.Visible = false

	return self
end

function WindowMT:_activateTab(tab)
	for _, t in ipairs(self._Tabs) do
		t.Page.Visible = false
		t.SideButton.BackgroundColor3 = COLOR.SidebarIdle
	end
	tab.Page.Visible = true
	tab.SideButton.BackgroundColor3 = COLOR.SidebarActive
	self._ActiveTab = tab
end

function WindowMT:CreateTab(name)
	name = tostring(name or "Tab")

	-- sidebar button
	local sbtn = self._SideBtnTemplate:Clone()
	sbtn.Visible = true
	sbtn.Parent = self._Side
	sbtn.Text = name
	sbtn.BackgroundColor3 = COLOR.SidebarIdle

	-- page (clone the page template)
	local page = self._PageTemplate:Clone()
	page.Name = name .. "_Page"
	page.Visible = false
	page.Parent = self._PagesHolder
	auto_canvas(page)

	local tab = setmetatable({
		Window = self,
		Name = name,
		SideButton = sbtn,
		Page = page,
		_order = 0
	}, TabMT)

	table.insert(self._Tabs, tab)

	sbtn.MouseButton1Click:Connect(function()
		self:_activateTab(tab)
	end)

	if not self._ActiveTab then
		self:_activateTab(tab)
	end

	return tab
end

-- Utility to assign layout order incrementally
function TabMT:_nextOrder()
	self._order += 1
	return self._order
end

function TabMT:AddButton(text, callback)
	local btn = self.Window._ButtonTemplate:Clone()
	btn.Visible = true
	btn.Parent = self.Page
	btn.Text = tostring(text or "Button")
	btn.LayoutOrder = self:_nextOrder()
	btn.BackgroundColor3 = COLOR.ButtonIdle
	btn.MouseButton1Click:Connect(function()
		if typeof(callback) == "function" then
			task.spawn(callback)
		end
	end)
	return btn
end


function TabMT:AddTextBox(placeholderText, callback, defaultText)
	local box = self.Window._PageTemplate:FindFirstChild("TextBoxElementTemplate"):Clone()
	box.Visible = true
	box.Parent = self.Page
	box.LayoutOrder = self:_nextOrder()
	box.PlaceholderText = placeholderText or "Enter text..."
	box.Text = defaultText or ""
	
	local function onFocusLost()
		if typeof(callback) == "function" then
			task.spawn(callback, box.Text)
		end
	end
	
	box.FocusLost:Connect(onFocusLost)
	
	-- expose simple API
	local api = {}
	function api:Set(text) box.Text = text end
	function api:Get() return box.Text end
	function api:OnChanged(fn) callback = fn end
	
	return api, box
end

function TabMT:AddToggle(title, description, callback, default)
	local frame = self.Window._ToggleTemplate:Clone()
	frame.Visible = true
	frame.Parent = self.Page
	frame.LayoutOrder = self:_nextOrder()
	frame.ToggleTitle.Text = tostring(title or "Toggle")
	frame.ToggleDescription.Text = tostring(description or "")

	local btn = frame.ToggleButton
	local state = not not default
	btn.BackgroundColor3 = state and COLOR.ToggleOn or COLOR.ToggleOff

	local function setState(s)
		state = not not s
		btn.BackgroundColor3 = state and COLOR.ToggleOn or COLOR.ToggleOff
		if typeof(callback) == "function" then
			task.spawn(callback, state)
		end
	end

	btn.MouseButton1Click:Connect(function()
		setState(not state)
	end)

	-- expose small API for this toggle instance
	local api = {}
	function api:Set(v) setState(v) end
	function api:Get() return state end
	function api:OnChanged(fn) callback = fn end

	return api, frame
end

-- Optional cleanup
function WindowMT:Destroy()
	pcall(function()
		self._Gui:Destroy()
	end)
end

return setmetatable({}, Library)











