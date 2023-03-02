LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_knives_thinker", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_knives", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_crit", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_crit_2", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_phantom_assassin_fan_of_damage", "abilities/phantom_assassin/custom_phantom_assassin_fan_of_knives", LUA_MODIFIER_MOTION_NONE)


custom_phantom_assassin_fan_of_knives              = class({})


function custom_phantom_assassin_fan_of_knives:GetAOERadius() 
return self:GetSpecialValueFor("radius")
end

function custom_phantom_assassin_fan_of_knives:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)   
        if not self:IsTrained() then      
          self:SetLevel(1)
        end
    else
        self:SetHidden(true)

    end
end

function custom_phantom_assassin_fan_of_knives:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end







function custom_phantom_assassin_fan_of_knives:OnSpellStart()

  self.caster = self:GetCaster()
  self.radius         = self:GetSpecialValueFor("radius") 
  self.projectile_speed   = self:GetSpecialValueFor("projectile_speed")
  self.location = self:GetCaster():GetAbsOrigin()
  self.duration       = self.radius / self.projectile_speed
  

  if not IsServer() then return end

  self:GetCaster():EmitSound("Hero_PhantomAssassin.FanOfKnives.Cast")


  CreateModifierThinker(self.caster, self, "modifier_custom_phantom_assassin_fan_of_knives_thinker", {duration = self.duration}, self.location, self.caster:GetTeamNumber(), false)
  
end



modifier_custom_phantom_assassin_fan_of_knives_thinker = class({})


function modifier_custom_phantom_assassin_fan_of_knives_thinker:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  

  self.radius         = self.ability:GetSpecialValueFor("radius")
  if not IsServer() then return end
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives.vpcf", PATTACH_ABSORIGIN, self.parent)
  ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(self.particle, 3, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
  
  self.hit_enemies = {}
  
  self:StartIntervalThink(FrameTime())
end

function modifier_custom_phantom_assassin_fan_of_knives_thinker:OnIntervalThink()
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
      
      local damage = enemy:GetMaxHealth()*self:GetAbility():GetSpecialValueFor("pct_health_damage_initial")/100
    
      if enemy:IsCreep() then 
        damage = math.min(damage,500)
      end


      local duration = self:GetAbility():GetSpecialValueFor("duration")*(1 - enemy:GetStatusResistance())
      enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_phantom_assassin_fan_of_knives", {duration = duration})

      local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_tidehunter_anchor_smash_caster", {})
      self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_phantom_assassin_fan_of_crit", {})
      local mod_2 = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_phantom_assassin_fan_of_crit_2", {})

      self:GetCaster():PerformAttack(enemy, true, true, true, true, false, false, true)
      mod:Destroy()
      mod_2:Destroy()
      enemy:EmitSound("Hero_PhantomAssassin.Attack")

      table.insert(self.hit_enemies, enemy)
      

    end

  end

end



modifier_custom_phantom_assassin_fan_of_knives = class({})
function modifier_custom_phantom_assassin_fan_of_knives:IsHidden() return false end
function modifier_custom_phantom_assassin_fan_of_knives:IsPurgable() return true end
function modifier_custom_phantom_assassin_fan_of_knives:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function modifier_custom_phantom_assassin_fan_of_knives:GetEffectName() return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_shard_fan_of_knives_dot.vpcf" end


modifier_custom_phantom_assassin_fan_of_crit = class({})
function modifier_custom_phantom_assassin_fan_of_crit:IsHidden() return true end
function modifier_custom_phantom_assassin_fan_of_crit:IsPurgable() return false end

function modifier_custom_phantom_assassin_fan_of_crit:OnCreated(table)
  self.damage = 100 - self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_custom_phantom_assassin_fan_of_crit:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_custom_phantom_assassin_fan_of_crit:GetModifierDamageOutgoing_Percentage()
if IsClient() then return end
return -1*self.damage
end


modifier_custom_phantom_assassin_fan_of_crit_2 = class({})
function modifier_custom_phantom_assassin_fan_of_crit_2:IsHidden() return true end
function modifier_custom_phantom_assassin_fan_of_crit_2:IsPurgable() return false end

