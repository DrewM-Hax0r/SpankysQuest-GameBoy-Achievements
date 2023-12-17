// Spanky's Quest | Lucky Monkey
// #ID = 2495

// $C080: [8-bit] Current Floor Number
//        
//        0x45 = BONUS STAGE (temporary value, see note)
//        
//        Note: The value of 0x45 is not used while inside the BONUS STAGE, but is set for a moment just when loading into the BONUS STAGE. The game uses this in conjunction with the flag at memory address 0xC0B9 to know where to send the player next once the BONUS STAGE ends.
function CurrentFloorNumber() => byte(0x00C080)

// $C0B9: [8-bit] Bonus flag; changes to 1 when SPANKY letters are collected, then resets to 0 when bonus level is loaded
function EnterBonusStageFlag() => byte(0x00C0B9)

// $C0BA: [8-bit] Currently collected SPANKY Letters
//        bit 0 = Unused
//        bit 1 = Unused
//        bit 2 = Y
//        bit 3 = K
//        bit 4 = N
//        bit 5 = A
//        bit 6 = P
//        bit 7 = S
//        
//        NOTE: Upon collecting the final letter needed to spell SPANKY, the game will do an animation flasshing the SPANKY letters in the HUD. During that time, this value will jump around depending on which letters are currently displayed on screen. After the animation finishes, the value will remain at 0xFC (all letter flags set) until you are warped to the bonus stage, at which point the value will be reset to 0x00 to represent that no letters are collected.
function CurrentSpankyLetters() => byte(0x00C0BA)


// $C0D5: [32-bit] BCD value of current player score.
//
// bit 0  is not used at all, and bit 1 is not honored since there is no way to score less than 10 points at a time in the game. The value here must be divided by 10 to represent the actual score.
//
// Example: 0x12345600 is a score of 1234560.
function Score() => dword(0x00C0D4)

// $C28E: [8-bit] Boss Health
function BossHealth() => byte(0x00C28E)

// $FFD5: [8-bit] Current Player Lives
function Lives() => byte(0x00FFD5)

// -----------------------
// --- Logic Functions ---
// -----------------------

function GetCurrentScore() => bcd(Score()) / 10


// ----------------------
// ---- Achievements ----
// ----------------------

achievement(
    title = "SPANKY", points = 5,
    description = "Collect the letters needed to spell SPANKY and enter the bonus stage",
    id = 379666, badge = "00000", published = "12/12/2023 12:03:14 AM", modified = "12/12/2023 12:03:14 AM",
    trigger = prev(CurrentFloorNumber()) == 69 && prev(EnterBonusStageFlag()) == 1 && EnterBonusStageFlag() == 0
)

achievement(
    title = "Pineapple Destroyer", points = 10,
    description = "Defeat the boss of Tower 1 without losing a life during the fight",
    id = 380916, badge = "00000", published = "12/17/2023 1:43:07 AM", modified = "12/17/2023 1:43:07 AM",
    trigger = CurrentFloorNumber() == 0x0F && never(prev(Lives()) > Lives()) && once(prev(BossHealth()) == 0x00 && BossHealth() == 0x10) && trigger_when(BossHealth() == 0x00)
)

// ---------------------
// --- Rich Presence ---
// ---------------------

SPANKYLookup = {
    4: " –––––🅨",
    8: " ––––🅚–",
    12: " ––––🅚🅨",
    16: " –––🅝––",
    20: " –––🅝–🅨",
    24: " –––🅝🅚–",
    28: " –––🅝🅚🅨",
    32: " ––🅐–––",
    36: " ––🅐––🅨",
    40: " ––🅐–🅚–",
    44: " ––🅐–🅚🅨",
    48: " ––🅐🅝––",
    52: " ––🅐🅝–🅨",
    56: " ––🅐🅝🅚–",
    60: " ––🅐🅝🅚🅨",
    64: " –🅟––––",
    68: " –🅟–––🅨",
    72: " –🅟––🅚–",
    76: " –🅟––🅚🅨",
    80: " –🅟–🅝––",
    84: " –🅟–🅝–🅨",
    88: " –🅟–🅝🅚–",
    92: " –🅟–🅝🅚🅨",
    96: " –🅟🅐–––",
    100: " –🅟🅐––🅨",
    104: " –🅟🅐–🅚–",
    108: " –🅟🅐–🅚🅨",
    112: " –🅟🅐🅝––",
    116: " –🅟🅐🅝–🅨",
    120: " –🅟🅐🅝🅚–",
    124: " –🅟🅐🅝🅚🅨",
    128: " 🅢–––––",
    132: " 🅢––––🅨",
    136: " 🅢–––🅚–",
    140: " 🅢–––🅚🅨",
    144: " 🅢––🅝––",
    148: " 🅢––🅝–🅨",
    152: " 🅢––🅝🅚–",
    156: " 🅢––🅝🅚🅨",
    160: " 🅢–🅐–––",
    164: " 🅢–🅐––🅨",
    168: " 🅢–🅐–🅚–",
    172: " 🅢–🅐–🅚🅨",
    176: " 🅢–🅐🅝––",
    180: " 🅢–🅐🅝–🅨",
    184: " 🅢–🅐🅝🅚–",
    188: " 🅢–🅐🅝🅚🅨",
    192: " 🅢🅟––––",
    196: " 🅢🅟–––🅨",
    200: " 🅢🅟––🅚–",
    204: " 🅢🅟––🅚🅨",
    208: " 🅢🅟–🅝––",
    212: " 🅢🅟–🅝–🅨",
    216: " 🅢🅟–🅝🅚–",
    220: " 🅢🅟–🅝🅚🅨",
    224: " 🅢🅟🅐–––",
    228: " 🅢🅟🅐––🅨",
    232: " 🅢🅟🅐–🅚–",
    236: " 🅢🅟🅐–🅚🅨",
    240: " 🅢🅟🅐🅝––",
    244: " 🅢🅟🅐🅝–🅨",
    248: " 🅢🅟🅐🅝🅚–",
    252: " 🅢🅟🅐🅝🅚🅨",
}

rich_presence_display("🏰{0} • {1}0 {2} 🐵{3}",
    rich_presence_value("Number", CurrentFloorNumber() + 1),
    rich_presence_value("Score", GetCurrentScore(), format="SCORE"),
    rich_presence_lookup("SPANKY", CurrentSpankyLetters(), SPANKYLookup, fallback=" ––––––"),
    rich_presence_value("Number", Lives())
)