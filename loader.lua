-- loader.lua - SINGLE FILE LOADER
local function loadZoAimbot()
    print("🎯 LOADING ZO AIMBOT SYSTEM...")
    
    -- Check if already loaded
    if _G.ZoAimbot then
        print("⚠️ Zo Aimbot already loaded!")
        return
    end
    
    -- Load main system
    loadstring(game:HttpGet("https://raw.githubusercontent.com/JUJUx1/ZoAimbot-Zeta/refs/heads/main/main.lua"))()
    
    wait(1)
    
    -- Load UI system
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/ZoAimbot-Zeta/main/ui.lua"))()
    
    print("✅ ZO AIMBOT FULLY DEPLOYED!")
    print("🔥 Welcome to Zeta Realm, Alpha!")
end

loadZoAimbot()
