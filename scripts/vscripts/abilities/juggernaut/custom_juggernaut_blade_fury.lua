LinkLuaModifier("modifier_custom_juggernaut_blade_fury", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_silence", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_shard_damage", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_passive_fury", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_thinker", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_fly", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_pause", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_fly_back", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_anim", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_tracker", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_mini", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_slow", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)





custom_juggernaut_blade_fury = class({})




custom_juggernaut_blade_fury.silence_duration = 5
custom_juggernaut_blade_fury.silence_radius = 80

custom_juggernaut_blade_fury.damage_bonus = {0.3, 0.4, 0.5}

custom_juggernaut_blade_fury.mini_duration = {1, 1.8}
custom_juggernaut_blade_fury.mini_radius = 180
custom_juggernaut_blade_fury.mini_chance = 20

custom_juggernaut_blade_fury.slow_move = {-20, -30, -40}
custom_juggernaut_blade_fury.slow_heal = {-10, -15, -20}
custom_juggernaut_blade_fury.slow_duration = 2

custom_juggernaut_blade_fury.heal = {0.2, 0.3, 0.4}
custom_juggernaut_blade_fury.heal_creeps = 0.25

custom_juggernaut_blade_fury.cd_init = -2
custom_juggernaut_blade_fury.cd_attack = 0.2


function custom_juggernaut_blade_fury:GetIntrinsicModifierName()
return "modifier_custom_juggernaut_blade_fury_tracker"
end


function custom_juggernaut_blade_fury:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_shield") then 
  upgrade_cooldown = self.cd_init
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end



function custom_juggernaut_blade_fury:BladeFury_DealDamage(point, radius, inc_damage)
if not IsServer() then return end

local tick = 0.2
local bonus = 0

if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_damage") then 
  bonus = self.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladefury_damage")]*self:GetCaster():GetAgility()
end


local damage = (self:GetSpecialValueFor("damage") + bonus)*tick


if inc_damage then 
	damage = damage*(1 + self:GetCaster():FindAbilityByName("custom_juggernaut_whirling_blade_custom"):GetSpecialValueFor("damage")/100)
end





if not IsServer() then return end

local targets = nil 
targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
for _,i in ipairs(targets) do
  ApplyDamage({victim = i, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
  

  if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_duration") then 
  	i:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_slow", {duration = (1 - i:GetStatusResistance())*self.slow_duration})
  end

  local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, i )
  ParticleManager:ReleaseParticleIndex( effect_cast )
end



end


 


function custom_juggernaut_blade_fury:OnSpellStart()
    self.duration = self:GetSpecialValueFor("duration")

    if not IsServer() then return end

    if self:GetCaster():HasModifier("modifier_custom_juggernaut_blade_fury") then 
        self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury")
    end

    if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_silence") then 
        local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius") + self.silence_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        for _,i in pairs(targets) do 
          i:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_silence", {duration = (1 - i:GetStatusResistance())*self.silence_duration})
        
          i:EmitSound("Juggernaut.Fury_silence")
        end
    end



    self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury", {duration = self.duration, anim = 1})
    self:GetCaster():Purge(false, true, false, false, false)


end










modifier_custom_juggernaut_blade_fury = class({})

function modifier_custom_juggernaut_blade_fury:IsPurgable() return false end

function modifier_custom_juggernaut_blade_fury:DeclareFunctions()
return
{

MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
MODIFIER_EVENT_ON_TAKEDAMAGE,
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
MODIFIER_PROPERTY_TOOLTIP,
MODIFIER_EVENT_ON_ATTACK_LANDED
}  

end






function modifier_custom_juggernaut_blade_fury:OnTooltip()
return self.damage/self.tick

end



function modifier_custom_juggernaut_blade_fury:GetModifierMoveSpeedBonus_Constant()
if self:GetParent():HasShard() then 
 return self:GetAbility():GetSpecialValueFor("shard_move")
end
end


function modifier_custom_juggernaut_blade_fury:GetModifierProcAttack_BonusDamage_Physical( params ) 
if params.target:IsBuilding() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_shard_damage") then return end

return -params.damage

end


function modifier_custom_juggernaut_blade_fury:OnCreated(table)
self.RemoveForDuel = true

self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.radius = self:GetAbility():GetSpecialValueFor("radius")

if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_silence") then 
	self.radius = self.radius + self:GetAbility().silence_radius
end

self.tick = 0.2
self.count = 5
self:StartIntervalThink(self.tick)

self:PlayEffects()
   

if not IsServer() then return end

if self:GetParent():IsHero() then 
	self.omni = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash")
	self.swift = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")
	self.blade = self:GetCaster():FindAbilityByName("custom_juggernaut_whirling_blade_custom")

	if self.omni then 
		self.omni:SetActivated(false)
	end

	if self.swift then 
		self.swift:SetActivated(false)
	end

	if self.blade then 
		self.blade:SetActivated(false)
	end

end
 

end




function modifier_custom_juggernaut_blade_fury:CheckState()
 return {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
end

function modifier_custom_juggernaut_blade_fury:OnIntervalThink()



if self:GetCaster():HasShard() and self:GetParent():IsHero() then 
	self.count = self.count + 1

	if self.count >= 5 then 


		local shard_targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		if #shard_targets > 0 then 
		    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_shard_damage", {})
		    local random = RandomInt(1, #shard_targets)
		    self:GetParent():PerformAttack(shard_targets[random],true,true,true,false,false,false, false)
		    self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_shard_damage")
		    self.count = 0
		end

	end
end

self:GetAbility():BladeFury_DealDamage(self:GetParent():GetAbsOrigin(), self.radius, not self:GetParent():IsHero())
end




function modifier_custom_juggernaut_blade_fury:OnDestroy( kv )
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_mini") then 
	self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart" )
end
self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")

self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)



if self:GetParent():IsHero() then 
	self.omni = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash")
	self.swift = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")
	self.blade = self:GetCaster():FindAbilityByName("custom_juggernaut_whirling_blade_custom")

	if self.omni then 
		self.omni:SetActivated(true)
	end

	if self.swift then 
		self.swift:SetActivated(true)
	end
	
	if self.blade then 
		self.blade:SetActivated(true)
	end

end


end



function modifier_custom_juggernaut_blade_fury:PlayEffects()
if not IsServer() then return end

local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf"


if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_legendary_thinker") then 
	local  particle_cast = "particles/jugg_small_fury.vpcf"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius/1.6, 0, 0 ) )

	self:AddParticle(effect_cast,false,false,-1,false,false)

end

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )

if self:GetParent():IsHero() then 
	self:AddParticle(effect_cast,false,false,-1,false,false)
	self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
end


end














modifier_custom_juggernaut_blade_fury_mini = class({})

function modifier_custom_juggernaut_blade_fury_mini:IsPurgable() return false end

function modifier_custom_juggernaut_blade_fury_mini:IsHidden() return false end
function modifier_custom_juggernaut_blade_fury_mini:GetTexture() return "buffs/bladefury_agility" end

function modifier_custom_juggernaut_blade_fury_mini:OnCreated(table)
self.RemoveForDuel = true

self.tick = 0.2
self:StartIntervalThink(self.tick)


local  particle_cast = "particles/jugg_small_fury.vpcf"


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self:GetAbility():GetSpecialValueFor("radius")/1.3, 0, 0 ) )


self:AddParticle(effect_cast,false,false,-1,false,false)
self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
end



function modifier_custom_juggernaut_blade_fury_mini:OnIntervalThink()
self:GetAbility():BladeFury_DealDamage(self:GetParent():GetAbsOrigin(), self:GetAbility().mini_radius)
end


function modifier_custom_juggernaut_blade_fury_mini:OnDestroy( kv )
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then 
	self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart" )
end

self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")
end










modifier_custom_juggernaut_blade_fury_slow = class({})
function modifier_custom_juggernaut_blade_fury_slow:IsHidden() return false end
function modifier_custom_juggernaut_blade_fury_slow:IsPurgable() return true end
function modifier_custom_juggernaut_blade_fury_slow:GetTexture() return "buffs/Blade_fury_slow" end


function modifier_custom_juggernaut_blade_fury_slow:OnCreated(table)
if not IsServer() then return end

local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(iParticleID, true, false, -1, false, false)

end




function modifier_custom_juggernaut_blade_fury_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}

end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladefury_duration")]
end






function modifier_custom_juggernaut_blade_fury_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetAbility().slow_heal[self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladefury_duration")]
end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierHealAmplify_PercentageTarget() 
return self:GetAbility().slow_heal[self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladefury_duration")]
end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierHPRegenAmplify_Percentage() 
return self:GetAbility().slow_heal[self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladefury_duration")]
end












modifier_custom_juggernaut_blade_fury_silence = class({})

function modifier_custom_juggernaut_blade_fury_silence:IsHidden() return false end

function modifier_custom_juggernaut_blade_fury_silence:IsPurgable() return true end

function modifier_custom_juggernaut_blade_fury_silence:GetTexture() return "silencer_last_word" end

function modifier_custom_juggernaut_blade_fury_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_custom_juggernaut_blade_fury_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_custom_juggernaut_blade_fury_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end











modifier_custom_juggernaut_blade_fury_shard_damage = class({})

function modifier_custom_juggernaut_blade_fury_shard_damage:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_shard_damage:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_shard_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_custom_juggernaut_blade_fury_shard_damage:GetModifierDamageOutgoing_Percentage()
if IsClient() then return end

return -25
end





modifier_custom_juggernaut_blade_fury_passive_fury = class({})
function modifier_custom_juggernaut_blade_fury_passive_fury:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_passive_fury:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_passive_fury:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_juggernaut_blade_fury_passive_fury:RemoveOnDeath() return false end














modifier_custom_juggernaut_blade_fury_tracker = class({})
function modifier_custom_juggernaut_blade_fury_tracker:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_tracker:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end







function modifier_custom_juggernaut_blade_fury_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end


if self:GetParent():HasModifier("modifier_juggernaut_bladefury_agility") and not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_mini") then 

	if RollPseudoRandomPercentage(self:GetAbility().mini_chance,194,self:GetParent()) then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_mini", {duration = self:GetAbility().mini_duration[self:GetParent():GetUpgradeStack("modifier_juggernaut_bladefury_agility")]})
	end

end


if not self:GetParent():HasModifier("modifier_juggernaut_bladefury_shield") then return end
if not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") and not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_mini") then return end
if params.target:IsBuilding() then return end

local cd = self:GetAbility():GetCooldownTimeRemaining()

self:GetAbility():EndCooldown()
self:GetAbility():StartCooldown(cd - self:GetAbility().cd_attack)



end


function modifier_custom_juggernaut_blade_fury_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not params.inflictor then return end
if params.inflictor ~= self:GetAbility() then return end
if params.unit:IsIllusion() then return end

if (self:GetParent():GetQuest() == "Jugg.Quest_5") and params.unit:IsRealHero() then 
	self:GetParent():UpdateQuest(math.floor(params.damage))
end


if not self:GetParent():HasModifier("modifier_juggernaut_bladefury_chance") then return end

local heal = self:GetAbility().heal[self:GetCaster():GetUpgradeStack("modifier_juggernaut_bladefury_chance")]*params.damage

if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().heal_creeps
end

self:GetParent():Heal(heal, self:GetAbility())

end



















custom_juggernaut_whirling_blade_custom = class({})



function custom_juggernaut_whirling_blade_custom:GetCooldown(iLevel)
local k = self:GetSpecialValueFor("cd_reduction")*(math.min(1, self:GetCaster():GetAttackSpeed()/7))

return self.BaseClass.GetCooldown(self, iLevel) - k
end


function custom_juggernaut_whirling_blade_custom:GetAOERadius()
local bonus = 0
if self:GetCaster():HasModifier("modifier_juggernaut_bladefury_silence") then 
	bonus = self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury").silence_radius
end

return self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury"):GetSpecialValueFor("radius") + bonus
end



function custom_juggernaut_whirling_blade_custom:OnAbilityPhaseStart( )
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_anim", {})
self:GetCaster():StartGesture(ACT_DOTA_ATTACK_EVENT)
return true 
end


modifier_custom_juggernaut_blade_fury_anim = class({})
function modifier_custom_juggernaut_blade_fury_anim:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_anim:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_anim:DeclareFunctions() return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS } end
function modifier_custom_juggernaut_blade_fury_anim:GetActivityTranslationModifiers() return "ti8" end

function modifier_custom_juggernaut_blade_fury_anim:OnAbilityPhaseInterrupted()


self:GetCaster():FadeGesture(ACT_DOTA_ATTACK_EVENT)
local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_fury_anim")
if mod then mod:Destroy() end
end


function custom_juggernaut_whirling_blade_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_anim")
self:GetCaster():EmitSound("Juggernaut.Whirling_start")
local target = self:GetCursorPosition()

local thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_legendary_thinker", {x = target.x, y = target.y }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )

thinker:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury"), "modifier_custom_juggernaut_blade_fury", {})
end


modifier_custom_juggernaut_blade_fury_legendary_thinker = class({})
function modifier_custom_juggernaut_blade_fury_legendary_thinker:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_legendary_thinker:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnCreated(table)
if not IsServer() then return end
self.fury = self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury")

	
if self.fury then 
	self.fury:SetActivated(false)
end

self.mod =  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_passive_fury", {})

local point = Vector(table.x, table.y, self:GetParent():GetAbsOrigin().z)

local distance = (point - self:GetParent():GetAbsOrigin()):Length2D()
local duration = distance/self:GetAbility():GetSpecialValueFor("speed")

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_fly", { x = table.x, y = table.y, duration = duration})

self:StartIntervalThink(0.1)
self.sound = false
end


function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), 0.1, false)

if self.sound == false then 	
	self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
	self.sound = true
end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	self:Destroy()
end

end


function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart")
self:GetCaster():EmitSound("Hero_Juggernaut.BladeFuryStop")

if self.mod then 
	self.mod:Destroy()
end

self.fury = self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury")


if self.fury and not self:GetCaster():HasModifier("modifier_custom_juggernaut_omnislash") and not self:GetCaster():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then 
	self.fury:SetActivated(true)
end


UTIL_Remove(self:GetParent())
end




modifier_custom_juggernaut_blade_fury_legendary_fly = class({})

function modifier_custom_juggernaut_blade_fury_legendary_fly:IsHidden() return true end

function modifier_custom_juggernaut_blade_fury_legendary_fly:OnCreated(params)
  if not IsServer() then return end


  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()

  self.knockback_speed = self:GetAbility():GetSpecialValueFor("speed")
  self.interval = 0.05

  --self.knockback_distance   = math.max(self.ability.knockback_distance - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)


  
  self.direction = (self.position - self:GetParent():GetAbsOrigin()):Normalized()
  
  self:StartIntervalThink(self.interval)
end

function modifier_custom_juggernaut_blade_fury_legendary_fly:OnIntervalThink()
if not IsServer() then return end

 
  self:GetParent():SetOrigin( self:GetParent():GetAbsOrigin() + self.direction*self.interval*self.knockback_speed )

  --GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(),  self:GetAbility():GetSpecialValueFor("radius"), true )
end


function modifier_custom_juggernaut_blade_fury_legendary_fly:OnDestroy()
if not IsServer() then return end
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_pause", {duration = self:GetAbility():GetSpecialValueFor("duration")})

end

modifier_custom_juggernaut_blade_fury_legendary_pause = class({})
function modifier_custom_juggernaut_blade_fury_legendary_pause:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_legendary_pause:OnDestroy()
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	return
end


local point = self:GetCaster():GetAbsOrigin()

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_fly_back", {})

end







modifier_custom_juggernaut_blade_fury_legendary_fly_back = class({})

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:IsHidden() return true end

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnCreated(params)
  if not IsServer() then return end


self:GetParent():EmitSound("Juggernaut.Whirling_start")
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self.start = params.start

  self.knockback_speed = self:GetAbility():GetSpecialValueFor("speed")
  self.interval = 0.05


  self:StartIntervalThink(self.interval)
end

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnIntervalThink()
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	return
end

self.direction = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
 
self:GetParent():SetOrigin( self:GetParent():GetAbsOrigin() + self.direction*self.interval*self.knockback_speed )

if  (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 50 then 
	self:Destroy()
end

end


function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnDestroy()
if not IsServer() then return end
	self:GetParent():FindModifierByName("modifier_custom_juggernaut_blade_fury_legendary_thinker"):Destroy()

end