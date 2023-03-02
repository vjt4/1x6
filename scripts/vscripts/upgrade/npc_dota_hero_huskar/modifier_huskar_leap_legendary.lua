

modifier_huskar_leap_legendary = class({})


function modifier_huskar_leap_legendary:IsHidden() return true end
function modifier_huskar_leap_legendary:IsPurgable() return false end



function modifier_huskar_leap_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetCaster():FindAbilityByName("custom_huskar_sacred_earth"):SetHidden(false)
end


function modifier_huskar_leap_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_leap_legendary:RemoveOnDeath() return false end