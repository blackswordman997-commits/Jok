-- ===================================================================
-- SCRIPT CONFIGURATION
-- ===================================================================

-- Run for 5 minutes (300 seconds)
local startTime = tick()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local VIM = game:GetService("VirtualInputManager")

-- A complete list of all Raid IDs to check
local allRaidIDs = {
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
    930061, 930062
}

-- ===================================================================
-- ACTIONS
-- ===================================================================

-- This function now loops through every ID and tries to start the raid.
-- The 'pcall' ensures the script won't error if a raid doesn't exist.
local function doRaid()
    print("Scanning for any available raids...")
    for _, raidId in ipairs(allRaidIDs) do
        pcall(function()
            local args = {raidId}
            -- NOTE: Corrected the typo from "CreateRadeam" to "CreateRaidTeam"
            Remotes:WaitForChild("CreateRaidTeam"):InvokeServer(unpack(args))
            Remotes:WaitForChild("StartChallengeRaidMap"):FireServer()
        end)
    end
    print("Scan complete. Waiting for next cycle.")
end

-- Dash action (presses and releases the 'Q' key)
local function doDash()
    VIM:SendKeyEvent(true, "Q", false, game)
    wait(0.1)
    VIM:SendKeyEvent(false, "Q", false, game)
end

-- ===================================================================
-- MAIN LOOP
-- ===================================================================

while tick() - startTime < 300 do
    -- 1. Scan for and attempt to join any available raid
    doRaid()

    -- 2. Wait 6 seconds, then dash
    wait(6)
    doDash()

    -- 3. Wait 33 seconds, then dash again
    wait(33)
    doDash()
end

print("✅ Script ended after 5 minutes.")
