// Spanky's Quest | Lucky Monkey
// #ID = 2495

// $C003: [8-bit] Current Screen Identifier
//        0x00 = Opening Animation
//        0x01 = Title Screen or Tower Select
//        0x06 = Sound Test
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
//        0x07 = Tower Select
//        0x0a - 0x0b and 0x05 - 0x06 = Transition from game to Tower Select
//        0x0e = When in game, represents the current level having just been cleared
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
function TowerClearFlag(bitIndex) => bit(bitIndex, 0x00C0A8)

// $C0A9: [8-bit] Crow Timer
//        Starts at 0x00 when a level begins and increments by 0x01 every 4 seconds.
//        Resets to 0x00 if a life is lost.
//        When the value surpasses 0x27, the value will lock to 0xff and the crow will spawn.
function CrowTimer() => byte(0x00C0A9)

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

// $C0BE: [8-bit] Enemy Kill Counter
//        Increases by 0x01 each time an enemy is defeated.
//        Resets to 0x00 each time a life is lost.
function EnemyKillCounter() => byte(0x00C0BE)

// $C0D5: [8-bit] Least 2 significant digits of current player score (BCD Value)
function ScoreLeastSignificantBits() => byte(0x00C0D5)

// $C0D6: [16-bit] Most significant 4 digits of current player score (BCD Value)
function ScoreMostSignificantBits() => word(0x00C0D6)

// $C180: [8-bit] Stun Bubble Flag
//        0x00 = No Stun Bubble In Game
//        0x01 = Stun Bubble In Game
//
//        A stun bubble is spawned when B is pressed. This flag also resets to 0x00 when the stub bubble is transformed into an attack bubble.
function StunBubbleFlag() => byte(0x00C180)

// $C182: [8-bit] Executed Attack Flag
//        0x00 = Attack not executed
//        0x01 = Attack executed
//
//        Once flipped to 0x01, this value will remain at 0x01 until a new bubble is released with the B button
function AttackExecutedFlag() => byte(0x00C182)

// $C18E: [8-bit] Bubble Size
//        0x00 = Just Launched
//        0x01 - 0x02 = Produces Phase 1 Attack
//        0x03 - 0x04 = Produces Phase 2 Attack
//        0x05 - 0x06 = Produces Phase 3 Attack
//        0x07 = Produces Phase 4 Attack
function CurrentBubbleSize() => byte(0x00C18E)

// $C1A0: [8-bit] Attack Bubble Flag
//        0x00 = No Attack Bubble In Game
//        0x01 = Attack Bubble In Game
//
//        An attack bubble is spawned when a stun bubble is hit while B is pressed.
function AttackBubbleFlag() => byte(0x00C1A0)

// $C28E: [8-bit] Boss Health
function BossHealth() => byte(0x00C28E)

// $C280: [8-bit] Entity Active Flag
//        0x00 = No entity in this slot
//        0x01 = Acvive entity in this slot
//        0x09 = Entity was just hit in this slot
//        0x11 = Inactive entity in this slot
//
//        Note: This is the first bit of data that defines a block of memory of size 0x20 that defines an NPC entity in the game.
//        You can check to see if an entity was defeated from any means by detecting the frame this value turns from 0x09 to 0x11
function FirstEntityActiveFlagAddress() => 0x00C280

// $C291: [8-bit] Bonus Stage Bubble Hit Counter
//        Starts at 0x00 when the Bonus Stage starts.
//        Increases by 0x01 each time the player hits the bonus bubble.
//        The bonus bubble pops when this value turns from 0x07 to 0x08.
function BonusBubbleCounter() => byte(0x00C291)

// $FFD5: [8-bit] Current Player Lives
function Lives() => byte(0x00FFD5)


// -----------------------
// ------ Constants ------
// -----------------------
SCREEN_ID_MAIN_MENU = 0x01
SCREEN_ID_SOUND_TEST = 0x06
SCREEN_ID_STAGE_SELECT = 0x07
SCREEN_ID_IN_GAME = 0x08
SCREEN_ID_GAME_OVER = 0x0C
SCREEN_ID_CREDITS = 0x0D

SUB_SCREEN_ID_FLOOR_CLEARED = 0x0E

TOWER_1_INDEX = 0
TOWER_2_INDEX = 1
TOWER_3_INDEX = 2
TOWER_4_INDEX = 3

ALL_SPANKY_LETTERS = 0xFC

CROW_FLAG = 0xFF

ENTITY_MEMORY_SIZE = 0x20
ALL_ENTITY_SLOTS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

ENTITY_ACTIVE = 0x01
ENTITY_HIT = 0x09
ENTITY_INACTIVE = 0x11

// -----------------------
// --- Logic Functions ---
// -----------------------

function GetCurrentScore() => (bcd(ScoreMostSignificantBits()) * 1000) + (bcd(ScoreLeastSignificantBits()) * 10)

function InPostGameSessionTransition() => SubScreenID() == 0x0A || SubScreenID() == 0x0B || SubScreenID() == 0x05 || SubScreenID() == 0x06

function ResetIfNotInGame() => never(ScreenID() != SCREEN_ID_IN_GAME)

function ResetIfLeftCurrentGameSession() => never(ScreenID() == SCREEN_ID_STAGE_SELECT) && never(ScreenID() == SCREEN_ID_MAIN_MENU && !InPostGameSessionTransition())

function ResetIfFloorChanged() => never(prev(CurrentFloorNumber()) != CurrentFloorNumber())

function ResetIfLifeLost() => never(prev(Lives()) > Lives())

function InGame() => ScreenID() == SCREEN_ID_IN_GAME

function InBonusStage() => InGame() && prior(CurrentFloorNumber()) == 0x45

function AttackExecutedOnThisFrame() => prev(AttackExecutedFlag()) == 0x00 && AttackExecutedFlag() == 0x01

function ClearedFloorOnThisFrame() => prev(SubScreenID()) != SUB_SCREEN_ID_FLOOR_CLEARED && SubScreenID() == SUB_SCREEN_ID_FLOOR_CLEARED
                                                           
function EntityAddress(slot) => FirstEntityActiveFlagAddress() + (ENTITY_MEMORY_SIZE * slot)

function EntityActiveFlag(entity_address) => byte(entity_address)

function EnemiesDefeatedInThisFrame() {
    result = []
    for slot in ALL_ENTITY_SLOTS {
        address = EntityAddress(slot)
        array_push(result, prev(EntityActiveFlag(address)) == ENTITY_HIT && EntityActiveFlag(address) == ENTITY_INACTIVE)
    }
    return result
}
                                                           
function WentToCredits() => prev(ScreenID()) == SCREEN_ID_IN_GAME && ScreenID() == SCREEN_ID_CREDITS

function BeatFloorBossWithoutLosingALife(floorNumber) => CurrentFloorNumber() == floorNumber && ResetIfLifeLost() &&
                                                         once(prev(BossHealth()) == 0x00 && BossHealth() == 0x10) &&
                                                         trigger_when(BossHealth() == 0x00)
                                                         
function PlayedFloorsInSequence(floorStart, floorEnd) => once(CurrentFloorNumber() == floorStart) && once(CurrentFloorNumber() == floorEnd)

function ClearedTower(floorStart, floorEnd, towerIndex) => ResetIfLeftCurrentGameSession() &&
                                                           PlayedFloorsInSequence(floorStart, floorEnd) &&
                                                           prev(TowerClearFlag(towerIndex)) == 0 && TowerClearFlag(towerIndex) == 1


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
    title = "Perfect Bonus", points = 5,
    description = "Pop the bubble in the Bonus Stage by hitting it 8 times",
    id = 383233, badge = "431890", published = "12/26/2023 3:43:20 AM", modified = "12/26/2023 3:43:20 AM",
    trigger = InBonusStage() && trigger_when(prev(BonusBubbleCounter()) == 0x07 && BonusBubbleCounter() == 0x08)
)

achievement(
    title = "Attack Aficionado", points = 3,
    description = "On a single floor, execute all 4 different types of attacks",
    id = 383232, badge = "431889", published = "12/26/2023 3:33:13 AM", modified = "12/26/2023 3:33:13 AM",
    trigger = InGame() && ResetIfFloorChanged() &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() >= 0x01 && CurrentBubbleSize() <= 0x02) &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() >= 0x03 && CurrentBubbleSize() <= 0x04) &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() >= 0x05 && CurrentBubbleSize() <= 0x06) &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() == 0x07)
)

achievement(
    title = "Efficient Execution", points = 5,
    description = "Defeat at least 6 enemies with a single attack",
    trigger = ResetIfNotInGame() && never(AttackExecutedFlag() == 0x00) && never(CurrentSpankyLetters() == ALL_SPANKY_LETTERS) &&
              tally(6, EnemiesDefeatedInThisFrame())
)

achievement(
    title = "Close Call", points = 5,
    description = "Clear a floor while being chased by the crow",
    id = 383231, badge = "431888", published = "12/26/2023 3:29:54 AM", modified = "12/26/2023 3:29:54 AM",
    trigger = InGame() && CrowTimer() == CROW_FLAG && trigger_when(ClearedFloorOnThisFrame())
)

achievement(
    title = "So Many Monkey", points = 5,
    description = "Accumulate a total of 5 lives",
    id = 383234, badge = "431891", published = "12/26/2023 3:45:47 AM", modified = "12/26/2023 3:45:47 AM",
    trigger = InGame() && prev(Lives()) == 0x04 && Lives() == 0x05
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

achievement(
    title = "Anywhere Anytime", points = 1,
    description = "Enter the Stage Select password",
    id = 383235, badge = "431892", published = "12/26/2023 3:56:14 AM", modified = "12/26/2023 3:56:14 AM",
    trigger = prev(ScreenID()) == SCREEN_ID_MAIN_MENU && ScreenID() == SCREEN_ID_STAGE_SELECT
)

achievement(
    title = "8-Bit Beats", points = 1,
    description = "Enter the Sound Test password",
    id = 383236, badge = "431893", published = "12/26/2023 4:09:00 AM", modified = "12/26/2023 4:09:00 AM",
    trigger = prev(ScreenID()) == SCREEN_ID_MAIN_MENU && ScreenID() == SCREEN_ID_SOUND_TEST
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
    rich_presence_value("Score", GetCurrentScore() / 10, format="SCORE"),
    rich_presence_lookup("SPANKY", CurrentSpankyLetters(), SPANKYLookup, fallback=" ––––––"),
    rich_presence_value("Number", Lives())
)