-- This script will intelligently search for and join raids from a list of IDs.
-- Once a raid is successfully joined, it will perform a series of timed actions
-- before resuming the search for another raid.

-- The entire script will run for a total of 30 minutes.

local startTime = tick()
local duration = 1800 -- 30 minutes in seconds

-- Getting necessary services and remotes once at the beginning for efficiency
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local VIM = game:GetService("VirtualInputManager")

-- List of all numerical IDs for the raids you provided
local raidIDs = {
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

-- Define a function for the dash action (Q key press)
local function doDash()
    VIM:SendKeyEvent(true, "Q", false, game)
    wait(0.1)
    VIM:SendKeyEvent(false, "Q", false, game)
end

-- Main loop that will run for 30 minutes
while tick() - startTime < duration do
    print("Searching for an available raid...")
    local raidJoined = false

    -- Loop through each raid ID to find an active raid to join
    for i, raidId in ipairs(raidIDs) do
        -- Check if the main timer has expired
        if tick() - startTime >= duration then
            break
        end

        -- Try to create a raid team and start the challenge map.
        local success, err = pcall(function()
            local args = {raidId}
            Remotes:WaitForChild("CreateRaidTeam"):InvokeServer(unpack(args))
            Remotes:WaitForChild("StartChallengeRaidMap"):FireServer()
        end)

        -- Assuming the raid was joined successfully if no error occurred.
        if success then
            raidJoined = true
            print("Found and joined a raid with ID: " .. tostring(raidId))
            -- If a raid is joined, break the inner loop to start the sequence below
            break
        end
        -- Add a small wait to prevent spamming the server
        wait(2)
    end

    -- If a raid was joined, perform the actions and wait before searching again
    if raidJoined then
        local joinedRaidTime = tick()

        -- Execute the dash sequence
        print("Starting dash sequence...")

        wait(6)
        doDash()

        wait(30)
        wait(3)
        doDash()

        -- Wait until at least 30 seconds have passed since joining the raid.
        -- This ensures we don't spam the server.
        local waitUntil = joinedRaidTime + 30
        while tick() < waitUntil do
            wait(1)
        end
    else
        -- If no raid was found, wait a moment before trying the list again
        wait(10)
    end
end

print("✅ Script ended after 30 minutes.")
