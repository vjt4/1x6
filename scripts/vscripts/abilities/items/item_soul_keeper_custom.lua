LinkLuaModifier( "modifier_item_soul_keeper_custom_passive", "abilities/items/item_soul_keeper_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_soul_keeper_custom_active_ally", "abilities/items/item_soul_keeper_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_soul_keeper_custom_active_enemy", "abilities/items/item_soul_keeper_custom", LUA_MODIFIER_MOTION_NONE )

item_soul_keeper_custom = class({})


function item_soul_keeper_custom:GetIntrinsicModifierName()
	return "modifier_item_soul_keeper_custom_passive"
end

function item_soul_keeper_custom:CastFilterResultTarget(target)
	if IsServer() then

		if self:GetCurrentCharges() < 1 then 
			self:EndCooldown()
			self:StartCooldown(1)
			return
		end

		local caster = self:GetCaster()
		if caster:GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
		
		if target:HasModifier("modifier_waveupgrade_boss") or target:GetUnitName() == "npc_roshan_custom" then 
			return UF_FAIL_OTHER
		end

		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end

function item_soul_keeper_custom:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor("duration")
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:EmitSound("DOTA_Item.UrnOfShadows.Activate")

	local particle_fx = ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_fx, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_fx)

	if target:GetTeam() == caster:GetTeam() then
		target:AddNewModifier(caster, self, "modifier_item_soul_keeper_custom_active_ally", {duration = duration })
	else
		target:AddNewModifier(caster, self, "modifier_item_soul_keeper_custom_active_enemy", {duration = duration })
	end

	self:SetCurrentCharges(self:GetCurrentCharges() - 1)
end

modifier_item_soul_keeper_custom_passive = class({})

function modifier_item_soul_keeper_custom_passive:IsHidden()		return true end
function modifier_item_soul_keeper_custom_passive:IsPurgable()		return false end
function modifier_item_soul_keeper_custom_passive:RemoveOnDeath()	return false end

function modifier_item_soul_keeper_custom_passive:DestroyOnExpire()
    return false
end

function modifier_item_soul_keeper_custom_passive:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	self.soul_cooldown = self.item:GetSpecialValueFor("soul_cooldown")
	self.bonus_armor = self.item:GetSpecialValueFor("bonus_armor")
	self.bonus_mana_regen = self.item:GetSpecialValueFor("mana_regen")
	self.bonus_agility = self.item:GetSpecialValueFor("bonus_all_stats")
	self.bonus_strength = self.item:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intelligence = self.item:GetSpecialValueFor("bonus_all_stats")
	self.health_bonus = self.item:GetSpecialValueFor("bonus_health")
	self.bonus_mana = self.item:GetSpecialValueFor("bonus_mana")
	self.radius = self.item:GetSpecialValueFor("soul_radius")
	self.duration = self.soul_cooldown
	self.heal = self.item:GetSpecialValueFor("lifesteal")/100
	self.creep_heal = self.item:GetSpecialValueFor("lifesteal_creep")/100
	self.kill_charges = self.item:GetSpecialValueFor("soul_additional_charges")

	--self:SetDuration(self.soul_cooldown, true)
	--self:StartIntervalThink(0.1)
end

function modifier_item_soul_keeper_custom_passive:OnIntervalThink()
	if not IsServer() then return end
	if self.duration <= 0 then
		self.item:SetCurrentCharges(self.item:GetCurrentCharges() + 1)
		self:SetDuration(self.soul_cooldown, true)
		self.duration = self:GetRemainingTime()
		return
	end
	self.duration = self:GetRemainingTime()
end

function modifier_item_soul_keeper_custom_passive:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_HEALTH_BONUS,
			MODIFIER_PROPERTY_MANA_BONUS,
			MODIFIER_EVENT_ON_DEATH,
			MODIFIER_EVENT_ON_TAKEDAMAGE

		}
	return decFuns
end


function modifier_item_soul_keeper_custom_passive:GetModifierManaBonus()
	return self.bonus_mana
end



function modifier_item_soul_keeper_custom_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_soul_keeper_custom_passive:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_soul_keeper_custom_passive:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_soul_keeper_custom_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_item_soul_keeper_custom_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_soul_keeper_custom_passive:GetModifierHealthBonus()
	return self.health_bonus
end

function modifier_item_soul_keeper_custom_passive:OnDeath(params)
	local target = params.unit
		
	if not self:GetCaster():IsRealHero() then return end
	if not target:IsRealHero() then return end
	if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() then return end
	if target:IsReincarnating() then return end

	if (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= self.radius or params.attacker and params.attacker == self:GetCaster() then
		self.item:SetCurrentCharges(self.item:GetCurrentCharges() + self.kill_charges)
	end
end

modifier_item_soul_keeper_custom_active_ally = class({})

function modifier_item_soul_keeper_custom_active_ally:IsDebuff() return false end
function modifier_item_soul_keeper_custom_active_ally:IsHidden() return false end
function modifier_item_soul_keeper_custom_active_ally:IsPurgable() return true end

function modifier_item_soul_keeper_custom_active_ally:OnCreated( params )
self.health_regen = self:GetAbility():GetSpecialValueFor("soul_heal_amount")
if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
end

function modifier_item_soul_keeper_custom_active_ally:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		--	MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuns
end

function modifier_item_soul_keeper_custom_active_ally:GetEffectName()
	return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end

function modifier_item_soul_keeper_custom_active_ally:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_soul_keeper_custom_active_ally:GetModifierConstantHealthRegen()
	return self.health_regen
end


function modifier_item_soul_keeper_custom_active_ally:OnTakeDamage(keys)
if not keys.attacker or not keys.attacker:IsHero() then return end


local unit = keys.unit
local parent = self:GetParent()

    if  unit == parent then
        self:Destroy()
    end
end


modifier_item_soul_keeper_custom_active_enemy = class({})

function modifier_item_soul_keeper_custom_active_enemy:IsDebuff() return true end
function modifier_item_soul_keeper_custom_active_enemy:IsHidden() return false end
function modifier_item_soul_keeper_custom_active_enemy:IsPurgable() return true end
function modifier_item_soul_keeper_custom_active_enemy:IsStunDebuff() return false end
function modifier_item_soul_keeper_custom_active_enemy:RemoveOnDeath() return true end

function modifier_item_soul_keeper_custom_active_enemy:GetEffectName()
	return "particles/items4_fx/soul_keeper.vpcf"
end

function modifier_item_soul_keeper_custom_active_enemy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_soul_keeper_custom_active_enemy:OnCreated( params )
	if IsServer() then
		if not self:GetAbility() then self:Destroy() return end
	end
	self.damage_per_second = self:GetAbility():GetSpecialValueFor("soul_damage_amount")
	self.enemy_hp_drain = self:GetAbility():GetSpecialValueFor("enemy_hp_drain") / 100
	self.hp_reduction_heal = -1 * self:GetAbility():GetSpecialValueFor("hp_regen_reduction_enemy")
	self.heal = self:GetAbility():GetSpecialValueFor("heal")/100

	self:StartIntervalThink(1)
end

function modifier_item_soul_keeper_custom_active_enemy:OnIntervalThink()
if not IsServer() then return end

local damage = self.damage_per_second + (self:GetParent():GetHealth()*self.enemy_hp_drain)

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility()
	}
	ApplyDamage(damageTable)

--damage = damage*self.heal


--my_game:GenericHeal(self:GetCaster(), damage, self:GetAbility())


end




function modifier_item_soul_keeper_custom_active_enemy:DeclareFunctions()
return 
    {
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    }
end

function modifier_item_soul_keeper_custom_active_enemy:GetModifierLifestealRegenAmplify_Percentage()
    return self.hp_reduction_heal
end

function modifier_item_soul_keeper_custom_active_enemy:GetModifierHealAmplify_PercentageTarget()
    return self.hp_reduction_heal
end

function modifier_item_soul_keeper_custom_active_enemy:GetModifierHPRegenAmplify_Percentage()
    return self.hp_reduction_heal
end