

modifier_templar_assassin_psionic_5 = class({})


function modifier_templar_assassin_psionic_5:IsHidden() return true end
function modifier_templar_assassin_psionic_5:IsPurgable() return false end



function modifier_templar_assassin_psionic_5:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetCaster():SwapAbilities("templar_assassin_psionic_trap_custom", "templar_assassin_psionic_trap_custom_2", false, true)
  local level = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom"):GetLevel()
  self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom_2"):SetLevel(level)


end


function modifier_templar_assassin_psionic_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_psionic_5:RemoveOnDeath() return false end