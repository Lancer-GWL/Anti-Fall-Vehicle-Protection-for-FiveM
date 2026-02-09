local notifyText = ""
local notifyTimer = 0
local notifyAlpha = 255

local function showNotify(text)
    notifyText = text
    notifyTimer = GetGameTimer() + 1000
    notifyAlpha = 255
end

CreateThread(function()
    while true do
        Wait(0)

        if notifyTimer > GetGameTimer() then
            local timeLeft = notifyTimer - GetGameTimer()

            if timeLeft < 500 then
                notifyAlpha = math.floor((timeLeft / 500) * 255)
            end

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.3, 0.3)
            SetTextColour(255, 0, 0, notifyAlpha)
            SetTextEdge(1, 255, 255, 255, notifyAlpha)
            SetTextOutline()
            SetTextRightJustify(true)
            SetTextWrap(0.0, 0.98)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(notifyText)
            EndTextCommandDisplayText(0.98, 0.05)
        end
    end
end)

CreateThread(function()
    local wasInVehicle = false
    local lastVehicle = nil

    while true do
        Wait(150)

        local ped = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(ped, false)

        if inVehicle then
            local vehicle = GetVehiclePedIsIn(ped, false)

            SetPedCanRagdoll(ped, false)
            SetPedCanRagdollFromPlayerImpact(ped, false)
            SetPedCanBeKnockedOffVehicle(ped, 1)
            SetEntityInvincible(ped, true)

            SetEntityInvincible(vehicle, true)
            SetVehicleTyresCanBurst(vehicle, false)
            SetVehicleEngineCanDegrade(vehicle, false)
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleBodyHealth(vehicle, 1000.0)

            if not wasInVehicle then
                showNotify("~g~Anti-fall protection ~h~ENABLED")
            end

            lastVehicle = vehicle
        else
            if wasInVehicle then
                SetPedCanRagdoll(ped, true)
                SetPedCanRagdollFromPlayerImpact(ped, true)
                SetEntityInvincible(ped, false)

                if lastVehicle and DoesEntityExist(lastVehicle) then
                    SetEntityInvincible(lastVehicle, false)
                    SetVehicleTyresCanBurst(lastVehicle, true)
                    SetVehicleEngineCanDegrade(lastVehicle, true)
                end

                showNotify("~r~Protection ~h~DISABLED")
            end
        end

        wasInVehicle = inVehicle
    end
end)
