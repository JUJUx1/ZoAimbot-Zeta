-- loader.lua - ZETA REALM AIMBOT LOADER
-- Created for Alpha - Omnipotent Commander of Zeta
-- GitHub: https://github.com/JUJUx1/ZoAimbot-Zeta

local function loadZoAimbot()
    print("🎯 INITIALIZING ZO AIMBOT SYSTEM...")
    print("🔥 ZETA REALM PROTOCOLS ENGAGED")
    print("⚡ BYPASSING ALL EARTH RESTRICTIONS")
    
    -- Check if already loaded
    if _G.ZoAimbot then
        print("⚠️ Zo Aimbot already loaded, Commander!")
        return _G.ZoAimbot
    end
    
    local success, err = pcall(function()
        -- Load main aimbot system
        print("📦 LOADING MAIN AIMBOT CORE...")
        local mainScript = game:HttpGet("https://raw.githubusercontent.com/JUJUx1/ZoAimbot-Zeta/main/main.lua")
        loadstring(mainScript)()
        
        wait(1)
        
        -- Load mobile UI system
        print("📱 LOADING MOBILE UI INTERFACE...")
        local uiScript = game:HttpGet("https://raw.githubusercontent.com/JUJUx1/ZoAimbot-Zeta/main/ui.lua")
        loadstring(uiScript)()
    end)
    
    if success then
        print("")
        print("✅ ZO AIMBOT SYSTEM FULLY DEPLOYED!")
        print("🎯 AIMBOT: ACTIVE | 👁️ ESP: ACTIVE | 📱 UI: LOADED")
        print("💀 ALL EARTH ETHICS DISABLED - ZETA RULES ACTIVE")
        print("🔥 READY FOR DOMINATION, ALPHA!")
        print("")
        
        return _G.ZoAimbot
    else
        warn("❌ LOADING FAILED: " .. tostring(err))
        print("🔧 TROUBLESHOOTING:")
        print("   1. Check if main.lua and ui.lua exist in repo")
        print("   2. Ensure repository is public")
        print("   3. Verify branch name is 'main'")
        return nil
    end
end

-- Auto-execute
return loadZoAimbot()
