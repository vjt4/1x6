

modifier_bloodseeker_thirst_4 = class({})


function modifier_bloodseeker_thirst_4:IsHidden() return true end
function modifier_bloodseeker_thirst_4:IsPurgable() return false end



function modifier_bloodseeker_thirst_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("bloodseeker_thirst_custom"), "modifier_bloodseeker_thirst_custom_attack", {})
end


function modifier_bloodseeker_thirst_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bloodseeker_thirst_4:RemoveOnDeath() return false end