LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_attack", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_slow", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_armor", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_stackig_damage", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_stackig_damage_count", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_tracker", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_poison", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_poisonstack", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_heal", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_cd", "abilities/phantom_assassin/custom_phantom_assassin_stifling_dagger", LUA_MODIFIER_MOTION_NONE)

custom_phantom_assassin_stifling_dagger = class({})

custom_phantom_assassin_stifling_dagger.cd_init = 0
custom_phantom_assassin_stifling_dagger.cd_inc = 0.5

custom_phantom_assassin_stifling_dagger.attack_heal = {20, 30, 40}

custom_phantom_assassin_stifling_dagger.healing = 15
custom_phantom_assassin_stifling_dagger.healing_duration = 10
custom_phantom_assassin_stifling_dagger.healing_max = 6
custom_phantom_assassin_stifling_dagger.healing_speed = 15
custom_phantom_assassin_stifling_dagger.healing_speed_duration = 3

custom_phantom_assassin_stifling_dagger.sleep_radius = 500
custom_phantom_assassin_stifling_dagger.sleep_duration = 2.5
custom_phantom_assassin_stifling_dagger.sleep_delay = 0.5
custom_phantom_assassin_stifling_dagger.sleep_cd = 40
custom_phantom_assassin_stifling_dagger.sleep_heal = 0.15


custom_phantom_assassin_stifling_dagger.legendary_chance = 30
custom_phantom_assassin_stifling_dagger.legendary_cast = 0.1


custom_phantom_assassin_stifling_dagger.incoming_damage = {3, 5}
custom_phantom_assassin_stifling_dagger.incoming_duration = 12
custom_phantom_assassin_stifling_dagger.incoming_attack = {10, 15}


custom_phantom_assassin_stifling_dagger.poison_inc = 50
custom_phantom_assassin_stifling_dagger.poison_init = 50
custom_phantom_assassin_stifling_dagger.poison_duration = 4


function custom_phantom_assassin_stifling_dagger:GetCastPoint()
if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then return self.legendary_cast
else return 0.3 end end



function custom_phantom_assassin_stifling_dagger:GetIntrinsicModifierName()
return "modifier_custom_phantom_assassin_stifling_dagger_tracker"
end

function custom_phantom_assassin_stifling_dagger:GetAOERadius()
  return self:GetSpecialValueFor("additional_targets_radius")
end

function custom_phantom_assassin_stifling_dagger:Dagger( target )

local caster = self:GetCaster()
self.duration = self:GetSpecialValueFor("duration")
local projectile_name = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf"
local projectile_speed = self:GetSpecialValueFor("speed")
local projectile_vision = 450

local j = 0
local count = self:GetSpecialValueFor("additional_targets") + 1

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_heal") then 

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_movespeed", 
  {
    duration = self.healing_speed_duration,
    movespeed = self.healing_speed,
    effect = "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
  })
end


local more_targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("additional_targets_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
for _,i in ipairs(more_targets) do
  if (j < count ) and (i:GetUnitName() ~= "npc_teleport") and not i:IsCourier() then 
    j = j+1
    

    local info = {
        Target = i,
        Source = caster,
        Ability = self, 
        EffectName = projectile_name,
        iMoveSpeed = projectile_speed,
        bReplaceExisting = false,                         
        bProvidesVision = true,                           
        iVisionRadius = projectile_vision,        
        iVisionTeamNumber = caster:GetTeamNumber()        
      }
      ProjectileManager:CreateTrackingProjectile(info)

      self:PlayEffects1()
  end
end


end


function custom_phantom_assassin_stifling_dagger:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
  end



function custom_phantom_assassin_stifling_dagger:OnSpellStart(target)
  
local caster = self:GetCaster() 

self.target = self:GetCursorTarget()
if target ~= nil then 
  self.target = target
end


self:Dagger(self.target)

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then 

  local chance = self.legendary_chance
  local random = RollPseudoRandomPercentage(chance,18,self:GetCaster())
  if random then 

    Timers:CreateTimer(0.13,function()
      if self.target:IsAlive() then 
          self:OnSpellStart(self.target)
      end
    end)
  end
end

 


end



function custom_phantom_assassin_stifling_dagger:OnProjectileHit( hTarget, vLocation )
local target = hTarget
if target==nil then return end
if target:IsInvulnerable() then return end
if target:TriggerSpellAbsorb( self ) then return end
  
local modifier = self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_custom_phantom_assassin_stifling_dagger_attack",{})


if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_double") then
  hTarget:EmitSound("Phantom_Assassin.LegendaryPosison")
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_stackig_damage", {duration = self.incoming_duration})
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_stackig_damage_count", {duration = self.incoming_duration})

end



if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_heal") and not hTarget:IsMagicImmune() then 
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_heal", {duration = self.healing_duration* (1-hTarget:GetStatusResistance())})
end

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_damage") then 
    local damage = self.poison_init + self.poison_inc*self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_damage")
     
    hTarget:EmitSound("Phantom_Assassin.PoisonImpact")
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_poison", {duration = self.poison_duration, damage = damage/self.poison_duration})
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_custom_phantom_assassin_stifling_dagger_poisonstack", {duration = self.poison_duration})
end

if not hTarget:IsMagicImmune() then 
    hTarget:AddNewModifier(self:GetCaster(),self,"modifier_custom_phantom_assassin_stifling_dagger_slow",{duration = self.duration* (1-hTarget:GetStatusResistance())})
end


if self:GetCaster():GetQuest() == "Phantom.Quest_5" and (hTarget:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() >= self:GetCaster().quest.number and hTarget:IsRealHero() then 
  self:GetCaster():UpdateQuest(1)
end


self:GetCaster():PerformAttack(hTarget,true,true,true,false,false,false,true)

--ApplyDamage({ victim = hTarget, attacker = self:GetCaster(), ability = self, damage = self:GetCaster():GetAverageTrueAttackDamage(hTarget), damage_type = DAMAGE_TYPE_PHYSICAL})

--self:GetCaster():PerformAttack(hTarget, true, true, true, false, false, true, true)

if modifier then 
  modifier:Destroy()
end



self:PlayEffects2( hTarget )
end

function custom_phantom_assassin_stifling_dagger:PlayEffects1()
 
  local sound_cast = "Hero_PhantomAssassin.Dagger.Cast"

  
  self:GetCaster():EmitSound( sound_cast  )
end


function custom_phantom_assassin_stifling_dagger:PlayEffects2( target )
  
  local sound_target = "Hero_PhantomAssassin.Dagger.Target"

    target:EmitSound( sound_target  )
end


modifier_custom_phantom_assassin_stifling_dagger_attack = class({})


function modifier_custom_phantom_assassin_stifling_dagger_attack:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_dagger_attack:IsPurgable() return false end


function modifier_custom_phantom_assassin_stifling_dagger_attack:OnCreated( kv )
 
  self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )  
  self.attack_factor = self:GetAbility():GetSpecialValueFor( "attack_factor" )

  if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_double") then 
    self.attack_factor = self.attack_factor + self:GetAbility().incoming_attack[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_double")]
  end
end


function modifier_custom_phantom_assassin_stifling_dagger_attack:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

  }

 
end


function modifier_custom_phantom_assassin_stifling_dagger_attack:GetModifierDamageOutgoing_Percentage( params )
  if IsServer() then
    return self.attack_factor
  end
end

function modifier_custom_phantom_assassin_stifling_dagger_attack:GetModifierPreAttack_BonusDamage( params )
  if IsServer() then
    return self.base_damage * 100/(100+self.attack_factor)
  end
end




modifier_custom_phantom_assassin_stifling_dagger_slow = class({})


function modifier_custom_phantom_assassin_stifling_dagger_slow:IsHidden() return false end

function modifier_custom_phantom_assassin_stifling_dagger_slow:IsDebuff() return true end

function modifier_custom_phantom_assassin_stifling_dagger_slow:IsPurgable()  return true   end 


function modifier_custom_phantom_assassin_stifling_dagger_slow:OnCreated( kv )

self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )

if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_legendary") then
  self:StartIntervalThink(FrameTime())
end

end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnIntervalThink()
if not IsServer() then return end
 AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), false)
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnRefresh( kv )

  self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )  
end



function modifier_custom_phantom_assassin_stifling_dagger_slow:DeclareFunctions()
return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_EVENT_ON_ATTACK_LANDED
  }
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:OnTooltip() return 
  self.move_slow  end

function modifier_custom_phantom_assassin_stifling_dagger_slow:GetModifierMoveSpeedBonus_Percentage()
  return self.move_slow
end


function modifier_custom_phantom_assassin_stifling_dagger_slow:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end
if not self:GetCaster():HasModifier("modifier_phantom_assassin_dagger_aoe") then return end

local heal = self:GetAbility().attack_heal[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_aoe")]
self:GetCaster():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

end


function modifier_custom_phantom_assassin_stifling_dagger_slow:GetEffectName()
  return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf"
end

function modifier_custom_phantom_assassin_stifling_dagger_slow:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end


---------------------------------------------------------ТАЛАНТ ЛЕГЕНДАРНЫЙ-----------------------------------------------------------------------------------

modifier_custom_phantom_assassin_stifling_dagger_stackig_damage = class({})

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetTexture() return "buffs/dagger_legendary" end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:IsPurgable() return true end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:DeclareFunctions()
return 
{ 
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:GetModifierIncomingDamage_Percentage()
return 
self:GetStackCount()*self:GetAbility().incoming_damage[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_dagger_double")]
end 
  


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnStackCountChanged(iStackCount)
if not IsServer() then return end
  if not self.pfx then
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    
  end

  ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
  ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
end

function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage:OnDestroy()
if not IsServer() then return end
if self.pfx then
  ParticleManager:DestroyParticle(self.pfx,false )
end

end



modifier_custom_phantom_assassin_stifling_dagger_stackig_damage_count = class({})
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage_count:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage_count:IsPurgable() return false end
function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage_count:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_custom_phantom_assassin_stifling_dagger_stackig_damage_count:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_custom_phantom_assassin_stifling_dagger_stackig_damage")
if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end

end





modifier_custom_phantom_assassin_stifling_dagger_poison = class({})

function modifier_custom_phantom_assassin_stifling_dagger_poison:IsHidden() return true end

function modifier_custom_phantom_assassin_stifling_dagger_poison:IsPurgable()
  return true  end

 
function modifier_custom_phantom_assassin_stifling_dagger_poison:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE 
end



function modifier_custom_phantom_assassin_stifling_dagger_poison:OnCreated(table)
if not IsServer() then return end
self.damage = table.damage
self:StartIntervalThink(1)

end

function modifier_custom_phantom_assassin_stifling_dagger_poison:OnIntervalThink()
if not IsServer() then return end
local tik = self.damage

ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = tik, damage_type = DAMAGE_TYPE_MAGICAL})

SendOverheadEventMessage(self:GetParent(), 9, self:GetParent(), tik, nil)


end



function modifier_custom_phantom_assassin_stifling_dagger_poison:OnDestroy()
if not IsServer() then return end
  local mod = self:GetParent():FindModifierByName("modifier_custom_phantom_assassin_stifling_dagger_poisonstack")
  if mod then
  mod:RemoveStack()
end
end





modifier_custom_phantom_assassin_stifling_dagger_poisonstack = class({})


function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:IsPurgable() return true  end

 

function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:IsDebuff() return true end


function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:GetTexture() return "buffs/dagger_damage" end

function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:OnCreated(table) 
if not IsServer() then return end
self:SetStackCount(1)
 end

 function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:OnRefresh(table) 
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
 end

 function modifier_custom_phantom_assassin_stifling_dagger_poisonstack:RemoveStack()
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()-1)
if self:GetStackCount() == 0 then self:Destroy() end
 end

 --------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------ТАЛАНТ ХИЛ-----------------------------------------------------------------------------------------

 modifier_custom_phantom_assassin_stifling_dagger_heal = class({})


function modifier_custom_phantom_assassin_stifling_dagger_heal:IsPurgable() return true  end

 
function modifier_custom_phantom_assassin_stifling_dagger_heal:IsDebuff() return true end
 
function modifier_custom_phantom_assassin_stifling_dagger_heal:IsHidden() return false end


function modifier_custom_phantom_assassin_stifling_dagger_heal:OnCreated(table) 


self.caster = self:GetCaster()

if self.caster:IsIllusion() then 
  self.caster = self.caster.owner
end

self.ability = self:GetAbility()

if not IsServer() then return end
 self:SetStackCount(1)
end

function modifier_custom_phantom_assassin_stifling_dagger_heal:OnRefresh(table)
 if not IsServer() then return end
 if self:GetStackCount() < self.ability.healing_max then 
 self:SetStackCount(self:GetStackCount()+1)
end
end


function modifier_custom_phantom_assassin_stifling_dagger_heal:GetTexture() return "buffs/dagger_heal" end



function modifier_custom_phantom_assassin_stifling_dagger_heal:DeclareFunctions()
return {
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }
 end

function modifier_custom_phantom_assassin_stifling_dagger_heal:GetModifierLifestealRegenAmplify_Percentage() return -1*self.ability.healing*self:GetStackCount() end
function modifier_custom_phantom_assassin_stifling_dagger_heal:GetModifierHealAmplify_PercentageTarget() return -1*self.ability.healing*self:GetStackCount() end
function modifier_custom_phantom_assassin_stifling_dagger_heal:GetModifierHPRegenAmplify_Percentage() return -1*self.ability.healing*self:GetStackCount() end

-------------------





modifier_custom_phantom_assassin_stifling_dagger_tracker = class({})
function modifier_custom_phantom_assassin_stifling_dagger_tracker:IsHidden() return true end
function modifier_custom_phantom_assassin_stifling_dagger_tracker:IsPurgable() return false end
function modifier_custom_phantom_assassin_stifling_dagger_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MIN_HEALTH,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_custom_phantom_assassin_stifling_dagger_tracker:GetMinHealth()

if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_dagger_duration") then return end
if self:GetParent():HasModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_cd") then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end

return 1
end


function modifier_custom_phantom_assassin_stifling_dagger_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_dagger_duration") then return end
if self:GetParent():HasModifier("modifier_custom_phantom_assassin_stifling_dagger_sleep_cd") then return end
if self:GetParent():HasModifier("modifier_death") then return end

self.caster = self:GetCaster()
self.radius         = self:GetAbility().sleep_radius
self.projectile_speed   = 1000
self.location = self:GetCaster():GetAbsOrigin()
self.duration       = self.radius / self.projectile_speed
  
local heal = self:GetParent():GetMaxHealth()*self:GetAbility().sleep_heal

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

self:GetParent():Heal(heal, self:GetParent())

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

self:GetCaster():EmitSound("Hero_PhantomAssassin.FanOfKnives.Cast")
self:GetCaster():EmitSound("Phantom_Assassin.Dagger_Sleep")

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_phantom_assassin_stifling_dagger_sleep_cd", {duration = self:GetAbility().sleep_cd})
CreateModifierThinker(self.caster, self:GetAbility(), "modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker", {duration = self.duration}, self.location, self.caster:GetTeamNumber(), false)
  
end



modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker = class({})


function modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  

  self.radius         = self:GetAbility().sleep_radius
  if not IsServer() then return end
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives.vpcf", PATTACH_ABSORIGIN, self.parent)
  ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(self.particle, 3, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
  
  self.hit_enemies = {}
  
  self:StartIntervalThink(FrameTime())
end

function modifier_custom_phantom_assassin_stifling_dagger_sleep_thinker:OnIntervalThink()
  if not IsServer() then return end

  local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)
  
  local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
  
  for _, enemy in pairs(enemies) do
  
    local hit_already = false
  
    for _, hit_enemy in pairs(self.hit_enemies) do
      if hit_enemy == enemy then
        hit_already = true
        break
      end
    end

    if not hit_already and not enemy:IsMagicImmune() then


      enemy:EmitSound("Hero_PhantomAssassin.Attack")
      enemy:EmitSound("Phantom_Assassin.Dagger_Sleep_target")
      local duration = self:GetAbility().sleep_duration*(1 - enemy:GetStatusResistance())
      enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_phantom_assassin_stifling_dagger_sleep", {duration = duration})

      table.insert(self.hit_enemies, enemy)
      

    end

  end

end



modifier_custom_phantom_assassin_stifling_dagger_sleep = class({})
function modifier_custom_phantom_assassin_stifling_dagger_sleep:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep:IsPurgable() return true end
function modifier_custom_phantom_assassin_stifling_dagger_sleep:CheckState() return 
  {[MODIFIER_STATE_STUNNED] = true} 
end
function modifier_custom_phantom_assassin_stifling_dagger_sleep:GetEffectName() return "particles/generic_gameplay/generic_sleep.vpcf" end


function modifier_custom_phantom_assassin_stifling_dagger_sleep:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


function modifier_custom_phantom_assassin_stifling_dagger_sleep:DeclareFunctions()
return
{
MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_custom_phantom_assassin_stifling_dagger_sleep:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if not params.attacker:IsHero() then return end
if (self.max_duration - self:GetRemainingTime()) <= self:GetAbility().sleep_delay then return end
 
 self:Destroy()
end



function modifier_custom_phantom_assassin_stifling_dagger_sleep:OnCreated(table)
if not IsServer() then return end
self.max_duration = self:GetRemainingTime()
self:GetParent():StartGesture(ACT_DOTA_DISABLED)
end



function modifier_custom_phantom_assassin_stifling_dagger_sleep:OnDestroy()
if not IsServer() then return end
self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
end

modifier_custom_phantom_assassin_stifling_dagger_sleep_cd = class({})
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:IsHidden() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:IsPurgable() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:IsDebuff() return true end 
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:RemoveOnDeath() return false end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:GetTexture() return "buffs/dagger_sleep" end
function modifier_custom_phantom_assassin_stifling_dagger_sleep_cd:OnCreated(table)
self.RemoveForDuel = true
end