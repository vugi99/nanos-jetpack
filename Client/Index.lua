
local Cube

function DestroyClientJetpack(client_only)
    if Cube then
        if Cube:IsValid() then
            Cube:Destroy()
        end
        Cube = nil
    end
    if not client_only then
        Events.CallRemote("DestroyServerJetpack")
    end
end

local function GetLocalCharacter()
    local ply = Client.GetLocalPlayer()
    if ply then
        return ply:GetControlledCharacter()
    end
end

Input.Bind("Jump", InputEvent.Pressed, function()
    local char = GetLocalCharacter()
    if char then
        if ((not char:IsInRagdollMode()) and (not char:GetVehicle()) and char:GetHealth() > 0) then
            if ((char:GetFallDamageTaken() == 0 and char:GetFallingMode() == FallingMode.HighFalling) or char:GetFallingMode() == FallingMode.Falling or char:GetFallingMode() == FallingMode.Jumping) then
                DestroyClientJetpack(true)

                Cube = StaticMesh(
                    Vector(0, 0, 0),
                    Rotator(0, 0, 0),
                    "nanos-world::SM_Cube"
                )
                Cube:SetScale(Vector(0.1, 0.1, 0.1))
                Cube:AttachTo(char, AttachmentRule.SnapToTarget, "", 0)
                Cube:SetRelativeLocation(Vector(0, 0, -100))
                Cube:SetVisibility(false)

                Events.CallRemote("CreateServerJetpack")
            end
        end
    end
end)

Input.Bind("Jump", InputEvent.Released, DestroyClientJetpack)


local function CharStopJetpackEvent(self)
    if self == GetLocalCharacter() then
        DestroyClientJetpack(true)
    end
end
Character.Subscribe("EnterVehicle", CharStopJetpackEvent)
Character.Subscribe("RagdollModeChange", function(char, old_state, new_state)
    if new_state then
        CharStopJetpackEvent(char)
    end
end)
Character.Subscribe("UnPossess", CharStopJetpackEvent)