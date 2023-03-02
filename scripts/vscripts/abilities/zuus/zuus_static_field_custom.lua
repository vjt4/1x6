LinkLuaModifier("modifier_zuus_static_field_custom_tracker", "abilities/zuus/zuus_static_field_custom" , LUA_MODIFIER_MOTION_NONE)

zuus_static_field_custom = class({})

function zuus_static_field_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasShard() then
        self:SetHidden(true)       
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function zuus_static_field_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end


function zuus_static_field_custom:GetIntrinsicModifierName()
return "modifier_zuus_static_field_custom_tracker"
end

function zuus_static_field_custom:ApplyDamageStatic(target, not_spell)
if not IsServer() then return end
local damage = target:GetHealth() / 100 * self:GetSpecialValueFor("damage_health_pct")

if not_spell == true then 
    damage = target:GetHealth() / 100 * self:GetSpecialValueFor("damage_health_pct_attack")
end

if target:IsCreep() then 
    damage = damage/self:GetSpecialValueFor("creeps_damage")
end
print(damage)
	ApplyDamage({ victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self })
end

modifier_zuus_static_field_custom_tracker = class({})
function modifier_zuus_static_field_custom_tracker:IsHidden() return false end
function modifier_zuus_static_field_custom_tracker:IsPurgable() return false end
function modifier_zuus_static_field_custom_tracker:OnCreated(table)
self.damage_spell = self:GetAbility():GetSpecialValueFor("damage_health_pct")
self.damage_attack = self:GetAbility():GetSpecialValueFor("damage_health_pct_attack")
end

function modifier_zuus_static_field_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2
}
end


function modifier_zuus_static_field_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:IsMagicImmune() then return end

self:GetAbility():ApplyDamageStatic(params.target, true)

end


function modifier_zuus_static_field_custom_tracker:OnTooltip()
return self.damage_spell
end

function modifier_zuus_static_field_custom_tracker:OnTooltip2()
return self.damage_attack
end