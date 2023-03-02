

modifier_legion_duel_legendary = class({})


function modifier_legion_duel_legendary:IsHidden() return true end
function modifier_legion_duel_legendary:IsPurgable() return false end



function modifier_legion_duel_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
local ability = self:GetParent():FindAbilityByName("custom_legion_commander_duel_double")
if ability then 
	ability:SetHidden(false)
end

end


function modifier_legion_duel_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_legendary:RemoveOnDeath() return false end