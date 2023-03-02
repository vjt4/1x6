LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_buff", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_passive", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_vision", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_slow", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_legendary", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_legendary_illusion", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_turn_slow", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_agility_stack", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_agility", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_strike_invun", "abilities/phantom_assassin/custom_phantom_assassin_phantom_strike", LUA_MODIFIER_MOTION_NONE )

 
 
 
 
  
custom_phantom_assassin_phantom_strike = class({})

custom_phantom_assassin_phantom_strike.illusion_duration = 4
custom_phantom_assassin_phantom_strike.illusion_damage = -100
custom_phantom_assassin_phantom_strike.illusion_health = 100
custom_phantom_assassin_phantom_strike.illusion_invun = 0.15

custom_phantom_assassin_phantom_strike.agility_duration = 12
custom_phantom_assassin_phantom_strike.agility_stack = {1.5,2.5}


custom_phantom_assassin_phantom_strike.speed_duration = 3
custom_phantom_assassin_phantom_strike.speed_move = {15, 20, 25}



custom_phantom_assassin_phantom_strike.damage = {100, 200, 300}
custom_phantom_assassin_phantom_strike.damage_illusion = 0.5


custom_phantom_assassin_phantom_strike.duration_init = 0
custom_phantom_assassin_phantom_strike.duration_inc = 0.5

custom_phantom_assassin_phantom_strike.turn_slow = -70
custom_phantom_assassin_phantom_strike.turn_duration = 2
custom_phantom_assassin_phantom_strike.turn_cd = -1


function custom_phantom_assassin_phantom_strike:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_blink") then 
  upgrade_cooldown = self.turn_cd
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end

function custom_phantom_assassin_phantom_strike:GetIntrinsicModifierName() 

  return "modifier_phantom_assassin_phantom_strike_passive" 
end


function custom_phantom_assassin_phantom_strike:GetCastPoint()
if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_blink") then 
  return 0
else 
  return 0.25
end 

end






--------------------------------------------------------------------------------
-- Ability Cast Filter
function custom_phantom_assassin_phantom_strike:CastFilterResultTarget( hTarget )
  if self:GetCaster() == hTarget then
    return UF_FAIL_CUSTOM
  end

  local result = UnitFilter(
    hTarget,  -- Target Filter
    DOTA_UNIT_TARGET_TEAM_BOTH, -- Team Filter
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, -- Unit Filter
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, -- Unit Flag
    self:GetCaster():GetTeamNumber()  -- Team reference
  )
  
  if result ~= UF_SUCCESS then
    return result
  end

  return UF_SUCCESS
end

--------------------------------------------------------------------------------
-- Ability Cast Error Message
function custom_phantom_assassin_phantom_strike:GetCustomCastErrorTarget( hTarget )
  if self:GetCaster() == hTarget then
    return "#dota_hud_error_cant_cast_on_self"
  end

  return ""
end










function custom_phantom_assassin_phantom_strike:UseBlink(caster, target)
if not IsServer() then return end


self.duration = self:GetSpecialValueFor("duration") 

if caster:HasModifier("modifier_phantom_assassin_blink_duration") then 
  local bonus = self.duration_init + self.duration_inc*caster:GetUpgradeStack("modifier_phantom_assassin_blink_duration")
  self.duration = self.duration  + bonus 
end



if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_move") then 

  caster:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_strike_slow", {duration = self.speed_duration})

end




if target:GetTeamNumber()~=caster:GetTeamNumber() then
  if target:TriggerSpellAbsorb( self ) then return end
end

local blinkDistance = 50
local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
local blinkPosition = target:GetOrigin() + blinkDirection



if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_blink") then 
  blinkPosition = target:GetAbsOrigin() - target:GetForwardVector()*75
  target:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_strike_turn_slow", {duration = self.turn_duration})
end

local origin = caster:GetAbsOrigin()


caster:SetOrigin( blinkPosition )
FindClearSpaceForUnit( caster, blinkPosition, true )

 
if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_damage") then

  local damage = self.damage[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blink_damage")]

  if caster:IsIllusion() then 
    damage = damage*self.damage_illusion
  end

  local attack = FindUnitsInLine(caster:GetTeamNumber(), origin, target:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

  for _,i in ipairs(attack) do

    local particle = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt_bladekeeper.vpcf", PATTACH_ABSORIGIN_FOLLOW,i )
    ParticleManager:SetParticleControlEnt( particle, 0, i, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", i:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle, 1, i, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", i:GetAbsOrigin(), true )

    local trail_pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_attack_crit_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, i)
    ParticleManager:SetParticleControl(trail_pfx, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(trail_pfx, 1, i:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(trail_pfx)


  
    local damageTable = {
      victim = i,
      attacker = caster,
      damage = damage,
      damage_type = DAMAGE_TYPE_MAGICAL,
      ability = self}
    ApplyDamage( damageTable )
  end

end


if target:GetTeamNumber()~=caster:GetTeamNumber() then

  caster:AddNewModifier(caster, self, "modifier_phantom_assassin_phantom_strike_buff", { duration = self.duration } )


  if self:GetCaster():HasModifier("modifier_phantom_assassin_blink_move") then 

    target:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_strike_slow", {duration = self.speed_duration*(1 - target:GetStatusResistance())})
    
  end


  caster:MoveToPositionAggressive(caster:GetOrigin())
end


   



if caster:HasModifier("modifier_phantom_assassin_blink_blind") and caster:IsRealHero() then 

  local damage = 100 - (self.illusion_damage)
  local incoming = (self.illusion_health)
 
  caster:AddNewModifier(caster, self, "modifier_phantom_assassin_phantom_strike_invun", {duration = self.illusion_invun})


  local illusion = CreateIllusions( caster, caster, {Duration = self.illusion_duration ,outgoing_damage = -damage ,incoming_damage = incoming}, 1, 1, true, true )
    for _,i in pairs(illusion) do

      i.owner = caster

      local effect = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"
      if caster:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
        effect = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf"
      end

      local effect_cast_end = ParticleManager:CreateParticle( effect, PATTACH_WORLDORIGIN, i )
      ParticleManager:SetParticleControl( effect_cast_end, 0, i:GetOrigin() )
      ParticleManager:ReleaseParticleIndex( effect_cast_end )

      for _,mod in pairs(caster:FindAllModifiers()) do
        if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            i:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
        end
      end

      i:MoveToPositionAggressive(i:GetAbsOrigin())
      i:AddNewModifier(caster, self, "modifier_phantom_assassin_phantom_strike_buff", { duration = self.duration } )
    i:AddNewModifier(caster, self, "modifier_phantom_assassin_phantom_strike_invun", {duration = self.illusion_invun})
    end
end

---------------------------------------------------------------------------------------------------------------------------


  self:PlayEffects( caster, origin )
end




modifier_phantom_assassin_phantom_strike_invun = class({})
function modifier_phantom_assassin_phantom_strike_invun:IsHidden() return true end
function modifier_phantom_assassin_phantom_strike_invun:IsPurgable() return false end

function modifier_phantom_assassin_phantom_strike_invun:GetEffectName()
    return "particles/items2_fx/manta_phase.vpcf"
end

function modifier_phantom_assassin_phantom_strike_invun:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE]       = true,
        [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
        [MODIFIER_STATE_STUNNED]            = true,
        [MODIFIER_STATE_OUT_OF_GAME]        = true,
        
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true
    }
end




function custom_phantom_assassin_phantom_strike:OnSpellStart()
local caster = self:GetCaster()
local origin = caster:GetOrigin()
local target = self:GetCursorTarget()

self:UseBlink(caster, target)

end








function custom_phantom_assassin_phantom_strike:PlayEffects(caster, origin )
 
  local particle_cast_start = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf"
  local particle_cast_end = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf"
  local sound_cast_start = "Hero_PhantomAssassin.Strike.Start"
  local sound_cast_end = "Hero_PhantomAssassin.Strike.End"

  if self:GetCaster():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
    particle_cast_start = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_start.vpcf"
    particle_cast_end = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_phantom_strike_end.vpcf"
  end


  local effect_cast_start = ParticleManager:CreateParticle( particle_cast_start, PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast_start, 0, origin )
  ParticleManager:ReleaseParticleIndex( effect_cast_start )

  local effect_cast_end = ParticleManager:CreateParticle( particle_cast_end, PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast_end, 0, caster:GetOrigin() )
  ParticleManager:ReleaseParticleIndex( effect_cast_end )


  EmitSoundOnLocationWithCaster( origin, sound_cast_start, caster )
  EmitSoundOnLocationWithCaster( caster:GetOrigin(), sound_cast_end, caster )
end






modifier_phantom_assassin_phantom_strike_passive = class({})

function modifier_phantom_assassin_phantom_strike_passive:IsHidden() return true end
function modifier_phantom_assassin_phantom_strike_passive:IsPurgable() return false end





modifier_phantom_assassin_phantom_strike_buff = class({})


function modifier_phantom_assassin_phantom_strike_buff:IsHidden()
  return false
end

function modifier_phantom_assassin_phantom_strike_buff:IsDebuff()
  return false
end

function modifier_phantom_assassin_phantom_strike_buff:IsPurgable()
  return true
end



function modifier_phantom_assassin_phantom_strike_buff:DeclareFunctions()
  return {
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE
  }
end


function modifier_phantom_assassin_phantom_strike_buff:GetModifierAttackSpeedBonus_Constant()
 return self:GetAbility():GetSpecialValueFor( "speed" )
end



function modifier_phantom_assassin_phantom_strike_buff:OnCreated(table)
self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal")/100
end

function modifier_phantom_assassin_phantom_strike_buff:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor ~= nil then return end
if params.unit:IsBuilding() then return end

local heal = params.damage*self.lifesteal

if self:GetParent():GetQuest() == "Phantom.Quest_6" and params.unit:IsRealHero() and self:GetParent():GetHealthPercent() < 100 then 
  self:GetParent():UpdateQuest( math.floor( math.min( (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()), heal )))
end

self:GetParent():Heal(heal, self:GetParent())


local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

end



function modifier_phantom_assassin_phantom_strike_buff:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():IsRealHero() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_blink_illusion") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_strike_agility_stack", {duration = self:GetAbility().agility_duration})
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_strike_agility", {duration = self:GetAbility().agility_duration})

end






---------------------------------------ТАЛАНТ АРМОР--------------------------------------------------------



modifier_phantom_assassin_phantom_strike_slow = class({})
function modifier_phantom_assassin_phantom_strike_slow:IsHidden() return false end
function modifier_phantom_assassin_phantom_strike_slow:IsPurgable() return true end
function modifier_phantom_assassin_phantom_strike_slow:GetTexture() return "buffs/phantom_slow" end

function modifier_phantom_assassin_phantom_strike_slow:GetEffectName()
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
  return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

end


function modifier_phantom_assassin_phantom_strike_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_phantom_assassin_phantom_strike_slow:OnCreated(table)
self.move = self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_blink_move")]
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
  self.move = self.move*-1
end

end


function modifier_phantom_assassin_phantom_strike_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end




custom_phantom_assassin_phantom_strike_legendary = class({})

function custom_phantom_assassin_phantom_strike_legendary:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Phantom_Assassin.Blink_start")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_strike_legendary", {duration = self:GetSpecialValueFor("duration"), target = self:GetCursorTarget():entindex()})

end


modifier_phantom_assassin_phantom_strike_legendary = class({})
function modifier_phantom_assassin_phantom_strike_legendary:IsHidden() return false end
function modifier_phantom_assassin_phantom_strike_legendary:GetAttributes()
return  MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_phantom_assassin_phantom_strike_legendary:IsPurgable() return false end


function modifier_phantom_assassin_phantom_strike_legendary:OnCreated(table)
if not IsServer() then return end

self.ground_particle = ParticleManager:CreateParticleForTeam("particles/pa_blink_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent(), self:GetParent():GetTeamNumber())
ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

self:AddParticle(self.ground_particle, false, false, -1, false, false)

self.illusion_duration = self:GetAbility():GetSpecialValueFor("illusion_duration")
self.illusion_damage = self:GetAbility():GetSpecialValueFor("illusion_damage")
self.illusion_health = self:GetAbility():GetSpecialValueFor("illusion_health")
self.max_range = self:GetAbility():GetSpecialValueFor("max_range")*1.1

self.blink_ability = self:GetCaster():FindAbilityByName("custom_phantom_assassin_phantom_strike")

if not self.blink_ability or self.blink_ability:GetLevel() < 1 then 
  self:Destroy()
  return
end

self.target = EntIndexToHScript(table.target)

self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))

end



function modifier_phantom_assassin_phantom_strike_legendary:OnIntervalThink()
if not IsServer() then return end
if (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() >= self.max_range then return end
if not self.target:IsAlive() then return end

local damage = 100 - self.illusion_damage 
local incoming = self.illusion_health
 

local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {Duration = self.illusion_duration ,outgoing_damage = -damage ,incoming_damage = incoming}, 1, 1, true, true )
for _,i in pairs(illusion) do

      i.owner = self:GetCaster()



      for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
        if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            i:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
        end
      end

      self.blink_ability:UseBlink(i, self.target)
      i:SetForceAttackTarget(self.target)
      i:AddNewModifier(i, self, "modifier_phantom_assassin_phantom_strike_legendary_illusion", {})
end



end



modifier_phantom_assassin_phantom_strike_legendary_illusion = class({})
function modifier_phantom_assassin_phantom_strike_legendary_illusion:IsHidden() return true end
function modifier_phantom_assassin_phantom_strike_legendary_illusion:IsPurgable() return false end
function modifier_phantom_assassin_phantom_strike_legendary_illusion:CheckState()
return
{
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end



modifier_phantom_assassin_phantom_strike_turn_slow = class({})
function modifier_phantom_assassin_phantom_strike_turn_slow:IsHidden() return true end
function modifier_phantom_assassin_phantom_strike_turn_slow:IsPurgable() return true end
function modifier_phantom_assassin_phantom_strike_turn_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
}
end

function modifier_phantom_assassin_phantom_strike_turn_slow:GetModifierTurnRate_Percentage()
return self:GetAbility().turn_slow
end



modifier_phantom_assassin_phantom_strike_agility_stack = class({})
function modifier_phantom_assassin_phantom_strike_agility_stack:IsHidden() return true end
function modifier_phantom_assassin_phantom_strike_agility_stack:IsPurgable() return false end
function modifier_phantom_assassin_phantom_strike_agility_stack:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end


function modifier_phantom_assassin_phantom_strike_agility_stack:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_strike_agility")
if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end

end


modifier_phantom_assassin_phantom_strike_agility = class({})
function modifier_phantom_assassin_phantom_strike_agility:IsHidden() return false end
function modifier_phantom_assassin_phantom_strike_agility:IsPurgable() return false end
function modifier_phantom_assassin_phantom_strike_agility:GetTexture() return "buffs/Blade_dance_speed" end

function modifier_phantom_assassin_phantom_strike_agility:OnCreated(table)
if not IsServer() then return end

self.StackOnIllusion = true


self:IncrementStackCount()
end


function modifier_phantom_assassin_phantom_strike_agility:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end


function modifier_phantom_assassin_phantom_strike_agility:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_phantom_assassin_phantom_strike_agility:GetModifierBonusStats_Agility()
local parent = self:GetParent()
if self:GetParent():IsIllusion() and self:GetParent().owner then 
  parent = self:GetParent().owner
end

return parent:FindAbilityByName("custom_phantom_assassin_phantom_strike").agility_stack[parent:GetUpgradeStack("modifier_phantom_assassin_blink_illusion")]*self:GetStackCount()
end
