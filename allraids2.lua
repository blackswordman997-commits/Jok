-- This script will attempt to join a list of raids for a duration of 5 minutes.
-- It will also perform a "dash" action after each raid attempt.

-- Run for 30 minutes (1800 seconds)
local startTime = tick()
local duration = 1800 -- 30 minutes in seconds

-- You can adjust these wait times to your preference
local firstWait = 3 -- Wait after raid actions (was 6s)
local secondWait = 5 -- Wait after first dash (was 30s)
local thirdWait = 2 -- Wait before second dash (was 3s)

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

-- The main loop that will run for 30 minutes
while tick() - startTime < duration do
    -- Loop through each raid ID in the list
    for i, raidId in ipairs(raidIDs) do
        -- Check if the timer has expired. If so, break out of both loops.
        if tick() - startTime >= duration then
            break
        end

        -- Raid actions: Create a team and start the challenge map
        -- Using pcall to prevent the script from stopping if the remote fails
        local success, err = pcall(function()
            local args = {raidId}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CreateRaidTeam"):InvokeServer(unpack(args))
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartChallengeRaidMap"):FireServer()
        end)
        
        if not success then
            print("Error creating raid team or starting map: " .. tostring(err))
            -- You might need to adjust the remote event names or arguments if this error occurs.
        end

        -- Wait a few seconds to let the action process
        wait(firstWait)

        -- First dash
        local success2, err2 = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartChallengeRaidMap"):FireServer()
        end)

        if not success2 then
            print("Error firing StartChallengeRaidMap remote for dash: " .. tostring(err2))
            -- If this remote doesn't work for dashing, try the alternative below.
        end
        
        --[[ ALTERNATIVE DASH METHOD
        -- game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
        -- wait(0.1)
        -- game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)
        ]]

        -- Wait a bit longer to recharge and for game events to pass
        wait(secondWait)

        -- Wait a little more before the second dash
        wait(thirdWait)

        -- Second dash
        local success3, err3 = pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("StartChallengeRaidMap"):FireServer()
        end)

        if not success3 then
            print("Error firing StartChallengeRaidMap remote for second dash: " .. tostring(err3))
        end

        --[[ ALTERNATIVE DASH METHOD
        -- game:GetService("VirtualInputManager"):SendKeyEvent(true, "Q", false, game)
        -- wait(0.1)
        -- game:GetService("VirtualInputManager"):SendKeyEvent(false, "Q", false, game)
        ]]
    end
end
