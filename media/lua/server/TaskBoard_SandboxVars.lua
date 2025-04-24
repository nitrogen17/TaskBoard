require("Sandbox/SandboxOptions")

local function addAndRegisterTaskBoardSandboxVars()
    SandboxVars.TaskBoard = SandboxVars.TaskBoard or {}
    SandboxVars.TaskBoard.UseInGameTime = SandboxVars.TaskBoard.UseInGameTime or false -- Boolean toggle

    -- Access the sandbox variable everywhere: local useInGameTime = SandboxVars.TaskBoard.UseInGameTime
    local taskBoardOptions = SandboxOptions.getOptionByName("TaskBoard") or SandboxOptions.addCategory("TaskBoard")
    taskBoardOptions:addOption("UseInGameTime", "Use In-Game Time", false, "By default, time used is real-world time.")
end

Events.OnGameBoot.Add(addAndRegisterTaskBoardSandboxVars)
