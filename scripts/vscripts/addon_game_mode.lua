
if my_game == nil then
    _G.my_game = class({})
end

-- on both server and client
require("util/safeguards")



require("events_protector")
if IsClient() then
    require("function_client")
end


_G.PlayerCount = 0

_G.teleports = {}
_G.waves = {}
_G.boss_waves = {}
_G.players = {}
_G.towers = {}
_G.timer = 0
_G.Deaths = 0

Rating_Table = {40,30,10,-10,-30,-40}
Rating_Table_Max = {20,15,5,-5,-15,-20}

_G.Wave_boss_number = {5,22}
_G.Purple_Wave = {3,10}
_G.upgrade_orange = 18

_G.Deaths_Players = {}
_G.End_net = {}

_G.Time_to_pick_Hero = 25
_G.Time_to_pick_Base = 15

_G.game_start = false
_G.Game_end = false
	
_G.duel_prepair = false
_G.duel_in_progress = false
_G.init_duel = false
_G.new_round = false

_G.Duel_Hero = {}
_G.duel_start = 5
_G.duel_timer = 90
_G.round_timer = 5
_G.duel_timer_progress = 60 + duel_start
_G.field_stun = 0.5
_G.wins_for_win = 2
_G.field = 0

_G.Duel_round = 0

_G.wall_particle = {}

_G.Target_start = 660
_G.Target_end = 1380
_G.Target_cooldown = 300
_G.Target_count = 0
_G.Target_duration = 210
_G.Target_gold = 1.2
_G.Target_gold_min = 2000
_G.Target_current_active = false 
_G.Target_current_cooldown = false
_G.Target_current_cooldown_time = 0


_G.Active_Roshan = false
_G.RoshanTimers = {1260,1800,2400,3000,3600,4200,4800,5400,6000,6600,7200,7800,8400,9000,9600,10200,10800,11400,12000,12600,13200,13800,14400,15000,15600,16200,16800,17400,18000,18600,19200,19800,20400,21000,21600,22200,22800,23400,24000,24600,25200,25800,26400,27000,27600,28200,28800,29400,30000,30600,31200,31800,32400,33000,33600,34200,34800,35400,36000,36600,37200,37800,38400,39000,39600,40200,40800,41400,42000,42600,43200,43800,44400,45000,45600,46200,46800,47400,48000,48600,49200,49800,50400,51000,51600,52200,52800,53400,54000,54600,55200,55800,56400,57000,57600,58200,58800,59400,60000,60600,61200}
_G.roshan_number = 1
_G.roshan_timer = 1
_G.roshan_alert = 60



_G.patrol_timer = 0
_G.patrol_timer_max = 45
_G.patrol_wave = 5
_G.patrol_second_tier = 1535
_G.patrol_first_tier = 350
_G.patrol_second_init = false 
_G.patrol_first_init = false
my_game.patrol_dontgo_radiant = false
my_game.patrol_dontgo_dire = false
my_game.ravager_table = {}
my_game.ravager_max = 12

_G.give_all_vision_time = 1500
_G.init_vision = false

_G.avg_rating = 0
_G.lobby_rating = {}
_G.lobby_rating_change = {}
_G.lobby_double_rating = {}

_G.Observer_max = 4
_G.Observer_cd = 180
_G.Observer_duration = 480

_G.DeathTimer = 2
_G.StartDeathTimer = 10
_G.DeathTimer_PerWave = 1.8
_G.Short_Respawn = 5
_G.Short_Respawn_target = 10

_G.lownet_gold = 1
_G.lownet_purple = 2
_G.lownet_blue = 2
_G.lownet_duration = 180

_G.Streak_res = 0
_G.Streak_gold = 400
_G.Streak_k = 0.3
_G.Kills_to_streak = 3

_G.teleport_cd = 20
_G.teleport_range = 350

_G.UpgradeGray = 0.2
_G.BlueMorePoints = 0.25

_G.GoldComeback = 2
_G.MaxTimer = 0

_G.StartPurple = 2
_G.PlusPurple = 1

_G.auto_pick_talent = 60

_G.low_net_gold = {500, 750, 1000}
_G.low_net_current = 0
_G.low_net_waves = {[RandomInt(8, 10)] = true, [RandomInt(11, 13)] = true, [RandomInt(14, 16)] = true,}
_G.low_net_diff = 0

_G.StartBlue = 60
_G.PlusBlue = 15

_G.Necro_Timer = 20

_G.PortalDelay = 5
_G.NeutralChance = 12
_G.MaxNeutral = 4

_G.dont_end_pick_hero = false

_G.dont_end_game = false

_G.test = false -- КЛЮЧ
_G.tower = false
_G.healing = true

_G.enable_pause = false

_G.start_wave = 0
_G.timer_test = 10111
_G.timer_test_start = 10111
_G.test_wave = 0

_G.push_timer =  900

_G.DontUpgradeCreeps = false

_G.Pause_Time = 30

_G.Trap_Duration = 30

_G.ValidGame_Time = 900

_G.kill_net_gold = 250
_G.more_gold_radius = 700

_G.bounty_timer = 0
_G.bounty_max_timer = 120
_G.bounty_init = false 
_G.bounty_start = 240
_G.bounty_gold_init = 120
_G.bounty_gold_per_minute = 5
_G.bounty_blue_init = 20
_G.bounty_blue_per_minute = 0.7

_G.Grenade_Creeps_Max = 6
_G.Grenade_Max = 4
_G.Grenade_Timer = 1200
_G.Grenade_start = false

_G.Player_damage_max = 40
_G.Player_damage_inc = 10
_G.Player_damage_time = 900

_G.LowPriorityTime = 900
_G.SafeToLeave = false
_G.SafeToLeave_reason = 0
_G.SafeToLeave_alert = false
_G.SafeLeaveTime = 300

_G.DoubleRating_timer = 25
_G.DoubleRating_active = true

_G.PartyTable = {}

_G.After_Lich = false

_G.ACT_DOTA_SPAWN_STATUE = ACT_DOTA_SPAWN_STATUE or 1766

_G.No_end_screen = {}


_G.RATING_CHANGE_BASE = { 40, 30, 10, -10, -30, -40,}

_G.glyph_cd = 360
_G.glyph_duration = 5

_G.sub_places_points = {14,12,10,8,6,4}
_G.sub_random_inc = 1.15
_G.sub_kills_inc = 1
_G.sub_kills_max = 10
_G.sub_towers_inc = 4
_G.sub_bounty_inc = 0.5
_G.sub_bounty_max = 10
_G.sub_points_max = 500
_G.sub_level_thresh =  {50,60,70,80, 100,120,140,160,180,200, 230,260,290,320,350,380, 420,460,500,540,580,620,680, 800,900,1000,1100,1200, 1500}
_G.sub_place_exp = {40,30,25,20,15,10}
_G.sub_level_max = 30
_G.level_thresh = {6,12,18,25,30}


_G.shop_daily_shards_min = 10
_G.shop_daily_shards_max = 30
_G.shop_daily_shards_cd = 86400
_G.shop_double_rating_cd = 86400 * 3
_G.shop_free_vote_cd = 86400
_G.shop_quests_cd = 86400 * 7




_G.abandon_players = {}

_G.wrong_map_players = {}

_G.damage_table = {}


function RegisterAnimations()
    local function Reg(hname)
        RegisterCustomAnimationScriptForModel(
            string.format("models/heroes/%s/%s.vmdl", hname, hname),
            string.format("animation/%s.lua", hname)
        )
    end

end





_G.rating_thresh =
{
	["ranked_0-500_start"] =
	{
		['min'] = 0,
		['max'] = 500,
	},
	["ranked_500-1000"] = 
	{
		['min'] = 500,
		['max'] = 1000,
	},
	["ranked_1000-x"] = 
	{
		['min'] = 1000,
		['max'] = 99999,
	},
}

_G.ranked_tier =
{
	0,150,300,500,750,1000,1300,9999999
}


local vision_abs = 
{
	{},
	{-6397,-6454,87,800,-7146,-7179,95,1000},
	{6599,6542,95,800,7371,7247,103,1000},
	{},
	{},
	{-6299,2554,103,800,-6263,3740,95,800},
	{2638,-6457,95,800,3824,-6486,103,800},
	{-2388,6400,103,800,-3574,6389,95,800},
	{6526,-2523,95,800,6529,-3710,103,800},

}
local bounty_abs = 
{
	Vector(-2322.87, -2748.66,260),
	Vector(-1965,-6816,390),
	Vector(-6385,-2489,390),
	Vector(2608.1, 2711.76,260),
	Vector(2345, 6731,390),
	Vector(7071,2385,390),
	Vector (43.8384, 139.514, 410),
	Vector(3072.38, -2833.06, 130),
	Vector(-2810.7, 2842.04, 130),




}







_G.UnvalidAbilities = 
{
	["mid_teleport"] = true,
	["custom_ability_observer"] = true,
	["custom_ability_sentry"] = true,
	["custom_ability_smoke"] = true,
	["custom_ability_dust"] = true,
	["custom_ability_grenade"] = true
}

_G.UnvalidItems = 
{
	["item_soul_ring"] = true,
	["item_bracer_custom"] = true,
	["item_wraith_band_custom"] = true,
	["item_null_talisman_custom"] = true,
	["item_power_treads"] = true,
	["item_phase_boots"] = true,
	["item_branches"] = true,
	["item_quelling_blade"] = true,
	["item_radiance_custom"] = true,
	["item_bfury"] = true,
	["item_vambrace"] = true,	
	["item_havoc_hammer"] = true,
}




_G.all_heroes = 
{
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_huskar",
	"npc_dota_hero_nevermore",
	"npc_dota_hero_queenofpain",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_puck",
	"npc_dota_hero_void_spirit",
	"npc_dota_hero_ember_spirit",
	"npc_dota_hero_pudge",
	"npc_dota_hero_hoodwink",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_lina",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_axe",
	"npc_dota_hero_alchemist",
	"npc_dota_hero_ogre_magi",
	"npc_dota_hero_antimage",
	"npc_dota_hero_primal_beast",
	"npc_dota_hero_marci",
	"npc_dota_hero_templar_assassin",
	"npc_dota_hero_bloodseeker",
	"npc_dota_hero_monkey_king",
	"npc_dota_hero_mars",
	"npc_dota_hero_zuus",
	"npc_dota_hero_leshrac",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_snapfire",
	"npc_dota_hero_sven",
	"npc_dota_hero_sniper"

}

require( 'chat_wheel')
require( 'resources')
require( 'server')
require( 'function')
require( 'addon_init')
require( 'timers')
require( 'spawn' )
require( 'upgrade')
require( 'debug_')
require( 'hero_select')
require( 'vector_target')
require( 'patrol_main')
require( 'shop')



function Precache( context )
local heroes = LoadKeyValues("scripts/npc/dota_heroes.txt")
for k,v in pairs(heroes) do
          PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_" .. k:gsub('npc_dota_hero_','') ..".vsndevts", context )  
          PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_" .. k:gsub('npc_dota_hero_','') ..".vsndevts", context ) 
end



for _,k in pairs(my_game.heroes_particles) do
	PrecacheResource( "particle_folder", "particles/units/heroes/" .. k, context )
end

for _,k in pairs(my_game.heroes_items_particles) do
	PrecacheResource( "particle_folder", "particles/econ/items/" .. k, context ) 
end



for _,v in pairs(my_game.Particles) do
	PrecacheResource( "particle", v, context )
end


PrecacheResource( "model", "custom/item_blue.vmdl", context )  
PrecacheResource( "model", "custom/item_orange.vmdl", context )     
PrecacheResource( "model", "custom/item_gray.vmdl", context )          
PrecacheResource( "model", "custom/item_purple.vmdl", context )   
PrecacheResource( "model", "models/heroes/terrorblade/demon.vmdl", context ) 

local mobs = LoadKeyValues("scripts/npc/npc_units_custom.txt")
for k,v in pairs(mobs) do
  PrecacheUnitByNameAsync(k, function(...) end)

end

local items = LoadKeyValues("scripts/npc/npc_items_custom.txt")
for k,v in pairs(items) do
  PrecacheItemByNameAsync(k, function(...) end)

end

--local mobs = LoadKeyValues("scripts/npc/npc_units_custom.txt")
--for k,v in pairs(mobs) do
 -- PrecacheUnitByNameSync(k, context, nil )

--end

--local items = LoadKeyValues("scripts/npc/npc_items_custom.txt")
--for k,v in pairs(items) do
--  PrecacheItemByNameSync(k, context)

--end


 PrecacheResource( "soundfile", "endsoundevents/game_sounds.vsndevts", context )
 PrecacheResource( "soundfile", "soundevents/soundevents_dota.vsndevts", context )
 PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer.vsndevts", context )
 PrecacheResource( "soundfile", "soundevents/game_sounds_effects.vsndevts", context ) 
 PrecacheResource( "soundfile", "soundevents/game_sounds_ui_imported.vsndevts", context ) 
     
end


-- Create the game mode when we activate
function Activate()
	my_game:InitGameMode()
	HTTP.FillOfflineServerData()
end

function shuffle(x)
    for i = #x, 2, -1 do
        local j = math.random(i)
        x[i], x[j] = x[j], x[i]
    end
end

local AvailableTeams = {
    DOTA_TEAM_GOODGUYS,
    DOTA_TEAM_BADGUYS,
    DOTA_TEAM_CUSTOM_1,
    DOTA_TEAM_CUSTOM_2,
    DOTA_TEAM_CUSTOM_3,
    DOTA_TEAM_CUSTOM_4,
}

local team_size = 1





function my_game:PostMatchPoints(player)
if not IsServer() then return end
if not HTTP.IsValidGame(PlayerCount) then return end


local id = player:GetPlayerOwnerID()
local player_array = players[player:GetTeamNumber()]

if not player_array then return end

local kills = player_array.kills_done
local towers = player_array.towers_destroyed
local runes = player_array.bounty_runes_picked

local place = HTTP.playersData[id].place
local table_data = CustomNetTables:GetTableValue("sub_data", tostring(id))

local quest_shards = 0
local quest_exp = 0

if (player:GetQuest() ~= nil) and player:QuestCompleted() and place < 4 then 
	quest_exp = player.quest.exp and player.quest.exp or 0
	quest_shards = player.quest.shards and player.quest.shards or 0
end



local random_k = 1
if player_array.randomed == 1 then 
	random_k = sub_random_inc
end




local points =  math.min(kills*sub_kills_inc, sub_kills_max) + sub_places_points[place] + towers*sub_towers_inc + math.floor(math.min(runes*sub_bounty_inc, sub_bounty_max))

points = math.floor(points * random_k)

if table_data.subscribed == 0 then 
	points = math.min(math.max(sub_points_max - table_data.points, 0), points)
end

if GameRules:GetDOTATime(false, false) < push_timer then 
	points = 0
end



HTTP.AddPlayerMatchShardsReceipt( id, points, 'endGame')
HTTP.AddPlayerMatchShardsReceipt( id, quest_shards, 'questCompleted')

points = points + quest_shards


table_data.points = table_data.points + points


local level = table_data.heroes_data[player:GetUnitName()].level
local exp = table_data.heroes_data[player:GetUnitName()].exp


if table_data.subscribed == 1 and level < sub_level_max then 

	local max_exp = sub_level_thresh[level]
	local exp_inc = math.floor(sub_place_exp[place]*random_k)

	if GameRules:GetDOTATime(false, false) < push_timer then 
		exp_inc = 0
	end

	HTTP.playersData[id].dpHeroMatchXp = exp_inc
	HTTP.playersData[id].dpHeroQuestXp = quest_exp

	exp_inc = exp_inc + quest_exp


	local exp_left = exp_inc

	repeat 
		
		if (level < 30) then 

			max_exp = sub_level_thresh[level]

			if (exp_left >= (max_exp - exp)) then 
			
				exp_left = exp_left -(max_exp - exp)
				level = level + 1
				exp = 0
			else 
		
				exp = exp + exp_left
				exp_left = 0
			end
		else 
		
			exp_left = 0
			exp = 0
		end

	until exp_left < 1


	table_data.heroes_data[player:GetUnitName()].exp = exp 
	table_data.heroes_data[player:GetUnitName()].level = level
end


CustomNetTables:SetTableValue("sub_data", tostring(id), table_data)

end





function my_game:ChangeGrenadeCount(unit, count)
if not IsServer() then return end
if true then return end

local player = players[unit:GetTeamNumber()]

if not player then return end

if count < 0 then 
	player.grenade_count = math.max(0, player.grenade_count - 1)
else 

	if player.grenade_count < Grenade_Max then
		player.grenade_count = player.grenade_count + 1

 		local item = CreateItem("item_patrol_grenade", unit, unit)

 		if unit:GetNumItemsInInventory() < 10 then
            unit:AddItem(item)
		else
		    CreateItemOnPositionSync(GetGroundPosition(unit:GetAbsOrigin(),  unit), item)
		end
	end
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(unit:GetPlayerOwnerID()), 'grenade_count_change',  {count = player.grenade_count, max = Grenade_Max, inc = count})
	
end

function my_game:InitGameMode()
	GameRules:SetCustomGameSetupAutoLaunchDelay(0)

    hero_select:RegisterHeroes()
    upgrade:InitGameMode()
    ListenToGameEvent("player_connect_full", Dynamic_Wrap(hero_select, "PlayerConnected"), hero_select)


	for _, team in pairs(AvailableTeams) do
        GameRules:SetCustomGameTeamMaxPlayers(team, team_size)
    end


    GameRules:SetSafeToLeave(true)

    GameRules:GetGameModeEntity():SetPauseEnabled( false )

    GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( my_game, "ExecuteOrderFilterCustom" ), self )


    --if test then 
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0 )


  	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
	GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath( false )
    GameRules:SetPreGameTime( 1 )
    GameRules:GetGameModeEntity():SetDaynightCycleDisabled( false )
	GameRules:SetTimeOfDay(0.7)
	GameRules:SetCustomGameEndDelay( 3 )
	GameRules:SetCustomVictoryMessageDuration(120)
	GameRules:SetPostGameTime(120)
	GameRules:SetTreeRegrowTime(4)

	--GameRules:GetGameModeEntity():SetCustomBuybackCooldownEnabled(true)
	GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled(true)



	GameRules:GetGameModeEntity():SetCustomBackpackCooldownPercent(1)

	GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_tpscroll_custom")

	GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )

	GameRules:GetGameModeEntity():SetCustomGlyphCooldown(300)
    GameRules:SetUseUniversalShopMode( true )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( my_game, "DamageFilter" ), self )
	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( my_game, "HealingFilter" ), self )
	
	--GameRules:GetGameModeEntity():SetUseTurboCouriers(true)

	CustomGameEventManager:RegisterListener( "ChangeTipsType", Dynamic_Wrap(self, 'ChangeTipsType'))

	CustomGameEventManager:RegisterListener( "SelectVO", Dynamic_Wrap(chat_wheel, 'SelectVO'))
	CustomGameEventManager:RegisterListener( "SelectHeroVO", Dynamic_Wrap(chat_wheel, 'SelectHeroVO'))
	CustomGameEventManager:RegisterListener( "select_chatwheel_player", Dynamic_Wrap(chat_wheel, 'SelectChatWheel'))

    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( self, 'OnGameRulesStateChange' ), self )
    ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(self, 'OnPlayerLevelUp'), self)
    ListenToGameEvent( "dota_glyph_used", Dynamic_Wrap( self, 'OnGlyphUsed' ), self )


    ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( self, "OnItemPickUp"), self )

	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( self, "BountyRunePickupFilter" ), self )

    CustomGameEventManager:RegisterListener( "GiveGlobalVision", Dynamic_Wrap(self, 'GiveGlobalVision'))


    CustomGameEventManager:RegisterListener( "send_report", Dynamic_Wrap(self, 'send_report'))

    CustomGameEventManager:RegisterListener( "DoubleRating", Dynamic_Wrap(self, 'DoubleRating'))

    CustomGameEventManager:RegisterListener( "request_key", Dynamic_Wrap(self, 'show_key'))
	CustomGameEventManager:RegisterListener( "shop_buy_item_player", Dynamic_Wrap(shop, 'shop_buy_item_player'))

	CustomGameEventManager:RegisterListener( "heroes_vote_change", Dynamic_Wrap(shop, 'heroes_vote_change'))
	CustomGameEventManager:RegisterListener( "heroes_vote_free", Dynamic_Wrap(shop, 'heroes_vote_free'))
	CustomGameEventManager:RegisterListener( "get_bonus_shards", Dynamic_Wrap(shop, 'get_bonus_shards'))

	CustomGameEventManager:RegisterListener( "browser_subscribe", Dynamic_Wrap(shop, 'browser_subscribe'))

   -- GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(self, "GoldFilter"), self)
   
	CustomGameEventManager:RegisterListener( "player_change_keybind", Dynamic_Wrap(self, 'player_change_keybind'))
	
	CustomGameEventManager:RegisterListener( "change_premium_pet", Dynamic_Wrap(shop, "ChangePetPremium"))

	CustomGameEventManager:RegisterListener( "change_show_tier", Dynamic_Wrap(shop, "ChangeShowTier"))
      
	CustomGameEventManager:RegisterListener( "end_choise_js", Dynamic_Wrap(upgrade, "EndChoiseJs"))

	CustomGameEventManager:RegisterListener( "ChangePickOrbs", Dynamic_Wrap(self, "ChangePickOrbs"))


	CustomGameEventManager:RegisterListener( "DoubleRating_show_change", Dynamic_Wrap(self, "DoubleRating_show_change"))


	CustomGameEventManager:RegisterListener( "SelectQuest", Dynamic_Wrap(shop, "SelectQuest"))

	CustomGameEventManager:RegisterListener( "check_id", Dynamic_Wrap(self, 'check_id'))
end

function my_game:check_id(kv)

	print(kv.PlayerID)

	print(PlayerResource:GetSteamAccountID(kv.PlayerID))
end



function my_game:DoubleRating_show_change(data)
if data.PlayerID == nil then return end


local player = players[PlayerResource:GetSelectedHeroEntity(data.PlayerID):GetTeamNumber()]

if not player then return end

if player.HideDouble == 1 then 
	player.HideDouble = 0
else 
	player.HideDouble = 1
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), 'DoubleRating_show_change_js', {state = player.HideDouble} ) 
end





function my_game:DoubleRating(data)
if data.PlayerID == nil then return end

local player = players[PlayerResource:GetSelectedHeroEntity(data.PlayerID):GetTeamNumber()]

if not player then return end


local subData = CustomNetTables:GetTableValue("sub_data", tostring(data.PlayerID))

if subData.double_rating_cd > 0 then return end

subData.double_rating_cd = shop_double_rating_cd

HTTP.DoubleRating( data.PlayerID, subData.double_rating_cd * 1000 )


local unit =   PlayerResource:GetSelectedHeroEntity(data.PlayerID) 

lobby_double_rating[data.PlayerID] = true


if player.HideDouble == 0 then 
	CustomGameEventManager:Send_ServerToAllClients( 'double_rating_alert', {unit = unit:GetUnitName()} ) 
end


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), 'hide_double_rating', {} ) 

CustomNetTables:SetTableValue("sub_data", tostring(data.PlayerID), subData)
end



function my_game:player_change_keybind(data)
    if data.PlayerID == nil then return end
    local keybinds_table = CustomNetTables:GetTableValue("keybinds", tostring(data.PlayerID))
    if data.name == "cast_ability_sentry" then
        keybinds_table.keybind_sentry_ward = data.newKey
    elseif data.name == "cast_ability_observer" then
        keybinds_table.keybind_observer_ward = data.newKey
    elseif data.name == "cast_ability_smoke" then
        keybinds_table.keybind_smoke = data.newKey
    elseif data.name == "cast_ability_dust" then
        keybinds_table.keybind_dust = data.newKey
    elseif data.name == "cast_ability_grenade" then
        keybinds_table.keybind_grenade = data.newKey
    end
    CustomNetTables:SetTableValue("keybinds", tostring(data.PlayerID), keybinds_table)
end



function my_game:InitLowNet(unit)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(unit:GetPlayerOwnerID()), "lownet_bonus", {gold = low_net_gold[low_net_current]})

Timers:CreateTimer(1, function()

	my_game:AddPurplePoints(unit, 1)
	my_game:CreateUpgradeOrb(unit, 2)
	unit:ModifyGold(low_net_gold[low_net_current], true, DOTA_ModifyGold_Unspecified)
	SendOverheadEventMessage(unit, 0, unit, low_net_gold[low_net_current], nil)


end)

end





function my_game:show_key(data)
	if data.PlayerID == nil then return end
	local steamid = PlayerResource:GetSteamID(data.PlayerID)


	if tostring(steamid) == "76561198192555753" then 

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), 'print_debug',  {text = GetDedicatedServerKeyV2(data.fuck_cheaters)})
		
	end

end

 

function my_game:ChangeTipsType(data) 
	if data.PlayerID == nil then return end
	CustomNetTables:SetTableValue("TipsType", tostring(data.PlayerID), {type = data.type})
end




function my_game:BountyRunePickupFilter(params)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.player_id_const), 'delete_bounty',  {})
				
local unit = PlayerResource:GetSelectedHeroEntity(params.player_id_const)


local minute = math.floor(GameRules:GetDOTATime(false, false) / 60)
local gold = bounty_gold_init + minute * bounty_gold_per_minute
local blue = bounty_blue_init + minute * bounty_blue_per_minute


my_game:AddBluePoints(unit, blue)

if (players[unit:GetTeamNumber()]) then 
	players[unit:GetTeamNumber()].bounty_runes_picked = players[unit:GetTeamNumber()].bounty_runes_picked + 1
end

if (unit:GetQuest() == "General.Quest_6") then 
	unit:UpdateQuest(1)
end


if unit and unit:HasModifier("modifier_alchemist_goblins_greed_custom") then 
	local ability = unit:FindAbilityByName("alchemist_goblins_greed_custom")
	gold = gold*ability:GetSpecialValueFor("bounty_multiplier")

	if unit:HasModifier("modifier_alchemist_greed_5") then 
		local buf_table = {
			"modifier_alchemist_goblins_greed_custom_haste",
			"modifier_alchemist_goblins_greed_custom_dd",
			"modifier_alchemist_goblins_greed_custom_arcane",
			"modifier_alchemist_goblins_greed_custom_regen"
		}
		local name = buf_table[RandomInt(1, #buf_table)]

		unit:AddNewModifier(unit, ability, name, {duration = ability.rune_duration})

	end

	unit:AddNewModifier(unit, ability, "modifier_alchemist_goblins_greed_custom_runes", {})


end


params["gold_bounty"] = gold 

return true

end

function my_game:send_report(kv)
    if kv.PlayerID == nil then return end

    local reported1 = PlayerResource:GetSteamAccountID(kv.Hero_1)
    local reported2 = PlayerResource:GetSteamAccountID(kv.Hero_2)

    local targets = {tostring(reported1), tostring(reported2)}

    local reports = CustomNetTables:GetTableValue("reports", tostring(kv.PlayerID))
    if reports.report == 0 then
        return
    end

    CustomNetTables:SetTableValue("reports", tostring(kv.PlayerID), {
        report = reports.report - 1    
    })

    
    HTTP.Report( kv.PlayerID, kv.Hero_1,kv.Hero_2, 0)
end



function my_game:OnGlyphUsed( params )
	GameRules:SetGlyphCooldown( params.teamnumber, glyph_cd )

	if players[params.teamnumber] ~= nil then 
		CustomGameEventManager:Send_ServerToAllClients( 'glyph_used', {player = players[params.teamnumber]:GetUnitName()} )
	end

	local towers = FindUnitsInRadius( params.teamnumber, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
	for _,tower in pairs(towers) do

		if tower:FindModifierByName("modifier_fountain_glyph") then 
			tower:FindModifierByName("modifier_fountain_glyph"):SetDuration(glyph_duration, true)
		end
	end

end



function my_game:ChangePickOrbs( kv )
if kv.PlayerID == nil then return end

local player = players[PlayerResource:GetSelectedHeroEntity(kv.PlayerID):GetTeamNumber()]

if not player then return end

if player.PickOrbs == 1 then 
	player.PickOrbs = 0
else 
	player.PickOrbs = 1
end

CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(kv.PlayerID), "ChangePickOrbs_js", { pick = player.PickOrbs } )

end




LinkLuaModifier("modifier_tower_level", "modifiers/modifier_tower_level.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_on_respawn", "modifiers/modifier_on_respawn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death", "modifiers/modifier_death", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_final_duel", "modifiers/modifier_final_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_finish", "modifiers/modifier_duel_finish", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_roshan_upgrade", "modifiers/modifier_roshan_upgrade", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_player_damage", "modifiers/modifier_player_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bounty_map", "modifiers/modifier_bounty_map", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_aegis_custom", "modifiers/modifier_aegis_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_damage", "modifiers/modifier_tower_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_target", "modifiers/modifier_target", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_ravager", "modifiers/modifier_ravager", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_damage_final", "modifiers/modifier_duel_damage_final", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invun", "modifiers/modifier_invun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_no_vision", "modifiers/modifier_no_vision", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unselect", "modifiers/modifier_unselect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ward_stack", "modifiers/modifier_ward_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mob_thinker", "modifiers/modifier_mob_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_attack_speed", "modifiers/generic/modifier_generic_attack_speed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_armor_reduction", "modifiers/generic/modifier_generic_armor_reduction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silence", "modifiers/generic/modifier_generic_silence", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc", "modifiers/generic/modifier_generic_arc", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_movespeed", "modifiers/generic/modifier_generic_movespeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback", "modifiers/generic/modifier_generic_knockback", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_repair", "modifiers/generic/modifier_generic_repair", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_bkb", "modifiers/generic/modifier_generic_bkb", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_passing", "modifiers/generic/modifier_generic_passing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_no_cleave", "modifiers/generic/modifier_no_cleave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_quest_blink", "modifiers/modifier_mob_thinker", LUA_MODIFIER_MOTION_NONE )




LinkLuaModifier( "modifier_recipe_gold_assault", "upgrade/general/modifier_recipe_gold_assault", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_recipe_gold_bfury", "upgrade/general/modifier_recipe_gold_bfury", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_recipe_gold_daedalus", "upgrade/general/modifier_recipe_gold_daedalus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_recipe_gold_skadi", "upgrade/general/modifier_recipe_gold_skadi", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_recipe_gold_heart", "upgrade/general/modifier_recipe_gold_heart", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_recipe_gold_octarine", "upgrade/general/modifier_recipe_gold_octarine", LUA_MODIFIER_MOTION_NONE )

function my_game:CheckDisarm( unit )
if not IsServer() then return end



local mods = {
		"modifier_heavens_halberd_debuff",
		"modifier_ghost_state",
		"modifier_item_book_of_shadows_buff",
		"modifier_custom_huskar_inner_fire_disarm",
		"modifier_nevermore_requiem_fear",
		"modifier_custom_void_remnant_target"

}

--for _,i in ipairs(mod) do 
	--if unit:HasModifier(i) then 
		--return true
	--end
--end
  for _, mod in pairs(unit:FindAllModifiers()) do
        if mod:GetName() ~= "modifier_alchemist_chemical_rage_custom" then
           -- if mod.CheckState then
                local tables = {}
                mod:CheckStateToTable(tables)
                for state_name, mod_table in pairs(tables) do
                    if tostring(state_name) == '1'  then
                         return true
                    end
                end
            --end
        end
    end
return false
end





function my_game:BreakInvis( unit )
if not IsServer() then return end

local mod = {
		"modifier_item_trickster_cloak_invis",
		"modifier_invisible"

}

for _,i in ipairs(mod) do 
	if unit:HasModifier(i) then 
		unit:RemoveModifierByName(i)
	end
end

end







function my_game:OnPlayerLevelUp( param )
 


end

function my_game:GetUpgradeStack( player, mod )
	local modifier = player:FindModifierByName(mod)
	if modifier then
		return modifier:GetStackCount()
	else
	return 0
	end

end



function my_game:GenericHeal(target, heal, ability, no_text)
if not IsServer() then return end

target:Heal(heal, ability)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:ReleaseParticleIndex( particle )


if no_text and no_text == true then return end

SendOverheadEventMessage(target, 10, target, heal, nil)
end



function my_game:regaUpgradeIllusion(mod, stack, illusion , player )
if not IsServer() then return end
for _,mod in pairs(player:FindAllModifiers()) do

	if mod.StackOnIllusion ~= nil then 
	if mod.StackOnIllusion == true then


	end
end

end

end




function my_game:BluePoints( unit )
if not IsServer() then return end
name = unit:GetUnitName()




if name == "npc_dota_neutral_kobold" then return 2 end
if name == "npc_dota_neutral_kobold_tunneler" then return 2 end

if	name == "npc_dota_neutral_kobold_taskmaster" then return 6 end 

if	name == "npc_dota_neutral_forest_troll_berserker" then return 4 end
if	name == "npc_dota_neutral_forest_troll_high_priest" then return 6 end 

if	name == "npc_dota_neutral_harpy_scout" then return 4 end 
if	name == "npc_dota_neutral_harpy_storm" then return 6 end

if	name == "npc_dota_neutral_gnoll_assassin" then return 5 end 

if	name == "npc_dota_neutral_ghost" then return 6 end 
if	name == "npc_dota_neutral_fel_beast" then return 4 end 



if name == "npc_dota_neutral_centaur_outrunner" then return 9 end

if	name == "npc_dota_neutral_alpha_wolf" then return 8 end
if	name == "npc_dota_neutral_giant_wolf" then return 5 end

if	name == "npc_dota_neutral_satyr_soulstealer" then return 5 end
if name == "npc_dota_neutral_satyr_trickster" then return 4 end

if	name == "npc_dota_neutral_mud_golem" then return 5 end
if	name == "npc_dota_neutral_mud_golem_split" then return 2 end

if	name == "npc_dota_neutral_ogre_magi" then return 6 end
if	name == "npc_dota_neutral_ogre_mauler" then return 6 end 





if name == "npc_dota_neutral_polar_furbolg_ursa_warrior" then return 15 end
if	name == "npc_dota_neutral_polar_furbolg_champion" then return 10 end

if	name == "npc_dota_neutral_satyr_hellcaller" then return 16 end

if	name == "npc_dota_neutral_centaur_khan" then return 9 end

if	name == "npc_dota_neutral_wildkin" then return 5 end 
if	name == "npc_dota_neutral_enraged_wildkin" then return 16 end

if	name == "npc_dota_neutral_dark_troll" then return 5 end
if	name == "npc_dota_neutral_dark_troll_warlord" then return 16 end 

if	name == "npc_dota_neutral_warpine_raider" then return 13 end



if name == "npc_dota_neutral_black_dragon" then return 20 end
if	name == "npc_dota_neutral_black_drake" then return 13 end

if	name == "npc_dota_neutral_granite_golem" then return 20 end
if	name == "npc_dota_neutral_rock_golem" then return 13 end

if	name == "npc_dota_neutral_big_thunder_lizard" then return 20 end
if	name == "npc_dota_neutral_small_thunder_lizard"  then return 13 end  

if	name == "npc_dota_neutral_ice_shaman"  then return 20 end  
if	name == "npc_dota_neutral_frostbitten_golem" then return 13 end


if name == "npc_filler_dire_stun" then return 40 end
if name == "npc_filler_dire_plasma" then return 40 end
if name == "npc_filler_dire_resist" then return 40 end
if name == "npc_filler_radiant_stun" then return 40 end
if name == "npc_filler_radiant_plasma" then return 40 end
if name == "npc_filler_radiant_resist" then return 40 end

if name == "patrol_melee_good" then return 5 end
if name == "patrol_range_good" then return 5 end
if name == "patrol_melee_bad" then return 5 end
if name == "patrol_range_bad" then return 5 end

end 

function my_game:IsAncientCreep( unit )
if not IsServer() then return end
name = unit:GetUnitName()
if name == "npc_dota_neutral_black_dragon" 
or	name == "npc_dota_neutral_black_drake" 
or	name == "npc_dota_neutral_granite_golem"
or	name == "npc_dota_neutral_rock_golem" 
or	name == "npc_dota_neutral_big_thunder_lizard" 
or	name == "npc_dota_neutral_small_thunder_lizard"  then return true end  

return false 
end



function my_game:FillQuests(hero_name)

local new_quests = {}
local normal_quests = {}
local legendary_quests = {}
local general_quests = {}

for number,shop_hero_quest in pairs(All_Quests.hero_quests[hero_name]) do 
	if shop_hero_quest.legendary and shop_hero_quest.legendary ~= nil then 
		legendary_quests[#legendary_quests + 1] = number
	else 
		normal_quests[#normal_quests + 1] = number
	end
end

for number,shop_hero_quest in pairs(All_Quests.general_quests) do 

	if (shop_hero_quest.not_for == nil or shop_hero_quest.not_for[hero_name] == nil) and 
	(shop_hero_quest.only_for == nil or shop_hero_quest.only_for[hero_name] ~= nil) then 
		general_quests[#general_quests + 1] = number
	end
end


if #normal_quests > 0 then 
	new_quests[#new_quests + 1] = All_Quests.hero_quests[hero_name][normal_quests[RandomInt(1, #normal_quests)]].name
end

if #legendary_quests > 0 then 
	new_quests[#new_quests + 1] = All_Quests.hero_quests[hero_name][legendary_quests[RandomInt(1, #legendary_quests)]].name
end


if #general_quests > 0 then 

	local name = All_Quests.general_quests[general_quests[RandomInt(1, #general_quests)]].name
	new_quests[#new_quests + 1] = name

end

return new_quests
end







function my_game:OnGameRulesStateChange()
	--my_game:UpdateMatch(true)


	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		HTTP.FillOfflineServerData()

		HTTP.MatchStart()

		for id = 0, 24 do
			if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then
				_G.PlayerCount = _G.PlayerCount + 1

		

				PartyTable[id] = tostring(PlayerResource:GetPartyID(id))

				CustomNetTables:SetTableValue(
					"reports",
					tostring(id),
					{
						report = 1
					}
				)
			end
		end
	end


	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then

		CustomNetTables:SetTableValue(
			"custom_pick",
			"pick_state",
			{
				in_progress = true,
			}
		)

		CustomNetTables:SetTableValue(
			"custom_pick",
			"avg_rating",
			{
				avg_rating = avg_rating
			}
		)
	
		GameRules:SetGameTimeFrozen(true)
	
		Timers:CreateTimer(
			"",
			{
				useGameTime = false,
				endTime = 1,
				callback = function()

					local position = Vector(0, 0, 343) + RandomVector(RandomInt(-1, 1) + 400)
	
					local p = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
					for _, player in ipairs(p) do
						player:SetAbsOrigin(position)
						FindClearSpaceForUnit(player, position, true)
					end
	

					GameRules:GetGameModeEntity():SetThink( check_connect, "check_connect_timer", 0.5 )
					hero_select:init()
			end})
	end	
end




function my_game:CreateUpgradeOrb(hero, rarity)
if not IsServer() then return end


local name = {"item_blue_upgrade","item_blue_upgrade","item_purple_upgrade","item_blue_upgrade"}
local sound = {"powerup_03","powerup_03","powerup_05","powerup_03"}
local effect = {"particles/blue_drop.vpcf","particles/blue_drop.vpcf","particles/purple_drop.vpcf"}

if rarity == 3 then
	players[hero:GetTeamNumber()].purple = players[hero:GetTeamNumber()].purple + 1
end

if hero:IsIllusion() then
	hero = hero.owner
end

local point = Vector(0, 0, 0)

if hero:IsAlive() then
	point = hero:GetAbsOrigin() + RandomVector(150)
else
	if towers[hero:GetTeamNumber()] ~= nil then
		point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector() * 300
	end
end

local item = CreateItem(name[rarity], hero, hero)

item_effect = ParticleManager:CreateParticle(effect[rarity], PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(item_effect, 0, point)

EmitSoundOnEntityForPlayer(sound[rarity], hero, hero:GetPlayerOwnerID())

item.after_legen = After_Lich

Timers:CreateTimer(0.8,function() CreateItemOnPositionSync(GetGroundPosition(point, unit), item) end)
	

end




function my_game:AddPurplePoints(hero, points)
if not IsServer() then return end

players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints + points


if players[hero:GetTeamNumber()].purplepoints >= math.floor(players[hero:GetTeamNumber()].purplemax) then

	CustomGameEventManager:Send_ServerToPlayer(
		PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
		"kill_progress",
		{
			blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
			purple = math.floor(players[hero:GetTeamNumber()].purplemax),
			max = players[hero:GetTeamNumber()].bluemax,
			max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
		}
	)

	Timers:CreateTimer(
		0.5,
		function()
			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
				"kill_progress",
				{
					blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
					purple = players[hero:GetTeamNumber()].purplepoints,
					max = players[hero:GetTeamNumber()].bluemax,
					max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
				}
			)
		end)

	players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints - math.floor(players[hero:GetTeamNumber()].purplemax)
	players[hero:GetTeamNumber()].purplemax = players[hero:GetTeamNumber()].purplemax + PlusPurple

	my_game:CreateUpgradeOrb(hero, 3)

	else
		CustomGameEventManager:Send_ServerToPlayer(
		PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
			"kill_progress",
			{
				blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
				purple = players[hero:GetTeamNumber()].purplepoints,
				max = players[hero:GetTeamNumber()].bluemax,
				max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
			}
		)
	end
end





function my_game:AddBluePoints(hero, points)
if not IsServer() then return end

local k = 1

if players[hero:GetTeamNumber()]:HasModifier("modifier_up_bluepoints") then
	k = k + BlueMorePoints
end


players[hero:GetTeamNumber()].bluepoints = players[hero:GetTeamNumber()].bluepoints + points * k

if players[hero:GetTeamNumber()].bluepoints >= players[hero:GetTeamNumber()].bluemax then

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
				"kill_progress",
				{
					blue = players[hero:GetTeamNumber()].bluemax,
					purple = players[hero:GetTeamNumber()].purplepoints,
					max = players[hero:GetTeamNumber()].bluemax,
					max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
				}
			)

	Timers:CreateTimer(0.5,function()
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
				"kill_progress",
				{
					blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
					purple = players[hero:GetTeamNumber()].purplepoints,
					max = players[hero:GetTeamNumber()].bluemax,
					max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
				}
			)
	end)

	players[hero:GetTeamNumber()].bluepoints = players[hero:GetTeamNumber()].bluepoints - players[hero:GetTeamNumber()].bluemax
	players[hero:GetTeamNumber()].bluemax = players[hero:GetTeamNumber()].bluemax + PlusBlue

	my_game:CreateUpgradeOrb(hero, 2)
else
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
			"kill_progress",
			{
				blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
				purple = players[hero:GetTeamNumber()].purplepoints,
				max = players[hero:GetTeamNumber()].bluemax,
				max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
			}
		)
end


end

















function my_game:start_game()
--Timers:CreateTimer("", {useGameTime = false, endTime = 5, callback = function() 

if not game_start then 


	for id = 1,20 do

		--PlayerResource:SetCustomBuybackCooldown(id, 9999)
		--PlayerResource:SetCustomBuybackCost(id, 30)

	end



	game_start = true 
	local  fillers = FindUnitsInRadius(0, Vector(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

 	for _,i in ipairs(fillers) do  
		local effect_name = '' 

  		i:RemoveModifierByName("modifier_invulnerable")
  		if i:GetUnitName() == "npc_filler_radiant_resist" then
  			effect_name = "particles/radiant_resist.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_radiant_stun" then
  			effect_name = "particles/radiant_stun.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_radiant_plasma" then
  			effect_name = "particles/radiant_plasma.vpcf"
  		end


  		if i:GetUnitName() == "npc_filler_dire_resist" then
  			effect_name = "particles/dire_resist.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_dire_stun" then
  			effect_name = "particles/dire_stun.vpcf"
  		end
  		if i:GetUnitName() == "npc_filler_dire_plasma" then
  			effect_name =  "particles/world_shrine/dire_shrine_ambient.vpcf"
  		end

  		if effect_name ~= '' then 
			i.effect = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, i)
			i:AddNewModifier(i, nil, "modifier_tower_incoming", {})	
		end
    end

	GameRules:GetGameModeEntity():SetThink( check_death, "check_tower_timer", 0 )
	GameRules:GetGameModeEntity():SetThink( spawn_timer, "check_wave_timer", 1 )
	CreateModifierThinker(nil, nil, "modifier_mob_thinker", {}, Vector(), DOTA_TEAM_NEUTRALS, false)

	my_game:initiate_tower()
	my_game:initiate_waves()



	if (IsInToolsMode() or GameRules:IsCheatMode() or not HTTP.IsValidGame(PlayerCount)) or (enable_pause) then 
		GameRules:GetGameModeEntity():SetPauseEnabled( true )
	end



--	CustomGameEventManager:Send_ServerToAllClients( 'init_hero_level', {	} ) 

	GameRules:ForceGameStart()
  	for _, player in pairs(players) do
        player:Stop()
    end


	Timers:CreateTimer("", {useGameTime = false, endTime = 1,
	 callback = function()
	 	GameRules:SpawnNeutralCreeps()
		GameRules:SetTimeOfDay(0.25)
		GameRules:SetGameTimeFrozen(false)

		CustomGameEventManager:Send_ServerToAllClients( 'init_hero_level', {} )
		
		CustomGameEventManager:Send_ServerToAllClients( 'init_chat', {tools = IsInToolsMode(), cheat = GameRules:IsCheatMode(), valid = HTTP.IsValidGame( PlayerCount )} )


		if not HTTP.IsValidGame(PlayerCount) then 
   		   Timers:CreateTimer(1,function() 
				CustomGameEventManager:Send_ServerToAllClients( 'alert_notvalid', {} ) 
			end)	 
   		else 

   		   Timers:CreateTimer(1,function()

   		   	local active_vote = CustomNetTables:GetTableValue("sub_data", "heroes_vote" ).active_vote

   		   	if active_vote == 1 then
        		CustomGameEventManager:Send_ServerToAllClients('show_active_vote', {} ) 
        	end

			for _,player in pairs(players) do 

				if active_vote == 0 then
					if player.islp then 
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerOwnerID()), 'alert_dont_leave', {lp = 1} )
					else 
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerOwnerID()), 'alert_dont_leave', {lp = 0} )
					end
				end

				local name = tostring(GetMapName())
				local server_data = CustomNetTables:GetTableValue("server_data", tostring(player:GetPlayerOwnerID()) )

				local wrong_map_status = server_data.wrong_map_status

				if wrong_map_status and wrong_map_status == 2 then 
					wrong_map_players[player:GetPlayerOwnerID()] = true
				end 


				
				if HTTP.serverData.isStatsMatch == true or test == true then 
					if rating_thresh[name] and wrong_map_status then 
				

						if wrong_map_status == 2 then 
							player.banned = true

							CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerOwnerID()), 'BadMap_ban', {mmr = lobby_rating[player:GetPlayerOwnerID()], min = rating_thresh[name].min, max = rating_thresh[name].max} )
						end 

						if wrong_map_status == 1 then
							CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerOwnerID()), 'BadMap', {mmr = lobby_rating[player:GetPlayerOwnerID()], min = rating_thresh[name].min, max = rating_thresh[name].max} )
						end

					else 

						if active_vote == 0 then
							CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerOwnerID()), 'unranked_alert', {} )
						end
					end

					player.wrong_map_status = wrong_map_status


				end


			end
   		    check_reports() 

   			end)



   		end
	end})


end

--end}) 

end








function check_reports()
	for _, server_player in pairs(HTTP.serverData.players) do



		local pid = HTTP.GetPlayerBySteamID( server_player.steamID )

		local player = nil

		if pid then 
			player = players[PlayerResource:GetTeam(pid)]
		end


		if player ~= nil and server_player.reports then

			if player.banned ~= true then
				player.banned = server_player.isBanned
			end

			for other_player, report_count in pairs(server_player.reports) do

				local other_pid = HTTP.GetPlayerBySteamID( other_player )

				if report_count > 0 then 
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid), 'report_alert',  {
				   	 id = other_pid,
				   	 number = report_count,
				   	 max = 6
					})
				end

				if report_count > player.reports then
					player.reports = report_count
					player.teammate = other_pid
				end
			end

		end

	end
end



function my_game:DestroyRoshan()

CustomGameEventManager:Send_ServerToAllClients( 'roshan_hide', {} )
Active_Roshan = false	
end


 function my_game:OnItemPickUp( event )
local item = EntIndexToHScript( event.ItemEntityIndex )

    local owner
    if event.HeroEntityIndex then
        owner = EntIndexToHScript(event.HeroEntityIndex)
    elseif event.UnitEntityIndex then
        owner = EntIndexToHScript(event.UnitEntityIndex)
    end

    if not owner:IsRealHero() then return end

if event.itemname == "item_aegis" then
    UTIL_Remove( item )
    owner:AddNewModifier(owner, nil, "modifier_aegis_custom", {duration = 300})
end




if not players[owner:GetTeamNumber()].IsChoosing and players[owner:GetTeamNumber()].PickOrbs == 0 then 
   
	local after_legen = false
	if item.after_legen == true then 
		after_legen = true
	end


    if event.itemname == "item_gray_upgrade" then
   	 		upgrade:init_upgrade(owner,1,nil,after_legen)
        	UTIL_Remove( item )
    end

    if event.itemname == "item_blue_upgrade" then
   	 		upgrade:init_upgrade(owner,2,nil,after_legen)
       		 UTIL_Remove( item )
    end
    if event.itemname == "item_purple_upgrade" then
   	 		upgrade:init_upgrade(owner,3,nil,after_legen)
       		 UTIL_Remove( item )

    end
    if event.itemname == "item_purple_upgrade_shop" then
   	 		upgrade:init_upgrade(owner,3,nil,true)
       		 UTIL_Remove( item )

    end
    if event.itemname == "item_legendary_upgrade" then
   	 		upgrade:init_upgrade(owner,4,nil,after_legen)		
        	UTIL_Remove( item )	
    end
        
    if event.itemname == "item_alchemist_recipe" then
   	 		upgrade:init_upgrade(owner,13,nil,nil)		
        	UTIL_Remove( item )	
    end
end	



end





duel_fields = 
{
	{2544, -6418, 215,  3983, -6418, 215, 4494, 2147, -5747, -7103, 215},
	{-6231, 2413, 215, -6231, 3843, 215, -5536, -7073, 4356, 2016, 215},
	{6530, -2364, 215, 6530, -3828, 215, 7300, 5728, -2016, -4506, 215},
	{-2259, 6413, 215, -3733, 6413, 215, -1888, -4264, 7103, 5501, 215}
}




function _G.Check_position(i)


local point = i:GetAbsOrigin()
local change = false  



if i:GetAbsOrigin().z < -1000 then 
	point.z = i.z
	change = true
end 

if i:GetAbsOrigin().x > i.x_max then 
	point.x = i.x_max - 200
	change = true
end

if i:GetAbsOrigin().x < i.x_min then 
	point.x = i.x_min + 200
	change = true
end

if i:GetAbsOrigin().y > i.y_max then 
	point.y = i.y_max - 200
	change = true
end

if i:GetAbsOrigin().y < i.y_min then 
	point.y = i.y_min + 200 
	change = true	
end   

if change == true then 
	i:SetAbsOrigin(point)
	FindClearSpaceForUnit(i, point, true)
end




end


function my_game:StartTargetCooldown()

Target_current_cooldown = true 
Target_current_cooldown_time = Target_cooldown
Target_current_active = false

end


function _G.EndAllCooldowns(caster)

local thinkers = Entities:FindAllByClassname("npc_dota_thinker")

for _,thinker in pairs(thinkers) do 
	UTIL_Remove(thinker)
end


local all_units = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

for _,unit in pairs(all_units) do 
  if unit:GetUnitName() == "npc_dota_wraith_king_skeleton_warrior_custom" or
  	unit:GetUnitName() == "npc_dota_wraith_king_skeleton_ghost_custom" then 
  		UTIL_Remove(unit)
  	end
end

for i = 0,caster:GetAbilityCount()-1 do
    	local a = caster:GetAbilityByIndex(i)
    
    	if not a or a:GetName() == "ability_capture" then break end

    	if a:GetName() == "skeleton_king_vampiric_aura_custom" then 
    		a:SetActivated(true)
    	end 

		if a:GetToggleState() then 
  			a:ToggleAbility()
  		end 
      
	
end

for i = 0, 8 do
	local current_ability = caster:GetAbilityByIndex(i)

		if current_ability then
			current_ability:EndCooldown()
			current_ability:RefreshCharges()
		end
end



for i = 0, 8 do
	local current_item = caster:GetItemInSlot(i)
	

	if current_item then	
		if current_item:GetName() ~= "item_refresher_custom" then 
			current_item:EndCooldown()		
		end
		if current_item:GetName() == "item_aegis" then 
			current_item:Destroy()
		end
	end
end


local neutral = caster:GetItemInSlot(16) 
if neutral then
	neutral:EndCooldown()
end



end

function _G.Destroy_Wave_Creeps()

local wave_creeps = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
for _,wave_creep in ipairs(wave_creeps) do
	if not wave_creep:IsNull() and wave_creep:GetTeamNumber() == 10 and wave_creep:IsAlive() then 
		wave_creep:ForceKill(false)
	end
end

end


function _G.Destroy_All_Units(caster)

local all_units = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 0, false)
for _,unit in ipairs(all_units) do
	if not unit:IsNull() and unit:IsAlive() and not unit:IsRealHero() then 
		
		if unit:IsCourier() then 
			unit:AddNewModifier(unit, nil, "modifier_stunned", {})		
		else
			unit:ForceKill(false)
		end

	end
end

end


function _G.finish_duel()
new_round = true
duel_in_progress = false 
MaxTimer = round_timer

local hero1 = Duel_Hero[1]
local hero2 = Duel_Hero[2]
hero1:AddNewModifier(hero1, nil, "modifier_duel_finish", {})
hero2:AddNewModifier(hero2, nil, "modifier_duel_finish", {})

local winner = nil 
local loser = nil

if hero1:IsAlive() and hero2:IsAlive() then 

	if hero1:GetHealthPercent() > hero2:GetHealthPercent() then 
		winner = hero1
		loser = hero2
	end

	if hero1:GetHealthPercent() < hero2:GetHealthPercent() then 
		winner = hero2
		loser = hero1
	end

	if hero1:GetHealthPercent() == hero2:GetHealthPercent() then 

		if hero1:GetHealth() >= hero2:GetHealth() then 
			winner = hero1
			loser = hero2
		else 
			winner = hero2
			loser = hero1
		end

	end

else 

	if not hero1:IsAlive() then 
		winner = hero2
		loser = hero1
	else 
		winner = hero1
		loser = hero2
	end
end

local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
winner:EmitSound("Hero_LegionCommander.Duel.Victory")

local mod = winner:FindModifierByName("modifier_final_duel")


if mod then 
	mod:SetStackCount(mod:GetStackCount() + 1)

	if mod:GetStackCount() == wins_for_win then 
		my_game:destroy_player(loser:GetTeamNumber())
	end
end




end


function my_game:DestroyPatrol()
if not IsServer() then return end

local patrols = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,patrol in pairs(patrols) do
	if patrol:GetUnitName() == "patrol_melee_good" or
		 patrol:GetUnitName() == "patrol_melee_bad" or
		  patrol:GetUnitName() == "patrol_range_good" or
		   patrol:GetUnitName() == "patrol_range_bad" then 

		patrol:AddNewModifier(patrol, nil, "modifier_death", {})
		patrol:ForceKill(false)
	end
end


end


function MaxTime(n)
local t = 70
if n == 1 then t = 20 end 
if n >= 6 then t = 120 end
if n >= 16 then t = 180 end
if n >= 21 then t = 240 end
return t
end



my_game.patrol_drop_first = 
{
	"item_ward_observer",
	"item_repair_patrol",
	"item_contract",
	--"item_smoke_of_deceit",
	"item_patrol_midas",
	"item_patrol_restrained_orb",
}


my_game.patrol_drop_second = 
{
	--"item_patrol_upgrade",
	"item_patrol_vision",
	"item_patrol_razor",
	--"item_patrol_grenade",
	"item_patrol_fortifier",
	"item_trap_custom",
	"item_patrol_respawn",
	"item_gray_upgrade",
}

function spawn_timer()

if (not IsInToolsMode() and not GameRules:IsCheatMode() and HTTP.IsValidGame(PlayerCount)) and (not enable_pause) then 
 
	local should_pause = false
	
	for id = 0,24 do
		if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0  then 
	
	
			local state = PlayerResource:GetConnectionState(id)
			local hero = PlayerResource:GetSelectedHeroEntity(id)
	
			if hero ~= nil and players[hero:GetTeamNumber()] ~= nil then  
	
				local player = players[hero:GetTeamNumber()]
			
				--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "pause_info_timer", {time = player.pause_time} )
	

				if ((player.pause_time > 0) and (state == DOTA_CONNECTION_STATE_DISCONNECTED or state == DOTA_CONNECTION_STATE_LOADING) or
					(player.after_pause_time > 0 and state == DOTA_CONNECTION_STATE_CONNECTED))
				 	and GameRules:GetDOTATime(false, false) > 1 then
	
					should_pause = true
	
					local time = players[hero:GetTeamNumber()].pause_time
					local hero_name = players[hero:GetTeamNumber()]:GetUnitName()
					
					if (player.pause_time > 0 and (state == DOTA_CONNECTION_STATE_DISCONNECTED or state == DOTA_CONNECTION_STATE_LOADING)) then 
						CustomGameEventManager:Send_ServerToAllClients( 'pause_think', {time = time, id = id, player = SelectedHeroes[id]} )

						player.pause_time = player.pause_time - 1
						player.after_pause_time = 3
					end

					if (player.after_pause_time > 0 and state == DOTA_CONNECTION_STATE_CONNECTED) then 
						CustomGameEventManager:Send_ServerToAllClients( 'pause_think', {time = player.after_pause_time, id = id, player = SelectedHeroes[id]} )

						player.after_pause_time = player.after_pause_time - 1

					end

				else
					CustomGameEventManager:Send_ServerToAllClients( 'pause_end', {id = id} )
				end
		
	
			end
	
		
		end
	end
	
	if GameRules:IsGamePaused() == true then 
		if should_pause == false then 
			PauseGame(false)
		end
	else 
		if should_pause == true  then 
			PauseGame(true)
		end
	end

end

if GameRules:IsGamePaused() == true then return 1 end



if Game_end == true then return -1 end



if GameRules:GetDOTATime(false, false) >= DoubleRating_timer and DoubleRating_active == true then 
	DoubleRating_active = false

	CustomGameEventManager:Send_ServerToAllClients( 'hide_double_rating', {} ) 
end


local net = {}
local j = 0
local b = 0


	
local max_net = 0
local max_team = 0	

for i = 1,11 do 
	if players[i] ~= nil then 

		if players[i].left_game == true then 
			players[i].left_game_timer = players[i].left_game_timer - 1
		end

		j = j + 1
		net[j] = {}
		net[j][1] = PlayerResource:GetNetWorth(players[i]:GetPlayerOwnerID())
		net[j][2] = players[i]:GetTeamNumber()

		if max_net < net[j][1] then 
			max_net = net[j][1]
			max_team = i
		end

	end 
end


	
for i = 1,11 do 
	if players[i] ~= nil then 

	   players[i].on_streak = false 
	   	if i == max_team then 
	   		players[i].on_streak = true
	   	end

	end 
end



if test then
	net[2] = {}
	net[2][1] = 5000
	net[2][2] = 3


end




local low_net = 0
local low_net_2 = 0

if #net > 3 or (test and #net > 1) then 

  	  for j = 1,#net-1 do
   		 for i = 1,#net-j do
 			if net[i][1] > net[i+1][1] then 
 				b = net[i]
 				net[i] = net[i+1]
 				net[i+1] = b
 			end	
  		 end
	  end

	

	if (net[2][1] - net[1][1])/net[1][1] > low_net_diff then 
		low_net = net[1][2]
		low_net_2 = net[2][2]
	end


	if (my_game.current_wave + 1) > 6 then 

		for _,player in pairs(players) do
			player.givegold = false
		end

		for i = 1, math.floor(#net/2) do
			if players[net[i][2]] ~= nil then 
				players[net[i][2]].givegold = true
			end
		end 

	end


	if GameRules:GetDOTATime(false, false) >= Target_start and GameRules:GetDOTATime(false, false) < Target_end then 

		if Target_current_active == false and Target_current_cooldown == false and #net > 1 then 

			local first_player = players[net[#net][2]]
			local diff = net[#net][1]/net[#net-1][1]
			

			if first_player and diff >= Target_gold and (net[#net][1] - net[#net-1][1] >= Target_gold_min) and first_player:IsAlive() then

				first_player:AddNewModifier(first_player, nil, "modifier_target", {duration = Target_duration})
				Target_current_active = true

			end
		end


		if Target_current_cooldown == true then 
			Target_current_cooldown_time = Target_current_cooldown_time - 1


			if Target_current_cooldown_time == 0 then 
				Target_current_cooldown = false
			end
		end


	end



end 




for id = 0,24 do 
	if PlayerResource:IsValidPlayerID(id) and (PlayerResource:GetSteamAccountID(id) ~= 0 or IsInToolsMode())  then 
	
		local team = PlayerResource:GetTeam(id)

		if GameRules:GetDOTATime(false, false) >= Player_damage_time and GameRules:GetDOTATime(false, false) < Player_damage_time + 3 then 
			local hero = PlayerResource:GetSelectedHeroEntity(id)
			
			if hero then 
				if hero:HasModifier("modifier_player_damage") then 
					hero:RemoveModifierByName("modifier_player_damage")
				end
			end

			if players[team] ~= nil then 
				players[team].damages = {0,0,0,0,0,0,0,0}
			end
		end

		if players[team] ~= nil then 

			local hero = PlayerResource:GetSelectedHeroEntity(id)
			local hero_has_aegis = false
			players[team].no_purple = false
			players[team].lowest_net = 0

			local no_purple = 0

			if team == low_net or team == low_net_2 then 
				players[team].lowest_net = 1
			end



			if hero then 
				hero_has_aegis = hero:HasModifier("modifier_aegis_custom")
			end

			if hero then 
				no_buyback = hero.no_buyback
			end

			local hero_kills_table = nil
			if GameRules:GetDOTATime(false, false) < Player_damage_time then 
				hero_kills_table = players[team].hero_kills
			end

			--CustomNetTables:SetTableValue("networth_players", tostring(id), {team = team, no_buyback = no_buyback, net = PlayerResource:GetNetWorth(id), damages = players[team].damages, hero_kills = hero_kills_table, streak = players[team].on_streak, hero_has_aegis = hero_has_aegis})	
			CustomNetTables:SetTableValue("networth_players", tostring(id), {
			    place = -1,
			    team = team,
			    no_buyback = no_buyback,
			    net = PlayerResource:GetNetWorth(id),
			    damages = players[team].damages,
			    hero_kills = hero_kills_table,
			    streak = players[team].on_streak,
			    hero_has_aegis = hero_has_aegis,
			    hero_tier = players[team].hero_tier,
			    hero_name = PlayerResource:GetSelectedHeroEntity(id):GetUnitName()
			})
		end
	end 
end




if GameRules:GetDOTATime(false, false) >= give_all_vision_time and init_vision == false and false then 

	init_vision = true 

	for i = 1,11 do 
		if players[i] ~= nil then 

			for j = 1,11 do
				if players[j] ~= nil and j ~= i then 

					local team_viewer = tonumber(teleports[j]:GetName())



				--	local Vector_fow = Vector(vision_abs[team_viewer][1],vision_abs[team_viewer][2],vision_abs[team_viewer][3])
				--	AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][4], 99999, true)

			--		Vector_fow = Vector(vision_abs[team_viewer][5],vision_abs[team_viewer][6],vision_abs[team_viewer][7])
				--	AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][8], 99999, true)

					Vector_fow = towers[j]:GetAbsOrigin()
					AddFOWViewer(i, Vector_fow, 1000, 99999, true)

				end
			end
		end
	end
end  


if GameRules:GetDOTATime(false, false) >= patrol_first_tier and  patrol_first_init == false then 

	patrol_first_init = true 

	CustomGameEventManager:Send_ServerToAllClients( 'PatrolAlert', {number = 1, items = my_game.patrol_drop_first} )
end  

if GameRules:GetDOTATime(false, false) >= patrol_second_tier and  patrol_second_init == false then 

	patrol_second_init = true 

	CustomGameEventManager:Send_ServerToAllClients( 'PatrolAlert', {number = 2, items = my_game.patrol_drop_second} )
end  


if GameRules:GetDOTATime(false, false) >= push_timer and Grenade_start == false then 

	Grenade_start = true 

	CustomGameEventManager:Send_ServerToAllClients( 'grenade_alert', {} )
--	CustomGameEventManager:Send_ServerToAllClients('grenade_count_change',  {count = 0, max = Grenade_Max})
--	CustomGameEventManager:Send_ServerToAllClients('show_grenades',  {})

end  

		




for _,i in pairs(players) do
	if i ~= nil and not i:HasModifier("modifier_final_duel") then
		Check_position(i)
	end
end

roshan_timer = roshan_timer + 1


if GameRules:GetDOTATime(false, false) >= bounty_start and bounty_init == false then 
	bounty_init = true 

	for i = 1,#bounty_abs do 
		local b_thinker = CreateUnitByName("npc_bounty_thinker", bounty_abs[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
		b_thinker:AddNewModifier(b_thinker, nil, "modifier_bounty_map", {})

	end
end


if bounty_timer >= bounty_max_timer and GameRules:GetDOTATime(false, false) >= bounty_start then 
	bounty_timer = 0

	for i = 1,#bounty_abs do 

		local near_rune = Entities:FindByModelWithin(nil, "models/props_gameplay/rune_goldxp.vmdl", bounty_abs[i], 200)
		if not near_rune then
			CreateRune(bounty_abs[i], DOTA_RUNE_BOUNTY)  
		end

	end
end
bounty_timer = bounty_timer + 1 



if false and Active_Roshan == false and roshan_number < #RoshanTimers then 

	if (RoshanTimers[roshan_number] - roshan_alert) < roshan_timer and RoshanTimers[roshan_number] > roshan_timer then 
		local time = RoshanTimers[roshan_number] - roshan_timer
		CustomGameEventManager:Send_ServerToAllClients( 'roshan_timer', {time = time, number = roshan_number} )

		if time == PortalDelay then 


			local teleport_center = CreateUnitByName("npc_dota_companion", Vector(41,140,343), false, nil, nil, 0)
   			teleport_center:AddNewModifier(teleport_center, nil, "modifier_phased", {})
    		teleport_center:AddNewModifier(teleport_center, nil, "modifier_invulnerable", {})
    		teleport_center:AddNewModifier(teleport_center, nil, "modifier_unselect", {})


    		teleport_center:EmitSound("Hero_AbyssalUnderlord.DarkRift.Cast")


			teleport_center.nWarningFX = ParticleManager:CreateParticle( "particles/portals/portal_ground_spawn_endpoint.vpcf", PATTACH_WORLDORIGIN, nil )
        	ParticleManager:SetParticleControl( teleport_center.nWarningFX, 0, Vector(41,140,440) )


        	Timers:CreateTimer(PortalDelay+0.3,function()
	         	ParticleManager:DestroyParticle(teleport_center.nWarningFX, true)
	         	teleport_center:StopSound("Hero_AbyssalUnderlord.DarkRift.Cast")
    			teleport_center:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")
         		teleport_center:Destroy()
       		 end)

        end	

 	end


 	if (RoshanTimers[roshan_number] == roshan_timer) then

   		local unit = CreateUnitByName("npc_roshan_custom", Vector(41,140,343), true, nil, nil, DOTA_TEAM_CUSTOM_5)
   		unit:AddNewModifier(unit, nil, "modifier_roshan_upgrade", {number = roshan_number})
   		unit:FaceTowards(Vector(-10,-10,343))
   		unit.number = roshan_number

 		roshan_number = roshan_number + 1
   		Active_Roshan = true

		local rosh = ParticleManager:CreateParticle("particles/neutral_fx/roshan_spawn.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(rosh, 0, unit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(rosh)

		unit:AddNewModifier(unit, nil, "modifier_roshan_custom_spawn", {duration = 5})
   		
		CustomGameEventManager:Send_ServerToAllClients( 'roshan_spawn', {} )
	end

end


if not duel_prepair and not duel_in_progress then 
	MaxTimer = MaxTime(my_game.current_wave + 1)

	if test then
		if my_game.current_wave + 1 == start_wave + 1 then 
			MaxTimer = timer_test_start
		else  
			MaxTimer = timer_test
		end
	end 
end

if duel_in_progress then 
	MaxTimer = duel_timer_progress
end

timer = timer + 1

local active_necro = true
if MaxTimer - timer <= Necro_Timer then 
	active_necro = false
end

for i = 1,12 do 
	if players[i] ~= nil then 
		players[i].active_necro = active_necro
	end
end

if patrol_wave <= my_game.current_wave and not duel_prepair and not duel_in_progress and GameRules:GetDOTATime(false, false) >= patrol_second_tier then 
	
	if my_game.radiant_patrol_alive == false and my_game.dire_patrol_alive == false then 
		
		local time = patrol_timer_max - (timer)

		if time >= 0 then 
			--CustomGameEventManager:Send_ServerToAllClients( 'patrol_timer', {time = time} )
		end
	end

end


if patrol_wave <= my_game.current_wave and timer + PortalDelay == patrol_timer_max and not duel_prepair and not duel_in_progress then 



	if my_game.patrol_dontgo_dire == true or my_game.patrol_dontgo_radiant == true then 
		if my_game.dire_patrol_alive == false then 
			my_game:patrol_portal(2) 
		end
	else 
	
		if my_game.radiant_patrol_alive == false and my_game.patrol_dontgo_radiant== false then 	
			my_game:patrol_portal(0)
		end
		if my_game.dire_patrol_alive == false and my_game.patrol_dontgo_dire == false then 
			my_game:patrol_portal(1)
		end

	end
end


if patrol_wave <= my_game.current_wave and timer == patrol_timer_max and not duel_prepair and not duel_in_progress  then 



	local drop = my_game.patrol_drop_first

	local second_tier = false 
	local center_patrol = false
	my_game.ravager_max = 12

	if my_game.patrol_dontgo_dire == true or my_game.patrol_dontgo_radiant == true then
		center_patrol = true
		my_game.ravager_max = 6
	end 


	local patrol_item = "item_patrol_reward_1"

	if GameRules:GetDOTATime(false, false) >= patrol_second_tier then 
		--CustomGameEventManager:Send_ServerToAllClients( 'patrol_count', {count =  my_game.ravager_max, max = my_game.ravager_max} )
		drop = my_game.patrol_drop_second
		second_tier = true

		patrol_item  = "item_patrol_reward_2"

	end


	--local item_1 = RandomInt(1, #drop)

	--local item_2 = item_1

	--repeat item_2 = RandomInt(1, #drop)
	--until item_2 ~= item_1
 



	if center_patrol then 

		if my_game.dire_patrol_alive == false then 
			
			my_game.dire_patrol_alive = true
			my_game:spawn_patrol(RandomInt(0,1), patrol_item, patrol_item, second_tier, true)

		end

	else 

		item_2 = ""

		if my_game.radiant_patrol_alive == false and my_game.patrol_dontgo_radiant == false then 
		
			my_game.radiant_patrol_alive = true
			my_game:spawn_patrol(0, patrol_item, nil ,second_tier, false)
		end
   	
		if my_game.dire_patrol_alive == false and my_game.patrol_dontgo_dire == false then 
		
			my_game.dire_patrol_alive = true
			my_game:spawn_patrol(1, patrol_item, nil,second_tier, false)

		end

	end 



	

	my_game.current_patrol = my_game.current_patrol + 1 
	if my_game.current_patrol == 4 then 
		my_game.current_patrol = 1
	end

end





local hide = false

if init_duel == true then 
	init_duel = false

	hide = true
	duel_prepair = true 
	MaxTimer = duel_timer
	timer = 0
end

if new_round == true then 
	new_round = false
	duel_prepair = true 
	MaxTimer = round_timer
	timer = 0
end


if timer + 10 == MaxTimer and not duel_prepair and not duel_in_progress then 
	for _,i in pairs(players) do
		if i ~= nil then	
			local table_tips = CustomNetTables:GetTableValue("TipsType", tostring(i:GetPlayerOwnerID()))
			local count = 0
			local teleport = teleports[i:GetTeamNumber()]:GetName()
			teleport = tonumber(teleport)
			if table_tips.type == 2 or table_tips.type == 3 then
				Timers:CreateTimer(0, function()
					GameRules:ExecuteTeamPing( i:GetTeamNumber(), vision_abs[teleport][1], vision_abs[teleport][2], i, 0 )
					count = count + 1
					if count <= 2 then
						return 1.5
					end
				end)
			end
			if table_tips.type == 3 then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i:GetPlayerOwnerID()), "TipForPlayer", {duration = 10, text = "#Tip_WaveStart"})
			end
		end
	end	
end






if timer + PortalDelay == MaxTimer and not duel_prepair and not duel_in_progress then 
	for _,i in pairs(players) do
		if i ~= nil then	
			my_game:spawn_portal(i:GetTeamNumber())
		end
	end	
end



local number_wave = 0
local go_boss = false




if timer == MaxTimer then 

	if duel_in_progress == false then 

		if duel_prepair == false then 

			my_game.current_wave = my_game.current_wave + 1


			for n = 1,#Wave_boss_number do 
				if my_game.current_wave == Wave_boss_number[n] then
					go_boss = true
					break
				end 
			end

			if go_boss then 
				my_game.go_boss_number = my_game.go_boss_number + 1
				number_wave = my_game.go_boss_number
			else 
				my_game.go_wave = my_game.go_wave + 1
				number_wave = my_game.go_wave
			end

			my_game:DestroyPatrol()

			if low_net_waves[my_game.current_wave] then 
				low_net_current = low_net_current + 1
			end

			for i = 1,12 do
				if players[i] ~= nil then	

		

					local necro = false 

					local trap = false

					if players[i].trap_wave == true then 
						trap= true 
						players[i].trap_wave = false
					end

					if players[i].necro_wave == true then 
						necro = true 
						players[i].necro_wave = false
					end

					local give_lownet = 0
					if players[i].lowest_net == 1 and low_net_waves[my_game.current_wave] then 
						give_lownet = 1
					end


					my_game:spawn_wave(i, number_wave, go_boss, necro, give_lownet, trap)

					


					if  towers[i] ~= nil and my_game.current_wave < 25 and my_game.current_wave > 1 then 
 						towers[i]:AddNewModifier(players[i], nil, "modifier_tower_level", {})
					end
				end
			end

			if my_game.go_wave == #waves then my_game.go_wave = 0 end
		else 

			duel_prepair = false
			duel_in_progress = true
			Destroy_Wave_Creeps()	

			MaxTimer = duel_timer_progress

			Duel_round = Duel_round + 1

			if field == 0 then 
				field = RandomInt(1, #duel_fields)
			end

			local start_points = {}
			start_points[1] = Vector(duel_fields[field][1],duel_fields[field][2],duel_fields[field][3])
			start_points[2] = Vector(duel_fields[field][4],duel_fields[field][5],duel_fields[field][6])
			local x_max = duel_fields[field][7]
			local x_min = duel_fields[field][8]
			local y_max = duel_fields[field][9]
			local y_min = duel_fields[field][10]
			local z_coord = duel_fields[field][11]

			local wall_start = {}
			local wall_end = {}

			wall_start[1] =  Vector(x_max,y_min,z)
			wall_end[1] = Vector(x_min,y_min,z)
			wall_start[2] = Vector(x_max,y_max,z)
			wall_end[2] = Vector(x_min,y_max,z)
			wall_start[3] = Vector(x_max,y_min,z)
			wall_end[3] = Vector(x_max,y_max,z)
			wall_start[4] = Vector(x_min,y_min,z)
			wall_end[4] = Vector(x_min,y_max,z)



			for w = 1, 4 do 

				if wall_particle[w] ~= nil then 
					ParticleManager:DestroyParticle(wall_particle[w], false)
					ParticleManager:ReleaseParticleIndex(wall_particle[w])
				end

				wall_particle[w] = ParticleManager:CreateParticle("particles/duel_wall.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(wall_particle[w], 0, wall_start[w])
				ParticleManager:SetParticleControl(wall_particle[w], 1, wall_end[w])

			end


			local n = 0

			for _,i in pairs(players) do
				if i ~= nil then	
					n = n + 1


					i.x_max = x_max
					i.x_min = x_min
					i.y_max = y_max
					i.y_min = y_min
					i.z = z_coord

					Destroy_All_Units(i)



    				local name = "spawn".. i:GetTeamNumber()
   					local spawner =  Entities:FindByName( nil, name )
    
    				spawner:SetAbsOrigin(start_points[n])

					if not i:IsAlive() then 
						i:RespawnHero(false, false)
					end


					i:Stop()
					i:SetAbsOrigin(start_points[n])
					FindClearSpaceForUnit(i, start_points[n], true)	
					PlayerResource:SetCameraTarget(i:GetPlayerOwnerID(), i)

					
					i:AddNewModifier(i, nil, "modifier_final_duel", {}) 


					if i:HasModifier("modifier_duel_finish") then
						i:RemoveModifierByName("modifier_duel_finish")
					end

				

					if n == 1 then 
                 		i:SetForwardVector(start_points[2] - start_points[1])
					else 
						
                 		i:SetForwardVector(start_points[1] - start_points[2])
					end

				end
			end


		end

	else 
		finish_duel()
	end


	timer = 0
end 


local next_boss = false
local next_wave_number = 0

for n = 1,#Wave_boss_number do 

	if my_game.current_wave + 1 == Wave_boss_number[n] then
		next_boss = true
		break

	end 
end


if next_boss then 
	next_wave_number = my_game.go_boss_number + 1
else 
	next_wave_number = my_game.go_wave + 1
end




local next_wave = my_game:GetWave(next_wave_number, next_boss)
local skills = my_game:GetSkills(next_wave_number, next_boss)
local mkb = my_game:GetMkb(next_wave_number, next_boss)
	


for id = 0,24 do 

	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0   then  

		local can_display = false 
		local givegold = false
		local reward = 0
		local necro = 0
		local upgrade = 0

		if PlayerResource:GetSelectedHeroEntity(id) ~= nil then 

			local team = PlayerResource:GetSelectedHeroEntity(id):GetTeamNumber()

			if players[team] ~= nil then 

				players[team].reward  = 1

				if (my_game.current_wave + 1) == Purple_Wave[1] or (my_game.current_wave + 1) == Purple_Wave[2]  then players[team].reward = 3  end

				local second_orange = 0

				if players[team].orange_count < 2 then 

					second_orange =  Wave_boss_number[2]
					if players[team]:HasModifier("modifier_up_orangepoints") and my_game.current_wave < Wave_boss_number[2] then 
					
						if my_game.current_wave + 1 < upgrade_orange then 
							second_orange = upgrade_orange
						else 
							second_orange = my_game.current_wave + 1
						end
					end
				end

				if (my_game.current_wave + 1) == Wave_boss_number[1] or (my_game.current_wave + 1) == second_orange then players[team].reward = 4  end


				reward = players[team].reward
				givegold = players[team].givegold
				can_display = players[team].ActiveWave == nil
				necro = players[team].necro_wave
				upgrade = players[team].creeps_upgrade
			else 
				can_display = true
			end

		else 
			can_display = true
		end

		if ( can_display == true and not duel_in_progress) or duel_prepair then 

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id) , 'timer_progress',  {upgrade = upgrade, necro = necro ,units = -1, units_max = -1,  time = timer, max = MaxTimer, name = next_wave, skills = skills, mkb = mkb, reward = reward, gold = givegold, number = my_game.current_wave + 1, hide = hide})
		end

		if duel_in_progress or duel_prepair or hide then 

			local hero = {'',''}
			local h = 0
			for j = 1,#Duel_Hero do 
				if Duel_Hero[j] ~= nil then 
					h = h + 1
					hero[h] = Duel_Hero[j]
				end
			end

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id) , 'duel_timer_progress',  {time = timer, max = MaxTimer, hide = false, prepair = duel_prepair, round = Duel_round, hero1 = hero[1]:GetUnitName(), wins1 = hero[1]:GetUpgradeStack("modifier_final_duel"), hero2 = hero[2]:GetUnitName() ,wins2 = hero[2]:GetUpgradeStack("modifier_final_duel") ,show = hide})
		end

	end 
end

	return 1
end







function my_game:destroy_tower( t , team )

local tower = nil
if t ~= nil then 
	tower = t
end

if team ~= nil and towers[team] ~= nil then 
	tower = towers[team]
end


local fillers = FindUnitsInRadius(tower:GetTeamNumber(), tower:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
for _,i in ipairs(fillers) do
	if i ~= tower and i ~= teleports[tower:GetTeamNumber()] then 
		i:ForceKill(false)
	end
end

if teleports[tower:GetTeamNumber()] ~= nil then
	teleports[tower:GetTeamNumber()]:AddNewModifier(nil, nil, "modifier_invulnerable", {})
end

if team ~= nil then 

	if towers[team] ~= nil and towers[team]:IsAlive() then 
		towers[team]:ForceKill(false)
	end
	towers[team] = nil
end



end

function my_game:CheckParty(id)

local p = PartyTable[id]


if p == nil or p == '0' then return false end

for i,party in pairs(PartyTable) do 
	
	if party == p and i ~= id then  
		local hero = PlayerResource:GetSelectedHeroEntity(i)

		if hero ~= nil then 

			if players[hero:GetTeamNumber()] ~= nil then 
				return true
			end

		end

	end
end

return false
end


function my_game:GiveGlobalVision(kv)
	if kv.PlayerID == nil then return end

local team = PlayerResource:GetTeam(kv.PlayerID)

if my_game:CheckParty(kv.PlayerID) == true then
 CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(kv.PlayerID), "CreateIngameErrorMessage", {message = "teammate_alive"})
 return
end



AddFOWViewer(team,Vector(0,0,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(5000,0,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(-5000,0,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(0,5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(0,-5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(5000,5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(-5000,-5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(5000,-5000,0), 10000, 99999, false) 
AddFOWViewer(team,Vector(-5000,5000,0), 10000, 99999, false) 

--No_end_screen[kv.PlayerID] = true
end


function my_game:calc_rating( avg, rating, place, id )
if not rating then return 0 end
if GetMapName() == "unranked" then return 0 end
if SafeToLeave == true then return 0 end

    local diff = rating - avg
    local coef = 1


    if diff > 300 then
        diff = math.min( 650, diff )
        diff = diff - 300

        if ( tonumber( place ) > 3 ) then
            coef = 1 + diff / 300
        else
            coef = 1 - diff / 300 / 1.3
        end
    end

    local r = math.floor( RATING_CHANGE_BASE[place] * coef )

    if lobby_double_rating[id] == true then 
    	r = r*2
    end
    if wrong_map_players[id] == true then 
    	--r = math.min(r, 0)
    end

    return r or 0
end



function my_game:destroy_player(p)
	if players[p] == nil then
		return
	end

    HTTP.SavePlayerItems( players[p]:GetPlayerOwnerID() )
    HTTP.SavePlayerBuffsTalents( players[p]:GetPlayerOwnerID() )

	for _, mod in pairs(players[p]:FindAllModifiers()) do
		if mod:GetName() == "modifier_ember_spirit_fire_remnant_custom_timer" then
			mod:Destroy()
		end
	end

	if players[p]:HasModifier("modifier_aegis_custom") then
		players[p]:RemoveModifierByName("modifier_aegis_custom")
	end

	local all_illusions = FindUnitsInRadius( p, players[p]:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false )

	for _, i in ipairs(all_illusions) do
		if i ~= players[p] then
			local mod = i:AddNewModifier(players[p], nil, "modifier_death", {})
			i:ForceKill(false)
			if mod then
				mod:Destroy()
			end
		end
	end

	if players[p]:IsAlive() then
		local mod = players[p]:AddNewModifier(players[p], nil, "modifier_death", {})

		for i = 0, 5 do
			local item = players[p]:GetItemInSlot(i)

			if item and item:GetName() == "item_aegis" then
				item:Destroy()
			end
		end

		players[p]:Kill(nil, nil)
	end

	players[p]:SetTimeUntilRespawn(-1)
	players[p]:SetBuyBackDisabledByReapersScythe(true)

	players[p].on_streak = false

	local id = players[p]:GetPlayerOwnerID()

	players[p].defeated = true

	End_net[id] = PlayerResource:GetNetWorth(id)



	if players[p].place == -1 then
        _G.Deaths = _G.Deaths + 1
        players[p].place = PlayerCount - Deaths + 1
        HTTP.playersData[id].place = PlayerCount - Deaths + 1
    end

	HTTP.playersData[id].wrong_map_status = players[p].wrong_map_status

	Deaths_Players[id] = {
		items = {},
		player = players[p]
	}
	for i = 0, 5 do
		local item = players[p]:GetItemInSlot(i)
		local name = ""
		if item then
			name = item:GetName()
		end
		Deaths_Players[id].items[#Deaths_Players[id].items + 1] = name
	end

	local server_player = HTTP.GetPlayerData(id)
	local rating = 0
	if server_player ~= nil then
		rating = server_player.rating
	end

	print('dp ',HTTP.playersData[id].ratingChange)

	CustomNetTables:SetTableValue(
		"networth_players",
		tostring(id),
		{
			net = End_net[id],
			place = players[p].place,
			purple = players[p].purple,
			streak = players[p].on_streak,
			rating_before = math.max(0, rating + my_game:calc_rating( avg_rating, lobby_rating[id], HTTP.playersData[id].place, id )),
			rating_change = my_game:calc_rating( avg_rating, lobby_rating[id], HTTP.playersData[id].place, id ),
			items = Deaths_Players[id].items,
			damages = players[p].damages,
			hero_name = PlayerResource:GetSelectedHeroEntity(id):GetUnitName()
		}
	)



	local icon_name = players[p]:GetUnitName() .. "_icon"
	local allunits = FindUnitsInRadius( DOTA_TEAM_NOTEAM, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)

	for _, icon in ipairs(allunits) do
		if icon and not icon:IsNull() then

			if icon ~= players[p] and not icon:IsCourier() and icon:GetUnitName() ~= "npc_teleport" then

				for _, mod in pairs(icon:FindAllModifiers()) do
					if icon and not icon:IsNull() and icon:GetTeamNumber() == p and mod:GetName() == "modifier_monkey_king_wukongs_command_custom_soldier" then 
						UTIL_Remove(icon)
						break
					end

					if not mod:IsNull() and mod:GetCaster() then
						if mod:GetCaster():GetTeamNumber() == players[p]:GetTeamNumber() then
							mod:Destroy()
						end
					end
				end

				if not icon:IsNull() and icon:GetUnitName() == icon_name then
					icon:ForceKill(false)
				end
			end

		end

		if
			not icon:IsNull() and
				((icon:IsCourier() or (icon:GetUnitName() == "npc_dota_companion") or
					(icon:GetUnitName() == "npc_dota_treant_eyes")) and
					icon:GetTeamNumber() == players[p]:GetTeamNumber())
		 then
			icon:Destroy()
		end
	end

	local thinkers = Entities:FindAllByClassname("npc_dota_thinker")

	for _, thinker in pairs(thinkers) do
		if thinker:GetTeamNumber() == players[p]:GetTeamNumber() then
			UTIL_Remove(thinker)
		end
	end

	CustomGameEventManager:Send_ServerToAllClients("pause_end", {id = id})
	--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "hide_pause_info_timer", {})

	local count = 0
	local team = {}

	for i = 1, 11 do
		if i ~= p and players[i] ~= nil then
			players[i].Players_Died = players[i].Players_Died + 1

			table.insert(team, i)
			count = count + 1
		end
	end

	if count == 3 then


		CustomGameEventManager:Send_ServerToAllClients( 'destroy_tower', {} )

		local dire_count = 0
		local radiant_count = 0

		for i = 1, 11 do
			if i ~= p and players[i] ~= nil then
				--for j = 1, 11 do

					--if players[j] ~= nil and j ~= p and j ~= i  then
					--	local team_viewer = tonumber(teleports[j]:GetName())

					--	local Vector_fow =
					--		Vector(vision_abs[team_viewer][1], vision_abs[team_viewer][2], vision_abs[team_viewer][3])
					--	AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][4], 99999, true)

						--Vector_fow =
					--		Vector(vision_abs[team_viewer][5], vision_abs[team_viewer][6], vision_abs[team_viewer][7])
						--AddFOWViewer(i, Vector_fow, vision_abs[team_viewer][8], 99999, true)

					--	Vector_fow = towers[j]:GetAbsOrigin()
						--AddFOWViewer(i, Vector_fow, 1000, 99999, true)
				--	end
			--	end

				if players[i]:HasModifier("modifier_target") then
					players[i]:RemoveModifierByName("modifier_target")
				end
				local team_viewer = tonumber(teleports[i]:GetName())

				if team_viewer == 3 or team_viewer == 8 or team_viewer == 9 then
					dire_count = dire_count + 1
				else
					radiant_count = radiant_count + 1
				end
			end
		end

		if radiant_count > dire_count then
			my_game.patrol_dontgo_radiant = true
		else
			my_game.patrol_dontgo_dire = true
		end

		if dire_count == 3 then
			my_game.patrol_dontgo_radiant = true
		end

		if radiant_count == 3 then
			my_game.patrol_dontgo_dire = true
		end
	end

	if count == 2 then
		init_duel = true
		local n = 0

		for i = 1, 11 do
			if i ~= p and players[i] ~= nil then
				n = n + 1
				players[i].damages = {0, 0, 0, 0, 0, 0, 0, 0}
				towers[i]:AddNewModifier(players[i], nil, "modifier_duel_finish", {})
				CustomGameEventManager:Send_ServerToPlayer(
					PlayerResource:GetPlayer(players[i]:GetPlayerOwnerID()),
					"Attack_Base",
					{sound = "FinalDuel.Start"}
				)
				Duel_Hero[n] = players[i]
			end
		end
	end

	if count == 1 then 
        local winner = players[team[1]]
        winner.place = 1
       my_game:WinTeam(winner)

    end

    HTTP.PlayerEnd( players[p]:GetPlayerOwnerID() )

    if PlayerCount == 1 then
        my_game:WinTeam(players[p])
    end

   -- my_game:UpdateMatch(true)
    players[p] = nil
end


_G.SelectedHeroes = {}




local couriers_spawned = {}


function check_death()
for id = 0,24 do 
 	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then 
		if not couriers_spawned[id] and SelectedHeroes[id] ~= nil then 
			local player = PlayerResource:GetPlayer(id)
			if player ~= nil then
				local courier = player:SpawnCourierAtPosition(COUR_POSITION[LOBBY_PLAYERS[id].select_base])
				courier:AddNewModifier(courier, nil, "modifier_invun", {})
				couriers_spawned[id] = true
			end
		end
 	end
end

if GameRules:GetDOTATime(false, false) < 2 then return 0 end


my_game:AsyncSpawn()



for i = 1,11 do
	local tower = towers[i]
	local player = players[i]

	if tower ~= nil and player ~= nil then 

		local state = PlayerResource:GetConnectionState(player:GetPlayerOwnerID())
		local id_ban = my_game.banned_ids[tostring(PlayerResource:GetSteamAccountID(player:GetPlayerOwnerID()))]


		if not tower:IsAlive() or state == DOTA_CONNECTION_STATE_ABANDONED or player.banned or id_ban then


			if not tower:IsAlive() then 
			 	Timers:CreateTimer(0.5, function()

					local hero_won = ''
			 		if tower.killer ~= nil then 
			 			hero_won = tower.killer:GetUnitName()
			 			HTTP.playersData[player:GetPlayerOwnerID()].killer = hero_won
			 		end
			 		
					CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 0, abbandon = 0, hero2 = hero_won, hero = player:GetUnitName()} )
				 end)
			end  

			local alert = false

			if state == DOTA_CONNECTION_STATE_ABANDONED and player.left_game == false and Game_end == false then 

				player.left_game = true
   		   		CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 0, abbandon = 1, hero2 = '', hero = player:GetUnitName()} )
   		   		alert = true
			end


			if (player.banned == 1 or player.banned == true or id_ban) and alert == false then
				CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 1, abbandon = 0, hero2 = '', hero = player:GetUnitName()} )

				if player.teammate then 
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerOwnerID()), 'banned', {reports = player.reports, id = player.teammate, max = 6} )
				end
			end
			

			if player.left_game_timer < 1 or player.banned == true or id_ban or player.banned == 1 or not tower:IsAlive() then  
				my_game:destroy_player(i)
				my_game:destroy_tower(tower,tower:GetTeamNumber())
			end
		end
	end

end


if SafeToLeave_alert == false and SafeToLeave == true and HTTP.serverData.isStatsMatch == true then 
	SafeToLeave_alert = true 
	CustomGameEventManager:Send_ServerToAllClients( 'saveleave', {reason = SafeToLeave_reason} )
end


return 0
end


function check_connect()
if not IsServer() then return end

if SafeToLeave == false and GameRules:GetDOTATime(false, false) < 3 then 

	local n = 0

	for id = 0, 24 do
    	local data = CustomNetTables:GetTableValue("server_data", tostring(id) )
    	
    	if data then 

	    	if data.wrong_map_status~= 0 then 
	    		n = n + 1
	    	end
	    	if n > 1 then 
				_G.SafeToLeave = true
				SafeToLeave_reason = 2
				break
			end
		end

	end


end


for id = 0, 24 do
    if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then

    	local state = PlayerResource:GetConnectionState(id)

    	local n = 0
    	for _,data in pairs(abandon_players) do 
    		n = n + 1
    	end


    	if ((state == DOTA_CONNECTION_STATE_ABANDONED) or (state == DOTA_CONNECTION_STATE_DISCONNECTED and n == PlayerCount - 1))
    	 and abandon_players[id] ~= true then 

    		abandon_players[id] = true

    		HTTP.playersData[id].isLeaver = true

    		local data = CustomNetTables:GetTableValue("server_data", tostring(id) )
    		local wrong_map_status = data.wrong_map_status


    		local lp_games = 0
    		local switch_safetoleave = false
    		local isPenalty = false
			local lp_games = data.lp_games_remaining

			if HTTP.serverData.isStatsMatch == true and SafeToLeave == false and GameRules:GetDOTATime(false, false) <= LowPriorityTime and HTTP.playersData[id].lost_game == false then 
				isPenalty = true
				lp_games = lp_games + 1
			end


			if HTTP.serverData.isStatsMatch == true and SafeToLeave == false and wrong_map_status == 0 and GameRules:GetDOTATime(false, false) <= SafeLeaveTime and HTTP.playersData[id].lost_game == false then 
                _G.SafeToLeave = true
                switch_safetoleave = true 
                SafeToLeave_reason = 1

            end

			data.lp_games_remaining = lp_games
			data.isPenalty = isPenalty
            data.switch_safetoleave = switch_safetoleave


			CustomNetTables:SetTableValue("server_data", tostring(id), data)

			HTTP.PlayerLeave( id )

    	end

    end
end


return 0.5
end



function my_game:WinTeam(player)
if test then 
	--return 
end

    _G.Game_end = true
    local last_id = player:GetPlayerOwnerID()

    HTTP.playersData[last_id].place = 1
        print( "SET FIRST PLACE" )


    HTTP.SavePlayerItems( last_id )
    HTTP.SavePlayerBuffsTalents( last_id )

	HTTP.playersData[last_id].wrong_map_status = player.wrong_map_status

    End_net[last_id] = PlayerResource:GetNetWorth(last_id)
    Deaths_Players[last_id] = {
        player = player,
        items = {}
    }

    for i = 0,5 do
        local item = player:GetItemInSlot(i)
        local name = ""
        if item then     
            name = item:GetName()
        end
        table.insert(Deaths_Players[last_id].items, name)
    end

   	HTTP.PlayerEnd( last_id )

    for id = 0, 24 do
        if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and Deaths_Players[id] ~= nil then

        	local change = lobby_rating_change[id]
        	local before = 0

        	if change and lobby_rating_change[id] then 
        		before = lobby_rating[id] + lobby_rating_change[id]
        	end


			CustomNetTables:SetTableValue(
			    "networth_players",
			    tostring(id),
			    {
					net = PlayerResource:GetNetWorth(id),
			        place = Deaths_Players[id].player.place,
			        purple = 0,
			        streak = false,
			        rating_before = math.max(0,  before),
			        rating_change = change,
			        items = Deaths_Players[id].items,
			        damages = Deaths_Players[id].player.damages,

			    	hero_name = PlayerResource:GetSelectedHeroEntity(id):GetUnitName()
			    }
			)

			
	  		HTTP.PlayerLeave( id )
        end
    end


    if dont_end_game == false then 
    	CustomNetTables:SetTableValue("networth_players", "", {game_ended = true})
   	end

end


function my_game:GetHeroType( player )
if not IsServer() then return end

if player:GetUnitName() == "npc_dota_hero_juggernaut" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_phantom_assassin" then return {"melle"}  end 
if player:GetUnitName() == "npc_dota_hero_terrorblade" then return {"melle"}  end 
if player:GetUnitName() == "npc_dota_hero_nevermore" then return {"mage"}  end 
if player:GetUnitName() == "npc_dota_hero_puck" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_queenofpain" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_huskar" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_bristleback" then return {"mage","melle"} end 
if player:GetUnitName() == "npc_dota_hero_legion_commander" then return {"mage","melle"} end 
if player:GetUnitName() == "npc_dota_hero_void_spirit" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_ember_spirit" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_pudge" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_hoodwink" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_skeleton_king" then return {"melle"} end
if player:GetUnitName() == "npc_dota_hero_lina" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_troll_warlord" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_axe" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_alchemist" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_ogre_magi" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_antimage" then return {"melle"} end 
if player:GetUnitName() == "npc_dota_hero_primal_beast" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_marci" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_templar_assassin" then return {} end 
if player:GetUnitName() == "npc_dota_hero_bloodseeker" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_monkey_king" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_mars" then return {"melle","mage"} end 
if player:GetUnitName() == "npc_dota_hero_zuus" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_leshrac" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_crystal_maiden" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_snapfire" then return {"mage"} end 
if player:GetUnitName() == "npc_dota_hero_sven" then return {"melle"} end 
if player:GetUnitName() == "npc_dota_hero_sniper" then return {"mage"} end 
end





function my_game:GetTowerDamage( player )
if not IsServer() then return end

if player:GetUnitName() == "npc_dota_hero_juggernaut" then return -30 end 
if player:GetUnitName() == "npc_dota_hero_phantom_assassin" then return -20  end 
if player:GetUnitName() == "npc_dota_hero_terrorblade" then return -60  end 
if player:GetUnitName() == "npc_dota_hero_nevermore" then return -60  end 
if player:GetUnitName() == "npc_dota_hero_puck" then return 10 end 
if player:GetUnitName() == "npc_dota_hero_queenofpain" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_huskar" then return -40 end 
if player:GetUnitName() == "npc_dota_hero_bristleback" then return -60 end 
if player:GetUnitName() == "npc_dota_hero_legion_commander" then return -60 end 
if player:GetUnitName() == "npc_dota_hero_void_spirit" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_ember_spirit" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_pudge" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_hoodwink" then return 0 end 
if player:GetUnitName() == "npc_dota_hero_skeleton_king" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_lina" then return -50 end 
if player:GetUnitName() == "npc_dota_hero_troll_warlord" then return -60 end 
if player:GetUnitName() == "npc_dota_hero_axe" then return 0 end 
if player:GetUnitName() == "npc_dota_hero_alchemist" then return -60 end 
if player:GetUnitName() == "npc_dota_hero_ogre_magi" then return -20 end 
if player:GetUnitName() == "npc_dota_hero_antimage" then return -40 end 
if player:GetUnitName() == "npc_dota_hero_primal_beast" then return -40 end 
if player:GetUnitName() == "npc_dota_hero_marci" then return -30 end 
if player:GetUnitName() == "npc_dota_hero_templar_assassin" then return -50 end 
if player:GetUnitName() == "npc_dota_hero_bloodseeker" then return -50 end 
if player:GetUnitName() == "npc_dota_hero_monkey_king" then return -40 end 
if player:GetUnitName() == "npc_dota_hero_mars" then return -40 end 

end













local icons_abs = 
{
	{},
	{-6695,-6750,119},
	{6770,6706,95},
	{},
	{},
	{-6297,2778,103},
	{2849,-6383,95},
	{-2648,6426,103},
	{6520,-2632,95},

}
function CreateDamageData()
    return {
        dealt_pre_reduction = { 0, 0, 0, 0 },
        dealt_post_reduction = { 0, 0, 0, 0 },
        received_pre_reduction = { 0, 0, 0, 0 },
        received_post_reduction = { 0, 0, 0, 0 },
    }
end


my_game.banned_ids = 
{
	--['242916466'] = true,
	--['898622414'] = true,
	--['1386764322'] = true,
	--['1396726809'] = true,
	--['1386695287'] = true,
	--['1386723172'] = true,
	--['1184150223'] = true,
	--['128920224'] = true, --mateedx
	['86791990'] = true, --снайпер бульдога
	--['1184186390'] = true,
	--['1183982061'] = true
	--['459964030'] = true, --prost0chlen
	['1258530980'] = true, -- ???
--	['298072165'] = true, -- fyva мейн
	--['868360098'] = true -- fyva фейк
	['1484025835'] = true, -- xeno вскройся
	--['172784619'] = true, -- biba
	['1477201119'] = true, -- xeno умри
--	['87882333'] = true, --slarky
	--['119753873'] = true, --slarky smurf
--	['440557549'] = true, -- gigapuck

}

function my_game:IsPatrol(name)
if name == "patrol_melee_good" or 
	name == "patrol_range_good" or 
	name == "patrol_melee_bad" or
	name == "patrol_range_bad" then return true end

return false
end


function my_game:initiate_player(oplayer, pause, randomed)
    oplayer:Stop()
    


    players[oplayer:GetTeamNumber()] = oplayer
    oplayer.choise = {}
    oplayer.HeroType = my_game:GetHeroType(oplayer)
    oplayer.upgrades = {}
    oplayer.ban_skills = {}
    oplayer.IsChoosing = false
    oplayer.bluepoints = 0
    oplayer.purplepoints = 0
    oplayer.death = 0
    oplayer.purple = 0
    oplayer.chosen_skill = 0
    oplayer.givegold = false
    oplayer.respawn_mod = {}
    oplayer.place = -1
    oplayer.NeutraItems = {0, 0, 0, 0, 0}
    oplayer.bluemax = StartBlue
    oplayer.purplemax = StartPurple
    oplayer.on_streak = false
    oplayer.ActiveWave = nil
    oplayer.choise_table = {}
    oplayer.Players_Died = 0
    oplayer.banned = false
    oplayer.randomed = randomed

    oplayer.wrong_map_status = 0

 	oplayer.reports = 0

    oplayer.after_pause_time = 0


    oplayer.grenade_count = 0
    oplayer.grenade_creeps_count = 0

    oplayer.kills_done = 0
    oplayer.towers_destroyed = 0
    oplayer.bounty_runes_picked = 0

    oplayer.can_refresh_choise = false
    oplayer.no_purple = 0
    oplayer.necro_wave = false
    oplayer.active_necro = false
    oplayer.give_lownet = 0
    oplayer.lowest_net = 0

    oplayer.trap_wave = false

    oplayer.can_refresh = true

    oplayer.no_buyback = 0

    oplayer.creeps_upgrade = 0

    oplayer.left_game = false
    oplayer.left_game_timer = 60

    oplayer.pause_time = pause
    oplayer.pause = -1

    oplayer.x_min = -8100
    oplayer.x_max = 8100
    oplayer.y_min = -8100
    oplayer.y_max = 8100
    oplayer.z = 215

    oplayer.PickOrbs = 0
    oplayer.HideDouble = 0

    oplayer.orange_count = 0

    oplayer.patrol_kills = 0
    oplayer.seconds_dead = 0
    oplayer.obs_placed = 0
    oplayer.sentry_placed = 0
    oplayer.obs_kills = 0
    oplayer.sentry_kills = 0
    oplayer.defeated = false

    oplayer.abilities = {}

    oplayer.creep_damage = CreateDamageData()
    oplayer.tower_damage = CreateDamageData()
    oplayer.hero_damage = CreateDamageData()

    oplayer.damages = {}

    oplayer.hero_kills = {}

   -- oplayer:SetBuybackCooldownTime(99999)

   	local id = oplayer:GetPlayerOwnerID()


   	oplayer.hero_tier = -1

   	oplayer:AddAbility("custom_ability_grenade")
   	local talent = oplayer:AddAbility("generic_talent")
   	talent:SetLevel(1)


    local sub_data = CustomNetTables:GetTableValue("sub_data", tostring(oplayer:GetPlayerOwnerID()))

    if sub_data and sub_data.heroes_data[oplayer:GetUnitName()] and sub_data.subscribed == 1 then 
    	oplayer.hero_tier = sub_data.heroes_data[oplayer:GetUnitName()].tier
    end

    chat_wheel:SetDefaultSound(id)


    for id = 0, 24 do
        if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then
            oplayer.damages[id] = 0

            if HTTP.GetPlayerData(id) then 

   				oplayer.islp = HTTP.GetPlayerData(id).lowPriorityRemaining > 0


            	CustomNetTables:SetTableValue("TipsType", tostring(id), {type = HTTP.GetPlayerData(id).tipsType})
            end
        end
    end

    if oplayer:GetUnitName() == "npc_dota_hero_pudge" then
        local ability = oplayer:FindAbilityByName("custom_pudge_flesh_heap")
        oplayer:AddNewModifier(oplayer, ability, "modifier_custom_pudge_flesh_heap", {})
    end

    if oplayer:FindAbilityByName("monkey_king_mischief_custom") then 
    	oplayer:FindAbilityByName("monkey_king_mischief_custom"):SetLevel(1)
    end

    if oplayer:HasModifier("modifier_tower_damage") then
        oplayer:RemoveModifierByName("modifier_tower_damage")
    end
    oplayer:AddNewModifier(oplayer, nil, "modifier_tower_damage", {})


    oplayer.damages[0] = 0
    oplayer.damages[1] = 0
    oplayer.damages[2] = 0
    oplayer.damages[3] = 0

 --   oplayer:AddNewModifier(nil, nil, "modifier_no_vision", {})
    oplayer:AddNewModifier(nil, nil, "modifier_on_respawn", {})
    oplayer:AddNewModifier(nil, nil, "modifier_player_damage", {})

    local tp_item = CreateItem("item_tpscroll_custom", oplayer, oplayer)
    oplayer:AddItem(tp_item)

    CustomGameEventManager:Send_ServerToPlayer(
        PlayerResource:GetPlayer(oplayer:GetPlayerOwnerID()),
        "kill_progress",
        {blue = oplayer.bluepoints, purple = oplayer.purplepoints, max = StartBlue, max_p = StartPurple}
    )

    CustomNetTables:SetTableValue("custom_items_button", tostring(oplayer:GetPlayerOwnerID()), {observer = 0, sentry = 0})

	local lvl = -1
	local hero_name = oplayer:GetUnitName()

    if sub_data then 


    	if sub_data.heroes_data[hero_name] and sub_data.heroes_data[hero_name].has_level == 1 and sub_data.subscribed == 1 and sub_data.hide_tier == 0 then
    		lvl = sub_data.heroes_data[hero_name].tier 
    	end

		shop:AddPetFromStart( oplayer:GetPlayerOwnerID())

		--CustomNetTables:SetTableValue('players_chat_wheel', tostring(oplayer:GetPlayerOwnerID()), sub_data.chat_wheel)
		chat_wheel:SetDefaultSound(oplayer:GetPlayerOwnerID())
		
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(oplayer:GetPlayerOwnerID()), 'change_show_level_lua', {}) 
    end



    CustomNetTables:SetTableValue("hero_portrait_levels", tostring(hero_name), {tier = lvl})
 



	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(oplayer:GetPlayerOwnerID()), 'init_damage_table', {	} ) 


	if sub_data and tostring(GetMapName()) ~= "unranked" and HTTP.IsValidGame(PlayerCount) then 
    	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(oplayer:GetPlayerOwnerID()), 'init_double_rating', {cd = sub_data.double_rating_cd, subscribed = sub_data.subscribed} ) 
 	end
 end









function my_game:initiate_tower()
  local t = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, 0, FIND_CLOSEST, false)

 
  for _,otower in ipairs(t) do
  	if otower and not otower:IsNull() then 

		if (otower:GetUnitName() == "npc_towerdire" or otower:GetUnitName() == "npc_towerradiant")  then

			if otower:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_6 then 

				towers[otower:GetTeamNumber()] = otower	
				towers[otower:GetTeamNumber()]:AddNewModifier(otower, nil, "modifier_tower_level", {})	
				towers[otower:GetTeamNumber()]:AddNewModifier(otower, nil, "modifier_tower_incoming", {})	

			else 
				local j = otower
				self:destroy_tower(otower)
				j:Destroy()

			end

    	 end
    end
  end

	LinkLuaModifier("modifier_mid_teleport", "modifiers/modifier_mid_teleport", LUA_MODIFIER_MOTION_NONE)
	local j = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, 0, 0, false)	
    for _,teleport in ipairs(j) do
     	if teleport:GetUnitName() == "npc_teleport"  then

			teleport:AddNewModifier(nil, nil, "modifier_mid_teleport", {})
			teleports[teleport:GetTeamNumber()] = teleport 

			if teleport:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_6 then 

				local number = tonumber(teleport:GetName())

				local Vector_fow = Vector(vision_abs[number][1],vision_abs[number][2],vision_abs[number][3])
				AddFOWViewer(teleport:GetTeamNumber(), Vector_fow, vision_abs[number][4], 99999, true)

				Vector_fow = Vector(vision_abs[number][5],vision_abs[number][6],vision_abs[number][7])
				AddFOWViewer(teleport:GetTeamNumber(), Vector_fow, vision_abs[number][8], 99999, true)

			else 

				teleport:AddNewModifier(nil, nil, "modifier_invulnerable", {})
			end

		end
     end



	for _,tower in pairs(towers) do

		if players[tower:GetTeamNumber()] ~= nil then 
 			for _,tt in pairs(towers) do 
 				if tt:GetTeamNumber() ~= tower:GetTeamNumber() then 
			   		local name = SelectedHeroes[players[tower:GetTeamNumber()]:GetPlayerOwnerID()] .. '_icon'
			   	    local vector = Vector(icons_abs[players[tower:GetTeamNumber()]:GetTeamNumber()][1],icons_abs[players[tower:GetTeamNumber()]:GetTeamNumber()][2],icons_abs[players[tower:GetTeamNumber()]:GetTeamNumber()][3])
					local hero_icon = CreateUnitByName(name, tower:GetAbsOrigin(), false, nil, nil, tt:GetTeamNumber())
					hero_icon:AddNewModifier(nil, nil, "modifier_unselect", {})
				end
			end

		end
	end



end




function my_game:IsSphere( item )
if item:GetName() == "item_legendary_upgrade" or 
	item:GetName() == "item_gray_upgrade" or
	item:GetName() == "item_blue_upgrade" or 
	item:GetName() == "item_purple_upgrade_shop" or 
	item:GetName() == "item_alchemist_recipe" or 
	item:GetName() == "item_purple_upgrade" then 
		return true end 
return false 
end

function my_game:ExecuteOrderFilterCustom( ord )



	local target = ord.entindex_target ~= 0 and EntIndexToHScript(ord.entindex_target) or nil
	local player = PlayerResource:GetPlayer(ord["issuer_player_id_const"])

	if player and player:GetAssignedHero() then 
		if player:GetAssignedHero():HasModifier("modifier_final_duel_start") then return false end 
	end


 	local unit


    if ord.units and ord.units["0"] then
        unit = EntIndexToHScript(ord.units["0"])
    end


    local orders = {
        DOTA_UNIT_ORDER_CAST_POSITION,
        DOTA_UNIT_ORDER_CAST_TARGET,
        DOTA_UNIT_ORDER_CAST_TARGET_TREE, 
        DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        DOTA_UNIT_ORDER_MOVE_TO_TARGET,
        DOTA_UNIT_ORDER_ATTACK_MOVE,
        DOTA_UNIT_ORDER_ATTACK_TARGET,
        --DOTA_UNIT_ORDER_CAST_NO_TARGET,
        DOTA_UNIT_ORDER_PICKUP_ITEM,
        DOTA_UNIT_ORDER_PICKUP_RUNE

    }

    if unit and unit:HasModifier("modifier_custom_ability_teleport") then
        for _, order in pairs(orders) do
            if ord.order_type == order then
                return false
            end
        end
    end


    if ord.order_type == DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN then
    	local item_ward = EntIndexToHScript(ord["entindex_ability"])	
    	if item_ward and item_ward:GetName() == "item_observer_stackable" then 
    		return false
    	end
    end 
    


    if ord.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then

            local item = EntIndexToHScript(ord["entindex_target"])

            if item then
            		

                local pickedItem = item:GetContainedItem()
                if not pickedItem then return true end
                if pickedItem:IsNeutralDrop() then return true end
                if players[unit:GetTeamNumber()] == nil then return false end


                if my_game:IsSphere(pickedItem) and players[unit:GetTeamNumber()].IsChoosing then return false end


                if unit:IsCourier() and pickedItem:GetPurchaser() ~= players[unit:GetTeamNumber()]
                and (pickedItem:GetName() ~= "item_roshan_necro") and (pickedItem:GetName() ~= "item_gem") then
					CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#wrong_sphere"})
				 return false end


                if (pickedItem:GetPurchaser() ~= unit) and (pickedItem:GetName() ~= "item_rapier") and (pickedItem:GetName() ~= "item_aegis")
                and (pickedItem:GetName() ~= "item_refresher_shard") and (pickedItem:GetName() ~= "item_roshan_necro") and (pickedItem:GetName() ~= "item_gem")
                and not unit:IsCourier() then

					CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#wrong_sphere"})
                    return false
                end
            end
    end



    if not player then return false end

    local hero = player:GetAssignedHero()


    if not hero then return end


	--if 
		--hero:HasModifier("odifier_primal_beast_onslaught_legendary") and (
		--ord.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
	--	ord.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		--ord.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or
		--ord.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
		--ord.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
	--	ord.order_type==DOTA_UNIT_ORDER_CAST_TARGET_TREE or
	--	ord.order_type==DOTA_UNIT_ORDER_CAST_RUNE or
	--	ord.order_type==DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION)
	--then 
	--	return false
	--end

    if ord.order_type == DOTA_UNIT_ORDER_BUYBACK and not hero:IsReincarnating() then 
    	
    	Timers:CreateTimer(1, function() 
    		if hero and not hero:IsNull() then 
    			hero.no_buyback = 1
    			hero:SetBuybackCooldownTime(99999)
    		end
   		 end)
    	
    end


    if ord.order_type == DOTA_UNIT_ORDER_CAST_TARGET and hero:GetUnitName() == "npc_dota_hero_alchemist" then
    	local item = EntIndexToHScript(ord.entindex_ability)
    	if item and item:GetName() == "item_ultimate_scepter" then 
			CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#alch_scepter"})
    		return false
    	end
    end

    if hero:HasModifier("modifier_final_duel") and not hero:IsAlive() and (ord.order_type == DOTA_UNIT_ORDER_MOVE_ITEM
    or ord.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM) then 
    	return false
    end





     if ord.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE then 


     	local ability = EntIndexToHScript(ord.entindex_ability)

     	if ability and ability:GetName() == "custom_puck_phase_shift" and hero:HasModifier("modifier_custom_puck_phase_shift_cooldown") then

     		return false 
     	end

     	if ability and not ability:IsFullyCastable() and ability:GetName() ~= "custom_puck_phase_shift" then 
     		return false
     	end

     end

    if ord.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM and players[hero:GetTeamNumber()] ~= nil and ord.shop_item_name == "item_purple_upgrade_shop" then 

    	if not players[hero:GetTeamNumber()].got_purple then 

    		players[hero:GetTeamNumber()].purple = players[hero:GetTeamNumber()].purple + 1
    		players[hero:GetTeamNumber()].got_purple = true
    	else 
    		return false
    	end
    end


    if hero and hero:HasModifier("modifier_mid_teleport_cast") and ord.order_type ~= DOTA_UNIT_ORDER_HOLD_POSITION
    and ord.order_type ~= DOTA_UNIT_ORDER_PURCHASE_ITEM and ord.order_type ~= DOTA_UNIT_ORDER_MOVE_ITEM
    and ord.order_type ~= DOTA_UNIT_ORDER_SELL_ITEM  then 
     return false end


    if hero and hero:HasModifier("modifier_bristle_spray_legendary") and hero:IsAlive() and ord.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then 
    	local ability = EntIndexToHScript(ord.entindex_ability)
    	if ability and ability:GetName() == "bristleback_quill_spray_custom" then 
    		local mod = hero:FindModifierByName("modifier_custom_bristleback_quill_spray_legendary")
    		if not mod then 
    			hero:AddNewModifier(hero, ability, "modifier_custom_bristleback_quill_spray_legendary", {})
    		else 
    			mod:Destroy()
    		end
    	end
    end



    if hero and hero:HasModifier("modifier_lina_array_legendary") and hero:IsAlive() and ord.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then 
    	local ability = EntIndexToHScript(ord.entindex_ability)
    	if ability and ability:GetName() == "lina_light_strike_array_custom" then 
    		local mod = hero:FindModifierByName("modifier_lina_light_strike_array_custom_legendary")
    		if not mod then 
    			hero:AddNewModifier(hero, ability, "modifier_lina_light_strike_array_custom_legendary", {})
    		else 
    			mod:Destroy()
    		end
    	end
    end




	if ord.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET or ord.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET  then


	if target and not target:IsNull() and  target:IsBaseNPC() and target:GetUnitName() == "npc_teleport" and unit:IsRealHero() then

		if target:GetTeamNumber() ~= hero:GetTeamNumber() then return false end

		if teleport_range >= ( hero:GetOrigin() - target:GetOrigin() ):Length2D() then 

			 if not hero:HasModifier("modifier_mid_teleport_cd") then
     			 hero:Interrupt() 
     			 hero:Stop()
    		     hero:AddAbility("mid_teleport")
      			local ability = hero:FindAbilityByName("mid_teleport")
     			 ability:SetLevel(1)
     			 ability.roshan = Active_Roshan
    			 hero:CastAbilityNoTarget(ability, hero:GetPlayerOwnerID())

    		else 
				CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#midteleport_cd"})
    		end
		else 
			CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#midteleport_distance"})
		end

		return false
	  end
	end



	if ord.order_type == DOTA_UNIT_ORDER_CAST_TARGET  then
		if target:GetUnitName() == "npc_teleport" then 
			return false
		end
	end




	local ability = EntIndexToHScript(ord.entindex_ability)

	if not ability or not ability.GetBehaviorInt then return true end
	local behavior = ability:GetBehaviorInt()

	-- check if the ability exists and if it is Vector targeting

if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) ~= 0  then



	if ord.order_type == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION then
		ability.vectorTargetPosition2 = Vector(ord.position_x, ord.position_y, 0)
	end





	if ord.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
		ability.vectorTargetPosition = Vector(ord.position_x, ord.position_y, 0)
		local position = ability.vectorTargetPosition
		local position2 = ability.vectorTargetPosition2
		local direction = (position2 - position):Normalized()

		--Change direction if just clicked on the same position
		if position == position2 then
			direction = (position - unit:GetAbsOrigin()):Normalized()
		end
		direction = Vector(direction.x, direction.y, 0)
		ability.vectorTargetDirection = direction

		local function OverrideSpellStart(self, position, direction)
			self:OnVectorCastStart(position, direction)
		end
		ability.OnSpellStart = function(self) return OverrideSpellStart(self, position, direction) end
	end





	if ord.order_type == DOTA_UNIT_ORDER_CAST_TARGET and 
	ability:GetName() == 'marci_companion_run_custom' then
		ability.vectorTargetPosition = Vector(ord.position_x, ord.position_y, 0)

		ability.vectorTargetPoisitioncheck = EntIndexToHScript(ord["entindex_target"]):GetAbsOrigin()



		local position = ability.vectorTargetPosition
		local position2 = ability.vectorTargetPosition2
		local direction = (position2 - position):Normalized()

		--Change direction if just clicked on the same position
		if position == position2 then
			direction = (position - unit:GetAbsOrigin()):Normalized()
		end
		direction = Vector(direction.x, direction.y, 0)
		ability.vectorTargetDirection = direction

		local function OverrideSpellStart(self, position, direction)
			self:OnVectorCastStart(position, direction)
		end
		ability.OnSpellStart = function(self) return OverrideSpellStart(self, position, direction) end
	end




end


	return true
end

function my_game:DamageFilter( dmg )

	if dmg["entindex_victim_const"] == nil then return true end

	local target = EntIndexToHScript(dmg["entindex_victim_const"])
	local damage = dmg["damage"]
	if dmg["entindex_attacker_const"] == nil then return true end

	local attacker = EntIndexToHScript(dmg["entindex_attacker_const"])


	if target:GetUnitName() == "npc_teleport" then
		return false
	end
	

	if attacker.owner then 
		attacker = attacker.owner
	end

	if target and target:IsRealHero() and attacker:IsHero() and target:GetTeamNumber() ~= attacker:GetTeamNumber() and damage > 0 then
        local no_found = true

        if not damage_table[target:GetPlayerID()] then 
			damage_table[target:GetPlayerID()] = {}
			damage_table[target:GetPlayerID()].spell_damage = {}
			damage_table[target:GetPlayerID()].spell_damage_income = {}
		end

        if damage_table[target:GetPlayerID()] then
          	if damage_table[target:GetPlayerID()].spell_damage_income then

              	if damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()] == nil then
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()] = {}
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].phys = 0
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].magic = 0
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].pure = 0
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].all_damage = 0
                end
                  
                damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].all_damage = damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].all_damage + damage

                  if dmg.damagetype_const == 1 then
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].phys = damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].phys + damage
                  elseif dmg.damagetype_const == 2 then
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].magic = damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].magic + damage
                  elseif dmg.damagetype_const == 4 then
                      damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].pure = damage_table[target:GetPlayerID()].spell_damage_income[attacker:GetUnitName()].pure + damage
                  end


                  CustomNetTables:SetTableValue("player_damages_income", tostring(target:GetPlayerID()), damage_table[target:GetPlayerID()].spell_damage_income)
          	end
        end
    end

    if attacker and attacker:IsHero() and target:IsRealHero() and target:GetTeamNumber() ~= attacker:GetTeamNumber() and damage > 0 then
        local no_found = true

        if not damage_table[attacker:GetPlayerID()] then 
			damage_table[attacker:GetPlayerID()] = {}
			damage_table[attacker:GetPlayerID()].spell_damage = {}
			damage_table[attacker:GetPlayerID()].spell_damage_income = {}
		end

        if damage_table[attacker:GetPlayerID()] then
          	if damage_table[attacker:GetPlayerID()].spell_damage then
              	local ability_name = nil
              	local ability_type = "attack"

              	if dmg.entindex_inflictor_const ~= nil then
                	ability_name = EntIndexToHScript(dmg.entindex_inflictor_const):GetAbilityName()
              	else
                  	ability_name = "attack"
              	end

              	for _, hero_table in pairs(damage_table[attacker:GetPlayerID()].spell_damage) do
                  	if hero_table.name == ability_name then
                      	no_found = false
                      	if hero_table.damage then
                        	hero_table.damage = hero_table.damage + damage
                      	else
                          	hero_table.damage = damage
                      	end
                  	end
              	end

              	if dmg.entindex_inflictor_const ~= nil then
                  	if EntIndexToHScript(dmg.entindex_inflictor_const):IsItem() then
                    	ability_type = "item"
                  	else
                    	ability_type = "ability"
                  	end
              	else
                  	ability_type = "attack"
              	end

              	if no_found then
                	table.insert(damage_table[attacker:GetPlayerID()].spell_damage, {name = ability_name, damage = damage, index = target:GetUnitName(), damage_type = dmg.damagetype_const, type = ability_type})
              	end

              	table.sort( damage_table[attacker:GetPlayerID()].spell_damage, function(x,y) return y.damage < x.damage end )

              	CustomNetTables:SetTableValue("player_damages", tostring(attacker:GetPlayerID()), damage_table[attacker:GetPlayerID()].spell_damage)
          	end
        end
    end


	return true
end


function my_game:HealingFilter( h )

if h["entindex_target_const"] == nil then return healing end
if h["entindex_healer_const"] == nil then return healing end
if h["heal"] == nil then return healing end

local heal = h["heal"]
local target = EntIndexToHScript(h["entindex_target_const"])
local healer = EntIndexToHScript(h["entindex_healer_const"])

	return healing
end




local first_think = true
function my_game:OnThink()
	--my_game:UpdateMatch(first_think)
	local steamIDs = {}


	for id = 0, 24 do
		if PlayerResource:IsValidPlayerID( id ) then
			table.insert( steamIDs, tostring( PlayerResource:GetSteamAccountID( id ) ) )
		end
	end

	HTTP.Request("/state", {
		playerIds = steamIDs,
	}, function(data)

		if not data then 
			return
		end

		for _, player in pairs( data ) do
			local pid = HTTP.GetPlayerBySteamID( player.playerId )
			local sub_data = CustomNetTables:GetTableValue("sub_data", tostring(pid))

			if sub_data then
				sub_data.points = player.shardsAmount
				sub_data.votes_count = player.voteCount

				if player.dotaPlusExpire and player.dotaPlusExpire > 0 and sub_data.subscribed == 0 then 
					sub_data.subscribed = 1
					sub_data.sub_time = player.dotaPlusExpire/1000
				end


				if (not player.dotaPlusExpire or player.dotaPlusExpire <= 0) and sub_data.subscribed == 1 then 
					sub_data.subscribed = 0
					sub_data.sub_time = 0
				end

   				CustomNetTables:SetTableValue("sub_data", tostring(pid), sub_data)
			else
				print( "Not sub_data when state", pid, player.playerId, sub_data )
   			end
		end
    end)


	first_think = false
	return 10
end

function my_game:AddPlayer(team)
if not IsInToolsMode() then return end

local p = FindUnitsInRadius(DOTA_TEAM_NOTEAM,Vector(0, 0, 0),nil,FIND_UNITS_EVERYWHERE,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)

for _,player in pairs(p) do 
	if player:GetTeamNumber() == team then 
		my_game:initiate_player(player, 30)
	end
end

end

--Convars:RegisterCommand('set_winner', function(_,team) my_game:WinTeam(tonumber(team)) end, '', 0)


Convars:RegisterCommand('add_player', function(_,team) my_game:AddPlayer(tonumber(team)) end, '', 0)

--Convars:RegisterCommand('start_duel', function() my_game:start_duel() end, '', 0)
--Convars:RegisterCommand('destroy_tower', function(_,team) my_game:destroy_tower(nil, tonumber(team) ) end, '', 0)
