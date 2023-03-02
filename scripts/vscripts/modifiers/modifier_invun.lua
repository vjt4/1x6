

modifier_invun = class({})


function modifier_invun:IsHidden() return true end
function modifier_invun:IsPurgable() return false end



function modifier_invun:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
end

function modifier_invun:RemoveOnDeath() return false end



function modifier_invun:OnCreated(table)
if not IsServer() then return end

--self:GetParent():SetDayTimeVisionRange(0)
--self:GetParent():SetNightTimeVisionRange(0)
end