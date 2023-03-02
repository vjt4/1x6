LinkLuaModifier("modifier_custom_juggernaut_omnislash", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omnislash_check", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omnislash_cd", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_effect", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_root", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_blink", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_regen", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)


custom_juggernaut_omnislash = class({})

custom_juggernaut_omnislash.proc_chance = 20
custom_juggernaut_omnislash.proc_omni = 2
custom_juggernaut_omnislash.proc_cd = 1.5

custom_juggernaut_omnislash.heal = {30 , 45 ,60}

custom_juggernaut_omnislash.blink_duration = 2
custom_juggernaut_omnislash.blink_max = 600
custom_juggernaut_omnislash.blink_damage = {0.08, 0.12}
custom_juggernaut_omnislash.blink_creeps = 0.33

custom_juggernaut_omnislash.root_duration = 1.5
custom_juggernaut_omnislash.root_heal = -60
custom_juggernaut_omnislash.root_heal_duration = 2

custom_juggernaut_omnislash.aoe_damage = {30, 45, 60}
custom_juggernaut_omnislash.aoe_radius = 200


custom_juggernaut_omnislash.rate_init = 20
custom_juggernaut_omnislash.rate_inc = 20

custom_juggernaut_omnislash.legendary_range = 700
custom_juggernaut_omnislash.legendary_duration = 1
custom_juggernaut_omnislash.legendary_cd = 20
custom_juggernaut_omnislash.legendary_radius = 250
custom_juggernaut_omnislash.legendary_mana = 100
custom_juggernaut_omnislash.legendary_cast = 0.15


custom_juggernaut_swift_slash = class({})

custom_juggernaut_swift_slash.legendary_range = 700
custom_juggernaut_swift_slash.legendary_radius = 250
custom_juggernaut_swift_slash.legendary_mana = 100
custom_juggernaut_swift_slash.legendary_cast = 0.15


function custom_juggernaut_swift_slash:GetCastPoint()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then return self.legendary_cast
else return 0.3 end end



function custom_juggernaut_omnislash:GetCastPoint()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then return self.legendary_cast
else return 0.3 end end


function custom_juggernaut_omnislash:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self.legendary_cd
end

return self.BaseClass.GetCooldown(self, iLevel)

end



function custom_juggernaut_omnislash:GetAOERadius() 
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self.legendary_radius
end
return 0
end

function custom_juggernaut_omnislash:GetBehavior()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end


function custom_juggernaut_omnislash:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  if IsClient() then 
    return self.legendary_range
  end
  return 999999
end
 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end



function custom_juggernaut_omnislash:GetIntrinsicModifierName()
if self:GetCaster():IsRealHero()  then  return "modifier_omnislash_check" end
end



function custom_juggernaut_omnislash:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
return self.legendary_mana
else 
return self:GetSpecialValueFor("mana") end
end



function custom_juggernaut_omnislash:OnSpellStart(target)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
    
  self.target = self:GetCursorPosition()
  local distance = (self.target - self:GetCaster():GetAbsOrigin())
  local range = self.legendary_range  + self:GetCaster():GetCastRangeBonus()

  if distance:Length2D() > range then 
    self.target = self:GetCaster():GetAbsOrigin() + distance:Normalized()*range
  end 

else 

  if target then 
    self.target = target:GetAbsOrigin()
  else 
    self.target = self:GetCursorTarget():GetAbsOrigin()
  end
end



   
self:GetCaster():Purge(false, true, false, false, false)
self.duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  self.duration = self.legendary_duration
end

if not IsServer() then return end

self:Omnislash(self:GetCaster(), self.target, self.duration, false)

end





function custom_juggernaut_omnislash:Omnislash( caster , target , duration)
if not IsServer() then return end
self.caster = caster

if caster:HasModifier("modifier_custom_juggernaut_omnislash") then 
  caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash")
end

self.caster:EmitSound("Hero_Juggernaut.OmniSlash")

local position = self.caster:GetAbsOrigin()
FindClearSpaceForUnit(self.caster, target, false)

local radius = 10
if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then 
  radius = self.legendary_radius
end

local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
local first_target = nil 

for _,i in ipairs(targets) do 
   if not i:IsCourier() and i:GetUnitName() ~= "npc_teleport" then 
      first_target = i
      break
  end
end

if first_target == nil then 


  if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then  

    if self.caster:HasModifier("modifier_custom_juggernaut_omnislash_effect") then 
      self.caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash_effect")
    end
    self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash_effect", {duration = 0.5})

  end

else 
   
  self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash", {duration = duration, first_target = first_target:entindex(), scepter = false})
end   

if self.caster:IsRealHero() then 
   PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), self.caster)
  PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), nil)
end


local position2 = self.caster:GetAbsOrigin()
local effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"

local particle = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, position)
ParticleManager:SetParticleControl(particle, 1, position2)
ParticleManager:ReleaseParticleIndex(particle)


end


modifier_custom_juggernaut_omnislash = class({})

function modifier_custom_juggernaut_omnislash:IsPurgable() return false end

function modifier_custom_juggernaut_omnislash:OnCreated(table)

local omni = self:GetAbility()
self.ability = self:GetParent():FindAbilityByName("custom_juggernaut_omnislash")
if table.scepter == 1 then 
  self.ability = self:GetParent():FindAbilityByName("custom_juggernaut_swift_slash")
end
self.scepter = table.scepter


self.root_target = nil

self.damage = omni:GetSpecialValueFor("damage")
self.speed = omni:GetSpecialValueFor("speed")
self.radius = omni:GetSpecialValueFor("radius")

self.ishitting = false
self.lastenemy = nil



if not IsServer() then return end 


self.arcana = false
if self:GetParent() ~= nil and self:GetParent():IsHero() then
  local children = self:GetParent():GetChildren()
    for k,child in pairs(children) do

     if child:GetClassname() == "dota_item_wearable" then
         if child:GetModelName() == "models/items/juggernaut/arcana/juggernaut_arcana_mask.vmdl" then
            self.arcana = true 
            break
         end
    end
  end
end 




self.first_target = EntIndexToHScript(table.first_target)


self.turn = self:GetCaster():GetForwardVector()

self.omni = self:GetParent():FindAbilityByName("custom_juggernaut_omnislash")
--if self.omni then  self.omni:SetActivated(false) end 

self.fury = self:GetParent():FindAbilityByName("custom_juggernaut_blade_fury")
if self.fury then  self.fury:SetActivated(false) end 

self.crit = self:GetParent():FindAbilityByName("custom_juggernaut_blade_dance")
if self.crit and self:GetParent():HasModifier("modifier_juggernaut_bladedance_legendary") then  self.crit:SetActivated(false) end 



self:SetHasCustomTransmitterData(true)

self.bonusrate = omni:GetSpecialValueFor("bonus_rate")


Timers:CreateTimer(FrameTime(),function()
  self:slash(true)
  self.rate = (1/self:GetParent():GetAttacksPerSecond())/self.bonusrate
  self:StartIntervalThink(self.rate)    
end)

end

 


function modifier_custom_juggernaut_omnislash:AddCustomTransmitterData() return {
damage = self.damage,
speed = self.speed


} end

function modifier_custom_juggernaut_omnislash:HandleCustomTransmitterData(data)
self.damage = data.damage
self.speed = data.speed
end


function modifier_custom_juggernaut_omnislash:StatusEffectPriority()
    return 20
end

function modifier_custom_juggernaut_omnislash:GetStatusEffectName()
    return "particles/status_fx/status_effect_omnislash.vpcf"
end


function modifier_custom_juggernaut_omnislash:OnIntervalThink()

self.rate = (1/self:GetParent():GetAttacksPerSecond())/(self.bonusrate)
self:slash()
self:StartIntervalThink(self.rate)
end

function modifier_custom_juggernaut_omnislash:TargetNear( target , near )
if not IsServer() then return end

for _,i in ipairs(near) do 
  if i == target then return true end
end

return false
end



function modifier_custom_juggernaut_omnislash:slash( first )
if not IsServer() then return end

local order = FIND_ANY_ORDER

if first then
  order = FIND_CLOSEST
  number = 1 
else 
  number = number + 1 
end

self.ishitting = false

local target = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS  + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, order, false)
    
if #target >= 1 then 

  for _,enemy in ipairs(target) do

    local can_hit = true



    if enemy:GetUnitName() == "npc_teleport" or enemy:IsCourier() then can_hit = false end

    if can_hit == true then

      self.ishitting = true
      self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
      self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

      local position1 = self:GetParent():GetAbsOrigin()

      if number%2 ~= 0 then       
        local position = (enemy:GetAbsOrigin() - (self.turn)*70)
        FindClearSpaceForUnit(self:GetParent(), position, false)
      else 
        local position = (enemy:GetAbsOrigin() + (self.turn)*70)
        FindClearSpaceForUnit(self:GetParent(), position, false)   
      end


      if number ~= 1 then  
          
        local angel = (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin())
        angel.z = 0.0
        angel = angel:Normalized()

        self:GetParent():SetForwardVector(angel)
        self:GetParent():FaceTowards(enemy:GetAbsOrigin())
      
      end

      local position2 = self:GetParent():GetAbsOrigin()


      local linken = false 
      if first and self:GetParent():IsRealHero() and self:GetCaster():GetName() == "npc_dota_hero_juggernaut" and not self:GetParent():HasModifier("modifier_juggernaut_omnislash_legendary")  then 
        if enemy:TriggerSpellAbsorb(self.ability) then 
          linken = true
        end
      end

      if linken == false then

        self:GetParent():PerformAttack(enemy, true, true, true, false, false, false, false)
        self.root_target = enemy
        if self:GetParent():HasModifier("modifier_juggernaut_omnislash_cd") then 
          self:GetParent():AddNewModifier(self:GetParent(), self.omni, "modifier_custom_juggernaut_omnislash_blink", {duration = self.omni.blink_duration})
        end

  
        enemy:EmitSound("Hero_Juggernaut.OmniSlash")
      end


      local effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf"
      if self.scepter == 1 then effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt_scepter.vpcf" end

      if self.arcana == true and self.scepter == 0 then 
          local particle = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
         ParticleManager:SetParticleControlEnt( particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )

      else 
         local particle = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
          ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetAbsOrigin(), true )
          ParticleManager:SetParticleControl( particle, 1, position2 )
      end

   
      effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"
      if self.scepter == 1 then effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf" end

      local trail_pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, self:GetParent())
      ParticleManager:SetParticleControl(trail_pfx, 0, position1)
      ParticleManager:SetParticleControl(trail_pfx, 1, position2)
      ParticleManager:ReleaseParticleIndex(trail_pfx)


      self.lastenemy = enemy
      return

    end
  end
end

Timers:CreateTimer(0.15,function()
if self then 

  if self ~= nil and not self:IsNull() and self.ishitting == false and self:GetParent() ~= nil then

    if not self:GetParent():IsRealHero() then 
      self:GetParent():ForceKill(false)
    end  
    
    self:Destroy() 
  end

end

end)
   
end

function modifier_custom_juggernaut_omnislash:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_custom_juggernaut_omnislash:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if self:GetParent():HasModifier("modifier_juggernaut_omnislash_heal") then 

  local heal = self.omni.heal[self:GetParent():GetUpgradeStack("modifier_juggernaut_omnislash_heal")]
  my_game:GenericHeal(self:GetParent(), heal, self.omni)

end
 
if self:GetParent():HasModifier("modifier_juggernaut_omnislash_speed") then 

  local damage = self.omni.aoe_damage[self:GetParent():GetUpgradeStack("modifier_juggernaut_omnislash_speed")]

  local damageTable = {
      attacker = self:GetParent(),
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self.omni,
      damage = damage}

  local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self.omni.aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)

  local particle = ParticleManager:CreateParticle("particles/jugg_omni_aoe.vpcf", PATTACH_WORLDORIGIN, nil)  
  ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())

  for _,target in pairs(targets) do
    damageTable.victim = target
    ApplyDamage(damageTable)


    local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( effect_cast )
  end

end

end




function modifier_custom_juggernaut_omnislash:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
local omni = self:GetParent():FindAbilityByName("custom_juggernaut_omnislash")

if self:GetParent():HasModifier("modifier_juggernaut_omnislash_stack") then 
  bonus = bonus + omni.rate_init + omni.rate_inc*self:GetParent():GetUpgradeStack("modifier_juggernaut_omnislash_stack")
end


 return self.speed + bonus
end

function modifier_custom_juggernaut_omnislash:GetModifierPreAttack_BonusDamage() return self.damage end


function modifier_custom_juggernaut_omnislash:OnDestroy()
if not IsServer() then return end

if self:GetParent():IsRealHero() then

  if self.fury and not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_passive_fury") then
    self.fury:SetActivated(true) 
  end

  if self.crit then self.crit:SetActivated(true) end 
end


self:GetParent():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
self:GetParent():MoveToPositionAggressive(self:GetParent():GetAbsOrigin())



if self:GetParent():HasModifier("modifier_juggernaut_omnislash_aoe_attack") and self.root_target and self.root_target:IsAlive() then 


  local point_1 = self.root_target:GetAbsOrigin()
  point_1.z = point_1.z - 100

  local point_2 = self.root_target:GetAbsOrigin()

  local particle = ParticleManager:CreateParticle("particles/jugger_stack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.root_target )
  ParticleManager:SetParticleControl( particle, 2, point_1  )
  ParticleManager:SetParticleControl( particle, 3, point_2 )
  self.root_target:EmitSound("PBeast.Uproar_root")
  self.root_target:AddNewModifier(self:GetParent(), self.omni, "modifier_custom_juggernaut_omnislash_root", {duration = (1 - self.root_target:GetStatusResistance())*self.omni.root_duration})
  self.root_target:AddNewModifier(self:GetParent(), self.omni, "modifier_custom_juggernaut_omnislash_regen", {duration = self.omni.root_heal_duration})
 
end



end

function modifier_custom_juggernaut_omnislash:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }

    return state
end

function modifier_custom_juggernaut_omnislash:GetModifierIgnoreCastAngle()
   return 1
end








--------------------------------------------------------------------------------------------------------------


modifier_omnislash_check = class({})

function modifier_omnislash_check:IsHidden() return true end

function modifier_omnislash_check:IsPurgable() return false end 

function modifier_omnislash_check:DeclareFunctions()
return 
{
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

end


function modifier_omnislash_check:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_juggernaut_omnislash_clone") then return end
if self:GetParent() ~= params.attacker then return end

local chance = self:GetAbility().proc_chance

if self:GetParent():HasModifier("modifier_custom_juggernaut_omnislash") then 
  chance = chance*self:GetAbility().proc_omni
end

local random = RollPseudoRandomPercentage(chance,22,self:GetParent())

if not random then return end


local effect_cast = ParticleManager:CreateParticle( "particles/jugg_omni_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("Juggernaut.Omni_cd")

if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
  local cd = self:GetAbility():GetCooldownTimeRemaining()
  self:GetAbility():EndCooldown()

  if cd > self:GetAbility().proc_cd then 
    cd = cd - self:GetAbility().proc_cd
  end
  self:GetAbility():StartCooldown(cd)

end

local ability = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")

if ability:GetCooldownTimeRemaining() > 0 then 
  local cd = ability:GetCooldownTimeRemaining()
  ability:EndCooldown()

  if cd > self:GetAbility().proc_cd then 
    cd = cd - self:GetAbility().proc_cd
  end
  ability:StartCooldown(cd)

end



end














function custom_juggernaut_swift_slash:GetAOERadius() 
if  self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  return self.legendary_radius
end
return 0
end

function custom_juggernaut_swift_slash:GetBehavior()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then
    return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end




function custom_juggernaut_swift_slash:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
return self.legendary_mana
else 
return self:GetSpecialValueFor("mana") end
end



function custom_juggernaut_swift_slash:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  if IsClient() then 
    return self.legendary_range
  end
  return 999999
end
 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end





function custom_juggernaut_swift_slash:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() and self:GetCaster():GetUnitName() == "npc_dota_hero_juggernaut" then
        self:SetHidden(false)        
        if not self:IsTrained() then
            local ab = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash"):GetLevel()
            if ab > 0 then
                self:SetLevel(1)
            end
        end
    else
        self:SetHidden(true)
    end
end

function custom_juggernaut_swift_slash:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end






function custom_juggernaut_swift_slash:OnSpellStart(target)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
    
  self.target = self:GetCursorPosition()
  local distance = (self.target - self:GetCaster():GetAbsOrigin())
  local range = self.legendary_range  + self:GetCaster():GetCastRangeBonus()

  if distance:Length2D() > range then 
    self.target = self:GetCaster():GetAbsOrigin() + distance:Normalized()*range
  end 

else 

  if target then 
    self.target = target:GetAbsOrigin()
  else 
    self.target = self:GetCursorTarget():GetAbsOrigin()
  end
end



   
self:GetCaster():Purge(false, true, false, false, false)

self.duration = self:GetSpecialValueFor("duration")



self:Omnislash(self:GetCaster(), self.target, self.duration)


end








function custom_juggernaut_swift_slash:Omnislash( caster , target , duration)
if not IsServer() then return end
self.caster = caster

if caster:HasModifier("modifier_custom_juggernaut_omnislash") then 
  caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash")
end
self.caster:EmitSound("Hero_Juggernaut.OmniSlash")

local position = self.caster:GetAbsOrigin()
FindClearSpaceForUnit(self.caster, target, false)

local radius = 10
if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then 
  radius = self.legendary_radius
end

local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
local first_target = nil 

for _,i in ipairs(targets) do 
   if not i:IsCourier() and i:GetUnitName() ~= "npc_teleport" then 
      first_target = i
      break
  end
end

if first_target == nil then 


  if self.caster:HasModifier("modifier_juggernaut_omnislash_legendary") then  

    if self.caster:HasModifier("modifier_custom_juggernaut_omnislash_effect") then 
      self.caster:RemoveModifierByName("modifier_custom_juggernaut_omnislash_effect")
    end
    self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash_effect", {duration = 0.5})

  end

else 
   
  self.caster:AddNewModifier(self.caster, self, "modifier_custom_juggernaut_omnislash", {duration = duration, first_target = first_target:entindex(), scepter = true})
end   

if self.caster:IsRealHero() then 
   PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), self.caster)
  PlayerResource:SetCameraTarget(self.caster:GetPlayerOwnerID(), nil)
end


local position2 = self.caster:GetAbsOrigin()
effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf"

local particle = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, position)
ParticleManager:SetParticleControl(particle, 1, position2)
ParticleManager:ReleaseParticleIndex(particle)


end















modifier_custom_juggernaut_omnislash_effect = class({})
function modifier_custom_juggernaut_omnislash_effect:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_effect:IsPurgable() return false end

function modifier_custom_juggernaut_omnislash_effect:StatusEffectPriority()
    return 20
end

function modifier_custom_juggernaut_omnislash_effect:GetStatusEffectName()
    return "particles/status_fx/status_effect_omnislash.vpcf"
end


function modifier_custom_juggernaut_omnislash_effect:OnCreated(table)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_SPAWN_STATUE)
self.pos = self:GetParent():GetAbsOrigin()
self.fade = false
self:StartIntervalThink(0.1)
end

function modifier_custom_juggernaut_omnislash_effect:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():GetAbsOrigin() ~= self.pos then 
  self.fade = true 
  self:GetParent():FadeGesture(ACT_DOTA_SPAWN_STATUE)

end

end

function modifier_custom_juggernaut_omnislash_effect:OnDestroy()
if not IsServer() then return end
if self.fade == true then return end
self:GetParent():FadeGesture(ACT_DOTA_SPAWN_STATUE)
end
      
      

modifier_custom_juggernaut_omnislash_root = class({})
function modifier_custom_juggernaut_omnislash_root:IsPurgable() return true end
function modifier_custom_juggernaut_omnislash_root:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_root:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true
}
end

function modifier_custom_juggernaut_omnislash_root:GetEffectName()
return "particles/beast_root.vpcf"
end


modifier_custom_juggernaut_omnislash_blink = class({})
function modifier_custom_juggernaut_omnislash_blink:IsHidden() return false end
function modifier_custom_juggernaut_omnislash_blink:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_blink:GetTexture() return "buffs/Omnislash_cd" end 
function modifier_custom_juggernaut_omnislash_blink:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ORDER,
  MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_custom_juggernaut_omnislash_blink:OnCreated(table)
if not IsServer() then return end
self.moved = false
end

function modifier_custom_juggernaut_omnislash_blink:OnRefresh(table)
if not IsServer() then return end
end

function modifier_custom_juggernaut_omnislash_blink:OnOrder( ord )
if not IsServer() then return end
if ord.unit ~= self:GetParent() then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_omnislash") then return end
if self.moved == true then return end
if ord.order_type ~= DOTA_UNIT_ORDER_MOVE_TO_POSITION then return end


local position1 = self:GetParent():GetAbsOrigin()
local position2 = ord.new_pos
local dir = (position2 - position1):Normalized()

if (position2 - position1):Length2D() > self:GetAbility().blink_max then 

  position2 =  position1 + dir*self:GetAbility().blink_max
end

local effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"

local particle = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, position1)
ParticleManager:SetParticleControl(particle, 1, position2)
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():EmitSound("Juggernaut.Stack")
self:GetParent():EmitSound("Hero_Juggernaut.OmniSlash")
self:GetParent():SetAbsOrigin(position2)

self.moved = true

self:GetParent():SetForwardVector(dir)
FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_omnislash_effect")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_omnislash_effect", {duration = 0.5})

 
local damageTable = {
      attacker = self:GetParent(),
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self:GetAbility()}
    ApplyDamage( damageTable )

local attack = FindUnitsInLine(self:GetParent():GetTeamNumber(), position1, position2, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

for _,i in ipairs(attack) do
  damageTable.victim = i

  local damage = i:GetMaxHealth()*self:GetAbility().blink_damage[self:GetParent():GetUpgradeStack("modifier_juggernaut_omnislash_cd")]

  if i:IsCreep() then 
    damage = damage*self:GetAbility().blink_creeps
  end

  damageTable.damage = damage

  SendOverheadEventMessage(i, 6, i, damage, nil)

  ApplyDamage(damageTable)
  local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, i)

end


self:Destroy()
end



function modifier_custom_juggernaut_omnislash_blink:OnTooltip()
return self:GetAbility().blink_damage[self:GetParent():GetUpgradeStack("modifier_juggernaut_omnislash_cd")]*100
end








modifier_custom_juggernaut_omnislash_regen = class({})
function modifier_custom_juggernaut_omnislash_regen:IsHidden() return false end
function modifier_custom_juggernaut_omnislash_regen:IsPurgable() 
return true
end


function modifier_custom_juggernaut_omnislash_regen:GetTexture() return "buffs/chains_resist" end



function modifier_custom_juggernaut_omnislash_regen:DeclareFunctions()
return
{
MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end



function modifier_custom_juggernaut_omnislash_regen:GetModifierLifestealRegenAmplify_Percentage() return self:GetAbility().root_heal
 end
function modifier_custom_juggernaut_omnislash_regen:GetModifierHealAmplify_PercentageTarget() return self:GetAbility().root_heal
 end
function modifier_custom_juggernaut_omnislash_regen:GetModifierHPRegenAmplify_Percentage() return self:GetAbility().root_heal end

function modifier_custom_juggernaut_omnislash_regen:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end