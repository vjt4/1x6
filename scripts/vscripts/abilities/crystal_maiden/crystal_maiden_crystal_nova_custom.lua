LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_custom", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_armor", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_legendary", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_legendary_aura", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_legendary_slide", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_crystal_nova_shards", "abilities/crystal_maiden/crystal_maiden_crystal_nova_custom", LUA_MODIFIER_MOTION_NONE )






crystal_maiden_crystal_nova_custom = class({})

crystal_maiden_crystal_nova_custom.cast_range = {100, 150, 200}
crystal_maiden_crystal_nova_custom.cast_speed = {10, 15, 20}
crystal_maiden_crystal_nova_custom.cast_speed_duration = 4

crystal_maiden_crystal_nova_custom.cd_inc = {-1, -1.5, -2}

crystal_maiden_crystal_nova_custom.damage_inc = {60, 100, 140}

crystal_maiden_crystal_nova_custom.armor_duration = 4
crystal_maiden_crystal_nova_custom.armor_damage = -20
crystal_maiden_crystal_nova_custom.armor_heal = 10

crystal_maiden_crystal_nova_custom.freeze_damage = {25, 40}
crystal_maiden_crystal_nova_custom.freeze_max = 3
crystal_maiden_crystal_nova_custom.freeze_mods =
{
  'modifier_crystal_maiden_crystal_nova_legendary_aura',
  'modifier_crystal_maiden_crystal_nova_custom',
  'modifier_crystal_maiden_freezing_field_custom_debuff',
  'modifier_crystal_maiden_frostbite_custom', 
}

function crystal_maiden_crystal_nova_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_maiden_crystal_1") then 
  bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_maiden_crystal_1")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end




function crystal_maiden_crystal_nova_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_maiden_crystal_5") then 
  return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end


return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function crystal_maiden_crystal_nova_custom:GetCastPoint()

if self:GetCaster():HasModifier("modifier_maiden_crystal_5") then 
  return 0
end

 return self:GetSpecialValueFor("AbilityCastPoint")
 
end




function crystal_maiden_crystal_nova_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_maiden_crystal_3") then 
  upgrade = self.cast_range[self:GetCaster():GetUpgradeStack("modifier_maiden_crystal_3")]
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



  

function crystal_maiden_crystal_nova_custom:GetAOERadius()
  return self:GetSpecialValueFor( "radius" )
end




function crystal_maiden_crystal_nova_custom:OnSpellStart()

  local caster = self:GetCaster()
  local point = self:GetCursorPosition()


  local castrange = self:GetSpecialValueFor("AbilityCastRange")

  if self:GetCaster():HasModifier("modifier_maiden_crystal_3") then 
    castrange = castrange + self.cast_range[self:GetCaster():GetUpgradeStack("modifier_maiden_crystal_3")]
  end

  local dir = (point - caster:GetAbsOrigin()):Normalized()

  if (point - caster:GetAbsOrigin()):Length2D() > castrange then 
    --point = point + self:GetCaster():GetAbsOrigin() + dir*castrange
  end


  local damage = self:GetSpecialValueFor("nova_damage")
  local radius = self:GetSpecialValueFor("radius")
  local debuffDuration = self:GetSpecialValueFor("duration")

  local vision_radius = 900
  local vision_duration = 6

  if self:GetCaster():HasModifier("modifier_maiden_crystal_2") then 
    damage = damage + self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_maiden_crystal_2")]
  end

  if self:GetCaster():HasModifier("modifier_maiden_crystal_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_movespeed",
    {
      duration = self.cast_speed_duration,
      effect = "particles/zuus_speed.vpcf",
      movespeed = self.cast_speed[self:GetCaster():GetUpgradeStack("modifier_maiden_crystal_3")]
    })
  end


--local modelDummy = CreateUnitByName("npc_dota_companion", point, false, nil, nil, self:GetCaster():GetTeamNumber())

--modelDummy:SetAbsOrigin(GetGroundPosition(modelDummy:GetAbsOrigin(), modelDummy))
--modelDummy:SetOriginalModel("models/particle/ice_shards.vmdl")
--modelDummy:SetModel("models/particle/ice_shards.vmdl")
--modelDummy:SetModelScale(11)
--modelDummy:SetHullRadius(40)
--modelDummy:AddNewModifier(self:GetCaster(), self, 'modifier_crystal_maiden_crystal_nova_shards',{duration = 10})

  local knockback = 0
  local height = 90
  local speed = 1100
  local duration = 0.3

  if self:GetCaster():HasModifier("modifier_maiden_crystal_5") then 

    knockback = 1

    if (self:GetCaster():GetAbsOrigin() - point):Length2D() <= radius then 
      local dir = (self:GetCaster():GetAbsOrigin() - point):Normalized()
      local point = point + dir*radius

      local distance = (point - self:GetCaster():GetAbsOrigin()):Length2D()

      distance = math.max(200, distance)
      point = point + dir*distance

      self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_generic_arc", {target_x = point.x, target_y = point.y, distance = distance, duration = duration, height = height, fix_end = false, isStun = false, activity = ACT_DOTA_FLAIL,} )

    end
  end

  local arcane = self:GetCaster():FindAbilityByName("crystal_maiden_arcane_aura_custom")
  local mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_spell")
  if arcane and mod then 

    mod:Destroy()

    EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "DOTA_Item.Arcane_Blink.Activate", self:GetCaster())

    local effect_end = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2016/blink_dagger_start_wm.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( effect_end, 0, self:GetCaster():GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_end )

    FindClearSpaceForUnit(self:GetCaster(), point, true)

    local effect_end = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2016/blink_dagger_wm_end.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( effect_end, 0, self:GetCaster():GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_end )

    self:GetCaster():EmitSound("Puck.Rift_Legendary")

   
  end


  local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )



  local damageTable = { attacker = caster, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }

  for _,enemy in pairs(enemies) do

    damageTable.victim = enemy

    local damage = damage
    local bonus = 0

    if self:GetCaster():HasModifier("modifier_maiden_crystal_4") then 
      local count = 0

      for i = 1,#self.freeze_mods do 


        if enemy:HasModifier(self.freeze_mods[i]) then 
          count = count + 1
        end
      end

      count = math.min(count, self.freeze_max)

      if count > 0 then 
        bonus = self.freeze_damage[self:GetCaster():GetUpgradeStack("modifier_maiden_crystal_4")]*count
        SendOverheadEventMessage(enemy, 2, enemy, bonus, nil)
      end
    end
    damage = damage * (1 + bonus/100)

    if enemy:IsCreep() then 
      damage = damage * (1 + self:GetSpecialValueFor("creeps_damage")/100)
    end

    damageTable.damage = damage


    ApplyDamage(damageTable)

    if knockback == 1 and enemy:IsHero() then 

    local dir = (enemy:GetAbsOrigin() - point):Normalized()
      local point = point + dir*radius

      local distance = (point - enemy:GetAbsOrigin()):Length2D()

    distance = math.max(200, distance)
      point = point + dir*distance

      enemy:AddNewModifier(
      enemy,
      self,
      "modifier_generic_arc",
      {target_x = point.x,
        target_y = point.y,
        distance = distance,
        duration = duration,
        height = height,
        fix_end = false,
        isStun = false,
        activity = ACT_DOTA_FLAIL,}
      )

    end

    enemy:AddNewModifier( caster, self, "modifier_crystal_maiden_crystal_nova_custom", { duration = debuffDuration } )
  end

  AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )

  
  if self:GetCaster():HasModifier("modifier_maiden_crystal_6") and (self:GetCaster():GetAbsOrigin() - point):Length2D() <= radius then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_armor", {duration = self.armor_duration})
    self:GetCaster():EmitSound("Maiden.Crystal_armor")
  end


  self:PlayEffects( point, radius, debuffDuration )
end




--------------------------------------------------------------------------------
function crystal_maiden_crystal_nova_custom:PlayEffects( point, radius, duration )

  local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
  local sound_cast = "Hero_Crystal.CrystalNova"


  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast, 0, point )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
  ParticleManager:ReleaseParticleIndex( effect_cast )


  EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end








modifier_crystal_maiden_crystal_nova_custom = class({})


function modifier_crystal_maiden_crystal_nova_custom:IsHidden()
  return false
end

function modifier_crystal_maiden_crystal_nova_custom:IsDebuff()
  return true
end

function modifier_crystal_maiden_crystal_nova_custom:IsPurgable()
  return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystal_maiden_crystal_nova_custom:OnCreated( kv )
  -- references
  self.as_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )  
  self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )  

  if not IsServer() then return end

  if self:GetCaster():GetQuest() == "Maiden.Quest_5" and self:GetParent():IsRealHero() and not self:GetCaster():QuestCompleted() then 
    self:StartIntervalThink(0.1)
  end

end

function modifier_crystal_maiden_crystal_nova_custom:OnIntervalThink()
if not IsServer() then return end

self:GetCaster():UpdateQuest(0.1)
end


function modifier_crystal_maiden_crystal_nova_custom:OnRefresh( kv )
  -- references
  self.as_slow = self:GetAbility():GetSpecialValueFor( "attackspeed_slow" )  
  self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )   
end

function modifier_crystal_maiden_crystal_nova_custom:OnDestroy( kv )

end


function modifier_crystal_maiden_crystal_nova_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  }

  return funcs
end

function modifier_crystal_maiden_crystal_nova_custom:GetModifierMoveSpeedBonus_Percentage()
  return self.ms_slow
end

function modifier_crystal_maiden_crystal_nova_custom:GetModifierAttackSpeedBonus_Constant()
  return self.as_slow
end




function modifier_crystal_maiden_crystal_nova_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_crystal_nova_custom:StatusEffectPriority()
return 9999
end










modifier_crystal_maiden_crystal_nova_armor = class({})
function modifier_crystal_maiden_crystal_nova_armor:IsHidden() return false end
function modifier_crystal_maiden_crystal_nova_armor:IsPurgable() return true end
function modifier_crystal_maiden_crystal_nova_armor:GetTexture() return "lich_frost_armor" end
function modifier_crystal_maiden_crystal_nova_armor:GetEffectName() return "particles/zuus_heal.vpcf" end




function modifier_crystal_maiden_crystal_nova_armor:OnCreated(table)
self.heal = self:GetAbility().armor_heal/self:GetRemainingTime()
self.damage = self:GetAbility().armor_damage

if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/neutral_fx/ogre_magi_frost_armor.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle( effect_cast, false, false, -1, false, false )

self:StartIntervalThink(1)
end

function modifier_crystal_maiden_crystal_nova_armor:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal*self:GetParent():GetMaxHealth()/100, nil)
end





function modifier_crystal_maiden_crystal_nova_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
   MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}

end


function modifier_crystal_maiden_crystal_nova_armor:GetModifierIncomingDamage_Percentage()
return self.damage
end

function modifier_crystal_maiden_crystal_nova_armor:GetModifierHealthRegenPercentage()
return self.heal
end











modifier_crystal_maiden_crystal_nova_legendary = class({})

function modifier_crystal_maiden_crystal_nova_legendary:IsAura()
return true
end

function modifier_crystal_maiden_crystal_nova_legendary:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("radius")

self.duration = self:GetAbility():GetSpecialValueFor("duration")

self.effect_cast = ParticleManager:CreateParticle("particles/maiden_ice_rink.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius*1.05, self.radius*1.05, self.radius*1.05 ) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector(self.duration, 0, 0) )
self:AddParticle( self.effect_cast, false, false, -1, false, false )

self:GetParent():EmitSound("Maiden.Crystal_rink_loop")

AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, self:GetRemainingTime(), false)

self.particle = ParticleManager:CreateParticle("particles/maiden_rink_glow.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetRemainingTime()+0.5, self.radius, 0))

end



function modifier_crystal_maiden_crystal_nova_legendary:OnDestroy()
if not IsServer() then return end

self:GetParent():StopSound("Maiden.Crystal_rink_loop")
self:GetParent():EmitSound("Lich.Spire_destroy")
end


function modifier_crystal_maiden_crystal_nova_legendary:GetAuraDuration()
  return 0
end


function modifier_crystal_maiden_crystal_nova_legendary:GetAuraRadius()
  return self.radius
end

function modifier_crystal_maiden_crystal_nova_legendary:GetAuraSearchFlags()
  return 
end

function modifier_crystal_maiden_crystal_nova_legendary:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_crystal_maiden_crystal_nova_legendary:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end




function modifier_crystal_maiden_crystal_nova_legendary:GetModifierAura()
  return "modifier_crystal_maiden_crystal_nova_legendary_aura"
end


function modifier_crystal_maiden_crystal_nova_legendary:GetAuraEntityReject(hEntity)
if hEntity:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hEntity:IsRooted() then 
  --return true
end

if hEntity:GetUnitName() == "npc_teleport" then 
  return true
end

return false
end



modifier_crystal_maiden_crystal_nova_legendary_aura = class({})
function modifier_crystal_maiden_crystal_nova_legendary_aura:IsHidden() return true end
function modifier_crystal_maiden_crystal_nova_legendary_aura:IsPurgable() return false end

function modifier_crystal_maiden_crystal_nova_legendary_aura:OnCreated(table)
if not IsServer() then return end


self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector())

self.interval = 0.5
self.cd_inc = self:GetAbility():GetSpecialValueFor("cd_inc")/100

self.count = 3

self:OnIntervalThink()
self:StartIntervalThink(self.interval)

end



function modifier_crystal_maiden_crystal_nova_legendary_aura:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + self.interval

if self.count >= 3 then 
  local effect_end = ParticleManager:CreateParticle( "particles/econ/items/drow/drow_arcana/drow_arcana_rare_run_slide.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( effect_end, 0, self:GetParent():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex( effect_end )

  local effect = ParticleManager:CreateParticle( "particles/zuus_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( effect, 0, self:GetParent():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex( effect)
  self:GetParent():EmitSound("Maiden.Crystal_rink_slide")
  self.count = 0
end

if self:GetCaster() ~= self:GetParent() then return end

local ability = self:GetParent():FindAbilityByName("crystal_maiden_crystal_nova_custom")

if not ability or ability:GetCooldownTimeRemaining() <= 0 then return end

local cd = ability:GetCooldownTimeRemaining()
ability:EndCooldown()

ability:StartCooldown(cd - (self.interval*self.cd_inc))


end





modifier_crystal_maiden_crystal_nova_legendary_slide = class({})

function modifier_crystal_maiden_crystal_nova_legendary_slide:IsAura()
return true
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("radius")

end



function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraDuration()
  return 0
end


function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraRadius()
  return self.radius
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraSearchFlags()
  return 
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraSearchType()
  return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end




function modifier_crystal_maiden_crystal_nova_legendary_slide:GetModifierAura()
  return "modifier_ice_slide"
end


function modifier_crystal_maiden_crystal_nova_legendary_slide:GetAuraEntityReject(hEntity)
if hEntity:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and hEntity:IsRooted() then 
  return true
end

if hEntity == self:GetCaster() and not self:GetCaster():HasShard() and self:GetCaster():HasModifier("modifier_crystal_maiden_freezing_field_custom") then 
  return true
end

if hEntity:GetUnitName() == "npc_teleport" then 
  return true
end

return false
end





crystal_maiden_crystal_nova_custom_legendary = class({})

function crystal_maiden_crystal_nova_custom_legendary:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function crystal_maiden_crystal_nova_custom_legendary:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()

CreateModifierThinker(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_legendary", {duration = self:GetSpecialValueFor("duration")}, point, self:GetCaster():GetTeamNumber(), false)
CreateModifierThinker(self:GetCaster(), self, "modifier_crystal_maiden_crystal_nova_legendary_slide", {duration = self:GetSpecialValueFor("duration")}, point, self:GetCaster():GetTeamNumber(), false)

self:GetCaster():EmitSound("Maiden.Crystal_rink_cast")

end



modifier_crystal_maiden_crystal_nova_shards = class({})

function modifier_crystal_maiden_crystal_nova_shards:IsPurgable() return false end
function modifier_crystal_maiden_crystal_nova_shards:CheckState()
return
{
  [MODIFIER_STATE_MAGIC_IMMUNE] = true,
  [MODIFIER_STATE_ATTACK_IMMUNE] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_ROOTED] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
}
end

function modifier_crystal_maiden_crystal_nova_shards:OnDestroy()
UTIL_Remove(self:GetParent())
end