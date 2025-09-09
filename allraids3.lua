-- Run for 5 minutes (300 seconds)
local startTime = tick()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local VIM = game:GetService("VirtualInputManager")

-- All raid IDs (Worlds 1–7)
local raidIds = {
    -- World 1
    930001, 930002, 930003, 930005, 930006, 930008,
    -- World 2
    930011, 930012, 930013, 930015, 930016, 930018,
    -- World 3
    930021, 930022, 930023, 930025, 930026, 930028,
    -- World 4
    930031, 930032, 930033, 930035, 930036, 930038,
    -- World 5
    930041, 930042, 930043, 930045, 930046, 930048,
    -- World 6
    930051, 930052, 930053,
    -- World 7
    930061, 930062,
}

-- Try to create + start a raid
local function doRaid(raidId)
    local success = pcall(function()
        Remotes:WaitForChild("CreateRaidTeam"):InvokeServer(raidId)
        Remotes:WaitForChild("StartChallengeRaidMap"):FireServer()
    end)
    return success
end

-- Dash (Q key press)
local function doDash()
    VIM:SendKeyEvent(true, "Q", false, game)
    wait(0.1)
    VIM:SendKeyEvent(false, "Q", false, game)
end

-- Main loop
while tick() - startTime < 300 do
    local raidJoined = false

    -- Search for available raid
    for _, raidId in ipairs(raidIds) do
        if doRaid(raidId) then
            raidJoined = true
            break -- stop searching once we join a raid
        end
    end

    if raidJoined then
        -- Dash cycle
        wait(6)
        doDash()

        wait(30) -- pause searching during this wait
        wait(3)
        doDash()
    else
        -- If no raid found, wait a short time before checking again
        wait(1)
    end
end

print("✅ Script ended after 5 minutes.")
