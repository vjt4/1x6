LinkLuaModifier("modifier_bloodseeker_thirst_custom", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_debuff", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_visual", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_kill", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_resist", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_legendary", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_attack", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_attack_cd", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_vision", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_vision_count", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_thirst_custom_heal", "abilities/bloodseeker/bloodseeker_thirst_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_thirst_custom = class({})

bloodseeker_thirst_custom.bonus_damage = {15, 20, 25}

bloodseeker_thirst_custom.bonus_speed = {10, 15, 20}

bloodseeker_thirst_custom.trash_max = 10
bloodseeker_thirst_custom.trash_resist = 30
bloodseeker_thirst_custom.trash_bva = 1.5
bloodseeker_thirst_custom.trash_radius = 1000

bloodseeker_thirst_custom.legendary_max = 20
bloodseeker_thirst_custom.legendary_perma = 3
bloodseeker_thirst_custom.legendary_str = 0.01
bloodseeker_thirst_custom.legendary_agi = 0.01
bloodseeker_thirst_custom.legendary_creeps_count = 4
bloodseeker_thirst_custom.legendary_creeps_stack = 1
bloodseeker_thirst_custom.legendary_heroes_stack = 6
bloodseeker_thirst_custom.legendary_heroes_radius = 700
bloodseeker_thirst_custom.legendary_death = 0.4

bloodseeker_thirst_custom.attack_cd_max = 8
bloodseeker_thirst_custom.attack_cd_reduction = 5
bloodseeker_thirst_custom.attack_agility_max = 300
bloodseeker_thirst_custom.attack_damage = {0.05, 0.08}

bloodseeker_thirst_custom.heal_dist = 500
bloodseeker_thirst_custom.heal_value = {2, 3, 4}
bloodseeker_thirst_custom.heal_health = 50

bloodseeker_thirst_custom.vision_radius = 4000
bloodseeker_thirst_custom.vision_duration = 60
bloodseeker_thirst_custom.vision_creeps = 40

function bloodseeker_thirst_custom:GetIntrinsicModifierName()
	return "modifier_bloodseeker_thirst_custom"
end


function bloodseeker_thirst_custom:OnUpgrade()
if self:GetLevel() == 1 and self:GetCaster():HasModifier("modifier_bloodseeker_thirst_7") 
and not self:GetCaster():HasModifier("modifier_bloodseeker_thirst_custom_legendary") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_thirst_custom_legendary", {})
end


end


function bloodseeker_thirst_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_bloodseeker_thirst_7") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function bloodseeker_thirst_custom:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)

return true
end

function bloodseeker_thirst_custom:OnSpellStart()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)


local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)
self:GetCaster():EmitSound("BS.Thirst_legendary_active")

local mod = self:GetCaster():FindModifierByName("modifier_bloodseeker_thirst_custom_legendary")
mod.perma_stack = mod.perma_stack + self.legendary_perma
mod:SetStackCount(mod:GetStackCount() - self.legendary_max + self.legendary_perma)

end



modifier_bloodseeker_thirst_custom = class({})

function modifier_bloodseeker_thirst_custom:IsHidden() return true end
function modifier_bloodseeker_thirst_custom:IsPurgable() return false end

function modifier_bloodseeker_thirst_custom:OnCreated()
	self.min_bonus_pct = self:GetAbility():GetSpecialValueFor("min_bonus_pct")
	self.max_bonus_pct = self:GetAbility():GetSpecialValueFor("max_bonus_pct")
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.hero_kill_heal = self:GetAbility():GetSpecialValueFor("hero_kill_heal")
	self.creep_kill_heal = self:GetAbility():GetSpecialValueFor("creep_kill_heal")
	self.half_bonus_aoe = self:GetAbility():GetSpecialValueFor("half_bonus_aoe")
	self.visibility_threshold_pct = self:GetAbility():GetSpecialValueFor("visibility_threshold_pct")
	self.invis_threshold_pct = self:GetAbility():GetSpecialValueFor("invis_threshold_pct")
	self.linger_duration = self:GetAbility():GetSpecialValueFor("linger_duration")
if not IsServer() then return end
self:StartIntervalThink(0.1)
self.dist = 0
self.pos = self:GetParent():GetAbsOrigin()
end


function modifier_bloodseeker_thirst_custom:OnRefresh(table)
self:OnCreated(table)
end


function modifier_bloodseeker_thirst_custom:OnIntervalThink()
if not IsServer() then return end

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	if self:GetParent():HasModifier("modifier_bloodseeker_thirst_6") then 
		self.max_bonus_pct = self:GetAbility():GetSpecialValueFor("max_bonus_pct") + self:GetAbility().trash_max

		local count = 0
		for _,target in pairs(enemies) do 
			if target:HasModifier("modifier_bloodseeker_thirst_custom_debuff") and 
				(target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility().trash_radius then 
					count = count + 1
			end
		end

		if count > 0 then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_resist", {})
		else 
			self:GetCaster():RemoveModifierByName("modifier_bloodseeker_thirst_custom_resist")
		end
	end



	for i = #enemies, 1, -1 do
        if enemies[i] ~= nil and not enemies[i]:IsAlive() then
            table.remove(enemies, i)
        end
    end

	if #enemies <= 0 then 
		self:SetStackCount(0) 
	end

	table.sort( enemies, function(x,y) return y:GetHealth() < x:GetHealth() end )

	local enemy_target = enemies[#enemies]
	local enemyHp = 0

	if (enemy_target and enemy_target:GetHealthPercent() < self.max_bonus_pct) or self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_kill")
	 then 
	 	if not self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_visual") then 

	 		if self:GetParent():IsAlive() then 
	 			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "bloodseeker_blod_ability_thirst_0"..math.random(1,3)})
	 		end

			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_visual", {})
		end
	else 

		self:GetParent():RemoveModifierByName("modifier_bloodseeker_thirst_custom_visual")
	end



	if enemy_target and not enemy_target:IsNull() and enemy_target:IsRealHero() and enemy_target:IsAlive() then

		if enemy_target:GetHealthPercent() < self.min_bonus_pct then
			enemyHp = (self.min_bonus_pct - enemy_target:GetHealthPercent())
			if enemyHp > (self.min_bonus_pct - self.max_bonus_pct) then 
				enemyHp = (self.min_bonus_pct - self.max_bonus_pct)
				enemy_target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_debuff", {})
			elseif enemy_target:HasModifier("modifier_bloodseeker_thirst_custom_debuff") then
				enemy_target:RemoveModifierByName("modifier_bloodseeker_thirst_custom_debuff")
			end
		end
	end

	for _, enemy in pairs(enemies) do

		if enemy:GetHealthPercent() < self.max_bonus_pct and self:GetParent():IsAlive() then 
			enemy_target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_debuff", {})
		end

		if enemy:GetHealthPercent() > self.max_bonus_pct or not self:GetParent():IsAlive() then 
			enemy:RemoveModifierByName("modifier_bloodseeker_thirst_custom_debuff")
		end


	end



	self:SetStackCount(enemyHp)

end

function modifier_bloodseeker_thirst_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_bloodseeker_thirst_custom:GetModifierMoveSpeedBonus_Percentage(params)
if self:GetParent():PassivesDisabled() then return end
local max_bonus_pct =  self:GetAbility():GetSpecialValueFor("max_bonus_pct")

if self:GetParent():HasModifier("modifier_bloodseeker_thirst_6") then 
	max_bonus_pct = max_bonus_pct + self:GetAbility().trash_max
end


local bonus = 0
local k = self:GetStackCount() / (self.min_bonus_pct - max_bonus_pct)
if self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_kill") or self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_vision") then 
	k = 1
end

if self:GetCaster():HasModifier("modifier_bloodseeker_thirst_2") then 
	bonus = self:GetAbility().bonus_speed[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_thirst_2")]
end

	return k * (self.bonus_movement_speed + bonus) 
end







function modifier_bloodseeker_thirst_custom:GetModifierBaseDamageOutgoing_Percentage()
if self:GetParent():PassivesDisabled() then return end
local max_bonus_pct =  self:GetAbility():GetSpecialValueFor("max_bonus_pct")

if self:GetParent():HasModifier("modifier_bloodseeker_thirst_6") then 
	max_bonus_pct = max_bonus_pct + self:GetAbility().trash_max
end


local k = self:GetStackCount() / (self.min_bonus_pct - max_bonus_pct)
if self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_kill") or self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_vision") then 
	k = 1
end

if self:GetCaster():HasModifier("modifier_bloodseeker_thirst_1") then 
	return k * self:GetAbility().bonus_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_thirst_1")]  
end

end











function modifier_bloodseeker_thirst_custom:GetModifierMoveSpeed_Max( params )
    return 30000
end

function modifier_bloodseeker_thirst_custom:GetModifierMoveSpeed_Limit( params )
    return 30000
end

function modifier_bloodseeker_thirst_custom:GetModifierIgnoreMovespeedLimit( params )
    return 1
end

function modifier_bloodseeker_thirst_custom:OnDeath( params )
if params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if params.unit == self:GetParent() then return end

if params.unit:IsRealHero() and not params.unit:IsReincarnating() then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_kill", {duration = self:GetAbility():GetSpecialValueFor("linger_duration")})
end

if params.unit:IsCreep() and params.attacker == self:GetParent() and self:GetParent():HasModifier("modifier_bloodseeker_thirst_5")
	and not self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_vision") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_vision_count", {})

end

local distance = (params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

if distance > self:GetAbility():GetSpecialValueFor("half_bonus_aoe") and params.attacker ~= self:GetParent() then return end

local heal = 0
if params.unit:IsRealHero() then
	heal = params.unit:GetMaxHealth() / 100 * self.hero_kill_heal
else
	if params.unit:IsCreep() then 
	    heal = params.unit:GetMaxHealth() / 100 * self.creep_kill_heal
	end
end

if self:GetParent():HasModifier("modifier_bloodseeker_blood_mist_custom") then
	heal = heal * ( 1 + self:GetParent():FindAbilityByName("bloodseeker_blood_mist_custom"):GetSpecialValueFor("thirst_bonus_pct")/100)
end

self:GetParent():Heal(heal, self:GetAbility())

SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), heal, nil)

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( effect_cast )

end

modifier_bloodseeker_thirst_custom_debuff = class({})

function modifier_bloodseeker_thirst_custom_debuff:IsPurgable() return false end

function modifier_bloodseeker_thirst_custom_debuff:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_bloodseeker_thirst_custom_debuff:OnIntervalThink()
	if not IsServer() then return end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 75, FrameTime(), false)
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_truesight", {duration = FrameTime() * 2})
end

function modifier_bloodseeker_thirst_custom_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_thirst_vision.vpcf"
end






modifier_bloodseeker_thirst_custom_visual = class({})

function modifier_bloodseeker_thirst_custom_visual:IsPurgable() return false end

function modifier_bloodseeker_thirst_custom_visual:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_bloodseeker_thirst_custom_visual:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end

function modifier_bloodseeker_thirst_custom_visual:GetActivityTranslationModifiers()
	return "thirst"
end







modifier_bloodseeker_thirst_custom_kill = class({})
function modifier_bloodseeker_thirst_custom_kill:IsHidden() return true end
function modifier_bloodseeker_thirst_custom_kill:IsPurgable() return false end


modifier_bloodseeker_thirst_custom_resist = class({})
function modifier_bloodseeker_thirst_custom_resist:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_resist:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_resist:GetTexture() return "buffs/thirst_trash" end
function modifier_bloodseeker_thirst_custom_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end

function modifier_bloodseeker_thirst_custom_resist:GetModifierBaseAttackTimeConstant()
return self:GetAbility().trash_bva
end

function modifier_bloodseeker_thirst_custom_resist:GetModifierStatusResistanceStacking() 
return self:GetAbility().trash_resist
end



function modifier_bloodseeker_thirst_custom_resist:OnCreated(table)
if not IsServer() then return end
	local particle = ParticleManager:CreateParticle( "particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( particle, false, false, -1, false, false  )
end


modifier_bloodseeker_thirst_custom_legendary = class({})
function modifier_bloodseeker_thirst_custom_legendary:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_legendary:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_legendary:GetTexture() return "buffs/thirst_legendary" end

function modifier_bloodseeker_thirst_custom_legendary:RemoveOnDeath() return false end

function modifier_bloodseeker_thirst_custom_legendary:OnStackCountChanged(iStackCount)
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'BloodSeeker_change',  {max = self:GetAbility().legendary_max, rage = self:GetStackCount() - self.perma_stack})
if self:GetStackCount() >= self:GetAbility().legendary_max + self.perma_stack then 
	self:GetAbility():SetActivated(true)
else 
	self:GetAbility():SetActivated(false)
end

end


function modifier_bloodseeker_thirst_custom_legendary:GiveStack(count)
if not IsServer() then return end

self:GetParent():EmitSound("BS.Thirst_legendary_stack")

for i = 1,count do 
	if self:GetStackCount() < self:GetAbility().legendary_max + self.perma_stack then 
		self:IncrementStackCount()
	end
end



end



function modifier_bloodseeker_thirst_custom_legendary:OnDeath(params)
if not IsServer() then return end

if params.unit == self:GetParent() then 
	self:SetStackCount((self:GetStackCount() - self.perma_stack) * ( 1 - self:GetAbility().legendary_death) + self.perma_stack)
end


if self:GetStackCount() >= self:GetAbility().legendary_max + self.perma_stack then return end

if params.unit:IsCreep() and self:GetParent() == params.attacker then 
	self.creeps = self.creeps + 1
	if self.creeps >= self:GetAbility().legendary_creeps_count then 
		self.creeps = 0
		self:GiveStack(1)
	end
end

if params.unit:IsRealHero() and params.unit:GetTeamNumber() ~= self:GetParent():GetTeamNumber()
 and ((self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() < self:GetAbility().legendary_heroes_radius 
	or params.attacker == self:GetParent()) then 
	self:GiveStack(self:GetAbility().legendary_heroes_stack)
end


end


function modifier_bloodseeker_thirst_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.perma_stack = 0
self:StartIntervalThink(0.5)
self:SetStackCount(0)
self.creeps = 0
end




function modifier_bloodseeker_thirst_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.str  = 0
self.str   = self:GetParent():GetStrength() * self:GetAbility().legendary_str * self:GetStackCount()

self.agi  = 0
self.agi   = self:GetParent():GetAgility() * self:GetAbility().legendary_agi * self:GetStackCount()

self:GetParent():CalculateStatBonus(true)
end


function modifier_bloodseeker_thirst_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_bloodseeker_thirst_custom_legendary:GetModifierBonusStats_Agility()
return self.agi
end

function modifier_bloodseeker_thirst_custom_legendary:GetModifierBonusStats_Strength()
return self.str
end


function modifier_bloodseeker_thirst_custom_legendary:OnTooltip()
return self:GetStackCount()
end



modifier_bloodseeker_thirst_custom_attack = class({})
function modifier_bloodseeker_thirst_custom_attack:IsHidden() 
	return self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_attack_cd")
end
function modifier_bloodseeker_thirst_custom_attack:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_attack:RemoveOnDeath() return false end
function modifier_bloodseeker_thirst_custom_attack:GetTexture() return "buffs/Thirst_attack" end
function modifier_bloodseeker_thirst_custom_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end
function modifier_bloodseeker_thirst_custom_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end
if self:GetParent():HasModifier("modifier_bloodseeker_thirst_custom_attack_cd") then return end

local cd = self:GetAbility().attack_cd_max - self:GetAbility().attack_cd_reduction*math.min(1, (self:GetParent():GetAgility()/self:GetAbility().attack_agility_max))

local damage = self:GetParent():GetMaxHealth() *self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_thirst_4")]

params.target:EmitSound("BS.Thirst_attack")
self:GetParent():EmitSound("BS.Thirst_legendary_stack")

ApplyDamage({attacker = self:GetCaster(), victim = params.target, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility(), damage = damage, })
SendOverheadEventMessage(params.target, 4, params.target, damage, nil)

local forward = ( params.target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW,  params.target )
ParticleManager:SetParticleControlEnt(effect_cast,0, params.target,PATTACH_POINT_FOLLOW,"attach_hitloc",params.target:GetOrigin(),true )
ParticleManager:SetParticleControlEnt(effect_cast,1, params.target,PATTACH_POINT_FOLLOW,"attach_hitloc", params.target:GetOrigin(),true )
ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
ParticleManager:ReleaseParticleIndex( effect_cast )


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( effect_cast )

my_game:GenericHeal(self:GetParent(), damage, self:GetAbility())

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_attack_cd", {duration = cd})
end


function modifier_bloodseeker_thirst_custom_attack:OnTooltip()
return self:GetAbility().attack_cd_max - self:GetAbility().attack_cd_reduction* math.min(1,(self:GetParent():GetAgility()/self:GetAbility().attack_agility_max))
end

function modifier_bloodseeker_thirst_custom_attack:OnTooltip2()
return self:GetParent():GetMaxHealth()*self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_thirst_4")]
end


modifier_bloodseeker_thirst_custom_attack_cd = class({})
function modifier_bloodseeker_thirst_custom_attack_cd:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_attack_cd:IsPurgable() return false end

function modifier_bloodseeker_thirst_custom_attack_cd:GetTexture() return "buffs/Thirst_attack" end
function modifier_bloodseeker_thirst_custom_attack_cd:RemoveOnDeath() return false end
function modifier_bloodseeker_thirst_custom_attack_cd:IsDebuff() return true end
function modifier_bloodseeker_thirst_custom_attack_cd:OnCreated(table)
self.RemoveForDuel = true
end







modifier_bloodseeker_thirst_custom_vision = class({})
function modifier_bloodseeker_thirst_custom_vision:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_vision:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_vision:GetTexture() return "buffs/Thirst_vision" end

function modifier_bloodseeker_thirst_custom_vision:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_bloodseeker_thirst_custom_vision:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_bloodseeker_thirst_custom_vision:GetActivityTranslationModifiers()
	return "thirst"
end


function modifier_bloodseeker_thirst_custom_vision:OnTooltip()
return self:GetAbility().vision_radius
end



function modifier_bloodseeker_thirst_custom_vision:OnCreated(table)
if not IsServer() then return end

if self:GetParent():IsAlive() then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "bloodseeker_blod_ability_thirst_0"..math.random(1,3)})

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "BS.Thirst_vision"})
end

self.particle_ally_fx = ParticleManager:CreateParticle("particles/bloodseeker_vision.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)  

self:StartIntervalThink(0.2)
end

function modifier_bloodseeker_thirst_custom_vision:OnIntervalThink()
if not IsServer() then return end


local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)


for _,hero in pairs(heroes) do 
    AddFOWViewer(self:GetCaster():GetTeamNumber(), hero:GetAbsOrigin(), 10, 0.2, false)
end


end




modifier_bloodseeker_thirst_custom_vision_count = class({})
function modifier_bloodseeker_thirst_custom_vision_count:IsHidden() return false end
function modifier_bloodseeker_thirst_custom_vision_count:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_vision_count:RemoveOnDeath() return false end
function modifier_bloodseeker_thirst_custom_vision_count:GetTexture() return "buffs/Thirst_vision" end
function modifier_bloodseeker_thirst_custom_vision_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)



end

function modifier_bloodseeker_thirst_custom_vision_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
if self:GetStackCount() >= self:GetAbility().vision_creeps then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_thirst_custom_vision", {duration = self:GetAbility().vision_duration})
	self:Destroy()
end

end


function modifier_bloodseeker_thirst_custom_vision_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_bloodseeker_thirst_custom_vision_count:OnTooltip()
return self:GetAbility().vision_creeps
end


modifier_bloodseeker_thirst_custom_heal = class({})
function modifier_bloodseeker_thirst_custom_heal:IsHidden() return 
self:GetStackCount() == 1
end
function modifier_bloodseeker_thirst_custom_heal:IsPurgable() return false end
function modifier_bloodseeker_thirst_custom_heal:RemoveOnDeath() return false end
function modifier_bloodseeker_thirst_custom_heal:GetTexture() return "buffs/thirst_heal" end


function modifier_bloodseeker_thirst_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_bloodseeker_thirst_custom_heal:GetModifierHealthRegenPercentage()
if self:GetStackCount() == 1 then return end
return self:GetAbility().heal_value[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_thirst_3")]
end


function modifier_bloodseeker_thirst_custom_heal:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.3)
end


function modifier_bloodseeker_thirst_custom_heal:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().heal_dist, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
local stack = 1
for _,enemy in pairs(enemies) do 
	if enemy:GetHealthPercent() <= self:GetAbility().heal_health and enemy:IsAlive() then 
		stack = 0
		break 
	end
end

self:SetStackCount(stack)
end