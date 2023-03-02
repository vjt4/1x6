

modifier_legion_duel_damage = class({})


function modifier_legion_duel_damage:IsHidden() return true end
function modifier_legion_duel_damage:IsPurgable() return false end


function modifier_legion_duel_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:GetParent():EmitSound("Hero_LegionCommander.Duel.Victory")
self:GetParent():CalculateStatBonus(false)
end


function modifier_legion_duel_damage:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:GetParent():EmitSound("Hero_LegionCommander.Duel.Victory")
self:GetParent():CalculateStatBonus(false)
 
end

function modifier_legion_duel_damage:RemoveOnDeath() return false end