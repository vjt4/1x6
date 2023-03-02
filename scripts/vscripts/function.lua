require("debug_")

function CDOTA_BaseNPC:GetUpgradeStack(mod)
	if self:HasModifier(mod) then 
		return self:GetModifierStackCount(mod, self)
	end
	return 0
end

function CDOTA_BaseNPC:HasShard()
	return self:HasModifier("modifier_item_aghanims_shard")
end


function CDOTA_BaseNPC:UpgradeIllusion(mod, stack)
	local i = self:AddNewModifier(self, nil, mod, {})
	i:SetStackCount(stack)
end



function CDOTA_BaseNPC:GenericHeal(heal, ability, no_text)
if not IsServer() then return end

self:Heal(heal, ability)


local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self )
ParticleManager:ReleaseParticleIndex( particle )


if no_text and no_text == true then return end

SendOverheadEventMessage(self, 10, self, heal, nil)
end


function CDOTA_BaseNPC:SetQuest(table)

self.quest = {}
self.quest.name = table.name and table.name or ""
self.quest.exp = table.exp and table.exp or 0
self.quest.shards = table.shards and table.shards or 0
self.quest.icon = table.icon and table.icon or ""
self.quest.goal = table.goal and table.goal or 0
self.quest.number = table.number and table.number or 0
self.quest.legendary = table.legendary
self.quest.progress = 0
self.quest.completed = 0

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()), 'hero_quest_init',
 {
 	name = self.quest.name,
 	exp = self.quest.exp,
 	shards = self.quest.shards,
 	icon = self.quest.icon,
 	goal = self.quest.goal,
 	legendary = self.quest.legendary
 }) 
end



function CDOTA_BaseNPC:UpdateQuest(inc)
if not self.quest then return end 
if inc == nil then return end

if self.quest.completed == 1 then 
	return
end

self.quest.progress = math.min(self.quest.goal, (self.quest.progress + inc))

if (self.quest.progress >= self.quest.goal) then 
	self.quest.completed = 1

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()), 'hero_quest_complete', {}) 
else 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetPlayerOwnerID()), 'hero_quest_update',
	 {
	 	goal = self.quest.goal,
	 	progress = self.quest.progress,
	 }) 
end

end


function CDOTA_BaseNPC:QuestCompleted()

local complete = false

if self.quest and self.quest.completed == 1 then 
	complete = true
end

return complete
end



function CDOTA_BaseNPC:GetQuest()
local name = nil 

if self.quest and self.quest.name then 
	name = self.quest.name
end

return name
end



function CDOTA_BaseNPC:IsPatrolCreep()
if self:GetUnitName() == "patrol_melee_good" or 
	self:GetUnitName() == "patrol_range_good" or 
	self:GetUnitName() == "patrol_melee_bad" or
	self:GetUnitName() == "patrol_range_bad" then return true end

return false

end







function CDOTABaseAbility:GetState()
	return self:GetAutoCastState()
end


CDOTA_Ability_Lua.GetCastRangeBonus = function(self, hTarget)
	if not self or self:IsNull() then
		return 0
	end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then
		return 0
	end

	return caster:GetCastRangeBonus()
end
 
CDOTABaseAbility.GetCastRangeBonus = function(self, hTarget)
	if not self or self:IsNull() then
		return 0
	end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then
		return 0
	end

	return caster:GetCastRangeBonus()
end

CDOTA_BaseNPC.StartGesture_old = CDOTA_BaseNPC.StartGesture
CDOTA_BaseNPC.StartGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:StartGesture_old(activity)
	else
		Debug:Log("invalid StartGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings_old = CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings
CDOTA_BaseNPC.StartGestureFadeWithSequenceSettings = function(npc, activity)
	if type(activity) == "number" then
		npc:StartGestureFadeWithSequenceSettings_old(activity)
	else
		Debug:Log("invalid StartGestureFadeWithSequenceSettings(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureWithFade_old = CDOTA_BaseNPC.StartGestureWithFade
CDOTA_BaseNPC.StartGestureWithFade = function(npc, activity, fadeIn, fadeOut)
	if type(activity) == "number" then
		npc:StartGestureWithFade_old(activity, fadeIn, fadeOut)
	else
		Debug:Log("invalid StartGestureWithFade(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ", " .. tostring(fadeIn) .. ", " .. tostring(fadeOut) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.StartGestureWithPlaybackRate_old = CDOTA_BaseNPC.StartGestureWithPlaybackRate
CDOTA_BaseNPC.StartGestureWithPlaybackRate = function(npc, activity, rate)
	if type(activity) == "number" then
		npc:StartGestureWithPlaybackRate_old(activity, rate)
	else
		Debug:Log("invalid StartGestureWithPlaybackRate(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ", " .. tostring(rate) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.FadeGesture_old = CDOTA_BaseNPC.FadeGesture
CDOTA_BaseNPC.FadeGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:FadeGesture_old(activity)
	else
		Debug:Log("invalid FadeGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end

CDOTA_BaseNPC.RemoveGesture_old = CDOTA_BaseNPC.RemoveGesture
CDOTA_BaseNPC.RemoveGesture = function(npc, activity)
	if type(activity) == "number" then
		npc:RemoveGesture_old(activity)
	else
		Debug:Log("invalid RemoveGesture(" .. npc:GetUnitName() .. ", " .. tostring(activity) .. ") at " .. debug.traceback())
	end
end
