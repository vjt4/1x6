LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_buff", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_mana", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_shield", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_speed", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_slow", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_shield_tracker", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_spell", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_arcane_aura_custom_move", "abilities/crystal_maiden/crystal_maiden_arcane_aura_custom", LUA_MODIFIER_MOTION_NONE )







crystal_maiden_arcane_aura_custom = class({})

crystal_maiden_arcane_aura_custom.cast_mana = {0.08, 0.012, 0.16}
crystal_maiden_arcane_aura_custom.cast_heal = 1
crystal_maiden_arcane_aura_custom.cast_duration = 3



crystal_maiden_arcane_aura_custom.legendary_mana = 0.15
crystal_maiden_arcane_aura_custom.legendary_cd = 3
crystal_maiden_arcane_aura_custom.legendary_regen = 15
crystal_maiden_arcane_aura_custom.legendary_reduce =  100
crystal_maiden_arcane_aura_custom.legendary_speed = 500
crystal_maiden_arcane_aura_custom.legendary_damage = 75

crystal_maiden_arcane_aura_custom.mana_damage = {400, 300, 200}

crystal_maiden_arcane_aura_custom.shield_cd = 6
crystal_maiden_arcane_aura_custom.shield_mana = 0.2
crystal_maiden_arcane_aura_custom.shield_absorb = 0.8
crystal_maiden_arcane_aura_custom.shield_resist = 40

crystal_maiden_arcane_aura_custom.speed_duration = 5
crystal_maiden_arcane_aura_custom.speed_attack = 300
crystal_maiden_arcane_aura_custom.speed_attack_count = {2, 3}
crystal_maiden_arcane_aura_custom.speed_move = {15, 25}
crystal_maiden_arcane_aura_custom.speed_move_duration = 3

crystal_maiden_arcane_aura_custom.attack_range = {50, 75, 100}
crystal_maiden_arcane_aura_custom.attack_slow = {-10, -15, -20}
crystal_maiden_arcane_aura_custom.attack_slow_duration = 2

crystal_maiden_arcane_aura_custom.spells_cd = 20
crystal_maiden_arcane_aura_custom.spells_duration = 10
crystal_maiden_arcane_aura_custom.spells_bkb = 2




function crystal_maiden_arcane_aura_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_maiden_arcane_6") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function crystal_maiden_arcane_aura_custom:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_maiden_arcane_6") then
  return self.spells_cd
end

return
end


function crystal_maiden_arcane_aura_custom:GetCastAnimation()
return ACT_DOTA_ATTACK
end


function crystal_maiden_arcane_aura_custom:GetIntrinsicModifierName()
  return "modifier_crystal_maiden_arcane_aura_custom"
end



function crystal_maiden_arcane_aura_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_crystal_maiden_arcane_aura_custom_spell", {duration = self.spells_duration})

local particle_peffect = ParticleManager:CreateParticle("particles/maiden_shield_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetCaster():EmitSound("Lina.Array_triple")

self:EndCooldown()
end




modifier_crystal_maiden_arcane_aura_custom = class({})

function modifier_crystal_maiden_arcane_aura_custom:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom:IsPurgable() return false end 


function modifier_crystal_maiden_arcane_aura_custom:GetAuraRadius()
  return 
end

function modifier_crystal_maiden_arcane_aura_custom:GetAuraSearchFlags()
  return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_crystal_maiden_arcane_aura_custom:GetAuraSearchTeam()

  return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_crystal_maiden_arcane_aura_custom:GetAuraSearchType()

  return DOTA_UNIT_TARGET_HERO 
end


function modifier_crystal_maiden_arcane_aura_custom:GetModifierAura()
  return "modifier_crystal_maiden_arcane_aura_custom_buff"
end

function modifier_crystal_maiden_arcane_aura_custom:IsAura()
  if self:GetParent():PassivesDisabled() then
    return false
  end

  return true
end




function modifier_crystal_maiden_arcane_aura_custom:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
  MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
  MODIFIER_PROPERTY_PROJECTILE_NAME,
  MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
  MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
  MODIFIER_EVENT_ON_ATTACK,
  MODIFIER_EVENT_ON_ATTACK_START,
  MODIFIER_EVENT_ON_ATTACK_FAIL,
  MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS

}
end


function modifier_crystal_maiden_arcane_aura_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_maiden_arcane_3") then return end
return self:GetAbility().attack_range[self:GetCaster():GetUpgradeStack("modifier_maiden_arcane_3")]
end



--function modifier_crystal_maiden_arcane_aura_custom:GetModifierBaseAttackTimeConstant()
--if not self:GetParent():HasModifier("modifier_maiden_arcane_4") then return end

--return self:GetAbility().speed_base[self:GetParent():GetUpgradeStack("modifier_maiden_arcane_4")]
--end




function modifier_crystal_maiden_arcane_aura_custom:GetAttackSound(params)
if not self.proc then return end

return "Maiden.Arcane_legendary_attack"
end

function modifier_crystal_maiden_arcane_aura_custom:GetModifierProjectileName(params)
if not self.proc then return end

--return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
end



function modifier_crystal_maiden_arcane_aura_custom:GetModifierProjectileSpeedBonus()
if not self.proc then return end

return self:GetAbility().legendary_speed
end

function modifier_crystal_maiden_arcane_aura_custom:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end

self.proc = nil

if not params.target:IsCreep() and not params.target:IsHero() then return end
if params.target:IsMagicImmune() then return end
if self:GetParent():GetMana() < self:GetParent():GetMaxMana()*self:GetAbility().legendary_mana then return end

self.proc = true


end



function modifier_crystal_maiden_arcane_aura_custom:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end


local mod = self:GetCaster():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_speed")
if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end


if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end


self:StartIntervalThink(self:GetAbility().legendary_cd)
self.attack = true

if not self.proc then return end

local damage = self:GetParent():GetMaxMana()*self:GetAbility().legendary_mana
self:GetParent():SetMana(math.max(1, self:GetParent():GetMana() - damage))

local projectile =
{
  Target = params.target,
  Source = self:GetParent(),
  Ability = self:GetAbility(),
  EffectName = "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf",
  iMoveSpeed = self:GetParent():GetProjectileSpeed(),
  vSourceLoc = self:GetParent():GetAbsOrigin(),
  bDodgeable = true,
  bProvidesVision = false,
}

local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )

self.record[params.record] = true
end



function modifier_crystal_maiden_arcane_aura_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end


if self:GetParent():HasModifier("modifier_maiden_arcane_3") and not params.target:IsMagicImmune()  then 
  params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_slow", {duration = self:GetAbility().attack_slow_duration})
end


if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end

if not self.record[params.record] then return end


local damage = self:GetParent():GetMaxMana()*self:GetAbility().legendary_mana*(self:GetAbility().legendary_damage/100)

if not params.target:IsMagicImmune() then 
  ApplyDamage({ victim = params.target, attacker = self:GetCaster(), damage = damage,  damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), })

  SendOverheadEventMessage(params.target, 4, params.target, damage, nil)

  params.target:EmitSound("Maiden.Arcane_legendary_attack_end")
end

self.record[params.record] = nil
end





function modifier_crystal_maiden_arcane_aura_custom:OnAttackFail(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end
if self:GetParent() ~= params.attacker then return end
if not self.record[params.record] then return end

self.record[params.record] = nil
end






function modifier_crystal_maiden_arcane_aura_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end


if self:GetParent():HasModifier("modifier_crystal_maiden_arcane_aura_custom_shield_tracker") then 
  self:GetParent():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_shield_tracker"):StartIntervalThink(self:GetAbility().shield_cd)
end


end

function modifier_crystal_maiden_arcane_aura_custom:GetModifierPercentageManacost()
if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end

return self:GetAbility().legendary_reduce
end







function modifier_crystal_maiden_arcane_aura_custom:OnAbilityFullyCast(keys)
if not IsServer() then return end
if not keys.ability then return end 
if keys.unit ~= self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if keys.ability:IsItem() or  UnvalidAbilities[keys.ability:GetName()] then return end

if self:GetParent():HasModifier("modifier_maiden_arcane_4") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_speed", {duration = self:GetAbility().speed_duration})
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_move", {duration = self:GetAbility().speed_move_duration})
end


if not self:GetParent():HasModifier("modifier_maiden_arcane_1") then return end
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_mana", {duration = self:GetAbility().cast_duration})

end



function modifier_crystal_maiden_arcane_aura_custom:GetModifierTotalPercentageManaRegen()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_maiden_arcane_7") then return end
if self.attack == true then return end

return self:GetAbility().legendary_regen
end


function modifier_crystal_maiden_arcane_aura_custom:OnCreated(table)
self.attack = false
self.proc = nil
self.record = {}
end



function modifier_crystal_maiden_arcane_aura_custom:OnIntervalThink()
if not IsServer() then return end


local pfx = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/ti9_immortal_staff/cm_ti9_staff_lvlup_globe.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(pfx, 5, Vector(1,1,1))
ParticleManager:ReleaseParticleIndex(pfx)

self:GetParent():EmitSound("Maiden.Arcane_legendary_regen")
self.attack = false
self:StartIntervalThink(-1)
end





modifier_crystal_maiden_arcane_aura_custom_buff = class({})
function modifier_crystal_maiden_arcane_aura_custom_buff:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_buff:IsPurgable() return false end



function modifier_crystal_maiden_arcane_aura_custom_buff:OnCreated(table)
if not IsServer() then return end
end


function modifier_crystal_maiden_arcane_aura_custom_buff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_crystal_maiden_arcane_aura_custom_buff:GetModifierConstantManaRegen()
return self:GetAbility():GetSpecialValueFor("base_mana_regen")
end


function modifier_crystal_maiden_arcane_aura_custom_buff:GetModifierMoveSpeedBonus_Constant()
return self:GetAbility():GetSpecialValueFor("base_move_speed")
end


function modifier_crystal_maiden_arcane_aura_custom_buff:GetModifierSpellAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_maiden_arcane_2") then return end
return self:GetCaster():GetMaxMana()/self:GetAbility().mana_damage[self:GetCaster():GetUpgradeStack("modifier_maiden_arcane_2")]
end







modifier_crystal_maiden_arcane_aura_custom_mana = class({})
function modifier_crystal_maiden_arcane_aura_custom_mana:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_mana:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_mana:GetTexture() return "buffs/arcane_regen" end

function modifier_crystal_maiden_arcane_aura_custom_mana:OnCreated(table)

self.heal = self:GetParent():GetMaxMana()*self:GetAbility().cast_mana[self:GetCaster():GetUpgradeStack("modifier_maiden_arcane_1")]/self:GetAbility().cast_duration

end

function modifier_crystal_maiden_arcane_aura_custom_mana:OnRefresh(table)
self:OnCreated(table)
end


function modifier_crystal_maiden_arcane_aura_custom_mana:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}
end


function modifier_crystal_maiden_arcane_aura_custom_mana:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_crystal_maiden_arcane_aura_custom_mana:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_crystal_maiden_arcane_aura_custom_mana:GetModifierConstantManaRegen()
return self.heal
end


function modifier_crystal_maiden_arcane_aura_custom_mana:GetModifierConstantHealthRegen()
return self.heal
end



modifier_crystal_maiden_arcane_aura_custom_shield = class({})
function modifier_crystal_maiden_arcane_aura_custom_shield:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield:GetTexture() return "buffs/arcane_shield" end

function modifier_crystal_maiden_arcane_aura_custom_shield:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(table.mana)
self.shield = self:GetStackCount()

self:GetCaster():EmitSound("Maiden.Arcane_shield_loop")

self.particle_peffect = ParticleManager:CreateParticle("particles/items5_fx/maiden_shield_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetCaster():GetAbsOrigin())
self:AddParticle(self.particle_peffect,false, false, -1, false, false)


self.pfx = ParticleManager:CreateParticle("particles/maiden_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
ParticleManager:SetParticleControl(self.pfx, 2, Vector(110,110,110))
self:AddParticle(self.pfx,false, false, -1, false, false)
end


function modifier_crystal_maiden_arcane_aura_custom_shield:OnRefresh(table)
if not IsServer() then return end

self:SetStackCount(table.mana)
self.shield = self:GetStackCount()
end

function modifier_crystal_maiden_arcane_aura_custom_shield:OnDestroy()
if not IsServer() then return end
self:GetCaster():EmitSound("Maiden.Arcane_shield_end")

if self:GetParent():HasModifier("modifier_crystal_maiden_arcane_aura_custom_shield_tracker") then 
  self:GetParent():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_shield_tracker"):StartIntervalThink(self:GetAbility().shield_cd)
end

self:GetCaster():StopSound("Maiden.Arcane_shield_loop")
end


function modifier_crystal_maiden_arcane_aura_custom_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_crystal_maiden_arcane_aura_custom_shield:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_arcane_aura_custom_shield:StatusEffectPriority()
return 9999
end

function modifier_crystal_maiden_arcane_aura_custom_shield:GetModifierStatusResistanceStacking()
return self:GetAbility().shield_resist
end

function modifier_crystal_maiden_arcane_aura_custom_shield:OnTooltip()
return self:GetAbility().shield_absorb*100
end


function modifier_crystal_maiden_arcane_aura_custom_shield:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end

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

local damage = self:GetAbility().shield_absorb*params.damage

self:GetParent():EmitSound("Hero_Lich.ProjectileImpact")


if damage>self.shield then
  self:Destroy()
  return self.shield
else
  self.shield = self.shield-damage
  self:SetStackCount(self.shield)
  return damage
end

end





modifier_crystal_maiden_arcane_aura_custom_speed = class({})
function modifier_crystal_maiden_arcane_aura_custom_speed:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_speed:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_speed:GetTexture() return "buffs/arcane_speed" end

function modifier_crystal_maiden_arcane_aura_custom_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility().speed_attack_count[self:GetCaster():GetUpgradeStack("modifier_maiden_arcane_4")])
end


function modifier_crystal_maiden_arcane_aura_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_crystal_maiden_arcane_aura_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().speed_attack
end









modifier_crystal_maiden_arcane_aura_custom_slow = class({})


function modifier_crystal_maiden_arcane_aura_custom_slow:IsHidden()
  return false
end

function modifier_crystal_maiden_arcane_aura_custom_slow:IsPurgable()
  return true
end

function modifier_crystal_maiden_arcane_aura_custom_slow:GetTexture()
  return "buffs/arcane_slow"
end


function modifier_crystal_maiden_arcane_aura_custom_slow:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }

  return funcs
end

function modifier_crystal_maiden_arcane_aura_custom_slow:GetModifierMoveSpeedBonus_Percentage()
  return self:GetAbility().attack_slow[self:GetCaster():GetUpgradeStack("modifier_maiden_arcane_3")]
end





function modifier_crystal_maiden_arcane_aura_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_crystal_maiden_arcane_aura_custom_slow:StatusEffectPriority()
return 9999
end




modifier_crystal_maiden_arcane_aura_custom_shield_tracker = class({})
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:RemoveOnDeath() return false end
function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:OnCreated(table)
if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().shield_cd)
end


function modifier_crystal_maiden_arcane_aura_custom_shield_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local mana = math.floor(self:GetCaster():GetMaxMana()*self:GetAbility().shield_mana)


local mod = self:GetParent():FindModifierByName("modifier_crystal_maiden_arcane_aura_custom_shield")


if mod and mod:GetStackCount() >= mana then 
  return 
end

SendOverheadEventMessage(self:GetCaster(), 11, self:GetCaster(), mana, nil)

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_crystal_maiden_arcane_aura_custom_shield", {mana = mana})

local pfx = ParticleManager:CreateParticle("particles/maiden_arcane.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:ReleaseParticleIndex(pfx)

self:GetCaster():EmitSound("Maiden.Arcane_shield")
self:GetCaster():EmitSound("Maiden.Arcane_shield_2")

end




modifier_crystal_maiden_arcane_aura_custom_spell = class({})
function modifier_crystal_maiden_arcane_aura_custom_spell:IsHidden() return false end
function modifier_crystal_maiden_arcane_aura_custom_spell:IsPurgable() return false end
function modifier_crystal_maiden_arcane_aura_custom_spell:GetTexture() return "buffs/arcane_spells" end

function modifier_crystal_maiden_arcane_aura_custom_spell:OnCreated(table)
if not IsServer() then return end
self:GetAbility():SetActivated(false)


self.nFXIndex = ParticleManager:CreateParticle("particles/maiden_spells.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
self:AddParticle(self.nFXIndex, false, false, 1, true, false)
end 

function modifier_crystal_maiden_arcane_aura_custom_spell:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, true)
end



modifier_crystal_maiden_arcane_aura_custom_move = class({})
function modifier_crystal_maiden_arcane_aura_custom_move:IsHidden() return true end
function modifier_crystal_maiden_arcane_aura_custom_move:IsPurgable() return true end
function modifier_crystal_maiden_arcane_aura_custom_move:GetEffectName()
  return "particles/zuus_speed.vpcf"
end




function modifier_crystal_maiden_arcane_aura_custom_move:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

end



function modifier_crystal_maiden_arcane_aura_custom_move:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_maiden_arcane_4")]
end