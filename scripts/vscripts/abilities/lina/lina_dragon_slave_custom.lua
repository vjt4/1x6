LinkLuaModifier( "modifier_lina_dragon_slave_custom_stack", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_legendary", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_tracker", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_legendary_tracker", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )

lina_dragon_slave_custom = class({})

lina_dragon_slave_custom.shard_damage = 15

lina_dragon_slave_custom.damage_init = 25
lina_dragon_slave_custom.damage_inc = 25

lina_dragon_slave_custom.heal_health = 100
lina_dragon_slave_custom.heal_mana = 0.1
lina_dragon_slave_custom.heal_chance = {20, 30, 40}

lina_dragon_slave_custom.stack_duration = 10
lina_dragon_slave_custom.stack_stun = 1.2
lina_dragon_slave_custom.stack_max = 3

lina_dragon_slave_custom.legendary_cd = 1
lina_dragon_slave_custom.legendary_max = 16
lina_dragon_slave_custom.legendary_attack = 1
lina_dragon_slave_custom.legendary_spells = 4
lina_dragon_slave_custom.legendary_duration = 6
lina_dragon_slave_custom.legendary_delay = 3
lina_dragon_slave_custom.legendary_range = 1000

lina_dragon_slave_custom.time_cast = 0.3
lina_dragon_slave_custom.time_cd = 1

lina_dragon_slave_custom.cd_init = 0.05
lina_dragon_slave_custom.cd_inc = 0.05

lina_dragon_slave_custom.burn_duration = 3
lina_dragon_slave_custom.burn_init = 0.01
lina_dragon_slave_custom.burn_inc = 0.01
lina_dragon_slave_custom.burn_interval = 1
lina_dragon_slave_custom.burn_creep = 0.25


function lina_dragon_slave_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_lina_dragon_5") then 
  return self.time_cast
end

return 0.45
end



function lina_dragon_slave_custom:GetCooldown(iLevel)

local k = 1
if self:GetCaster():HasModifier("modifier_lina_dragon_3") then 
  k = k - self.cd_init - self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_3")
end

if self:GetCaster():HasModifier("modifier_lina_dragon_slave_custom_legendary") then 
  return self.legendary_cd*k
end

 return self.BaseClass.GetCooldown(self, iLevel)*k

end

function lina_dragon_slave_custom:GetIntrinsicModifierName()
return "modifier_lina_dragon_slave_custom_tracker"
end

function lina_dragon_slave_custom:OnSpellStart(new_target)
  if not IsServer() then return end
  local caster = self:GetCaster()

  local target = self:GetCursorTarget()
  if new_target ~= nil then 
    target = new_target
  end

  local point = self:GetCursorPosition()


  if target then point = target:GetAbsOrigin()  end

  if point == self:GetCaster():GetAbsOrigin() then 
    point = point + self:GetCaster():GetForwardVector()*10
  end

  local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
  local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
  local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
  local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

  local direction = point-caster:GetAbsOrigin()
  direction.z = 0
  local projectile_normalized = direction:Normalized()


  if self:GetCaster():HasModifier("modifier_lina_dragon_5") then 

    for i = 0, 8 do
        local current_item = self:GetCaster():GetItemInSlot(i)
  

        if current_item and current_item:GetName() ~= "item_aeon_disk" and current_item:GetName() ~= "item_midas_custom" then  
          local cd = current_item:GetCooldownTimeRemaining()
          current_item:EndCooldown()
          if cd > self.time_cd then 
            current_item:StartCooldown(cd - self.time_cd)
          end
 
        end
    end

  end

  local info = {
      Source = caster,
      Ability = self,
      vSpawnOrigin = caster:GetAbsOrigin(),
      bDeleteOnHit = false,
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
      fDistance = projectile_distance,
      fStartRadius = projectile_start_radius,
      fEndRadius = projectile_end_radius,
      vVelocity = projectile_normalized * projectile_speed,
      bProvidesVision = false,
  }

  ProjectileManager:CreateLinearProjectile(info)
  self:GetCaster():EmitSound("Hero_Lina.DragonSlave.Cast")
  self:GetCaster():EmitSound("Hero_Lina.DragonSlave")

end

function lina_dragon_slave_custom:OnProjectileHitHandle( target, location, projectile )
  if not IsServer() then return end
  if not target then return end

  local damage = self:GetAbilityDamage()


  if self:GetCaster():HasModifier("modifier_lina_dragon_1") then 
    damage = damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_1")
  end

  if self:GetCaster():HasShard() then 
    local mod = self:GetCaster():FindModifierByName("modifier_lina_fiery_soul_custom")
    if mod then 
      damage = damage + mod:GetStackCount()*self.shard_damage
    end
  end



  if self:GetCaster():HasModifier("modifier_lina_dragon_6") then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_stack", {duration = self.stack_duration})
  end

  if self:GetCaster():HasModifier("modifier_lina_dragon_4") and not target:IsBuilding() then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_burn", {duration = self.burn_duration})
  end

  if target:IsRealHero() and self:GetCaster():GetQuest() == "Lina.Quest_5" and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() >= self:GetCaster().quest.number then 
    self:GetCaster():UpdateQuest(1)
  end

  if self:GetCaster():GetQuest() == "Lina.Quest_7" and target:IsRealHero() and not self:GetCaster():QuestCompleted() then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_lina_fiery_soul_custom_quest", {duration = self:GetCaster().quest.number})
  end



  ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self } )

  local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
  direction.z = 0
  direction = direction:Normalized()

  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
  ParticleManager:SetParticleControlForward( particle, 1, direction )
  ParticleManager:ReleaseParticleIndex( particle )
end



modifier_lina_dragon_slave_custom_stack = class({})
function modifier_lina_dragon_slave_custom_stack:IsHidden() return false end
function modifier_lina_dragon_slave_custom_stack:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_stack:GetTexture() return "buffs/dragon_stack" end
function modifier_lina_dragon_slave_custom_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_lina_dragon_slave_custom_stack:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
if self:GetStackCount() >= self:GetAbility().stack_max then 

  local stun = self:GetAbility().stack_stun

  self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex(self.effect_cast)
  self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.Target")

  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = stun*(1 - self:GetParent():GetStatusResistance())})

  self:Destroy()

end

end


function modifier_lina_dragon_slave_custom_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

  local particle_cast = "particles/lina_stack_stun.vpcf"

  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end


function modifier_lina_dragon_slave_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_lina_dragon_slave_custom_stack:OnTooltip()
return self:GetAbility().stack_max
end

modifier_lina_dragon_slave_custom_legendary = class({})
function modifier_lina_dragon_slave_custom_legendary:IsHidden() return false end
function modifier_lina_dragon_slave_custom_legendary:IsPurgable() return false end 
function modifier_lina_dragon_slave_custom_legendary:GetEffectName() return "particles/huskar_spears_legen.vpcf" end
function modifier_lina_dragon_slave_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_omnislash.vpcf"
end
function modifier_lina_dragon_slave_custom_legendary:StatusEffectPriority() return
11111
end

function modifier_lina_dragon_slave_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

self:GetParent():EmitSound("Lina.Dragon_legendary")
  --self.hands = ParticleManager:CreateParticle("particles/huskar_hands.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
 -- ParticleManager:SetParticleControlEnt(self.hands,0,self:GetParent(),PATTACH_ABSORIGIN_FOLLOW,"follow_origin",self:GetParent():GetOrigin(),false)
  --self:AddParticle(self.hands,true,false,0,false,false)

self:StartIntervalThink(0.2)
end
function modifier_lina_dragon_slave_custom_legendary:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = self:GetAbility().legendary_duration, current = self:GetRemainingTime(), active = 1})

end





function modifier_lina_dragon_slave_custom_legendary:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = self:GetAbility().legendary_max, current = 0, active = 0})

end






modifier_lina_dragon_slave_custom_tracker = class({})
function modifier_lina_dragon_slave_custom_tracker:IsHidden() return true end
function modifier_lina_dragon_slave_custom_tracker:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_lina_dragon_slave_custom_tracker:OnCreated(table)
if not IsServer() then return end
self.active = 0

self:StartIntervalThink(1)
end

function modifier_lina_dragon_slave_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_lina_dragon_legendary") then 
  return
else
  if self.active == 0 then 
    self.active = 1
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = self:GetAbility().legendary_max, current = self:GetStackCount(), active = 0})
  end

end



if self:GetStackCount() == 0 then return end

self:DecrementStackCount()

self:StartIntervalThink(0.2)
end


function modifier_lina_dragon_slave_custom_tracker:OnTakeDamage( params )
if not IsServer() then return end
if self:GetParent() ~= params.unit and self:GetParent() ~= params.attacker then return end
if (self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() >= self:GetAbility().legendary_range then return end
if params.inflictor and params.inflictor:IsItem() then return end

self:StartIntervalThink(self:GetAbility().legendary_delay)

end



function modifier_lina_dragon_slave_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end


if self:GetCaster():HasModifier("modifier_lina_dragon_2") then 

    local chance = self:GetAbility().heal_chance[self:GetCaster():GetUpgradeStack("modifier_lina_dragon_2")]
    local random = RollPseudoRandomPercentage(chance,123,self:GetCaster())

    if random then 
      local mana = self:GetCaster():GetMaxMana()*self:GetAbility().heal_mana
      local heal = mana*(self:GetAbility().heal_health/100)
      
      local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
      ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetAbsOrigin() )
      ParticleManager:ReleaseParticleIndex( particle )
      self:GetCaster():EmitSound("Lina.Dragon_heal")

      self:GetCaster():Heal(heal, self:GetAbility())
      self:GetCaster():GiveMana(mana)
      SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)
    end
end

if self:GetParent():HasModifier("modifier_lina_dragon_slave_custom_legendary") then return end
if not self:GetParent():HasModifier("modifier_lina_dragon_legendary") then return end

self:GiveStacks(self:GetAbility().legendary_spells)

self:StartIntervalThink(self:GetAbility().legendary_delay)


end



function modifier_lina_dragon_slave_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_lina_dragon_slave_custom_legendary") then return end
if not self:GetParent():HasModifier("modifier_lina_dragon_legendary") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

self:GiveStacks(self:GetAbility().legendary_attack)

end


function modifier_lina_dragon_slave_custom_tracker:GiveStacks(count)
if not IsServer() then return end

self:SetStackCount(self:GetStackCount() + count)

if self:GetStackCount() >= self:GetAbility().legendary_max then 

   self:GetAbility():EndCooldown()
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_dragon_slave_custom_legendary", {duration = self:GetAbility().legendary_duration})
  
  self:SetStackCount(0)
end

end


function modifier_lina_dragon_slave_custom_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_lina_dragon_slave_custom_legendary")


local max = self:GetAbility().legendary_max
local current = self:GetStackCount()
local active = 0

if mod then 
  max = self:GetAbility().legendary_duration
  current = mod:GetRemainingTime()
  active = 1
end

self.active = 1
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = max, current = current, active = active})


end






modifier_lina_dragon_slave_custom_burn = class({})
function modifier_lina_dragon_slave_custom_burn:IsHidden() return false end
function modifier_lina_dragon_slave_custom_burn:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lina_dragon_slave_custom_burn:GetTexture() return "buffs/dragon_burn" end
function modifier_lina_dragon_slave_custom_burn:GetEffectName()
return "particles/roshan_meteor_burn_.vpcf"
end

function modifier_lina_dragon_slave_custom_burn:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().burn_interval)
end

function modifier_lina_dragon_slave_custom_burn:OnIntervalThink()
if not IsServer() then return end

local damage = self:GetParent():GetMaxHealth()*(self:GetAbility().burn_init + self:GetAbility().burn_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_4"))
if not self:GetParent():IsHero() then 
  damage = damage*self:GetAbility().burn_creep
end

 ApplyDamage( { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() } )

  SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)

end


