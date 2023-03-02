LinkLuaModifier("modifier_queenofpain_blood_pact", "abilities/queen_of_pain/custom_queenofpain_blood_pact", LUA_MODIFIER_MOTION_NONE)


custom_queenofpain_blood_pact = class({})

function custom_queenofpain_blood_pact:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("QoP.Scepter")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_queenofpain_blood_pact", {duration = self:GetSpecialValueFor("duration")})

local particle = ParticleManager:CreateParticle("particles/brist_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:ReleaseParticleIndex(particle)



end


modifier_queenofpain_blood_pact = class({})
function modifier_queenofpain_blood_pact:IsHidden() return false end
function modifier_queenofpain_blood_pact:IsPurgable() return false end


function modifier_queenofpain_blood_pact:OnCreated(table)
if not IsServer() then return end


self.particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( self.particle, 3, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)


self.pfx_2 = ParticleManager:CreateParticle("particles/qop_scepter.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.pfx_2, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
self:AddParticle(self.pfx_2, false, false, -1, false, false)

self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
end

function modifier_queenofpain_blood_pact:OnIntervalThink()
if not IsServer() then return end

local cost = self:GetParent():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("cost")*self:GetAbility():GetSpecialValueFor("interval")/100
self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - cost))

for abilitySlot = 0,8 do

	local ability = self:GetCaster():GetAbilityByIndex(abilitySlot)

	if ability ~= nil then

		local cd = ability:GetCooldownTimeRemaining()
		ability:EndCooldown()
		ability:StartCooldown(cd - self:GetAbility():GetSpecialValueFor("interval")*self:GetAbility():GetSpecialValueFor("cd_speed")/100 )

	end
end

end