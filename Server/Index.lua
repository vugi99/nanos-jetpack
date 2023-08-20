

Events.SubscribeRemote("CreateServerJetpack", function(ply)
    if (ply and ply:IsValid()) then
        local char = ply:GetControlledCharacter()
        if char then
            if ((not char:IsInRagdollMode()) and (not char:GetVehicle()) and char:GetHealth() > 0) then
                local sever_jetpack_data = char:GetValue("ServerJetpackData")
                if not sever_jetpack_data then
                    local particle = Particle(
                        Vector(0, 0, 0),
                        Rotator(0, 0, 0),
                        "nanos-world::P_Fire",
                        false,
                        true
                    )
                    particle:AttachTo(char, AttachmentRule.SnapToTarget, "", 0)
                    particle:SetRelativeLocation(Vector(0, 0, -100))
                    particle:SetRelativeRotation(Rotator(180, 0, 0))
                    particle:SetScale(Vector(2, 2, 2))

                    -- TODO: Jetpack sound. Missing Serverside Sounds

                    char:SetValue("ServerJetpackData", {
                        particle = particle,
                    }, false)
                end
            end
        end
    end
end)

function DestroyServerJetpack(char)
    local sever_jetpack_data = char:GetValue("ServerJetpackData")
    if sever_jetpack_data then
        for k, v in pairs(sever_jetpack_data) do
            if v:IsValid() then
                v:Destroy()
            end
        end
        char:SetValue("ServerJetpackData", nil, false)
    end
end
Character.Subscribe("EnterVehicle", DestroyServerJetpack)
Character.Subscribe("RagdollModeChange", function(char, old_state, new_state)
    if new_state then
        DestroyServerJetpack(char)
    end
end)
Character.Subscribe("UnPossess", DestroyServerJetpack)

Events.SubscribeRemote("DestroyServerJetpack", function(ply)
    if (ply and ply:IsValid()) then
        local char = ply:GetControlledCharacter()
        if char then
            DestroyServerJetpack(char)
        end
    end
end)