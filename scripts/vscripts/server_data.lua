require("debug_")
--local profiler = require("profiler")
--profiler:start()

local record_interval = 60
local batch_size = 1
local last_record = -record_interval
local last_send = -(record_interval * batch_size)
local last_send_data = nil


Http = {}

--Http.HOST = "http://localhost/"
--Http.KEY = GetDedicatedServerKeyV2( "dedicated-api" )

function string.starts(String,Start)
	return  string.sub(String,1,string.len(Start))==Start
end

function Http:WillSendData()
	return not IsInToolsMode() and IsDedicatedServer() and not string.starts(GetDedicatedServerKeyV2(''), "Invalid_")
end

function Http:IsValidGame(PlayerCount)
	return PlayerCount >= 6 and Http:WillSendData()
end







function HttpRequest(data, success)
	last_send = GameRules:GetGameTime()
	last_send_data = data
	if not Http:WillSendData() then
		return
	end

	local key = GetDedicatedServerKeyV2('dota1x6key')
	if string.starts(key, "Invalid") then
		return
	end

	local r = CreateHTTPRequestScriptVM("POST", "http://dota1x6.com/api/update_match")
	r:SetHTTPRequestHeaderValue("authorization", 'Bearer ' .. key)
	r:SetHTTPRequestHeaderValue("x-match-id", tostring(GameRules:Script_GetMatchID()))
	r:SetHTTPRequestRawPostBody("application/json", json.encode(data))

	r:SetHTTPRequestAbsoluteTimeoutMS(15 * 1000)
	r:Send(function(res)
		if res.StatusCode == 200 and string.sub(res.Body, 1, 1) == "{" then
			status, ret, err = xpcall(function()
				if res.Body == "" then
					return
				end
				success(json.decode(res.Body))
			end, debug.traceback)
			
			if ret == nil then
				return
			end
			Debug:Log(ret)
		end
		success(nil)
	end)
end

local update_match_cache = {}
local match_was_ended = false

local defeated_players = {}
local winner_team = nil
local critical_changes = false

function my_game:GetPlayerServerData(pid, has_lobby)
	local result = {
		account_id =  tostring(PlayerResource:GetSteamAccountID(pid)),
		player_name = PlayerResource:GetPlayerName(pid),
		team = PlayerResource:GetCustomTeamAssignment(pid),
		leaver_status = PlayerResource:GetConnectionState(pid),
		networth = PlayerResource:GetNetWorth(pid),
		gold = PlayerResource:GetGold(pid),
		gold_spent = PlayerResource:GetTotalGoldSpent(pid),
		gold_lost_to_death = PlayerResource:GetGoldLostToDeath(pid),
		claimed_farm_gold = PlayerResource:GetClaimedFarm(pid, true),
		gpm = PlayerResource:GetGoldPerMin(pid),
		xppm = PlayerResource:GetXPPerMin(pid),
		last_hits = PlayerResource:GetLastHits(pid),
		denies = PlayerResource:GetDenies(pid),
		nearby_creep_deaths = PlayerResource:GetNearbyCreepDeaths(pid),
		kills = PlayerResource:GetKills(pid),
		deaths = PlayerResource:GetDeaths(pid),
		assists = PlayerResource:GetAssists(pid),
		misses = PlayerResource:GetMisses(pid),
		rune_pickups = PlayerResource:GetRunePickups(pid),
		aegis_pickups = PlayerResource:GetAegisPickups(pid),
		units = {},
		place = -1,
		party_id = "0"
	}
	if has_lobby then
		result.party_id = tostring(PlayerResource:GetPartyID(pid))
	end

	local lobby_player = LOBBY_PLAYERS[pid]
	if lobby_player ~= nil then
		result.hero_was_randomed = lobby_player.randomed
		result.position = lobby_player.select_base
		result.banned_hero = lobby_player.ban_hero
	end

	local player = players[result.team]
	if result.leaver_status == DOTA_CONNECTION_STATE_FAILED then
		defeated_players[pid] = true
		_G.Game_end = true
		critical_changes = true
	end
	if result.leaver_status == DOTA_CONNECTION_STATE_ABANDONED then
		defeated_players[pid] = true
		_G.Deaths = _G.Deaths + 1
		result.place = _G.PlayerCount - _G.Deaths + 1
		if player ~= nil then
			player.place = result.place
		end
		critical_changes = true
	end

	if player == nil then
		return result
	end
	if player.defeated then
		defeated_players[pid] = true
	end
	if player.place == 1 then
		winner_team = result.team
	end

	result.hero_name = PlayerResource:GetSelectedHeroName(pid)
	result.last_hits_patrol = player.patrol_kills
	result.seconds_dead = player.seconds_dead
	result.observers_placed = player.obs_placed
	result.sentries_placed = player.sentry_placed
	result.observers_killed = player.obs_kills
	result.sentries_killed = player.sentry_kills
	result.place = player.place
	result.rating_change = player.rating_change

	local position = player:GetAbsOrigin()
	result.units[1] = {
		name = result.hero_name,
		level = player:GetLevel(),
		abilities = {},
		abilities_levels = {},
		damage_sources = player.abilities,
		hero_damage_stats = player.hero_damage,
		tower_damage_stats = player.tower_damage,
		creep_damage_stats = player.creep_damage,
		position_x = position.x,
		position_y = position.y,
		hp = player:GetHealth(),
		mana = player:GetMana()
	}

	for i = 0,DOTA_MAX_ABILITIES - 1 do
		local abil = player:GetAbilityByIndex(i)
		if abil ~= nil then
			table.insert(result.units[1].abilities, {
				name = abil:GetName(),
				level = abil:GetLevel()
			})
		end
	end

	for i = 0, DOTA_ITEM_INVENTORY_SIZE - 1 do
		local item = player:GetItemInSlot(i)
		if item ~= nil then
			table.insert(result.units[1].abilities, {
				name = item:GetName(),
				level = item:GetLevel()
			})
		end
	end

	for _, mod in pairs(player:FindAllModifiers()) do
		local name = mod:GetName()
		if (
			mod.IsUpgrade
			or name == "modifier_item_aghanims_shard"
			or name == "modifier_item_moon_shard_consumed"
			or name == "modifier_item_ultimate_scepter_consumed"
			or name == "modifier_item_ultimate_scepter_consumed"
			or name == "modifier_item_essence_of_speed"
		) then
			table.insert(result.units[1].abilities, {
				name = mod:GetName(),
				level = mod:GetStackCount(),
				is_talent = mod.IsUpgrade or false,
				is_orange_talent = mod.IsOrangeTalent or false,
				talent_tree = mod.TalentTree or ""
			})
		end
	end

	return result
end

_G.last_update_match = {}
_G.Server_data = nil
function _G.FindPlayerServerData(pid)
	if Server_data == nil then
		return nil
	end

	local account_id = tostring(PlayerResource:GetSteamAccountID(pid))
	for _, data in pairs(Server_data.players) do
		if data.account_id == account_id then
			return data
		end
	end

	return nil
end
function _G.FindPlayerByAccountID(id)
	for pid = 0,DOTA_MAX_TEAM_PLAYERS - 1 do
		if tostring(PlayerResource:GetSteamAccountID(pid)) == id then
			return pid
		end
	end
	return nil
end

local match_started = false
function my_game:OnServerDataInit()
	if match_was_ended and winner_team ~= nil and #update_match_cache == 0 then
		GameRules:SetGameWinner(winner_team)
	end
	CustomNetTables:SetTableValue(
		"server_data",
		"",
		{
			is_match_made = Server_data.is_match_made,
			season_name = Server_data.season_name
		}
	)
	CustomNetTables:SetTableValue(
		"leaderboard",
		"leaderboard",
		Server_data.leaderboard
	)
	for i, player in pairs(Server_data.players) do
		local pid = FindPlayerByAccountID(player.account_id)
		if pid ~= nil then
			player.PlayerID = pid
			for hero_name, stats in pairs(player.hero_stats) do
				CustomNetTables:SetTableValue(
					"server_hero_stats",
					tostring(pid) .. "_" .. hero_name,
					{
						places = stats.places,
						rating = stats.rating,
						kills = stats.kills,
						deaths = stats.deaths,
						total = stats.total_matches
					}
				)
			end
			CustomNetTables:SetTableValue(
				"server_data",
				tostring(pid),
				{
					total_games = player.total_matches,
				 	rating = player.rating,
                    rank_tier = player.rank_tier,
                    leaderboard_rank = player.leaderboard_rank,
                    competitive_calibration_games_remaining = player.competitive_calibration_games_remaining,
					favorite_hero = player.favorite_hero,
					places = player.places,
					lp_games_remaining = player.lp_games_remaining,
					player_matches = player.matches
				}
			)
		end
	end
	if not match_started then
		avg_rating = Server_data.avg_rating
		CustomNetTables:SetTableValue(
			"custom_pick",
			"pick_state",
			{
				avg_rating = avg_rating
			}
		)
		for _, hero in pairs(Server_data.bans) do
			table.insert(BANNED_HEROES, hero)
			CustomGameEventManager:Send_ServerToAllClients('ban_hero', {hero = banned_hero})
		end
		match_started = true
	end
end

function my_game:FillFakeServerData(data)
	Server_data = {
		season_name = 'Unknown',
		bans = {},
		is_match_made = false,
		players = {},
		leaderboard = {},
		avg_rating = 1
	}
	local parties = {}
	for i, player in pairs(data.players) do
		local server_player = {
			account_id = player.account_id,

			rating = 1,
            rank_tier = 0,
            leaderboard_rank = 0,
            competitive_calibration_games_remaining = -1,

			rating_change = 0,
			hero_pick_order = i,
			role = 0,
			is_banned = false,
			lp_games_remaining = 0,
			party_id = -1,
			tips_type = 3,
			reports = {},
			matches = {},
			places = {},
			hero_stats = {},
			total_matches = 0,
			duration = 0
		}

		if player.party_id ~= "0" then
			for i, otherParty in pairs(parties) do
				if otherParty == player.party_id then
					server_player.party_id = i
					break
				end
			end
		end
		if server_player.party_id == -1 then
			server_player.party_id = #parties + 1
			parties[server_player.party_id] = player.party_id
		end

		table.insert(Server_data.players, server_player)
	end
end

local request_in_flight = false
local force_next_request = false
function my_game:UpdateMatchCb(expected_last_send_data, data)
	if not request_in_flight or last_send_data ~= expected_last_send_data then
		return
	end
	if data == nil then
	--	HttpRequest(
	--		last_send_data,
	--		function(data)
	--			my_game:UpdateMatchCb(expected_last_send_data, data)
	--		end
	--	)
		return
	end
	last_send_data = nil
	request_in_flight = false
	if Server_data ~= nil then
		Server_data.season_name = data.season_name or Server_data.season_name
		Server_data.bans = data.bans or Server_data.bans
		Server_data.is_match_made = data.is_match_made or Server_data.is_match_made
		Server_data.leaderboard = data.leaderboard or Server_data.leaderboard
		Server_data.avg_rating = data.avg_rating or Server_data.avg_rating
		for _, new_ply in pairs(data.players) do
			local found = false
			for i, old_ply in pairs(Server_data.players) do
				if new_ply.account_id == old_ply.account_id then
					old_ply.rating = new_ply.rating or old_ply.rating
					old_ply.rank_tier = new_ply.rank_tier or old_ply.rank_tier
					old_ply.competitive_calibration_games_remaining = new_ply.competitive_calibration_games_remaining or old_ply.competitive_calibration_games_remaining
					old_ply.rating_change = new_ply.rating_change or old_ply.rating_change
					old_ply.hero_pick_order = new_ply.hero_pick_order or old_ply.hero_pick_order
					old_ply.role = new_ply.role or old_ply.role
					old_ply.is_banned = new_ply.is_banned or old_ply.is_banned
					old_ply.lp_games_remaining = new_ply.lp_games_remaining or old_ply.lp_games_remaining
					old_ply.party_id = new_ply.party_id or old_ply.party_id
					old_ply.tips_type = new_ply.tips_type or old_ply.tips_type
					old_ply.reports = new_ply.reports or old_ply.reports
					old_ply.matches = new_ply.matches or old_ply.matches
					old_ply.places = new_ply.places or old_ply.places
					old_ply.hero_stats = new_ply.hero_stats or old_ply.hero_stats
					old_ply.total_matches = new_ply.total_matches or old_ply.total_matches
					old_ply.duration = new_ply.duration or old_ply.duration
					old_ply.favorite_hero = new_ply.favorite_hero or old_ply.favorite_hero
					local pid = FindPlayerByAccountID(old_ply.account_id)
					if pid ~= nil and defeated_players[pid] and Deaths_Players[pid] ~= nil then
						local custom_ply = Deaths_Players[pid].player
						CustomNetTables:SetTableValue(
							"networth_players",
							tostring(id),
							{
								net = End_net[pid],
								place = custom_ply.place,
								purple = custom_ply.purple,
								streak = custom_ply.on_streak,
								rating_before = old_ply.rating,
								rating_change = old_ply.rating_change,
								items = Deaths_Players[pid].items,
								damages = custom_ply.damages
							}
						)
						local dota_ply = PlayerResource:GetPlayer(pid)

						if dota_ply ~= nil and custom_ply.place > 2 then 
							CustomGameEventManager:Send_ServerToPlayer(dota_ply, "EndScreenShow", {
								place = custom_ply.place,
								rating_before = old_ply.rating,
								rating_change = old_ply.rating_change,
								calibration_games = old_ply.competitive_calibration_games_remaining,
							})
						end

					end
					found = true
					break
				end
			end
			if not found then
				table.insert(Server_data.players, new_ply)
			end
		end
	else
		Server_data = data
	end

	for _, ply in pairs(Server_data.players) do
		ply.leaderboard_rank = 0
		for i, leaderboard_ply in pairs(Server_data.leaderboard) do
			if leaderboard_ply.account_id == ply.account_id then
				ply.leaderboard_rank = i
			end
		end
	end

	my_game:OnServerDataInit()
end

function my_game:UpdateMatch(force)
	if not IsServer() then
		return
	end

	local cur_time = GameRules:GetGameTime()
	if not match_was_ended then
		critical_changes = false
		local has_lobby = tostring(GameRules:Script_GetMatchID()) ~= "0" and not string.starts(GetDedicatedServerKeyV2(''), "Invalid_")
		local players_array = {}
		for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
			if PlayerResource:IsValidPlayerID(i) and PlayerResource:GetSteamAccountID(i) ~= 0 and not defeated_players[i] then
				table.insert(players_array, my_game:GetPlayerServerData(i, has_lobby))
			end
		end

		if #players_array ~= 0 then
			if critical_changes then
				force = true
			end
			if cur_time - last_record >= record_interval or force then
				last_record = cur_time
	
				last_update_match = {
					map_name = GetMapName(),
					sv_cluster = Convars:GetInt("sv_cluster"),
					sv_region = Convars:GetInt("sv_region"),
					cheats_enabled = GameRules:IsCheatMode(),
					players = players_array,
					raw_game_time = GameRules:GetGameTime(),
					game_time = GameRules:GetDOTATime(false, false),
					game_state = GameRules:State_Get(),
					reports = _G.PendingReports,
					logs = _G.PendingLogs
				}
				_G.PendingReports = {}
				_G.PendingLogs = {}
				if IN_STATE then
					last_update_match.game_state = DOTA_GAMERULES_STATE_HERO_SELECTION
				elseif Game_end then
					last_update_match.game_state = DOTA_GAMERULES_STATE_POST_GAME
				end
				if not match_started then
					my_game:FillFakeServerData(last_update_match)
				end
				table.insert(update_match_cache, last_update_match)
			end
		end
	end

	if request_in_flight or #update_match_cache == 0 then
		force_next_request = force_next_request or force

		if request_in_flight and (cur_time - last_send) > 20 then
			local sending_update_match_cache = last_send_data
			HttpRequest(
				last_send_data,
				function(data)
					my_game:UpdateMatchCb(sending_update_match_cache, data)
				end
			)
		end

		return
	end

	force = force or force_next_request
	force_next_request = false
	if not force and #update_match_cache < batch_size then
		return
	end

	--profiler:stop()
	--local profiler_report = profiler:report()
	--profiler:start()
	--DeepPrintTable(profiler_report)

	match_was_ended = match_was_ended or Game_end
	local sending_update_match_cache = update_match_cache
	-- DeepPrintTable(update_match_cache)
	update_match_cache = {}

	request_in_flight = true

	HttpRequest(
		sending_update_match_cache,
		function(data)
			my_game:UpdateMatchCb(sending_update_match_cache, data)
		end
	)
end
