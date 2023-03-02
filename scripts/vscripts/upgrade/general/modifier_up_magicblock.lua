LinkLuaModifier("modifier_magic_shield", "upgrade/general/modifier_up_magicblock", LUA_MODIFIER_MOTION_NONE)

modifier_up_magicblock = class({})


function modifier_up_magicblock:IsHidden() return true end
function modifier_up_magicblock:IsPurgable() return false end


function modifier_up_magicblock:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_magic_shield", {duration = 30.5})
  

end


function modifier_up_magicblock:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_magicblock:RemoveOnDeath() return false end




modifier_magic_shield = class({})
function modifier_magic_shield:IsHidden() return false end
function modifier_magic_shield:IsPurgable() return false end
function modifier_magic_shield:RemoveOnDeath() return false end

function modifier_magic_shield:GetTexture() return "item_hood_of_defiance"
   end


function modifier_magic_shield:RefreshShield()
if not IsServer() then return end
self:GetParent():EmitSound("DOTA_Item.Pipe.Activate")
    

  self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_v2.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(self.particle, 2, Vector(125, 0, 0))

end
function modifier_magic_shield:DestroyShield()
if not IsServer() then return end
self.shield = 0

       if self.particle ~= nil then 
           ParticleManager:DestroyParticle(self.particle, false)
           self.particle = nil
        end

     self:SetStackCount(0)
end



function modifier_magic_shield:OnCreated(table)
if not IsServer() then return end

self.shield = 200*self:GetParent():GetUpgradeStack("modifier_up_magicblock")
self:RefreshShield()
self.duration = self:GetRemainingTime()
self.count = 0
self.max = 30
self:SetStackCount(self.shield)
self:StartIntervalThink(1)

end

function modifier_magic_shield:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + 1

if self.count >= self.max and self:GetParent():IsAlive() then  
  self.count = 0

  if self.particle == nil then 
    self:RefreshShield()
  end

  self.shield = 200*self:GetParent():GetUpgradeStack("modifier_up_magicblock")
  self:SetStackCount(self.shield)
  self:SetDuration(self.duration, true)

end

end


function modifier_magic_shield:DeclareFunctions()

return 
{
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
    MODIFIER_EVENT_ON_DEATH,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_EVENT_ON_RESPAWN
}
end
function modifier_magic_shield:OnTooltip() return self:GetStackCount() end


function modifier_magic_shield:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
  self:SetDuration(-1, true)
  self:DestroyShield()
       
end
function modifier_magic_shield:OnRespawn(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

self:SetDuration(30.5, true)
self:OnCreated()
       
end

function modifier_magic_shield:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if self:GetParent() == params.attacker then return end
if self.shield == 0 then return end
if self:GetParent():HasModifier("modifier_templar_assassin_refraction_custom_absorb") then return end
if self:GetParent():HasModifier("modifier_item_hood_of_defiance_custom_active") then return end
if self:GetParent():HasModifier("modifier_item_pipe_custom_active") then return end
if self:GetParent():HasModifier("item_eternal_shroud_custom") then return end
if self:GetParent():HasModifier("modifier_sven_warcry_custom_legendary") then return end

if params.damage_type ~= DAMAGE_TYPE_MAGICAL
 then return end

  if self.shield > params.damage then
    self.shield = self.shield - params.damage
    self:SetStackCount(self.shield)
    local i = params.damage
return i
else
    
    local i = self.shield
    self:DestroyShield()
    return i
end
end



