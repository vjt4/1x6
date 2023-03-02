LinkLuaModifier("modifier_custom_pudge_rot","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_slow","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_tracker","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_str","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_silence","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_silence_timer","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_legendary_aura","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_legendary_aura_buff","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_poison","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_pudge_rot_poison_cd","abilities/pudge/custom_pudge_rot", LUA_MODIFIER_MOTION_NONE)

custom_pudge_rot = class({})

custom_pudge_rot.slow_init = 0
custom_pudge_rot.slow_inc = -4
custom_pudge_rot.slow_attack_init = -10
custom_pudge_rot.slow_attack_inc = -10

custom_pudge_rot.heal_init = 0
custom_pudge_rot.heal_inc = 0.04
custom_pudge_rot.heal_creep = 0.5

custom_pudge_rot.silence_timer = 5
custom_pudge_rot.silence_duration = 3

custom_pudge_rot.scepter_regeneration_debuff = -20


custom_pudge_rot.poison_timer = 10
custom_pudge_rot.poison_damage = {0.25, 0.4}
custom_pudge_rot.poison_heal = {0.25, 0.4}
custom_pudge_rot.poison_duration = 4
custom_pudge_rot.poison_radius = 400

custom_pudge_rot.magic_reduce = {-1,-1.5,-2}
custom_pudge_rot.magic_max = 10
custom_pudge_rot.magic_duration = 3

custom_pudge_rot.legendary_self_damage = 0.02
custom_pudge_rot.legendary_self_damage_stack = 0.01
custom_pudge_rot.legendary_pull = 4
custom_pudge_rot.legendary_damage = 0.3
custom_pudge_rot.legendary_radius = 600
custom_pudge_rot.legendary_cd = 2
custom_pudge_rot.legendary_max = 8
custom_pudge_rot.legendary_interval = 1

custom_pudge_rot.self_damage = 0.85
custom_pudge_rot.self_health = 20


function custom_pudge_rot:ResetToggleOnRespawn()	return true end



function custom_pudge_rot:OnInventoryContentsChanged()
local mod = self:GetCaster():FindModifierByName("modifier_custom_pudge_rot")

if not mod then return end
if not mod.pfx then return end
if not mod.rot_radius then return end

ParticleManager:SetParticleControl(mod.pfx, 1, Vector(mod.rot_radius, 1, mod.rot_radius))


end


function custom_pudge_rot:OnSpellStart()
if not IsServer() then return end

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_rot_legendary_aura", {duration = self.legendary_duration})
end

function custom_pudge_rot:GetIntrinsicModifierName()
return "modifier_custom_pudge_rot_tracker"
end

function custom_pudge_rot:GetCastRange()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("rot_radius") + self:GetSpecialValueFor("scepter_rot_radius_bonus")
	end
	return self:GetSpecialValueFor("rot_radius")
end

function custom_pudge_rot:OnToggle()
 if not IsServer() then return end

 if self:GetCaster():HasModifier("modifier_pudge_rot_legendary") then 
	self:StartCooldown(self.legendary_cd)
end

    if self:GetToggleState() then

    	if not self:GetCaster():HasModifier("modifier_pudge_rot_legendary") then 
	       	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_custom_pudge_rot", {} )
       	else 
	       	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_custom_pudge_rot_legendary_aura", {} )
       	end
    else
        if not self:GetCaster():HasModifier("modifier_pudge_rot_legendary") then 

        	if self:GetCaster():HasModifier("modifier_custom_pudge_rot") then 
	       		self:GetCaster():RemoveModifierByName("modifier_custom_pudge_rot")
	       	end

       	else 

	       	if self:GetCaster():HasModifier("modifier_custom_pudge_rot_legendary_aura") then 
	       		self:GetCaster():RemoveModifierByName("modifier_custom_pudge_rot_legendary_aura")
	       	end

       	end
    end
end

modifier_custom_pudge_rot = class({})

function modifier_custom_pudge_rot:IsPurgable() return false end
function modifier_custom_pudge_rot:IsDebuff() return true end
function modifier_custom_pudge_rot:IsHidden() return self:GetParent():HasModifier("modifier_pudge_rot_legendary") end

function modifier_custom_pudge_rot:RemoveOnDeath()
	return not self:GetParent():HasModifier("modifier_pudge_rot_legendary")
end

function modifier_custom_pudge_rot:OnCreated()
	if not IsServer() then return end

	local abil = self:GetAbility()
	self.rot_radius = abil:GetSpecialValueFor("rot_radius")
	self.rot_tick = abil:GetSpecialValueFor("rot_tick")
	self.rot_damage = abil:GetSpecialValueFor("rot_damage") * self.rot_tick
	self.last_rot_time = 0
	self.normal_particle =true

	 

	if self:GetCaster():HasScepter() then
		self.rot_radius = self.rot_radius + abil:GetSpecialValueFor("scepter_rot_radius_bonus")
		self.rot_damage = self.rot_damage + abil:GetSpecialValueFor("scepter_rot_damage_bonus")
	end

	self.rot_damage = self.rot_damage * self.rot_tick
	
	self.pfx = ParticleManager:CreateParticle("particles/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.rot_radius, 1, self.rot_radius))
	self:AddParticle(self.pfx, false, false, -1, false, false)	

	self:StartIntervalThink(0)
	
	if not self:GetParent():HasModifier("modifier_pudge_rot_legendary") then 
		self:GetParent():EmitSound("Hero_Pudge.Rot")
	else 
		self:GetParent():EmitSound("Pudge.Rot_legendary")
	end

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_ROT)
end

function modifier_custom_pudge_rot:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetCaster():IsAlive() then return end

	if self:GetCaster():HasModifier("modifier_custom_pudge_rot_legendary_aura") and self.normal_particle == true then 
		self.normal_particle = false
		ParticleManager:DestroyParticle(self.pfx, true)

		self.pfx = ParticleManager:CreateParticle("particles/pudge_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.rot_radius, 1, self.rot_radius))
		self:AddParticle(self.pfx, false, false, -1, false, false)

	end

	if not self:GetCaster():HasModifier("modifier_custom_pudge_rot_legendary_aura") and self.normal_particle == false then 
		self.normal_particle = true
		ParticleManager:DestroyParticle(self.pfx, true)


		self.pfx = ParticleManager:CreateParticle("particles/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.rot_radius, 1, self.rot_radius))
		self:AddParticle(self.pfx, false, false, -1, false, false)

	end


	local abil = self:GetAbility()
	self.rot_radius = abil:GetSpecialValueFor("rot_radius")
	self.rot_tick = abil:GetSpecialValueFor("rot_tick")
	self.rot_damage = abil:GetSpecialValueFor("rot_damage")

	local cur_time = GameRules:GetGameTime()
	if abil.last_rot_time ~= nil and (cur_time - abil.last_rot_time) < self.rot_tick then
		return
	end
	abil.last_rot_time = cur_time

	if self:GetCaster():HasScepter() then
		self.rot_radius = self.rot_radius + abil:GetSpecialValueFor("scepter_rot_radius_bonus")
		self.rot_damage = self.rot_damage + abil:GetSpecialValueFor("scepter_rot_damage_bonus")
	end
	

	self.rot_damage = self.rot_damage



	if self.pfx then
		ParticleManager:SetParticleControl(self.pfx, 1, Vector(self.rot_radius, 1, self.rot_radius))
	end
	
	local self_damage = self.rot_damage*self.rot_tick

	local damage_type = DAMAGE_TYPE_MAGICAL

	if self:GetCaster():HasModifier("modifier_pudge_rot_legendary") and not self:GetCaster():HasModifier("modifier_custom_pudge_rot_legendary_aura") then 
		self_damage = 0
	end 

	local mod = self:GetCaster():FindModifierByName("modifier_custom_pudge_rot_legendary_aura") 

	if self:GetCaster():HasModifier("modifier_pudge_rot_legendary") and mod then 

		self_damage = (self:GetCaster():GetMaxHealth()*(abil.legendary_self_damage + mod:GetStackCount()*abil.legendary_self_damage_stack))*self.rot_tick
		damage_type = DAMAGE_TYPE_PURE
	end 

	if self_damage ~= 0 then 

		local after_damage = self_damage

		local can_damage = true

		if self:GetCaster():HasModifier("modifier_pudge_rot_6") then 
			after_damage = after_damage*abil.self_damage

			if self:GetCaster():GetHealthPercent() <= abil.self_health then 
				can_damage = false
			end
		end


		if can_damage == true and not self:GetParent():IsMagicImmune() then 

			ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = after_damage, damage_type = damage_type, damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL, ability = self:GetAbility() })
		end
	end

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.rot_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(units) do

		local damage = self.rot_damage


		damage = damage*self.rot_tick

		if self:GetCaster():HasModifier("modifier_pudge_rot_legendary") and self:GetCaster():HasModifier("modifier_custom_pudge_rot_legendary_aura") and self_damage ~= 0 then 
			damage = damage + self_damage*abil.legendary_damage
		end

		if enemy:HasModifier("modifier_custom_pudge_rot_poison") then 
			damage = damage*(1 + self:GetAbility().poison_damage[self:GetCaster():GetUpgradeStack("modifier_pudge_rot_4")])
		end


		ApplyDamage({ victim = enemy, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, ability = self:GetAbility() })
	

	end
end

function modifier_custom_pudge_rot:OnDestroy()
if not IsServer() then return end

		self:GetParent():StopSound("Hero_Pudge.Rot")
		self:GetParent():StopSound("Pudge.Rot_legendary")
		if self:GetParent():GetModelName() == "models/heroes/pudge_cute/pudge_cute.vmdl" then 
			self:GetParent():StopSound("Hero_Pudge.Rot.Persona")
		end
end

function modifier_custom_pudge_rot:IsAura()	
	return true 
end

function modifier_custom_pudge_rot:IsAuraActiveOnDeath() 
	return false 
end

function modifier_custom_pudge_rot:GetAuraRadius() 
	if self.rot_radius then 
		return self.rot_radius 
	end 
end

function modifier_custom_pudge_rot:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_custom_pudge_rot:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_custom_pudge_rot:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
end

function modifier_custom_pudge_rot:GetModifierAura() 
	return "modifier_custom_pudge_rot_slow" 
end





modifier_custom_pudge_rot_slow = class({})

function modifier_custom_pudge_rot_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}
end



function modifier_custom_pudge_rot_slow:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(1)
end

function modifier_custom_pudge_rot_slow:OnIntervalThink()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_pudge_rot_2") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_rot_str", {duration = self:GetAbility().magic_duration})
end

if self:GetCaster():HasModifier("modifier_pudge_rot_5") and not self:GetParent():HasModifier("modifier_custom_pudge_rot_silence") then 
 	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_rot_silence_timer", {duration = 1.1})
end




end





function modifier_custom_pudge_rot_slow:GetModifierLifestealRegenAmplify_Percentage()
	if self:GetCaster():HasScepter() then
		return self:GetAbility().scepter_regeneration_debuff
	end
	return 0
end


function modifier_custom_pudge_rot_slow:GetModifierHealAmplify_PercentageTarget()
	if self:GetCaster():HasScepter() then
		return self:GetAbility().scepter_regeneration_debuff
	end
	return 0
end

function modifier_custom_pudge_rot_slow:GetModifierHPRegenAmplify_Percentage()
	if self:GetCaster():HasScepter() then
		return self:GetAbility().scepter_regeneration_debuff
	end
	return 0
end

function modifier_custom_pudge_rot_slow:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetCaster():HasModifier("modifier_pudge_rot_1") then 
	bonus = self:GetAbility().slow_init + self:GetAbility().slow_inc*self:GetCaster():GetUpgradeStack("modifier_pudge_rot_1")
end
	return self:GetAbility():GetSpecialValueFor("rot_slow") + bonus
end


function modifier_custom_pudge_rot_slow:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_pudge_rot_1") then 
	bonus = self:GetAbility().slow_attack_init + self:GetAbility().slow_attack_inc*self:GetCaster():GetUpgradeStack("modifier_pudge_rot_1")
end
	return  bonus
end








modifier_custom_pudge_rot_tracker = class({})
function modifier_custom_pudge_rot_tracker:IsHidden() return true end
function modifier_custom_pudge_rot_tracker:IsPurgable() return false end
function modifier_custom_pudge_rot_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_custom_pudge_rot_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = 0

if self:GetParent():HasModifier("modifier_pudge_rot_4") and params.unit:HasModifier("modifier_custom_pudge_rot_poison") then 
	local more_heal = (self:GetAbility().poison_heal[self:GetCaster():GetUpgradeStack("modifier_pudge_rot_4")])*params.damage

	if not params.unit:IsHero() then 
		more_heal = more_heal*self:GetAbility().heal_creep
	end

	heal = heal + more_heal

	local particle = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( particle )

	if params.unit:IsHero() then 
		SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), more_heal, nil)
	end

end


if self:GetParent():HasModifier("modifier_pudge_rot_3") and params.inflictor == self:GetAbility() then 

	local more_heal = (self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetParent():GetUpgradeStack("modifier_pudge_rot_3"))*params.damage

	if not params.unit:IsHero() then 
		more_heal = more_heal*self:GetAbility().heal_creep
	end

	heal = heal + more_heal
end



self:GetParent():Heal(heal, self:GetAbility())

end



function modifier_custom_pudge_rot_tracker:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(1)
end


function modifier_custom_pudge_rot_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_pudge_rot_4") then return end
if not self:GetParent():IsAlive() then return end

local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().poison_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)



local wave_particle = ParticleManager:CreateParticle( "particles/pudge_poison.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(wave_particle)

for _,unit in pairs(units) do
	unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_rot_poison", {duration = self:GetAbility().poison_duration})
end

self:GetParent():EmitSound("Pudge.Rot_poison")

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_rot_poison_cd", {duration = self:GetAbility().poison_timer})
self:StartIntervalThink(self:GetAbility().poison_timer)
end














modifier_custom_pudge_rot_str = class({})
function modifier_custom_pudge_rot_str:IsHidden() 
return false
end
function modifier_custom_pudge_rot_str:IsPurgable() return false end

function modifier_custom_pudge_rot_str:OnCreated(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().magic_max then return end

self:IncrementStackCount()
if self:GetParent():IsHero() then 
	self:GetParent():CalculateStatBonus(true)
end

end

function modifier_custom_pudge_rot_str:GetTexture()
return "buffs/sunder_speed"
end


function modifier_custom_pudge_rot_str:OnRefresh(table)
self:OnCreated(table)
end


function modifier_custom_pudge_rot_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_custom_pudge_rot_str:GetModifierMagicalResistanceBonus()
if not self:GetCaster():HasModifier("modifier_pudge_rot_2") then return end
return self:GetStackCount()*(self:GetAbility().magic_reduce[self:GetCaster():GetUpgradeStack("modifier_pudge_rot_2")])
end 





modifier_custom_pudge_rot_silence_timer	 = class({})
function modifier_custom_pudge_rot_silence_timer:IsHidden() return true end
function modifier_custom_pudge_rot_silence_timer:IsPurgable() return true end
function modifier_custom_pudge_rot_silence_timer:OnCreated(table)
if not IsServer() then return end

local particle_cast = "particles/units/heroes/hero_drow/rot_silence_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

self:AddParticle(self.effect_cast,false, false, -1, false, false)


self:SetStackCount(1)
end

function modifier_custom_pudge_rot_silence_timer:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount() + 1)

if self:GetStackCount() == self:GetAbility().silence_timer then 
	self:GetParent():EmitSound("Pudge.Rot_Silence")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_rot_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().silence_duration})
	self:Destroy()
end
end


function modifier_custom_pudge_rot_silence_timer:OnStackCountChanged(iStackCount)

if self.effect_cast then 
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


end








modifier_custom_pudge_rot_silence = class({})
function modifier_custom_pudge_rot_silence:IsHidden() return false end
function modifier_custom_pudge_rot_silence:IsPurgable() return true end
function modifier_custom_pudge_rot_silence:GetTexture() return "buffs/rot_silence" end
function modifier_custom_pudge_rot_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_custom_pudge_rot_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_custom_pudge_rot_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end








modifier_custom_pudge_rot_legendary_aura = class({})



function modifier_custom_pudge_rot_legendary_aura:IsDebuff() return false end
function modifier_custom_pudge_rot_legendary_aura:IsHidden() return false end
function modifier_custom_pudge_rot_legendary_aura:IsPurgable() return false end

function modifier_custom_pudge_rot_legendary_aura:GetAuraRadius()
local radius = self:GetAbility().legendary_radius
return radius
end

function modifier_custom_pudge_rot_legendary_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end


function modifier_custom_pudge_rot_legendary_aura:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(0)


self:GetParent():EmitSound("Hero_Pudge.Rot")
self:GetParent():StopSound("Pudge.Rot_legendary")

self:StartIntervalThink(self:GetAbility().legendary_interval)
end


function modifier_custom_pudge_rot_legendary_aura:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().legendary_max then return end

self:IncrementStackCount()
end


function modifier_custom_pudge_rot_legendary_aura:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self:GetStackCount() == 0 then 
	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
end

ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
self:AddParticle(self.pfx, false, false, -1, false, false)


end


function modifier_custom_pudge_rot_legendary_aura:GetAuraEntityReject(hEntity)
if hEntity:IsInvulnerable() or hEntity:IsMagicImmune() then return true end
return false
end
function modifier_custom_pudge_rot_legendary_aura:GetAuraDuration()
	return 0
end


function modifier_custom_pudge_rot_legendary_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_pudge_rot_legendary_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_custom_pudge_rot_legendary_aura:GetModifierAura()
	return "modifier_custom_pudge_rot_legendary_aura_buff"

end

function modifier_custom_pudge_rot_legendary_aura:IsAura()

return true
end


function modifier_custom_pudge_rot_legendary_aura:OnDestroy()
if not IsServer() then return end
	self:GetParent():StopSound("Hero_Pudge.Rot")
	if self:GetParent():GetModelName() == "models/heroes/pudge_cute/pudge_cute.vmdl" then 
		self:GetParent():StopSound("Hero_Pudge.Rot.Persona")
	end

	self:GetParent():EmitSound("Pudge.Rot_legendary")
end


modifier_custom_pudge_rot_legendary_aura_buff = class({})
function modifier_custom_pudge_rot_legendary_aura_buff:IsHidden() return true end
function modifier_custom_pudge_rot_legendary_aura_buff:IsPurgable() return false end

function modifier_custom_pudge_rot_legendary_aura_buff:OnCreated(table)
if not IsServer() then return end

self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/pudge_pull.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
self:AddParticle(self.pfx, false, false, -1, false, false)	

self:StartIntervalThink(0)
end

function modifier_custom_pudge_rot_legendary_aura_buff:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():IsInvulnerable() or self:GetParent():IsMagicImmune() then return end 

	local vect = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() >= 100 then 
		self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() - vect*self:GetAbility().legendary_pull)
	end

end

function modifier_custom_pudge_rot_legendary_aura_buff:OnDestroy()
if not IsServer() then return end
if self:GetParent():IsInvulnerable() or self:GetParent():IsMagicImmune() then return end 
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)

end















modifier_custom_pudge_rot_poison = class({})
function modifier_custom_pudge_rot_poison:IsHidden() return false end
function modifier_custom_pudge_rot_poison:GetTexture()
return "buffs/goo_ground"
end


function modifier_custom_pudge_rot_poison:IsPurgable() return false end
function modifier_custom_pudge_rot_poison:OnCreated(table)
if not IsServer() then return end

self.pfx = ParticleManager:CreateParticle("particles/pudge_rot.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.pfx, 1, Vector(150, 1, 150))
self:AddParticle(self.pfx, false, false, -1, false, false)	

end


modifier_custom_pudge_rot_poison_cd = class({})
function modifier_custom_pudge_rot_poison_cd:IsHidden() return false end
function modifier_custom_pudge_rot_poison_cd:IsPurgable() return false end
function modifier_custom_pudge_rot_poison_cd:IsDebuff() return true end
function modifier_custom_pudge_rot_poison_cd:RemoveOnDeath() return false end
function modifier_custom_pudge_rot_poison_cd:GetTexture() return "buffs/goo_ground" end
function modifier_custom_pudge_rot_poison_cd:OnCreated(table)
self.RemoveForDuel = true
end