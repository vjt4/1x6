LinkLuaModifier( "modifier_tower_incoming_speed", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_damage", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_damage_cd", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_damage_visual", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_vision", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_no_heal", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_no_spells", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_push_reduce", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )

modifier_tower_incoming = class({})

modifier_tower_incoming.skills = 
{
	"ember_spirit_activate_fire_remnant_custom",
	"alchemist_acid_spray_mixing"
}


function modifier_tower_incoming:IsHidden() return true end
function modifier_tower_incoming:IsPurgable() return false end
function modifier_tower_incoming:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end

function modifier_tower_incoming:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if not params.attacker:IsHero() then return end

params.attacker:AddNewModifier(params.attacker, nil, "modifier_tower_incoming_speed", {duration = 1.1})


if players[self:GetParent():GetTeamNumber()] and players[self:GetParent():GetTeamNumber()]:HasModifier("modifier_target") then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#push_target"})
	return
end

if GameRules:GetDOTATime(false, false) < push_timer then 

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#push_timer"})
	return
end

if not params.attacker:IsRealHero() then return end
if params.attacker:HasModifier("modifier_mars_scepter_damage") then return end
if params.attacker:HasModifier("modifier_skeleton_king_reincarnation_custom_legendary") then return end

local mod = params.attacker:FindModifierByName("modifier_crystal_maiden_crystal_nova_legendary_aura")
if mod and mod:GetCaster() == params.attacker then 
	return
end


params.attacker:AddNewModifier(params.attacker, nil, "modifier_tower_incoming_damage", {})

local damage = self:GetParent():GetMaxHealth()*0.1
if self:GetParent():GetUnitName() == "npc_towerradiant" or self:GetParent():GetUnitName() == "npc_towerdire" then 
	damage = self:GetParent():GetMaxHealth()*0.04
end
local k = 1

local mod = self:GetParent():FindModifierByName("modifier_filler_armor")

if self:GetParent():HasModifier("modifier_razor_tower_custom") then 
	k = k + 0.25
end

if self:GetParent():HasModifier("modifier_item_patrol_fortifier") then 
	k = k - 0.3
end
	
local push_mod = self:GetParent():FindModifierByName("modifier_tower_incoming_push_reduce")
if push_mod then 

	if (push_mod.hero and push_mod.hero ~= params.attacker) or not push_mod.hero then 
		k = k - 0.65
	end

	if players[self:GetParent():GetTeamNumber()] then 
		AddFOWViewer(params.attacker:GetTeamNumber(), players[self:GetParent():GetTeamNumber()]:GetAbsOrigin(), 800, 3, false)
	end
end

local common_damage = 0.08
if params.attacker:HasModifier("modifier_up_graypoints") then 
	common_damage = 0.08*(1 + 0.25)
end

if params.attacker:HasModifier("modifier_up_towerdamage") then 
	k = k + common_damage*params.attacker:FindModifierByName("modifier_up_towerdamage"):GetStackCount()
end

if mod then 
	k =  k - 0.2*mod:GetStackCount()
	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_incoming_damage_visual", {duration = 3})
else 
	self:GetParent():RemoveModifierByName("modifier_tower_incoming_damage_visual")
end

if params.attacker:HasModifier("modifier_item_the_leveller") then 
	k = k + 0.1
end

if k < 0 then 
	k = 0
end


damage = damage*k

if not self:GetParent():HasModifier("modifier_tower_incoming_damage_cd") then 

	local damageTable = {
				victim = self:GetParent(),
				attacker = params.attacker,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = nil,
				damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			}

	ApplyDamage(damageTable)

	if params.attacker:IsRealHero() and params.attacker:GetQuest() == "General.Quest_14" then 
		params.attacker:UpdateQuest(damage)
	end

	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_incoming_no_heal", {duration = 3})

	--params.attacker:AddNewModifier(params.attacker, nil, "modifier_tower_incoming_no_spells", {duration = 3})

	if towers[self:GetParent():GetTeamNumber()] then 
	--	params.attacker:AddNewModifier(params.attacker, nil, "modifier_tower_incoming_vision", {team = self:GetParent():GetTeamNumber(), duration = 10})
	end

	if towers[params.attacker:GetTeamNumber()] and players[self:GetParent():GetTeamNumber()] then 
 		local base = FindUnitsInRadius( params.attacker:GetTeamNumber(), towers[params.attacker:GetTeamNumber()]:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER,false)
        
 		for _,building in pairs(base) do 
 			building:AddNewModifier(building, nil, "modifier_tower_incoming_push_reduce", {duration = 3, hero = players[self:GetParent():GetTeamNumber()]:entindex()})
 		end	
	end


	for _,name in pairs(self.skills) do 	
		local ability = params.attacker:FindAbilityByName(name)


		if ability and ability:GetSpecialValueFor("tower_attack_cd") then 
			local cd = ability:GetCooldownTimeRemaining()

			if cd < ability:GetSpecialValueFor("tower_attack_cd") then 
				ability:StartCooldown(ability:GetSpecialValueFor("tower_attack_cd"))
			end
		end

	end

	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_incoming_damage_cd", {duration = 0.5})
end

params.attacker:RemoveModifierByName("modifier_tower_incoming_damage")

end



modifier_tower_incoming_damage = class({})
function modifier_tower_incoming_damage:IsHidden() return true end
function modifier_tower_incoming_damage:IsPurgable() return false end



modifier_tower_incoming_speed = class({})
function modifier_tower_incoming_speed:IsHidden() return false end
function modifier_tower_incoming_speed:IsDebuff() return true end
function modifier_tower_incoming_speed:IsPurgable() return false end
function modifier_tower_incoming_speed:GetTexture() return "backdoor_protection" end


function modifier_tower_incoming_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_tower_incoming_speed:GetModifierFixedAttackRate()
return 0.85
end

function modifier_tower_incoming_speed:OnTooltip()
return 10
end

function modifier_tower_incoming_speed:OnTooltip2()
return 4
end

modifier_tower_incoming_damage_cd = class({})
function modifier_tower_incoming_damage_cd:IsHidden() return true end
function modifier_tower_incoming_damage_cd:IsPurgable() return false end


modifier_tower_incoming_damage_visual = class({})
function modifier_tower_incoming_damage_visual:IsHidden() return true end
function modifier_tower_incoming_damage_visual:IsPurgable() return false end
function modifier_tower_incoming_damage_visual:OnCreated(table)
if not IsServer() then return end

  
self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self:GetCaster():EmitSound( self.sound)

local abs = self:GetCaster():GetAbsOrigin()
abs.z = abs.z + 80

self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.buff_particles[1], 1, abs) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.buff_particles[2], 1, abs) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.buff_particles[3], 1, abs) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)
end


modifier_tower_incoming_vision = class({})
function modifier_tower_incoming_vision:IsHidden() return true end
function modifier_tower_incoming_vision:IsPurgable() return false end
function modifier_tower_incoming_vision:RemoveOnDeath() return false end
function modifier_tower_incoming_vision:OnCreated(table)
if not IsServer() then return end
local team = table.team
self.tower = towers[team]

self:StartIntervalThink(0.5)
end

function modifier_tower_incoming_vision:OnIntervalThink()
if not IsServer() then return end
if self.tower == nil then
	self:Destroy()
	return
end

AddFOWViewer(self:GetParent():GetTeamNumber(), self.tower:GetAbsOrigin(), 1000, 0.5, false)
end


modifier_tower_incoming_no_heal = class({})
function modifier_tower_incoming_no_heal:IsHidden() return true end
function modifier_tower_incoming_no_heal:IsPurgable() return false end



modifier_tower_incoming_no_spells = class({})
function modifier_tower_incoming_no_spells:IsHidden() return false end
function modifier_tower_incoming_no_spells:IsPurgable() return false end
function modifier_tower_incoming_no_spells:OnCreated(table)
if not IsServer() then return end

for _,name in pairs(self.skills) do 

	local ability = self:GetParent():FindAbilityByName(name)


	if ability then 
		local cd = ability:GetCooldownTimeRemaining()

		if cd < self:GetRemainingTime() then 
			ability:StartCooldown(self:GetRemainingTime())
		end
	end
end


end

function modifier_tower_incoming_no_spells:OnRefresh(table)
self:OnCreated()
end



modifier_tower_incoming_push_reduce = class({})
function modifier_tower_incoming_push_reduce:IsHidden() return false end
function modifier_tower_incoming_push_reduce:IsPurgable() return false end
function modifier_tower_incoming_push_reduce:GetTexture() return "shrine_aura" end
function modifier_tower_incoming_push_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_tower_incoming_push_reduce:OnTooltip()
	return -65

end


function modifier_tower_incoming_push_reduce:OnCreated(table)
if not  IsServer() then return end
if not table.hero then return end

self.hero = EntIndexToHScript(table.hero)
end

function modifier_tower_incoming_push_reduce:GetEffectName() return "particles/items3_fx/star_emblem_friend_shield.vpcf" end
 
function modifier_tower_incoming_push_reduce:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end