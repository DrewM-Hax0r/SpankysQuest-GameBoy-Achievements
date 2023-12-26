// Spanky's Quest | Lucky Monkey
// #ID = 2495

// $C003: [8-bit] Current Screen Identifier
//        0x00 = Opening Animation
//        0x01 = Title Screen or Tower Select
//        0x07 = Stage Select
//        0x08 = In Game
//        0x0c = Game Over screen
//        0x0d = Credits
function ScreenID() => byte(0x00C003)

// $C004: [8-bit] Sub Screen Identifier
//        A secondary ID for the current screen that is used in conjunction with the main screen ID to know the exact state of the game
//        0x01 = Loading Title Screen
//        0x02 = Title Screen
//        0x03 = Scoreboard when viewed from Title Screen
//        0x04 = Transition from Title Screen to Tower Select
//        0x0a - 0x0b and 0x05 - 0x06 = Transition from game to Tower Select
//        0x07 = Tower Select
function SubScreenID() => byte(0x00C004)

// $C080: [8-bit] Current Floor Number
//        
//        0x45 = BONUS STAGE (temporary value, see note)
//        
//        Note: The value of 0x45 is not used while inside the BONUS STAGE, but is set for a moment just when loading into the BONUS STAGE. The game uses this in conjunction with the flag at memory address 0xC0B9 to know where to send the player next once the BONUS STAGE ends.
function CurrentFloorNumber() => byte(0x00C080)

// $C0A8: [8-bit] Tower Clear Flag, individual bits are set to 1 when each tower is crossed off on the tower select screen
//        bit0 = Tower 1
//        bit1 = Tower 2
//        bit2 = Tower 3
//        bit3 = Tower 4
//        bit4 = Tower 5
//        bit5 = Unused
//        bit6 = Unused
//        bit7 = Unused
//
//        Note: Since tower 5 is locked until the previous 4 towers are cleared, the initial state on a new game will be 0001 0000, signifying that towers 1-4 are open and tower 5 is locked.
function Tower1ClearFlag() => bit0(0x00C0A8)
function Tower2ClearFlag() => bit1(0x00C0A8)
function Tower3ClearFlag() => bit2(0x00C0A8)
function Tower4ClearFlag() => bit3(0x00C0A8)
function TowerClearFlag(bitIndex) => bit(bitIndex, 0x00C0A8)

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

// $C0D5: [8-bit] Least 2 significant digits of current player score (BCD Value)
function ScoreLeastSignificantBits() => byte(0x00C0D5)

// $C0D6: [16-bit] Most significant 4 digits of current player score (BCD Value)
function ScoreMostSignificantBits() => word(0x00C0D6)

// $C28E: [8-bit] Boss Health
function BossHealth() => byte(0x00C28E)

// $FFD5: [8-bit] Current Player Lives
function Lives() => byte(0x00FFD5)


// -----------------------
// ------ Constants ------
// -----------------------
SCREEN_ID_MAIN_MENU = 0x01
SCREEN_ID_STAGE_SELECT = 0x07
SCREEN_ID_IN_GAME = 0x08
SCREEN_ID_GAME_OVER = 0x0C
SCREEN_ID_CREDITS = 0x0D

TOWER_1_INDEX = 0
TOWER_2_INDEX = 1
TOWER_3_INDEX = 2
TOWER_4_INDEX = 3


// -----------------------
// --- Logic Functions ---
// -----------------------

function GetCurrentScore() => (bcd(ScoreMostSignificantBits()) * 1000) + (bcd(ScoreLeastSignificantBits()) * 10)

function InPostGameSessionTransition() => SubScreenID() == 0x0A || SubScreenID() == 0x0B || SubScreenID() == 0x05 || SubScreenID() == 0x06

function ResetIfLeftCurrentGameSession() => never(ScreenID() == SCREEN_ID_STAGE_SELECT) && never(ScreenID() == SCREEN_ID_MAIN_MENU && !InPostGameSessionTransition())

function ResetIfLifeLost() => never(prev(Lives()) > Lives())

function PlayedFloorsInSequence(floorStart, floorEnd) => once(CurrentFloorNumber() == floorStart) && once(CurrentFloorNumber() == floorEnd)

function ClearedTower(floorStart, floorEnd, towerIndex) => ResetIfLeftCurrentGameSession() &&
                                                           PlayedFloorsInSequence(floorStart, floorEnd) &&
                                                           prev(TowerClearFlag(towerIndex)) == 0 && TowerClearFlag(towerIndex) == 1
                                                           
function WentToCredits() => prev(ScreenID()) == SCREEN_ID_IN_GAME && ScreenID() == SCREEN_ID_CREDITS

function BeatFloorBossWithoutLosingALife(floorNumber) => CurrentFloorNumber() == floorNumber && ResetIfLifeLost() &&
                                                         once(prev(BossHealth()) == 0x00 && BossHealth() == 0x10) &&
                                                         trigger_when(BossHealth() == 0x00)

// ----------------------
// ---- Achievements ----
// ----------------------

achievement(
    title = "Tower 1 Clear", points = 5,
    description = "Start from 1-01 and sequentially clear all 16 floors of Tower 1",
    id = 382207, badge = "431738", published = "12/20/2023 2:17:20 AM", modified = "12/20/2023 2:17:20 AM",
    trigger = ClearedTower(0x00, 0x0F, TOWER_1_INDEX)
)

achievement(
    title = "Tower 2 Clear", points = 5,
    description = "Start from 2-01 and sequentially clear all 16 floors of Tower 2",
    id = 383097, badge = "431739", published = "12/24/2023 4:43:42 AM", modified = "12/24/2023 4:43:42 AM",
    trigger = ClearedTower(0x10, 0x1F, TOWER_2_INDEX)
)

achievement(
    title = "Tower 3 Clear", points = 5,
    description = "Start from 3-01 and sequentially clear all 16 floors of Tower 3",
    id = 383098, badge = "431740", published = "12/24/2023 4:44:10 AM", modified = "12/24/2023 4:44:10 AM",
    trigger = ClearedTower(0x20, 0x2F, TOWER_3_INDEX)
)

achievement(
    title = "Tower 4 Clear", points = 5,
    description = "Start from 4-01 and sequentially clear all 16 floors of Tower 4",
    id = 383099, badge = "431741", published = "12/24/2023 4:44:22 AM", modified = "12/24/2023 4:44:22 AM",
    trigger = ClearedTower(0x30, 0x3F, TOWER_4_INDEX)
)

achievement(
    title = "Tower 5 Clear", points = 25,
    description = "Start from 5-01 and sequentially clear all 5 floors of Tower 5",
    id = 383100, badge = "431742", published = "12/24/2023 4:44:32 AM", modified = "12/24/2023 4:44:32 AM",
    trigger = ResetIfLeftCurrentGameSession() && PlayedFloorsInSequence(0x40, 0x44) && WentToCredits()
)

achievement(
    title = "SPANKY", points = 5,
    description = "Collect the letters needed to spell SPANKY and enter the bonus stage",
    id = 379666, badge = "431745", published = "12/12/2023 12:03:14 AM", modified = "12/12/2023 12:03:14 AM",
    trigger = prev(CurrentFloorNumber()) == 0x45 && prev(EnterBonusStageFlag()) == 0x01 && EnterBonusStageFlag() == 0x00
)

achievement(
    title = "Pineapple Pulverizer", points = 10,
    description = "Defeat the boss of Tower 1 without losing a life during the fight",
    id = 380916, badge = "431746", published = "12/17/2023 1:43:07 AM", modified = "12/17/2023 1:43:07 AM",
    trigger = BeatFloorBossWithoutLosingALife(0x0F)
)

achievement(
    title = "Peach Pincher", points = 10,
    description = "Defeat the boss of Tower 2 without losing a life during the fight",
    id = 383156, badge = "431747", published = "12/24/2023 6:53:58 PM", modified = "12/24/2023 6:53:58 PM",
    trigger = BeatFloorBossWithoutLosingALife(0x1F)
)

achievement(
    title = "Watermelon Wipe-Out", points = 10,
    description = "Defeat the boss of Tower 3 without losing a life during the fight",
    id = 383157, badge = "431748", published = "12/24/2023 7:17:05 PM", modified = "12/24/2023 7:17:05 PM",
    trigger = BeatFloorBossWithoutLosingALife(0x2F)
)

achievement(
    title = "Grape Grinder", points = 10,
    description = "Defeat the boss of Tower 4 without losing a life during the fight",
    id = 383158, badge = "431749", published = "12/24/2023 7:31:59 PM", modified = "12/24/2023 7:31:59 PM",
    trigger = BeatFloorBossWithoutLosingALife(0x3F)
)

achievement(
    title = "Ultimate Boss Rush", points = 25,
    description = "Start from 5-01 and sequentially clear all 5 floors of Tower 5 without losing a life",
    id = 383159, badge = "431750", published = "12/24/2023 7:53:40 PM", modified = "12/24/2023 7:53:40 PM",
    trigger = ResetIfLeftCurrentGameSession() && ResetIfLifeLost() && PlayedFloorsInSequence(0x40, 0x44) && WentToCredits()
)


// ----------------------
// ---- Leaderboards ----
// ----------------------

leaderboard(
    id = 85012,
    title = "Top Score",
    description = "Highest score achieved in a game before losing all lives or clearing the final tower",
    start = prev(ScreenID()) != SCREEN_ID_GAME_OVER && ScreenID() == SCREEN_ID_GAME_OVER,
    cancel = ScreenID() == SCREEN_ID_MAIN_MENU,
    submit = prev(ScreenID()) != SCREEN_ID_GAME_OVER && ScreenID() == SCREEN_ID_GAME_OVER,
    value = GetCurrentScore(),
    format="VALUE",
    lower_is_better=false
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