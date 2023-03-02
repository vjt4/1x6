LinkLuaModifier("modifier_custom_juggernaut_healing_ward", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_reduction_effect", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_buff", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_slow_aura", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_slow", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_healing_ward_slow_strong", "abilities/juggernaut/custom_juggernaut_healing_ward.lua", LUA_MODIFIER_MOTION_NONE)

 
custom_juggernaut_healing_ward = class({})


custom_juggernaut_healing_ward.cd_inc = {4, 6, 8}

custom_juggernaut_healing_ward.heal_init = 0
custom_juggernaut_healing_ward.heal_inc = 1

custom_juggernaut_healing_ward.status_res = {10, 15, 20}

custom_juggernaut_healing_ward.buff_timer = 5
custom_juggernaut_healing_ward.buff_duration = 3
custom_juggernaut_healing_ward.buff_speed = {80, 140}
custom_juggernaut_healing_ward.buff_move = {15, 30}

custom_juggernaut_healing_ward.slow = -25
custom_juggernaut_healing_ward.slow_start = -100
custom_juggernaut_healing_ward.slow_start_duration = 1.5

custom_juggernaut_healing_ward.stun_stun = 1.5
custom_juggernaut_healing_ward.stun_heal = 0.2

custom_juggernaut_healing_ward.legendary_hits = 3
custom_juggernaut_healing_ward.legendary_move = 50





function custom_juggernaut_healing_ward:GetCooldown(iLevel)
local upgrade_cooldown = 0  
if self:GetCaster():HasModifier("modifier_juggernaut_healingward_cd") then 
  upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_cd")]
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end





function custom_juggernaut_healing_ward:OnSpellStart()
self.duration = self:GetSpecialValueFor("duration")
self.radius = self:GetSpecialValueFor("radius")
if not IsServer() then return end

local wards = Entities:FindAllByModel("models/heroes/juggernaut/jugg_healing_ward.vmdl")


for _,ward in pairs(wards) do 
  if ward:GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
    ward:ForceKill(false)
 end
end

self:SetActivated(false)
self:EndCooldown()


self.ward = CreateUnitByName("juggernaut_healing_ward", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
self.ward:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self.duration})
self.ward:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)


Timers:CreateTimer(0.05, function()self.ward:MoveToNPC(self:GetCaster()) end)
self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward", {})

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then
  self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_reduction", {})
end

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_purge") then
  self.ward:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_slow_aura", {})

  local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.ward:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

  for _,target in pairs(targets) do 
    target:EmitSound("Jugg.Disarm_ward")
    target:AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_healing_ward_slow_strong", {duration = (1 - target:GetStatusResistance())*self.slow_start_duration})
  end

end



end




modifier_custom_juggernaut_healing_ward = class({})



function modifier_custom_juggernaut_healing_ward:OnCreated(table)
if not IsServer() then return end
self.hits = self:GetAbility().legendary_hits

self:GetParent():EmitSound("Hero_Juggernaut.HealingWard.Cast")

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetAbility().radius, 1, 1))
ParticleManager:SetParticleControlEnt(self.particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "flame_attachment", self:GetParent():GetAbsOrigin(), true)
self:GetParent():EmitSound("Hero_Juggernaut.HealingWard.Loop") 






if self:GetCaster():HasModifier("modifier_juggernaut_healingward_return") then 

  local name = "particles/jugg_ward_count.vpcf"
  self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  self:AddParticle(self.particle, false, false, -1, false, false)


  self:OnIntervalThink()
  self:StartIntervalThink(1)
end

end



function modifier_custom_juggernaut_healing_ward:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("radius") then 
  self:SetStackCount(0)
else 
  if not self:GetCaster():HasModifier("modifier_custom_juggernaut_healing_ward_buff") then 
    self:IncrementStackCount()
  end
end


if self:GetStackCount() >= self:GetAbility().buff_timer then 

  self:Buff()
  self:SetStackCount(0)
end



if self.particle then

  for i = 1,self:GetAbility().buff_timer do 
    if i <= self:GetStackCount() then 
      ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
    else 
      ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
    end
  end

end



end






function modifier_custom_juggernaut_healing_ward:Buff()
if not IsServer() then return end

  local item_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(item_effect, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
  ParticleManager:SetParticleControlEnt(item_effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    
  ParticleManager:ReleaseParticleIndex(item_effect)
  self:GetCaster():EmitSound("Juggernaut.Ward_buff")

  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_healing_ward_buff", {duration = self:GetAbility().buff_duration})

end


function modifier_custom_juggernaut_healing_ward:OnDeath( params )
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
self:Death()

if not self:GetCaster():HasModifier("modifier_juggernaut_healingward_stun") then return end
  
self:HealOnDeath()

local duration = self:GetAbility().stun_stun *( 1 - params.attacker:GetStatusResistance())
params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = duration})

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.attacker )
ParticleManager:ReleaseParticleIndex( particle )

end



function modifier_custom_juggernaut_healing_ward:HealOnDeath()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_juggernaut_healingward_stun") then return end

local heal =  self:GetAbility().stun_heal*self:GetCaster():GetMaxHealth()

self:GetCaster():Heal(heal, self:GetCaster())
self:GetCaster():EmitSound("Juggernaut.WardDeath")    

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

end

function modifier_custom_juggernaut_healing_ward:Death()
if not IsServer() then return end

self:GetParent():EmitSound("Hero_Juggernaut.HealingWard.Stop")

ParticleManager:DestroyParticle(self.particle, true)
ParticleManager:ReleaseParticleIndex(self.particle)

self:GetParent():StopSound("Hero_Juggernaut.HealingWard.Loop")


if self:GetAbility() then 
  self:GetAbility():UseResources(false, false, true)
  self:GetAbility():SetActivated(true)
end


end




function modifier_custom_juggernaut_healing_ward:GetModifierMoveSpeedBonus_Constant()

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then 
  return self:GetAbility().legendary_move
end

end



function modifier_custom_juggernaut_healing_ward:IsHidden() return true end

function modifier_custom_juggernaut_healing_ward:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward:IsAura() return true end

function modifier_custom_juggernaut_healing_ward:GetAuraDuration() return 2 end

function modifier_custom_juggernaut_healing_ward:GetAuraRadius() return self:GetAbility().radius end

function modifier_custom_juggernaut_healing_ward:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_custom_juggernaut_healing_ward:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_custom_juggernaut_healing_ward:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_aura" end

function modifier_custom_juggernaut_healing_ward:CheckState() return 
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_MAGIC_IMMUNE] = true,
  [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
}
end


function modifier_custom_juggernaut_healing_ward:DeclareFunctions() return
{
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_DEATH,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
} 
end





function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamageMagical() return 1 end

function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePhysical() return 1 end

function modifier_custom_juggernaut_healing_ward:GetAbsoluteNoDamagePure() return 1 end

function modifier_custom_juggernaut_healing_ward:OnAttackLanded( param )
if not IsServer() then return end
if self:GetAbility():GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") and not param.attacker:IsRealHero() then return end
if self:GetParent() ~= param.target then return end

if self:GetAbility():GetCaster():HasModifier("modifier_juggernaut_healingward_legendary") then
  self.hits = self.hits - 1
else 
  self.hits = self.hits - self:GetAbility().legendary_hits 
end
        
self:GetParent():SetHealth(self.hits)

if self.hits <= 0 then
  self:GetParent():Kill(nil, param.attacker)
  if self:GetCaster():HasModifier("modifier_juggernaut_healingward_return") then 
    self:Buff()
  end
end



end






modifier_custom_juggernaut_healing_ward_aura = class({})

function modifier_custom_juggernaut_healing_ward_aura:IsPurgable() return false end

function modifier_custom_juggernaut_healing_ward_aura:DeclareFunctions()
return 
  {
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
  }
end 

function modifier_custom_juggernaut_healing_ward_aura:GetModifierStatusResistanceStacking()
local bonus = 0
if self:GetCaster():HasModifier("modifier_juggernaut_healingward_move") then 
  bonus = self:GetAbility().status_res[self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_move")]
end
return bonus
end




function modifier_custom_juggernaut_healing_ward_aura:OnCreated(table)
self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen") 

if self:GetCaster():HasModifier("modifier_juggernaut_healingward_heal") then 
  self.health_regen = self.health_regen + self:GetAbility().heal_init + self:GetAbility().heal_inc*self:GetCaster():GetUpgradeStack("modifier_juggernaut_healingward_heal")
end

end








function modifier_custom_juggernaut_healing_ward_aura:GetModifierHealthRegenPercentage() return self.health_regen end




modifier_custom_juggernaut_healing_ward_reduction = class({})

function modifier_custom_juggernaut_healing_ward_reduction:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_reduction:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_reduction:IsAura() return true end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraDuration() return 0.1 end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraRadius() return self:GetAbility().radius end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_custom_juggernaut_healing_ward_reduction:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_custom_juggernaut_healing_ward_reduction:GetModifierAura() return "modifier_custom_juggernaut_healing_ward_reduction_aura" end



modifier_custom_juggernaut_healing_ward_reduction_aura = class({})

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetEffectName() return "particles/jugger_ward_legend.vpcf" end
function modifier_custom_juggernaut_healing_ward_reduction_aura:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_reduction_aura:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_reduction_aura:DeclareFunctions() 
  return 
  {
    MODIFIER_PROPERTY_MIN_HEALTH
  }
end

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetMinHealth()
if not self:GetCaster():HasModifier("modifier_death") then 
 return 1 
else 
 return 0
end
end

function modifier_custom_juggernaut_healing_ward_reduction_aura:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end






modifier_custom_juggernaut_healing_ward_slow_aura = class({})

function modifier_custom_juggernaut_healing_ward_slow_aura:IsHidden() return true end
function modifier_custom_juggernaut_healing_ward_slow_aura:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_slow_aura:IsAura() return true end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraDuration() return 0.1 end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_custom_juggernaut_healing_ward_slow_aura:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_custom_juggernaut_healing_ward_slow_aura:GetModifierAura()
 return "modifier_custom_juggernaut_healing_ward_slow" 

end





modifier_custom_juggernaut_healing_ward_slow = class({})
function modifier_custom_juggernaut_healing_ward_slow:IsHidden() return false end

function modifier_custom_juggernaut_healing_ward_slow:GetEffectName()
return "particles/jugg_ward_slow.vpcf"
end
function modifier_custom_juggernaut_healing_ward_slow:GetTexture()
return "buffs/Healing_ward_slow"
end

function modifier_custom_juggernaut_healing_ward_slow:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_slow:OnCreated(table)
if not IsServer() then return end

end

function modifier_custom_juggernaut_healing_ward_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_custom_juggernaut_healing_ward_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow
end



modifier_custom_juggernaut_healing_ward_slow_strong = class({})
function modifier_custom_juggernaut_healing_ward_slow_strong:IsHidden() return true end

function modifier_custom_juggernaut_healing_ward_slow_strong:GetEffectName()
return "particles/items2_fx/heavens_halberd.vpcf"
end


function modifier_custom_juggernaut_healing_ward_slow_strong:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end



function modifier_custom_juggernaut_healing_ward_slow_strong:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_slow_strong:CheckState()
return
{
  [MODIFIER_STATE_DISARMED] = true
}
end







modifier_custom_juggernaut_healing_ward_buff = class({})
function modifier_custom_juggernaut_healing_ward_buff:IsHidden() return false end

function modifier_custom_juggernaut_healing_ward_buff:GetEffectName()
return "particles/jugg_ward_buff.vpcf"
end

function modifier_custom_juggernaut_healing_ward_buff:GetTexture()
return "buffs/Healing_ward_buff"
end

function modifier_custom_juggernaut_healing_ward_buff:IsPurgable() return false end
function modifier_custom_juggernaut_healing_ward_buff:OnCreated(table)
if not IsServer() then return end

end

function modifier_custom_juggernaut_healing_ward_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_juggernaut_healing_ward_buff:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().buff_move[self:GetParent():GetUpgradeStack("modifier_juggernaut_healingward_return")]
end
function modifier_custom_juggernaut_healing_ward_buff:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().buff_speed[self:GetParent():GetUpgradeStack("modifier_juggernaut_healingward_return")]
end