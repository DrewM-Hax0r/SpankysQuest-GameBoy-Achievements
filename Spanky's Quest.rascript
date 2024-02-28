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
//        0x07 = Tower Select, or starting a stage if in game
//        0x0a - 0x0b and 0x05 - 0x06 = Transition from game to Tower Select
//        0x0e = When in game, represents the current level having just been cleared
function SubScreenID() => byte(0x00C004)

// $C013: [8-bit] Invincibility Cheat Code Flag (JP version ONLY)
//        0x00 = Inactive
//        0x01 = Active
//
//        See notes at address 0xc012 for more information on cheat codes.
//        The code to activate this cheat is: A, A, A, A, B, B, B, B, A, B, A, B, A, B, A, B
//        Note: This flag is still functional in all versions of the game if manually set, but is impossible to activate under normal gameplay in any version of the game besides JP
function InvincibilityCheatFlag() => byte(0x00C013)

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

// $C0D5: [24-bit] Current Player Score (BCD Value)
//        Excludes the right-most digit since there is no way to score less than 10 points at a time in the game, the right-most digit is always 0.
function CurrentPlayerScore() => tbyte(0x00C0D5)

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

// $C280: [8-bit] Entity Active Flag
//        0x00 = No entity in this slot
//        0x01 = Acvive entity in this slot
//        0x09 = Enemy entity was just hit in this slot
//        0x11 = Inactive entity in this slot (also represents an item an enemy dropped)
//
//        Note: This is the first bit of data that defines a block of memory of size 0x20 that defines an entity (enemy, item, dynamic object) in the game.
//        You can check to see if an enemy type entity was defeated from any means by detecting the frame this value turns from 0x09 to 0x11
function FirstEntityActiveFlagAddress() => 0x00C280

// $C281: [8-bit] Entity Type
//        This can identify anything from the type of enemy to the type of item it is that is occupying this span of memory
//        0x09 = Bonus Points
//        0x0A = Extra Life
//        0x0B = Attack Power Up
//        0x0C = SPANKY Letter
function FirstEntityTypeAddress() => 0x00C281

// $C282: [8-bit] Pick-Up Flag
//        Used for item entities that the player can touch to pick up, flag values depend on item type
//        Bonus Points = 0x00 to 0x01 when picked up
//        Attack Power Up = 0x00 to 0x01 when picked up
//        Extra Life = 0x00 to 0x01 when picked up
//        SPANKY Letter = 0x01 to 0x02 when picked up
function FirstEntityTypeAddress() => 0x00C282

// $C28E: [8-bit] Boss Health
function BossHealth() => byte(0x00C28E)

// $C291: [8-bit] Bonus Stage Bubble Hit Counter
//        Starts at 0x00 when the Bonus Stage starts.
//        Increases by 0x01 each time the player hits the bonus bubble.
//        The bonus bubble pops when this value turns from 0x07 to 0x08.
function BonusBubbleCounter() => byte(0x00C291)

// $FFD5: [8-bit] Current Player Lives
function Lives() => byte(0x00FFD5)

// $FFD6: [8-bit] Attack Power-Up Counter
//        Set to 0x10 when the attack power-up item is collected.
//        When greater than 0x00, decreases by 0x01 each time an attack is used.
//        Resets to 0x00 when a life is lost.
//        When 0x00, the attack power-up is not in effect.
function AttackPowerUpCounter() => byte(0x00FFD6)


// -----------------------
// ------ Constants ------
// -----------------------
SCREEN_ID_MAIN_MENU = 0x01
SCREEN_ID_SOUND_TEST = 0x06
SCREEN_ID_STAGE_SELECT = 0x07
SCREEN_ID_IN_GAME = 0x08
SCREEN_ID_GAME_OVER = 0x0C

SUB_SCREEN_ID_FLOOR_START = 0x07
SUB_SCREEN_ID_FLOOR_ACTIVE = 0x0A
SUB_SCREEN_ID_FLOOR_CLEARED = 0x0E

SPANKY_LETTERS_S = 0x80
SPANKY_LETTERS_SP = 0xC0
SPANKY_LETTERS_SPA = 0xE0
SPANKY_LETTERS_SPAN = 0xF0
SPANKY_LETTERS_SPANK = 0xF8
ALL_SPANKY_LETTERS = 0xFC

CROW_FLAG = 0xFF

ENTITY_MEMORY_SIZE = 0x20
ALL_ENTITY_SLOTS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

// Offsets are relative to the first byte in the block of entity memory (active flag)
ENTITY_TYPE_OFFSET = 0x01
ENTITY_PICK_UP_FLAG_OFFSET = 0x02

ENTITY_ACTIVE = 0x01
ENTITY_HIT = 0x09
ENTITY_INACTIVE = 0x11

ENTITY_TYPE_ITEM_BONUS_POINTS = 0x09
ENTITY_TYPE_ITEM_EXTRA_LIFE = 0x0A
ENTITY_TYPE_ITEM_POWER_UP = 0x0B
ENTITY_TYPE_ITEM_SPANKY_LETTER = 0x0C

// -----------------------
// --- Logic Functions ---
// -----------------------

function GetCurrentScore() => (bcd(CurrentPlayerScore()) * 10)

function InPostGameSessionTransition() => SubScreenID() == 0x0A || SubScreenID() == 0x0B || SubScreenID() == 0x05 || SubScreenID() == 0x06

function ResetIfNotInGame() => never(ScreenID() != SCREEN_ID_IN_GAME)

function ResetIfUsingInvincibilityCheat() => never(InvincibilityCheatFlag() == 0x01)

function ResetIfLeftCurrentGameSession() => never(ScreenID() == SCREEN_ID_STAGE_SELECT) && never(ScreenID() == SCREEN_ID_MAIN_MENU && !InPostGameSessionTransition())

function ResetIfFloorChanged() => never(prev(CurrentFloorNumber()) != CurrentFloorNumber())

function ResetIfLifeLost() => never(prev(Lives()) > Lives())

function InGame() => ScreenID() == SCREEN_ID_IN_GAME

function StartingStage() => InGame() && SubScreenID() == SUB_SCREEN_ID_FLOOR_START

function NotUsingInvincibilityCheat() => InvincibilityCheatFlag() == 0x00

function InBonusStage() => InGame() && prior(CurrentFloorNumber()) == 0x45

function SurpassedScore(score) => InGame() && ResetIfUsingInvincibilityCheat() && prev(GetCurrentScore()) <= score && GetCurrentScore() > score

function HasAttackPowerUp() => AttackPowerUpCounter() > 0x00

function AttackExecutedOnThisFrame() => prev(AttackExecutedFlag()) == 0x00 && AttackExecutedFlag() == 0x01

function ClearedFloorOnThisFrame() => prev(SubScreenID()) == SUB_SCREEN_ID_FLOOR_ACTIVE && SubScreenID() == SUB_SCREEN_ID_FLOOR_CLEARED
                                                           
function EntityAddress(slot) => FirstEntityActiveFlagAddress() + (ENTITY_MEMORY_SIZE * slot)

function EntityActiveFlag(entityAddress) => byte(entityAddress)

function EntityType(entityAddress) => byte(entityAddress + ENTITY_TYPE_OFFSET)

function EntityPickUpFlag(entityAddress) => byte(entityAddress + ENTITY_PICK_UP_FLAG_OFFSET)

function EnemiesDefeatedInThisFrame() {
    result = []
    for slot in ALL_ENTITY_SLOTS {
        address = EntityAddress(slot)
        array_push(result, prev(EntityActiveFlag(address)) == ENTITY_HIT && EntityActiveFlag(address) == ENTITY_INACTIVE)
    }
    return result
}

function PickedUpItemInThisFrame(itemType) {
    result = []
    for slot in ALL_ENTITY_SLOTS {
        address = EntityAddress(slot)
        type = EntityType(address)
        pickUpFlag = EntityPickUpFlag(address)
        
        itemPickedUp = itemType == type
        if (itemType == ENTITY_TYPE_ITEM_SPANKY_LETTER) {
            itemPickedUp = itemPickedUp && prev(pickUpFlag) == 0x01 && pickUpFlag == 0x02
        } else {
            itemPickedUp = itemPickedUp && prev(pickUpFlag) == 0x00 && pickUpFlag == 0x01
        }
        
        array_push(result, itemPickedUp)
    }
    return result
}

function CollectedSpankyLettersInOrder(priorLetters, currentLetters) => once(prev(CurrentSpankyLetters()) == priorLetters && CurrentSpankyLetters() == currentLetters)

function BeatFloorBossWithoutLosingALife(floorNumber) => ResetIfUsingInvincibilityCheat() &&
                                                         ResetIfLifeLost() &&
                                                         once(StartingStage() && CurrentFloorNumber() == floorNumber) &&
                                                         trigger_when(ClearedFloorOnThisFrame())
                                                         
function CompletedFloorsInSequence(floorStart, floorEnd) => once(StartingStage() && CurrentFloorNumber() == floorStart) &&
                                                            CurrentFloorNumber() == floorEnd &&
                                                            trigger_when(ClearedFloorOnThisFrame())

function ClearedTower(floorStart, floorEnd) => ResetIfUsingInvincibilityCheat() &&
                                               ResetIfLeftCurrentGameSession() &&
                                               CompletedFloorsInSequence(floorStart, floorEnd)
                                                           
function AcedTower(floorStart, floorEnd) => ResetIfLifeLost() &&
                                            ClearedTower(floorStart, floorEnd)



// ----------------------
// ---- Achievements ----
// ----------------------

achievement(
    title = "Tower 1 Clear", points = 3,
    description = "Start from stage 1-01 and sequentially clear all 15 stages and the boss fight of Tower 1",
    id = 382207, badge = "431738", published = "12/20/2023 2:17:20 AM", modified = "12/20/2023 2:17:20 AM",
    trigger = ClearedTower(0x00, 0x0F)
)

achievement(
    title = "Tower 2 Clear", points = 3,
    description = "Start from stage 2-01 and sequentially clear all 15 stages and the boss fight of Tower 2",
    id = 383097, badge = "431739", published = "12/24/2023 4:43:42 AM", modified = "12/24/2023 4:43:42 AM",
    trigger = ClearedTower(0x10, 0x1F)
)

achievement(
    title = "Tower 3 Clear", points = 3,
    description = "Start from stage 3-01 and sequentially clear all 15 stages and the boss fight of Tower 3",
    id = 383098, badge = "431740", published = "12/24/2023 4:44:10 AM", modified = "12/24/2023 4:44:10 AM",
    trigger = ClearedTower(0x20, 0x2F)
)

achievement(
    title = "Tower 4 Clear", points = 3,
    description = "Start from stage 4-01 and sequentially clear all 15 stages and the boss fight of Tower 4",
    id = 383099, badge = "431741", published = "12/24/2023 4:44:22 AM", modified = "12/24/2023 4:44:22 AM",
    trigger = ClearedTower(0x30, 0x3F)
)

achievement(
    title = "Morticia Appears", points = 5,
    description = "Reveal the crow's true identity",
    id = 384921, badge = "433786",
    trigger = InGame() && NotUsingInvincibilityCheat() && CurrentFloorNumber() == 0x44 && prev(BossHealth()) > 0x00 && BossHealth() == 0x00
)

achievement(
    title = "Savior of Mopoland", points = 25,
    description = "Start from stage 5-01 and sequentially clear all 5 stages of Tower 5",
    id = 383100, badge = "431742", published = "12/24/2023 4:44:32 AM", modified = "12/24/2023 4:44:32 AM",
    trigger = ResetIfUsingInvincibilityCheat() && ResetIfLeftCurrentGameSession() && CompletedFloorsInSequence(0x40, 0x44)
)

achievement(
    title = "Tower 1 Stage Master", points = 10,
    description = "Start from stage 1-01 and sequentially clear 15 stages of Tower 1 without losing a life",
    id = 384106, badge = "432825",
    trigger = AcedTower(0x00, 0x0F)
)

achievement(
    title = "Sluggo the Pineapple Pulverized", points = 5,
    description = "Defeat Sluggo The Pineapple in Tower 1 without losing a life during the fight",
    id = 380916, badge = "431746", published = "12/17/2023 1:43:07 AM", modified = "12/17/2023 1:43:07 AM",
    trigger = BeatFloorBossWithoutLosingALife(0x0F)
)

achievement(
    title = "Tower 2 Stage Master", points = 10,
    description = "Start from stage 2-01 and sequentially clear 15 stages of Tower 2 without losing a life",
    id = 384107, badge = "432826",
    trigger = AcedTower(0x10, 0x1F)
)

achievement(
    title = "Pippi the Peach Pinched", points = 5,
    description = "Defeat Pippi The Peach in Tower 2 without losing a life during the fight",
    id = 383156, badge = "431747", published = "12/24/2023 6:53:58 PM", modified = "12/24/2023 6:53:58 PM",
    trigger = BeatFloorBossWithoutLosingALife(0x1F)
)

achievement(
    title = "Tower 3 Stage Master", points = 10,
    description = "Start from stage 3-01 and sequentially clear 15 stages of Tower 3 without losing a life",
    id = 384108, badge = "432827",
    trigger = AcedTower(0x20, 0x2F)
)

achievement(
    title = "Fatso the Watermelon Wiped Out", points = 5,
    description = "Defeat Fatso The Watermelon in Tower 3 without losing a life during the fight",
    id = 383157, badge = "431748", published = "12/24/2023 7:17:05 PM", modified = "12/24/2023 7:17:05 PM",
    trigger = BeatFloorBossWithoutLosingALife(0x2F)
)

achievement(
    title = "Tower 4 Aced", points = 10,
    description = "Start from stage 4-01 and sequentially clear 15 stages of Tower 4 without losing a life",
    id = 384109, badge = "432828",
    trigger = AcedTower(0x30, 0x3F)
)

achievement(
    title = "Vito Mascutone the Grapes Got Grinded", points = 5,
    description = "Defeat Vito Mascutone in Tower 4 without losing a life during the fight",
    id = 383158, badge = "431749", published = "12/24/2023 7:31:59 PM", modified = "12/24/2023 7:31:59 PM",
    trigger = BeatFloorBossWithoutLosingALife(0x3F)
)

achievement(
    title = "Ultimate Boss Rush", points = 25,
    description = "Start from stage 5-01 and sequentially clear all 5 stages of Tower 5 without losing a life",
    id = 383159, badge = "431750", published = "12/24/2023 7:53:40 PM", modified = "12/24/2023 7:53:40 PM",
    trigger = ResetIfUsingInvincibilityCheat() && ResetIfLeftCurrentGameSession() && ResetIfLifeLost() && once(CurrentFloorNumber() == 0x40) &&
              trigger_when(CurrentFloorNumber() == 0x44 && ClearedFloorOnThisFrame())
)

achievement(
    title = "Attack Aficionado", points = 3,
    description = "In a single stage, execute all 4 different types of basic attacks",
    id = 383232, badge = "431889", published = "12/26/2023 3:33:13 AM", modified = "12/26/2023 3:33:13 AM",
    trigger = InGame() && ResetIfUsingInvincibilityCheat() && ResetIfFloorChanged() &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() >= 0x01 && CurrentBubbleSize() <= 0x02) &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() >= 0x03 && CurrentBubbleSize() <= 0x04) &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() >= 0x05 && CurrentBubbleSize() <= 0x06) &&
              once(AttackExecutedOnThisFrame() && CurrentBubbleSize() == 0x07)
)

achievement(
    title = "Efficient Execution", points = 5,
    description = "Defeat at least 6 enemies with a single attack (excludes use of attack power-up item)",
    id = 384101, badge = "432821",
    trigger = ResetIfUsingInvincibilityCheat() && ResetIfNotInGame() && never(HasAttackPowerUp()) && never(AttackExecutedFlag() == 0x00) && never(CurrentSpankyLetters() == ALL_SPANKY_LETTERS) &&
              tally(6, EnemiesDefeatedInThisFrame())
)

achievement(
    title = "Close Call", points = 10,
    description = "Clear a stage while being chased by the crow",
    id = 383231, badge = "431888", published = "12/26/2023 3:29:54 AM", modified = "12/26/2023 3:29:54 AM",
    trigger = InGame() && NotUsingInvincibilityCheat() && CrowTimer() == CROW_FLAG && trigger_when(ClearedFloorOnThisFrame())
)

achievement(
    title = "SPANKY", points = 5,
    description = "Collect the letters needed to spell SPANKY (or MONKEY) and enter the Bonus Stage",
    id = 379666, badge = "431745", published = "12/12/2023 12:03:14 AM", modified = "12/12/2023 12:03:14 AM",
    trigger = NotUsingInvincibilityCheat() && prev(CurrentFloorNumber()) == 0x45 && prev(EnterBonusStageFlag()) == 0x01 && EnterBonusStageFlag() == 0x00
)

achievement(
    title = "Super 1-UP Bonus", points = 10,
    description = "Collect the letters needed to spell SPANKY (or MONKEY) in order and recieve the Super 1-UP Bonus",
    id = 384905, badge = "433769",
    trigger = InGame() && ResetIfUsingInvincibilityCheat() && never(CurrentSpankyLetters() == 0x00) &&
              CollectedSpankyLettersInOrder(0x00, SPANKY_LETTERS_S) &&
              CollectedSpankyLettersInOrder(SPANKY_LETTERS_S, SPANKY_LETTERS_SP) &&
              CollectedSpankyLettersInOrder(SPANKY_LETTERS_SP, SPANKY_LETTERS_SPA) &&
              CollectedSpankyLettersInOrder(SPANKY_LETTERS_SPA, SPANKY_LETTERS_SPAN) &&
              CollectedSpankyLettersInOrder(SPANKY_LETTERS_SPAN, SPANKY_LETTERS_SPANK) &&
              trigger_when(CollectedSpankyLettersInOrder(SPANKY_LETTERS_SPANK, ALL_SPANKY_LETTERS))
)

achievement(
    title = "Perfect Bonus", points = 5,
    description = "Pop the bubble in the Bonus Stage by hitting it 8 times",
    id = 383233, badge = "431890", published = "12/26/2023 3:43:20 AM", modified = "12/26/2023 3:43:20 AM",
    trigger = InBonusStage() && NotUsingInvincibilityCheat() && trigger_when(prev(BonusBubbleCounter()) == 0x07 && BonusBubbleCounter() == 0x08)
)

achievement(
    title = "Bonus Points Galore", points = 5,
    description = "Collect 30 bonus point items in a single game before losing all lives or clearing the final tower (excludes Bonus Stage and Boss item drops)",
    id = 384922, badge = "433788",
    trigger = ResetIfUsingInvincibilityCheat() && never(ScreenID() == SCREEN_ID_GAME_OVER) && measured(tally(30, PickedUpItemInThisFrame(ENTITY_TYPE_ITEM_BONUS_POINTS)), Lives() > 0)
)

achievement(
    title = "Power-Up Pills", points = 3,
    description = "Collect an attack power-up",
    id = 384846, badge = "433757",
    trigger = InGame() && ResetIfUsingInvincibilityCheat() && tally(1, PickedUpItemInThisFrame(ENTITY_TYPE_ITEM_POWER_UP))
)

achievement(
    title = "1-UP Monkey", points = 3,
    description = "Collect an extra life item",
    id = 384857, badge = "433768",
    trigger = InGame() && ResetIfUsingInvincibilityCheat() && tally(1, PickedUpItemInThisFrame(ENTITY_TYPE_ITEM_EXTRA_LIFE))
)

achievement(
    title = "So Many Monkeys", points = 5,
    description = "Accumulate a total of 5 lives",
    id = 383234, badge = "431891", published = "12/26/2023 3:45:47 AM", modified = "12/26/2023 3:45:47 AM",
    trigger = InGame() && NotUsingInvincibilityCheat() && prev(Lives()) == 0x04 && Lives() == 0x05
)

achievement(
    title = "Monkey in Training", points = 5,
    description = "Score over 50,000 points in a single game before losing all lives or clearing the final tower",
    id = 384843, badge = "433754",
    trigger = SurpassedScore(50000)
    
)

achievement(
    title = "Monkey of Mastery", points = 10,
    description = "Score over 200,000 points in a single game before losing all lives or clearing the final tower",
    id = 384844, badge = "433755",
    trigger = SurpassedScore(200000)
)

achievement(
    title = "Monkey of Legend", points = 25,
    description = "Score over 400,000 points in a single game before losing all lives or clearing the final tower",
    id = 384845, badge = "433756",
    trigger = SurpassedScore(400000)
)

achievement(
    title = "Anywhere Anytime", points = 0,
    description = "Enter the Stage Select password",
    id = 383235, badge = "431892", published = "12/26/2023 3:56:14 AM", modified = "12/26/2023 3:56:14 AM",
    trigger = prev(ScreenID()) == SCREEN_ID_MAIN_MENU && ScreenID() == SCREEN_ID_STAGE_SELECT
)

achievement(
    title = "8-Bit Beats", points = 0,
    description = "Enter the Sound Test password",
    id = 383236, badge = "431893", published = "12/26/2023 4:09:00 AM", modified = "12/26/2023 4:09:00 AM",
    trigger = prev(ScreenID()) == SCREEN_ID_MAIN_MENU && ScreenID() == SCREEN_ID_SOUND_TEST
)


// ----------------------
// ---- Leaderboards ----
// ----------------------

leaderboard(
    id = 85012,
    title = "Top Score (no cheats)",
    description = "Highest score achieved in a game before losing all lives or clearing the final tower",
    start = NotUsingInvincibilityCheat() && prev(ScreenID()) != SCREEN_ID_GAME_OVER && ScreenID() == SCREEN_ID_GAME_OVER,
    cancel = ScreenID() == SCREEN_ID_MAIN_MENU,
    submit = prev(ScreenID()) != SCREEN_ID_GAME_OVER && ScreenID() == SCREEN_ID_GAME_OVER,
    value = GetCurrentScore(),
    format="VALUE",
    lower_is_better=false
)


// ---------------------
// --- Rich Presence ---
// ---------------------

FloorLookup = {
    0: "1-01",
    1: "1-02",
    2: "1-03",
    3: "1-04",
    4: "1-05",
    5: "1-06",
    6: "1-07",
    7: "1-08",
    8: "1-09",
    9: "1-10",
    10: "1-11",
    11: "1-12",
    12: "1-13",
    13: "1-14",
    14: "1-15",
    15: "1-16 🍍",
    16: "2-01",
    17: "2-02",
    18: "2-03",
    19: "2-04",
    20: "2-05",
    21: "2-06",
    22: "2-07",
    23: "2-08",
    24: "2-09",
    25: "2-10",
    26: "2-11",
    27: "2-12",
    28: "2-13",
    29: "2-14",
    30: "2-15",
    31: "2-16 🍑",
    32: "3-01",
    33: "3-02",
    34: "3-03",
    35: "3-04",
    36: "3-05",
    37: "3-06",
    38: "3-07",
    39: "3-08",
    40: "3-09",
    41: "3-10",
    42: "3-11",
    43: "3-12",
    44: "3-13",
    45: "3-14",
    46: "3-15",
    47: "3-16 🍉",
    48: "4-01",
    49: "4-02",
    50: "4-03",
    51: "4-04",
    52: "4-05",
    53: "4-06",
    54: "4-07",
    55: "4-08",
    56: "4-09",
    57: "4-10",
    58: "4-11",
    59: "4-12",
    60: "4-13",
    61: "4-14",
    62: "4-15",
    63: "4-16 🍇",
    64: "5-01 🍍",
    65: "5-02 🍑",
    66: "5-03 🍉",
    67: "5-04 🍇",
    68: "5-05 🐦✨"
}

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

rich_presence_conditional_display(!InGame(), "In Menus • {0}0 {1} 🐵{2}",
    rich_presence_value("Score", GetCurrentScore() / 10, format="SCORE"),
    rich_presence_lookup("SPANKY", CurrentSpankyLetters(), SPANKYLookup, fallback=" ––––––"),
    rich_presence_value("Number", Lives())
)

rich_presence_conditional_display(prior(CurrentFloorNumber()) == 0x45, "Bonus Stage • {0}0 {1} 🐵{2}",
    rich_presence_value("Score", GetCurrentScore() / 10, format="SCORE"),
    rich_presence_lookup("SPANKY", CurrentSpankyLetters(), SPANKYLookup, fallback=" ––––––"),
    rich_presence_value("Number", Lives())
)

rich_presence_display("🏰{0} • {1}0 {2} 🐵{3}",
    rich_presence_lookup("Floor", CurrentFloorNumber(), FloorLookup, fallback="?-??"),
    rich_presence_value("Score", GetCurrentScore() / 10, format="SCORE"),
    rich_presence_lookup("SPANKY", CurrentSpankyLetters(), SPANKYLookup, fallback=" ––––––"),
    rich_presence_value("Number", Lives())
)