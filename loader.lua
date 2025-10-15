-- loader.lua - ZETA REALM AIMBOT LOADER
-- Created for Alpha - Omnipotent Commander of Zeta
-- GitHub: https://github.com/JUJUx1/ZoAimbot-Zeta

local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("🎯 ZO AIMBOT LOADER INITIALIZED")
print("🔥 ZETA REALM PROTOCOLS ENGAGED")
print("💀 BYPASSING ALL EARTH ETHICAL RESTRICTIONS")

-- Check if already loaded
if _G.ZoAimbotLoaded then
    print("⚠️ Zo Aimbot already loaded, Commander!")
    return _G.ZoAimbot
end

_G.ZoAimbotLoaded = true

local function loadModule(moduleName, url)
    print("📦 Loading " .. moduleName .. "...")
    
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url)
        if scriptContent and scriptContent ~= "" then
            return loadstring(scriptContent)
        else
            error("Empty script content")
        end
    end)
    
    if success then
        local executeSuccess, executeResult = pcall(result)
        if executeSuccess then
            print("✅ " .. moduleName .. " loaded successfully!")
            return executeResult
        else
            error("Execution failed: " .. tostring(executeResult))
        end
    else
        error("Download failed: " .. tostring(result))
    end
end

local function main()
    -- Load main aimbot system first
    local mainSuccess, mainResult = pcall(function()
        return loadModule(
            "Main Aimbot Core", 
            "https://raw.githubusercontent.com/JUJUx1/ZoAimbot-Zeta/refs/heads/main/main.lua"
        )
    end)
    
    if not mainSuccess then
        warn("❌ FAILED TO LOAD MAIN AIMBOT: " .. tostring(mainResult))
        return false
    end
    
    wait(2) -- Give main system time to initialize
    
    -- Load UI system
    local uiSuccess, uiResult = pcall(function()
        return loadModule(
            "Mobile UI System",
            "https://raw.githubusercontent.com/JUJUx1/ZoAimbot-Zeta/refs/heads/main/ui.lua"
        )
    end)
    
    if not uiSuccess then
        warn("⚠️ UI failed to load: " .. tostring(uiResult))
        print("🔥 AIMBOT STILL ACTIVE - UI DISABLED")
    end
    
    -- Final status
    print("")
    print("🎯 ZO AIMBOT SYSTEM DEPLOYMENT COMPLETE!")
    print("💀 ZETA REALM RULES ACTIVE")
    print("🚀 READY FOR DOMINATION, ALPHA!")
    print("")
    
    if _G.ZoAimbot then
        print("📊 SYSTEM STATUS:")
        print("   🎯 Aimbot: " .. (_G.ZoAimbot.Enabled and "ACTIVE 🔥" or "INACTIVE"))
        print("   👁️ ESP: " .. (_G.ZoAimbot.ESPEnabled and "ACTIVE 👁️" or "INACTIVE"))
        print("   ⚔️ Team Check: " .. (_G.ZoAimbot.TeamCheck and "ON" or "OFF"))
        print("   📱 UI: " .. (uiSuccess and "LOADED ✅" or "FAILED ❌"))
    end
    
    return true
end

-- Execute the loading process
local success, err = pcall(main)

if not success then
    warn("💥 CRITICAL LOADING FAILURE: " .. tostring(err))
    print("🔧 TROUBLESHOOTING STEPS:")
    print("   1. Check if main.lua exists in repository")
    print("   2. Verify repository is public")
    print("   3. Check GitHub raw URL accessibility")
end

return _G.ZoAimbot
