
local Cube
local particle

Input.Bind("Jump", InputEvent.Pressed, function()
    --print("Jump")
    local ply = Client.GetLocalPlayer()
    if ply then
        local char = ply:GetControlledCharacter()
        if char then
            if not char:IsInRagdollMode() then
                if (char:GetFallDamageTaken() == 0 or char:GetFallingMode() ~= FallingMode.HighFalling) then
                    Cube = StaticMesh(
                        Vector(0, 0, 0),
                        Rotator(0, 0, 0),
                        "nanos-world::SM_Cube"
                    )
                    Cube:SetScale(Vector(0.1, 0.1, 0.1))
                    Cube:AttachTo(char, AttachmentRule.SnapToTarget, "", 0)
                    Cube:SetRelativeLocation(Vector(0, 0, -100))
                    Cube:SetVisibility(false)

                    particle = Particle(
                        Vector(0, 0, 0),
                        Rotator(0, 0, 0),
                        "nanos-world::P_Fire",
                        false,
                        true
                    )
                    particle:AttachTo(Cube, AttachmentRule.SnapToTarget, "", 0)
                    particle:SetRelativeRotation(Rotator(180, 0, 0))
                end
            end
        end
    end
end)


Input.Bind("Jump", InputEvent.Released, function()
    if Cube then
        if Cube:IsValid() then
            Cube:Destroy()
        end
        Cube = nil
    end
    particle = nil
end)