mouse=game.Players.LocalPlayer:GetMouse()
local vars = {
	Radius=_G.FOV*3,
	Filled=_G.Filled,
	Color = _G.Color,
	Visible=_G.Visible
}
_G.SILENTAIM=true

_G.CIRCLE=Drawing.new('Circle')
_G.FILLED=false
_G.CIRCLE.Visible=vars.Visible
_G.CIRCLE.Radius=vars.Radius*3
_G.CIRCLE.Thickness=1
_G.CIRCLE.NumSides=360
_G.CIRCLE.Color=vars.Color
_G.CIRCLE.Filled=vars.Filled
local inset=game:GetService('GuiService'):GetGuiInset().Y
game:GetService('RunService').RenderStepped:Connect(function()
	_G.CIRCLE.Position=Vector2.new(game.Players.LocalPlayer:GetMouse().X,game.Players.LocalPlayer:GetMouse().Y+game:GetService('GuiService'):GetGuiInset().Y)
end)

function IsPartVisible(Part)
local Character = game.Players.LocalPlayer.Character
local Origin = game.Workspace.CurrentCamera.CFrame.Position
	local _, OnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(Part.Position)
if (OnScreen) then
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.FilterDescendantsInstances = {Character, game.Workspace.CurrentCamera}
	local Result = workspace:Raycast(workspace, Origin, Part.Position - Origin, raycastParams)
	if (Result) then
		local PartHit = Result.Instance
			if PartHit:IsDescendantOf(Part.Parent) then
				return true
			end
	end
end
return false
end
function GetClosestToMouse()
	for i,v in pairs(game:GetService('Players'):GetPlayers()) do
		local distance=999999999999999999999999999999999999999999999
		player=nil
		local mouse=game.Players.LocalPlayer:GetMouse()
		for i,v in pairs(game.Players:GetPlayers()) do
			if v and v.Character:FindFirstChild('Humanoid') and v~=game.Players.LocalPlayer then
				local vchar,onscreen=game.Workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
				local mag=(Vector2.new(mouse.X,mouse.Y+inset)-Vector2.new(vchar.X,vchar.Y)).Magnitude
				if mag < _G.CIRCLE.Radius and mag < distance then
					distance=mag
					player=v
				end
			end	
		end
	end
	return player
end
function FOVUpdate()
	if _G.CIRLCE~= nil then
		local vars1 = {
			Radius=_G.FOV*3,
			Filled=_G.Filled,
			Color = _G.Color,
			Visible=_G.Visible
		}
		_G.CIRCLE.Radius=vars1.Radius
		_G.CIRCLE.Filled=vars1.Filled
		_G.CIRCLE.Color=vars1.Color
		_G.CIRCLE.Visible=vars1.Visible
	end
end
m =
	hookmetamethod(
		game,
		"__index",
		function(n, o)
			if n:IsA("Mouse") and (o == "Hit" or o == "Target") and GetClosestToMouse().Character:FindFirstChild('Head') and IsPartVisible(GetClosestToMouse().Character:FindFirstChild('Head')) then
			local p =  GetClosestToMouse().Character:FindFirstChild('HumanoidRootPart')
			if _G.SILENTAIM==true and (o == "Hit" or o == "Target") then
				local q = p.CFrame + p.Velocity * 0.165
				return o == "Hit" and q or p
			end
		end
			return m(n, o)
		end
	)
game["Run Service"].Heartbeat:Connect(function()
	FOVUpdate()
end)
