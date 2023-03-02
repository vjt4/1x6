

modifier_skeleton_reincarnation_4 = class({})


function modifier_skeleton_reincarnation_4:IsHidden() return true end
function modifier_skeleton_reincarnation_4:IsPurgable() return false end



function modifier_skeleton_reincarnation_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetParent():FindAbilityByName("skeleton_king_reincarnation_custom"), "modifier_skeleton_king_reincarnation_custom_aura", {})
end


function modifier_skeleton_reincarnation_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_skeleton_reincarnation_4:RemoveOnDeath() return false end