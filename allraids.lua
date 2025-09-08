-- This script will attempt to join a list of raids for a duration of 5 minutes.
-- It will also perform a "dash" action after each raid attempt.

-- Run for 5 minutes (300 seconds)
local startTime = tick()
local duration = 300 -- 5 minutes in seconds

-- List of all numerical IDs for the raids you provided
-- The script will attempt to join these raids in the order they are listed.
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

-- The main loop that will run for 5 minutes
while tick() - startTime < duration do
    -- Loop through each raid ID in the list
    for i, raidId in ipairs(raidIDs) do
        -- Check if the timer has expired. If so, break out of both loops.
        if tick() - startTime >= duration then
            break
        end

        -- Raid actions: Create a team and start the challenge map
        local args = {raidId}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CreateRaidTeam"):InvokeServer(unpack(args))
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartChallengeRaidMap"):FireServer()

        -- Wait 6 seconds
        wait(6)

        -- First dash
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)

        -- Wait for 30 seconds
        wait(30)

        -- Wait 3 seconds
        wait(3)

        -- Second dash
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)
    end
end
