LUAGUI_NAME = "KH1 Save Anywhere"
LUAGUI_AUTH = "Mariano"
LUAGUI_DESC = "The Start menu opens the save point menu: save and change party anywhere."

local MOD_VERSION = "1.0.0"

-- Steam Global only: every address below was found or verified on it.
local FINGERPRINT_ADDR = 0x3B2271
local FINGERPRINT      = 0x7265737563697065

local GAME_STATE  = 0x233FBC0   -- 5 on foot, 7 in gummi mode
local STATE_FIELD = 5

-- Screen mode, set by the game: 0 in normal play, 4 at a save point (Start
-- then opens the save point menu instead of the Start menu), 1 and 2 in
-- transitions and fights. The game resets it to 0 every frame in normal
-- play; this script writes 4 after it, so a Start press opens the save
-- point menu. "Menu" there still opens the Start menu. Cutscenes and fights
-- keep their own pause menu: the game doesn't open the save point menu there.
-- Found by a memory scan comparing the Start menu at and away from save points.
local SCREEN_MODE      = 0x232DFA4
local MODE_NORMAL      = 0
local MODE_SAVE_POINT  = 4

local active

function _OnInit()
    active = ReadLong(FINGERPRINT_ADDR) == FINGERPRINT
    if not active then
        ConsolePrint(string.format("KH1 Save Anywhere v%s - NOT running: only the "
            .. "Steam Global version is supported. Nothing will be written.", MOD_VERSION))
        return
    end
    ConsolePrint(string.format("KH1 Save Anywhere v%s - installed (Steam GL)", MOD_VERSION))
end

function _OnFrame()
    if not active then return end
    if ReadInt(GAME_STATE) == STATE_FIELD and ReadInt(SCREEN_MODE) == MODE_NORMAL then
        WriteInt(SCREEN_MODE, MODE_SAVE_POINT)
    end
end
