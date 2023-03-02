LinkLuaModifier( "modifier_sven_warcry_custom", "abilities/sven/sven_warcry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_warcry_custom_slow", "abilities/sven/sven_warcry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_warcry_custom_tracker", "abilities/sven/sven_warcry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_warcry_custom_legendary", "abilities/sven/sven_warcry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_warcry_custom_quest", "abilities/sven/sven_warcry_custom", LUA_MODIFIER_MOTION_NONE )

sven_warcry_custom = class({})

sven_warcry_custom.bonus_armor = {4, 6, 8}
sven_warcry_custom.bonus_move = {4, 6, 8}

sven_warcry_custom.cd_inc = {-2, -4, -6}
sven_warcry_custom.duration_inc = {1, 1.5, 2}

sven_warcry_custom.armor_damage = {0.3, 0.5, 0.7}

sven_warcry_custom.reduce_armor = {-0.15, -0.25}
sven_warcry_custom.reduce_move = {-20, -30}
sven_warcry_custom.reduce_duration = 6

sven_warcry_custom.dispel_delay = 3

sven_warcry_custom.lowhp_armor = 12
sven_warcry_custom.lowhp_magic = 25
sven_warcry_custom.lowhp_min = 15

sven_warcry_custom.legendary_duration = 4
sven_warcry_custom.legendary_radius = 500
sven_warcry_custom.legendary_shield = 12
sven_warcry_custom.legendary_damage = 1.2
sven_warcry_custom.legendary_stun = 0.2
sven_warcry_custom.legendary_status = 50




function sven_warcry_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("radius")
end


function sven_warcry_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_sven_cry_5") then 
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end

return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET
end


function sven_warcry_custom:GetIntrinsicModifierName()
return "modifier_sven_warcry_custom_tracker"
end



function sven_warcry_custom:GetCooldown(iLevel)

local bonus = 0

if self:GetCaster():HasModifier("modifier_sven_cry_2") then
	bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_sven_cry_2")]
end

return self.BaseClass.GetCooldown(self, iLevel) + bonus
end




function sven_warcry_custom:OnSpellStart()
if not IsServer() then return end

local warcry_radius = self:GetSpecialValueFor( "radius" ) 
local warcry_duration = self:GetSpecialValueFor(  "duration" )

if self:GetCaster():HasModifier("modifier_sven_cry_2") then 
	--warcry_duration = warcry_duration + self.duration_inc[self:GetCaster():GetUpgradeStack("modifier_sven_cry_2")]
end

if self:GetCaster():GetQuest() == "Sven.Quest_7" and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_warcry_custom_quest", {duration = self:GetCaster().quest.number})
end


if self:GetCaster():HasModifier("modifier_sven_cry_5") then 
	self:GetCaster():Purge(false, true, false, false, false)

	self:GetCaster():EmitSound("Brewmaster_Storm.DispelMagic")
    
	local effect_cast = ParticleManager:CreateParticle( "particles/cleance_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetCaster())
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(200,0,0) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), warcry_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,ally in pairs(allies) do
	ally:AddNewModifier( self:GetCaster(), self, "modifier_sven_warcry_custom", { duration = warcry_duration } )
end

if self:GetCaster():GetName() == "npc_dota_hero_sven" then
	self:GetCaster():EmitSound("sven_sven_ability_warcry_0"..RandomInt(1, 4))
end



Timers:CreateTimer(0.1, function()
	if not self:GetCaster() then return end

	if self:GetCaster():HasModifier("modifier_sven_cry_4") then 

		local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), warcry_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

		for _,target in pairs(targets) do
			target:AddNewModifier( self:GetCaster(), self, "modifier_sven_warcry_custom_slow", { duration =  self.reduce_duration } )
		end

	end

	if self:GetCaster():HasModifier("modifier_sven_cry_7") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_warcry_custom_legendary", {duration = self.legendary_duration})
	end
end)



local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( nFXIndex )

self:GetCaster():EmitSound("Hero_Sven.WarCry")

--self:EndCooldown()
--self:SetActivated(false)

self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_3 );
end







modifier_sven_warcry_custom = class({})


function modifier_sven_warcry_custom:IsPurgable()
	return not self:GetParent():HasShard()
end


function modifier_sven_warcry_custom:OnCreated( kv )

self.warcry_armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
self.warcry_movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )

if not IsServer() then return end

self.RemoveForDuel = true

self.no_slow = false

if self:GetParent():HasModifier("modifier_sven_cry_5") then 
	self.no_slow = true

	self.speed_part = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( self.speed_part, false, false, -1, false, true )

	self:StartIntervalThink(self:GetAbility().dispel_delay)

end


local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_head", self:GetCaster():GetOrigin(), true )
self:AddParticle( nFXIndex, false, false, -1, false, true )
end



function modifier_sven_warcry_custom:OnIntervalThink()
if not IsServer() then return end

self.no_slow = false

ParticleManager:DestroyParticle(self.speed_part, false)
ParticleManager:ReleaseParticleIndex(self.speed_part)

self:StartIntervalThink(-1)
end


function modifier_sven_warcry_custom:OnDestroy()
if not IsServer() then return end
if self:GetParent() ~= self:GetCaster() then return end

--self:GetAbility():SetActivated(true)
--self:GetAbility():UseResources(false, false, true)

end


function modifier_sven_warcry_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end


function modifier_sven_warcry_custom:CheckState()
if self.no_slow == false then return end

return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}

end


function modifier_sven_warcry_custom:GetActivityTranslationModifiers( params )
	if self:GetParent() == self:GetCaster() then
		return "sven_warcry"
	end

	return 0
end


function modifier_sven_warcry_custom:GetEffectName() return "particles/items2_fx/medallion_of_courage_friend_shield.vpcf" end
 
function modifier_sven_warcry_custom:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


function modifier_sven_warcry_custom:GetModifierMoveSpeedBonus_Percentage( params )
local bonus = 0
if self:GetCaster():HasModifier("modifier_sven_cry_1") then 
	bonus = self:GetAbility().bonus_move[self:GetCaster():GetUpgradeStack("modifier_sven_cry_1")]
end

	return self.warcry_movespeed + bonus
end


function modifier_sven_warcry_custom:GetModifierPhysicalArmorBonus( params )
local bonus = 0
if self:GetCaster():HasModifier("modifier_sven_cry_1") then 
	bonus = self:GetAbility().bonus_move[self:GetCaster():GetUpgradeStack("modifier_sven_cry_1")]
end

	return self.warcry_armor + bonus
end


function modifier_sven_warcry_custom:GetModifierBaseAttack_BonusDamage()
if not self:GetParent():HasModifier("modifier_sven_cry_3") then return end

return self:GetParent():GetPhysicalArmorValue(false)*self:GetAbility().armor_damage[self:GetParent():GetUpgradeStack("modifier_sven_cry_3")]
end





modifier_sven_warcry_custom_slow = class({})
function modifier_sven_warcry_custom_slow:IsHidden() return false end
function modifier_sven_warcry_custom_slow:IsPurgable() return false end
function modifier_sven_warcry_custom_slow:GetTexture() return "buffs/cry_reduce" end

function modifier_sven_warcry_custom_slow:OnCreated(table)

self.armor = math.min(-0.1,  self:GetAbility().reduce_armor[self:GetCaster():GetUpgradeStack("modifier_sven_cry_4")]*self:GetCaster():GetPhysicalArmorValue(false))
self.move = self:GetAbility().reduce_move[self:GetCaster():GetUpgradeStack("modifier_sven_cry_4")]

if not IsServer() then return end
self:StartIntervalThink(0.2)

self:GetParent():EmitSound("Hoodwink.Acorn_armor")
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end




function modifier_sven_warcry_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_sven_warcry_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_sven_warcry_custom_slow:GetModifierPhysicalArmorBonus()
return self.armor
end


function modifier_sven_warcry_custom_slow:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_sven_warcry_custom_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sven_warcry_custom_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_sven_warcry_custom_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end



modifier_sven_warcry_custom_tracker = class({})
function modifier_sven_warcry_custom_tracker:IsHidden() 
	return not self:GetParent():HasModifier("modifier_sven_cry_6") 
end
function modifier_sven_warcry_custom_tracker:IsPurgable() return false end
function modifier_sven_warcry_custom_tracker:GetTexture() return "buffs/cry_lowhp" end
function modifier_sven_warcry_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_sven_warcry_custom_tracker:GetModifierStatusResistanceStacking() 
if self:GetParent():HasShard() then 
	return self:GetAbility():GetSpecialValueFor("shard_passive_status")
end

end



function modifier_sven_warcry_custom_tracker:GetModifierPhysicalArmorBonus()
local bonus = 0

if self:GetParent():HasModifier("modifier_sven_cry_6") and not self:GetParent():PassivesDisabled() then
	bonus = bonus +  math.min(self:GetAbility().lowhp_armor, (100 - self:GetParent():GetHealthPercent())*(self:GetAbility().lowhp_armor/(100 - self:GetAbility().lowhp_min)))
end

if self:GetParent():HasShard() then 
	bonus = bonus + self:GetAbility():GetSpecialValueFor("shard_passive_armor")
end

return bonus
end


function modifier_sven_warcry_custom_tracker:OnTooltip()
local bonus = 0

if self:GetParent():HasModifier("modifier_sven_cry_6") and not self:GetParent():PassivesDisabled() then
	bonus = bonus +  math.min(self:GetAbility().lowhp_armor, (100 - self:GetParent():GetHealthPercent())*(self:GetAbility().lowhp_armor/(100 - self:GetAbility().lowhp_min)))
end

return bonus
end


function modifier_sven_warcry_custom_tracker:GetModifierMagicalResistanceBonus()
if not self:GetParent():HasModifier("modifier_sven_cry_6") then return end
if self:GetParent():PassivesDisabled() then return end

return math.min(self:GetAbility().lowhp_magic, (100 - self:GetParent():GetHealthPercent())*(self:GetAbility().lowhp_magic/(100 - self:GetAbility().lowhp_min)))
end


modifier_sven_warcry_custom_legendary = class({})
function modifier_sven_warcry_custom_legendary:IsHidden() return false end
function modifier_sven_warcry_custom_legendary:IsPurgable() return false end
function modifier_sven_warcry_custom_legendary:GetTexture() return "buffs/cry_legendary" end
function modifier_sven_warcry_custom_legendary:OnCreated()
if not IsServer() then return end

self:GetParent():EmitSound("Sven.Cry_shield_loop")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_warcry_buff_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( particle, 1, Vector( 110, 1, 1 ) )
self:AddParticle( particle, false, false, 0, false, false )

self:GetParent():EmitSound("Hero_Pangolier.TailThump.Shield")

self.max = math.max(1, self:GetAbility().legendary_shield*self:GetParent():GetPhysicalArmorValue(false))
self.shield = self.max


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'sven_shield_change',  {max = self.max, damage = 0, time = 1})


self:SetStackCount(self.max)
self:StartIntervalThink(0.05)
end



function modifier_sven_warcry_custom_legendary:OnIntervalThink()
if not IsServer() then return end

local time = math.max(0, self:GetRemainingTime()/(self:GetElapsedTime() + self:GetRemainingTime()))


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'sven_shield_change',  {time = time, max = self.max, damage = math.floor(self.max - self:GetStackCount())})

end



function modifier_sven_warcry_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

    
function modifier_sven_warcry_custom_legendary:GetModifierStatusResistanceStacking() 
return self:GetAbility().legendary_status
end


function modifier_sven_warcry_custom_legendary:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end

if params.damage>=self.shield then
    self:SetStackCount(0)
    self:Destroy()
    return self.shield
else
    self.shield = self.shield-params.damage
    self:SetStackCount(self.shield)
    return params.damage
end

end


function modifier_sven_warcry_custom_legendary:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Sven.Cry_shield_loop")

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'sven_shield_hide',  {})


if self:GetStackCount() == self.max then return end

local damage = (self.max - self:GetStackCount())*self:GetAbility().legendary_damage

if damage <= 1 then 
	return 
end

self:GetParent():EmitSound("Sven.Cry_shield_break")
self:GetParent():EmitSound("Sven.Cry_shield_break2")

local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self:GetAbility().legendary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

local pfx = ParticleManager:CreateParticle( "particles/sven_shield_break.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,70) )
ParticleManager:ReleaseParticleIndex(pfx)




for _,enemy in pairs(enemies) do
	if  not enemy:IsMagicImmune() and not enemy:IsInvulnerable()  then
		ApplyDamage(  { victim = enemy, attacker = self:GetCaster(), damage = damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_PHYSICAL, })
		SendOverheadEventMessage(enemy, 4, enemy, damage, nil)

		enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility().legendary_stun})

		enemy:EmitSound("Sven.Cry_shield_damage")

		local particle = ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field_gold.vpcf", PATTACH_POINT_FOLLOW, enemy )
        ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
        ParticleManager:ReleaseParticleIndex( particle )

        local particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf", PATTACH_POINT_FOLLOW, enemy )
        ParticleManager:SetParticleControlEnt( particle2, 4, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
        ParticleManager:ReleaseParticleIndex( particle2 )

        local pfx2 = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_warcry_ti5/sven_warcry_cast_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControl( pfx2, 0, enemy:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(pfx2)
	end
end


end





modifier_sven_warcry_custom_quest = class({})
function modifier_sven_warcry_custom_quest:IsHidden() return true end
function modifier_sven_warcry_custom_quest:IsPurgable() return false end