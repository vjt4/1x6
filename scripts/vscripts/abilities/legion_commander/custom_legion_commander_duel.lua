LinkLuaModifier("modifier_duel_buff", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_damage", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_health", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_speed", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_cdr", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_legendary_count", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_win_duration", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_charge", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double_anim", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duel_double_tracker", "abilities/legion_commander/custom_legion_commander_duel", LUA_MODIFIER_MOTION_NONE)


custom_legion_commander_duel = class({})

custom_legion_commander_duel.speed_init = 20
custom_legion_commander_duel.speed_inc = 20

custom_legion_commander_duel.end_heal = 0.2

custom_legion_commander_duel.charge_range = 450
custom_legion_commander_duel.charge_min_range = 200
custom_legion_commander_duel.charge_speed = 800
custom_legion_commander_duel.charge_duration = 5
custom_legion_commander_duel.charge_cd_fail = 2

custom_legion_commander_duel.kill_cdr = {3,4}
custom_legion_commander_duel.kill_cdr_max = 50
custom_legion_commander_duel.kill_health = {80, 160}
custom_legion_commander_duel.kill_speed = {10,20}

custom_legion_commander_duel.legendary_duration = 1

custom_legion_commander_duel.win_slow = -80
custom_legion_commander_duel.win_duration = {2,3,4}

custom_legion_commander_duel.face_damage = {0.08, 0.12, 0.16}



function custom_legion_commander_duel:GetIntrinsicModifierName()
return "modifier_duel_double_tracker"
end


function custom_legion_commander_duel:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_legion_duel_blood") then 
  upgrade = self.charge_range
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end




function custom_legion_commander_duel:StartDuel(target)
if not IsServer() then return end


if self:GetCaster():HasModifier("modifier_duel_double") then 
  local ability = self:GetCaster():FindAbilityByName("custom_legion_commander_duel_double")

  if ability then 
    ability:SetActivated(true)
    ability:UseResources(false, false, true)
  end

end



self.caster = self:GetCaster()
duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasScepter() then 
  duration = duration + self:GetSpecialValueFor("scepter_duration")
end

if self:GetCaster():IsIllusion() then 
  duration = 1.5
end

if target:TriggerSpellAbsorb(self) then return end

self.caster:EmitSound("Hero_LegionCommander.Duel.Cast")
self.caster:AddNewModifier(self.caster, self, "modifier_duel_buff", {duration = duration, target = target:entindex()})
target:AddNewModifier(self.caster, self, "modifier_duel_buff", {duration = duration, target = self.caster:entindex()})




end

function custom_legion_commander_duel:OnSpellStart(target)

self.target = self:GetCursorTarget()
if target ~= nil then 
  self.target = target
end

if self:GetCaster():HasModifier("modifier_legion_duel_blood") then 
  if (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= self.charge_min_range then 
    self:StartDuel(self.target)
  else 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_duel_charge", {duration = self.charge_duration, target = self.target:entindex()})
  end
else 
  self:StartDuel(self.target)
end


if self.target:IsCreep() and self:GetCaster():HasShard() then 
  local cd = self:GetCooldownTimeRemaining()
  self:EndCooldown()
  self:StartCooldown(cd*(1 - self:GetSpecialValueFor("shard_cd")/100))

end

end


function custom_legion_commander_duel:WinDuel(caster, winner, loser, double)
if not IsServer() then return end
if loser:IsIllusion() then return end

local mod = winner:FindModifierByName("modifier_duel_damage")

if not mod then 
  mod = winner:AddNewModifier(winner, self, "modifier_duel_damage", {})
end 

local damage = self:GetSpecialValueFor("reward_damage")

if caster:HasScepter() then 
  damage = damage + self:GetSpecialValueFor("scepter_damage")
end

if loser:IsCreep() then 
  damage = self:GetSpecialValueFor("creeps_damage")
  if caster:HasShard() then 
    damage = damage + self:GetSpecialValueFor("shard_damage")
  end
end

if winner:GetQuest() == "Legion.Quest_8" then 
  winner:UpdateQuest(damage)
end

mod:SetStackCount(mod:GetStackCount() + damage) 
  

if caster == winner and loser:IsHero() then 

  winner:AddNewModifier(winner, self, "modifier_duel_legendary_count", {})

  local name = ""

  if loser:GetPrimaryAttribute() == 0 then name = "modifier_duel_legendary_health" end
  if loser:GetPrimaryAttribute() == 1 then name = "modifier_duel_legendary_speed" end
  if loser:GetPrimaryAttribute() == 2 then name = "modifier_duel_legendary_cdr" end

  winner:AddNewModifier(winner, self, name, {})

end



local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, winner)
winner:EmitSound("Hero_LegionCommander.Duel.Victory")

if winner == caster then 
  local ability = winner:FindAbilityByName("custom_legion_commander_press_the_attack")
  if ability and ability:GetLevel() > 0 then 
      ability:OnSpellStart()
  end
end  


if winner == caster and double == true then 
  self:WinDuel(caster, winner, loser, false)
  caster:AddNewModifier(caster, self, "modifier_duel_double_anim", {duration = 2})
end


end








modifier_duel_buff = class({})
function modifier_duel_buff:IsHidden() return false end
function modifier_duel_buff:IsPurgable() return false end
function modifier_duel_buff:IsDebuff() return true end
function modifier_duel_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_duel_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MIN_HEALTH,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_duel_buff:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetParent() ~= self:GetCaster() and self:GetCaster():HasScepter() then 
  return self:GetAbility():GetSpecialValueFor("scepter_heal")*-1
end

end
function modifier_duel_buff:GetModifierHealAmplify_PercentageTarget()
if self:GetParent() ~= self:GetCaster() and self:GetCaster():HasScepter() then 
  return self:GetAbility():GetSpecialValueFor("scepter_heal")*-1
end

end

function modifier_duel_buff:GetModifierHPRegenAmplify_Percentage() 
if self:GetParent() ~= self:GetCaster() and self:GetCaster():HasScepter() then 
  return self:GetAbility():GetSpecialValueFor("scepter_heal")*-1
end

end


function modifier_duel_buff:GetEffectName()
if self:GetParent() ~= self:GetCaster() then return end
if not self:GetCaster():HasModifier("modifier_legion_duel_win") then return end
return "particles/beast_grave.vpcf"
end

function modifier_duel_buff:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent() ~= self:GetCaster() then return end
if not self:GetCaster():HasModifier("modifier_legion_duel_win") then return end

return 1
end



function modifier_duel_buff:GetModifierAttackSpeedBonus_Constant()
if self:GetCaster():HasModifier("modifier_legion_duel_speed") then 
  return self:GetAbility().speed_init + self:GetAbility().speed_inc*self:GetCaster():GetUpgradeStack("modifier_legion_duel_speed")
end

end






function modifier_duel_buff:OnCreated(table)
 if not IsServer() then return end	

  self.RemoveForDuel = true
  self.target = EntIndexToHScript(table.target)

  if not self:GetParent():IsCreep() then 
    self:GetParent():SetForceAttackTarget(self.target)
    self:GetParent():MoveToTargetToAttack(self.target)
  end

  if self:GetCaster() == self:GetParent() then 
  	self:GetCaster().particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_duel_ring.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
  	
	self:GetCaster():EmitSound("Hero_LegionCommander.Duel")
    local center_point = self.target:GetAbsOrigin() + ((self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()) / 1)
    ParticleManager:SetParticleControl(self:GetCaster().particle, 0, center_point)
    ParticleManager:SetParticleControl(self:GetCaster().particle, 7, center_point)

  end



  if self:GetCaster() ~= self:GetParent() and self:GetCaster():HasScepter() then 
   --self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
   -- ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
  --  self:AddParticle(self.particle, false, false, -1, false, false)
  end

  self.double = false

  if self:GetCaster():HasModifier("modifier_duel_double") then 
    self:GetCaster():RemoveModifierByName("modifier_duel_double")
    self.double = true
  end

  self:StartIntervalThink(0.1)
end






function modifier_duel_buff:OnIntervalThink()
if not IsServer() then return end	

  if not self:GetParent():IsCreep() then 
    self:GetParent():SetForceAttackTarget(self.target)
    self:GetParent():MoveToTargetToAttack(self.target)
  end

  if not self.target:IsAlive()  then 
  	self:GetAbility():WinDuel(self:GetCaster(), self:GetParent(), self.target, self.double)
  	self:Destroy()
  end

  if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("victory_range")
  or not self.target:HasModifier(self:GetName()) then 
  	self:Destroy()
  end

end

function modifier_duel_buff:OnDestroy()
if not IsServer() then return end
self:GetCaster():StopSound("Hero_LegionCommander.Duel")

if self:GetCaster().particle then 
  ParticleManager:DestroyParticle(self:GetCaster().particle, false)
end

if self:GetParent() == self:GetCaster() and self:GetCaster():HasModifier("modifier_legion_duel_win") then
  local heal = self:GetParent():GetMaxHealth()*self:GetAbility().end_heal

  self:GetParent():Heal(heal, self:GetParent())

  local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:ReleaseParticleIndex( particle )
  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:ReleaseParticleIndex( particle )

  SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
end

if self.target:IsAlive() and self:GetCaster():HasModifier("modifier_legion_duel_passive") then 
  if self:GetParent() == self:GetCaster() then 

    self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_duel_win_duration", {double = self.double, duration = self:GetAbility().win_duration[self:GetCaster():GetUpgradeStack("modifier_legion_duel_passive")]})
  end
end

  if not self:GetParent():IsCreep() then 
    self:GetParent():SetForceAttackTarget(nil)
  end

end



function modifier_duel_buff:CheckState() 
if self:GetCaster() ~= self:GetParent() and self:GetCaster():HasScepter() then 
  return 
    {
    [MODIFIER_STATE_TAUNTED] = true, 
   -- [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_SILENCED] = true
  } 
else 
  return {
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_TAUNTED] = true, 
    [MODIFIER_STATE_SILENCED] = true
  }
end

end




modifier_duel_damage = class({})
function modifier_duel_damage:IsHidden() return false end
function modifier_duel_damage:IsPurgable() return false end
function modifier_duel_damage:RemoveOnDeath() return false end
function modifier_duel_damage:GetTexture() return "legion_commander_duel" end
function modifier_duel_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_duel_damage:GetModifierPreAttack_BonusDamage() return self:GetStackCount() end








modifier_duel_legendary_speed = class({})
function modifier_duel_legendary_speed:IsHidden() return true  end
function modifier_duel_legendary_speed:IsPurgable() return false end
function modifier_duel_legendary_speed:RemoveOnDeath() return false end
function modifier_duel_legendary_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_duel_legendary_speed:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end




modifier_duel_legendary_health = class({})
function modifier_duel_legendary_health:IsHidden() return true end
function modifier_duel_legendary_health:IsPurgable() return false end
function modifier_duel_legendary_health:RemoveOnDeath() return false end

function modifier_duel_legendary_health:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_duel_legendary_health:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end



modifier_duel_legendary_cdr = class({})
function modifier_duel_legendary_cdr:IsHidden() return true  end
function modifier_duel_legendary_cdr:IsPurgable() return false end
function modifier_duel_legendary_cdr:RemoveOnDeath() return false end

function modifier_duel_legendary_cdr:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_duel_legendary_cdr:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

modifier_duel_legendary_count = class({})

function modifier_duel_legendary_count:IsHidden() 
  return not self:GetCaster():HasModifier("modifier_legion_duel_damage")
end

function modifier_duel_legendary_count:IsPurgable() return false end
function modifier_duel_legendary_count:RemoveOnDeath() return false end
function modifier_duel_legendary_count:GetTexture() return "buffs/duel_win" end
function modifier_duel_legendary_count:OnCreated(table)
self:SetStackCount(1)
end

function modifier_duel_legendary_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_duel_legendary_count:DeclareFunctions()
return
{
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
MODIFIER_PROPERTY_HEALTH_BONUS,
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_duel_legendary_count:GetModifierPercentageCooldown()
if self:GetCaster():HasModifier("modifier_legion_duel_damage") then 
  return math.min(self:GetAbility().kill_cdr_max, self:GetParent():GetUpgradeStack("modifier_duel_legendary_cdr")*self:GetAbility().kill_cdr[self:GetCaster():GetUpgradeStack("modifier_legion_duel_damage")])
end 
return
end



function modifier_duel_legendary_count:GetModifierHealthBonus()
if self:GetCaster():HasModifier("modifier_legion_duel_damage") then 
  return self:GetParent():GetUpgradeStack("modifier_duel_legendary_health")*self:GetAbility().kill_health[self:GetCaster():GetUpgradeStack("modifier_legion_duel_damage")]
end 
return
end



function modifier_duel_legendary_count:GetModifierAttackSpeedBonus_Constant()
if self:GetCaster():HasModifier("modifier_legion_duel_damage") then 
	return self:GetParent():GetUpgradeStack("modifier_duel_legendary_speed")*self:GetAbility().kill_speed[self:GetCaster():GetUpgradeStack("modifier_legion_duel_damage")]
end 
return
end



modifier_duel_win_duration = class({})
function modifier_duel_win_duration:IsHidden() return false end
function modifier_duel_win_duration:IsPurgable() return false end
function modifier_duel_win_duration:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_duel_win_duration:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_duel_win_duration:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end


function modifier_duel_win_duration:OnCreated(table)
if not IsServer() then return end
self.double = false

if table.double == 1 then 
  self.double = true
end


end

function modifier_duel_win_duration:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if not self:GetCaster():IsAlive() then return end  

self:GetAbility():WinDuel(self:GetCaster(), self:GetCaster(), self:GetParent(), self.double)
self:Destroy()
end

function modifier_duel_win_duration:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().win_slow
end





modifier_duel_charge = class({})
function modifier_duel_charge:IsHidden() return false end
function modifier_duel_charge:IsPurgable() return false end
function modifier_duel_charge:GetTexture() return "buffs/odds_mark" end

function modifier_duel_charge:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
self.stun = false 
self:GetParent():SetForceAttackTarget(self.target)
self:GetParent():EmitSound("Lc.Odds_Charge")
self:GetParent():MoveToTargetToAttack(self.target)
self:StartIntervalThink(FrameTime())
end

function modifier_duel_charge:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_EVENT_ON_ATTACK_START
}

end


function modifier_duel_charge:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self.stun = true 
self:Destroy()

end



function modifier_duel_charge:OnIntervalThink()
if not IsServer() then return end

if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= self:GetAbility().charge_min_range then 
  self.stun = true 
end


if self.stun
or not self.target:IsAlive()  
or self.target:IsInvulnerable() 
or self.target:IsInvisible() 
or self:GetParent():IsStunned()
or self:GetParent():IsHexed()
or self:GetParent():IsRooted()
or not self:GetParent():CanEntityBeSeenByMyTeam(self.target) then 
  self:Destroy()
end

end

function modifier_duel_charge:OnDestroy()
if not IsServer() then return end
self:GetParent():SetForceAttackTarget(nil)


if self:GetParent():IsAlive() and self.stun and not self.target:IsInvulnerable() then 

    local anim = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_mark_anim", {})
    self:GetParent():EmitSound("Lc.Odds_ChargeHit")
    self:GetParent():StartGesture(ACT_DOTA_ATTACK)
    if anim then 
      anim:Destroy()
    end


    local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_charge_hit_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
    
    ParticleManager:SetParticleControl(particle_peffect, 0, self.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 1, self.target:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 3, self.target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)
    
    self:GetAbility():StartDuel(self.target)

else 
  self:GetAbility():EndCooldown()
  self:GetAbility():StartCooldown(self:GetAbility().charge_cd_fail)
end

end
function modifier_duel_charge:GetEffectName() return "particles/lc_odd_charge.vpcf" end

function modifier_duel_charge:GetModifierMoveSpeed_Absolute() return self:GetAbility().charge_speed
 end
function modifier_duel_charge:GetActivityTranslationModifiers() return "overwhelmingodds" end




custom_legion_commander_duel_double = class({})

function custom_legion_commander_duel_double:OnSpellStart()
if not IsServer() then return end
self:GetCaster():EmitSound("LC.Duel_double")

local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)


local effect_target = ParticleManager:CreateParticle( "particles/lc_press_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
ParticleManager:ReleaseParticleIndex( effect_target )


self:SetActivated(false)
self:EndCooldown()
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_duel_double", {})
end


modifier_duel_double = class({})
function modifier_duel_double:IsHidden() return false end
function modifier_duel_double:IsPurgable() return false end
function modifier_duel_double:RemoveOnDeath() return false end
function modifier_duel_double:GetEffectName() return "particles/lc_odd_proc_hands_2.vpcf" end


modifier_duel_double_anim = class({})
function modifier_duel_double_anim:IsHidden() return true end
function modifier_duel_double_anim:IsPurgable() return false end
function modifier_duel_double_anim:OnDestroy()
if not IsServer() then return end
local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
self:GetCaster():EmitSound("Hero_LegionCommander.Duel.Victory")

self:GetCaster():EmitSound("LC.Duel_double")

end


modifier_duel_double_tracker = class({})
function modifier_duel_double_tracker:IsHidden() return true end
function modifier_duel_double_tracker:IsPurgable() return false end
function modifier_duel_double_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_duel_double_tracker:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_duel_return") then return end


if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end


local vector = (self:GetCaster():GetAbsOrigin()-params.attacker:GetAbsOrigin()):Normalized()

local center_angle = VectorToAngles( vector ).y
local facing_angle = VectorToAngles(self:GetParent():GetForwardVector() ).y


local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > 85 )

if facing then 
  return params.damage*self:GetAbility().face_damage[self:GetCaster():GetUpgradeStack("modifier_legion_duel_return")]
end 

end

function modifier_duel_double_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_duel_return") then return end
if not params.attacker then return end
if self:GetParent() ~= params.unit then return end

local vector = (self:GetCaster():GetAbsOrigin()-params.attacker:GetAbsOrigin()):Normalized()

local center_angle = VectorToAngles( vector ).y
local facing_angle = VectorToAngles(self:GetParent():GetForwardVector() ).y


local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > 85 )

if facing and RandomInt(1, 3) == 3 then 
  self:GetParent():EmitSound("Juggernaut.Parry")
  local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
  ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )
end 

end