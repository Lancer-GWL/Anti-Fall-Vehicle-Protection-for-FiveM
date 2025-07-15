local fallOffSpeed = Config.FallOffSpeed or 250
local notifyDuration = Config.NotifyDuration or 3000
local notifySound = Config.NotifySound == nil and true or Config.NotifySound

local antiFallEnabled = true
local notifyTimer = 0
local notifyText = ""
local notifyAlpha = 255

local wasInVehicle = false

-- Play notification sound (default GTA frontend sound)
local function playNotifySound()
    if notifySound then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end

-- Show on-screen notification (top-right)
local function showNotify(text)
    notifyText = text
    notifyTimer = GetGameTimer() + notifyDuration
    notifyAlpha = 255
    playNotifySound()
end

-- Draw notification on screen
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if notifyTimer > GetGameTimer() then
            local timeLeft = notifyTimer - GetGameTimer()
            if timeLeft < 500 then -- Fade out last 0.5 seconds
                notifyAlpha = math.floor((timeLeft / 500) * 255)
            end

            SetTextFont(4)
            SetTextProportional(0)
            SetTextScale(0.35, 0.35)
            SetTextColour(255, 255, 255, notifyAlpha)
            SetTextDropshadow(0, 0, 0, 0, notifyAlpha)
            SetTextEdge(1, 0, 0, 0, notifyAlpha)
            SetTextDropShadow()
            SetTextOutline()
            SetTextRightJustify(true)
            SetTextWrap(0.0, 0.95)
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(notifyText)
            EndTextCommandDisplayText(0.95, 0.05)
        end
    end
end)

-- Command: /fall - Enable falling off vehicles (disable anti-fall)
RegisterCommand("fall", function()
    antiFallEnabled = false
    showNotify("~r~Falling off vehicles is now ~h~ENABLED~r~.")
end)

-- Command: /unfall - Disable falling off vehicles (enable anti-fall)
RegisterCommand("unfall", function()
    antiFallEnabled = true
    showNotify("~g~Falling off vehicles is now ~h~DISABLED~g~.")
end)

-- Command: /fallstatus - Show current anti-fall status
RegisterCommand("fallstatus", function()
    if antiFallEnabled then
        showNotify("~g~Anti-fall protection is ~h~ENABLED~g~.")
    else
        showNotify("~r~Anti-fall protection is ~h~DISABLED~r~.")
    end
end)

-- Main thread: monitor vehicle and player ragdoll state
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local inVehicle = IsPedInAnyVehicle(playerPed, false)

        -- Detect if player just fell off vehicle
        if wasInVehicle and not inVehicle then
            if IsPedRagdoll(playerPed) or IsPedFalling(playerPed) then
                showNotify("~r~You have fallen off the vehicle!")
            end
        end
        wasInVehicle = inVehicle

        if inVehicle and antiFallEnabled then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 3.6 -- Convert m/s to km/h

            if speed <= fallOffSpeed then
                -- Prevent falling off
                SetPedCanRagdollFromPlayerImpact(playerPed, false)
                SetPedCanRagdoll(playerPed, false)
                SetPedConfigFlag(playerPed, 32, false)
                SetPedConfigFlag(playerPed, 33, true)
                SetPedConfigFlag(playerPed, 60, false)
            else
                -- Allow falling off at high speed
                SetPedCanRagdollFromPlayerImpact(playerPed, true)
                SetPedCanRagdoll(playerPed, true)
                SetPedConfigFlag(playerPed, 33, false)
            end
        else
            -- Reset flags when not in vehicle or protection disabled
            SetPedCanRagdollFromPlayerImpact(playerPed, true)
            SetPedCanRagdoll(playerPed, true)
            SetPedConfigFlag(playerPed, 33, false)
        end
    end
end)
