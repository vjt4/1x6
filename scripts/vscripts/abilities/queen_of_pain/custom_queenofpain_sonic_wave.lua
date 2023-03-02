LinkLuaModifier("modifier_generic_motion_controller", "abilities/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_custom_sonic_heal", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kills", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kills_cd", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_tracker", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_fire_thinker", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_reduce", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_stack", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_attack_cd", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kill", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_quest", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)




custom_queenofpain_sonic_wave = class({})

custom_queenofpain_sonic_wave.stack_damage = {0.06, 0.1}
custom_queenofpain_sonic_wave.stack_max = 8
custom_queenofpain_sonic_wave.stack_duration = 10
custom_queenofpain_sonic_wave.stack_radius = 400

custom_queenofpain_sonic_wave.blink_heal = 0.5

custom_queenofpain_sonic_wave.damage_init = 0
custom_queenofpain_sonic_wave.damage_inc = 50

custom_queenofpain_sonic_wave.legendary_damage = 2
custom_queenofpain_sonic_wave.legendary_cooldown = 40
custom_queenofpain_sonic_wave.legendary_cd_hero = 2
custom_queenofpain_sonic_wave.legendary_cd_max = 20
custom_queenofpain_sonic_wave.legendary_timer = 3

custom_queenofpain_sonic_wave.fire_duration = 12
custom_queenofpain_sonic_wave.fire_radius = 150
custom_queenofpain_sonic_wave.fire_length = 1300
custom_queenofpain_sonic_wave.fire_interval = 0.5
custom_queenofpain_sonic_wave.fire_damage_init = 0.05
custom_queenofpain_sonic_wave.fire_damage_inc = 0.05

custom_queenofpain_sonic_wave.far_stun = 3

custom_queenofpain_sonic_wave.reduce_init = 0
custom_queenofpain_sonic_wave.reduce_inc = -10
custom_queenofpain_sonic_wave.reduce_duration = 10

custom_queenofpain_sonic_wave.attack_cd = 6
custom_queenofpain_sonic_wave.attack_aoe = 300
custom_queenofpain_sonic_wave.attack_damage = 0.25
custom_queenofpain_sonic_wave.attack_heal = 1



function custom_queenofpain_sonic_wave:GetIntrinsicModifierName()
return "modifier_custom_sonic_tracker"
end


function custom_queenofpain_sonic_wave:GetCooldown(iLevel)
local upgrade_cooldown = 0	
local base = self.BaseClass.GetCooldown(self, iLevel)

if self:GetCaster():HasModifier("modifier_queen_Sonic_legendary") then 
	base =  self.legendary_cooldown
end

upgrade_cooldown = self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills_cd")
return base - upgrade_cooldown 
end



function custom_queenofpain_sonic_wave:OnAbilityPhaseStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_QueenOfPain.SonicWave.Precast")

	return true
end

function custom_queenofpain_sonic_wave:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	self:GetCaster():StopSound("Hero_QueenOfPain.SonicWave.Precast")
end

function custom_queenofpain_sonic_wave:OnSpellStart()
if not IsServer() then return end
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()


		local damage = self:GetSpecialValueFor("damage")
		local start_radius = self:GetSpecialValueFor("starting_aoe")
		local end_radius = self:GetSpecialValueFor("final_aoe")
		local travel_distance = self:GetSpecialValueFor("distance")
		local projectile_speed = self:GetSpecialValueFor("speed")

		local direction
		if target_loc == caster_loc then
			direction = caster:GetForwardVector()
		else
			direction = (target_loc - caster_loc):Normalized()
		end


		
		if self:GetCaster():HasModifier("modifier_custom_sonic_kills") then 
			damage = damage + self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills")
		end


		if self:GetCaster():HasModifier("modifier_queen_Sonic_damage") then 
			damage = damage + self.damage_init + self.damage_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_damage")
		end


		caster:EmitSound("Hero_QueenOfPain.SonicWave")


		if self:GetCaster():HasModifier("modifier_custom_blink_spell") then 
			self:GetCaster():AddNewModifier(caster, self, "modifier_custom_sonic_heal", {duration = 3})
			self:GetCaster():RemoveModifierByName("modifier_custom_blink_spell")
		end
	
		local effect = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf"
		if self:GetCaster():GetModelName() == "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana.vmdl" then 
			effect = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave.vpcf"
		end


		projectile =
			{
				Ability				= self,
				EffectName			= effect,
				vSpawnOrigin		= caster_loc,
				fDistance			= travel_distance,
				fStartRadius		= start_radius,
				fEndRadius			= end_radius,
				Source				= caster,
				bHasFrontalCone		= true,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= true,
				vVelocity			= Vector(direction.x,direction.y,0) * projectile_speed,
				bProvidesVision		= false,
				ExtraData			= {damage = damage, x = caster_loc.x, y = caster_loc.y, z = caster_loc.z}
			}

		ProjectileManager:CreateLinearProjectile(projectile)

	if caster:HasModifier("modifier_queen_Sonic_fire") then 
		local end_pos = caster:GetAbsOrigin() + caster:GetForwardVector()*self.fire_length	


		local damage_burn = self.fire_damage_init + self.fire_damage_inc*caster:GetUpgradeStack("modifier_queen_Sonic_fire")
		damage_burn = damage*damage_burn*self.fire_interval
			

		 CreateModifierThinker(caster, self, "modifier_custom_sonic_fire_thinker",
	  	{duration = self.fire_duration, damage = damage_burn, end_x = end_pos.x, end_y = end_pos.y,end_z = end_pos.z}, 
	    caster:GetAbsOrigin(), caster:GetTeamNumber(), false)

	end


end

function custom_queenofpain_sonic_wave:OnProjectileHit_ExtraData(target, location, ExtraData)
if not target then return end
if target:GetUnitName() == "npc_teleport" then return end
if target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end

		local damage = ExtraData.damage
		
		if target:HasModifier("modifier_custom_sonic_stack") then 
			local mod = target:FindModifierByName("modifier_custom_sonic_stack")

			damage = damage * ( 1 + self.stack_damage[self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_taken")]*mod:GetStackCount() )
			mod:Destroy()
		end

		if target:IsRealHero() and self:GetCaster():GetQuest() == "Queen.Quest_8" and not self:GetCaster():QuestCompleted() then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_quest", {duration = self:GetCaster().quest.number})
		end


		ApplyDamage({attacker = self:GetCaster(), victim = target, ability = self, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_kill", {duration = self.legendary_timer})


		if self:GetCaster():HasModifier("modifier_queen_Sonic_reduce") then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_reduce", {duration = self.reduce_duration}) 
		end

		if self:GetCaster():HasModifier("modifier_queen_Sonic_far") then 
			local origin = Vector(ExtraData.x, ExtraData.y, ExtraData.z)
			local distance = (origin - target:GetAbsOrigin()):Length2D()
			local stun_duration = (distance / self:GetSpecialValueFor("distance"))*self.far_stun
			target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = stun_duration*(1 - target:GetStatusResistance())})

		end
	

		local speed = self:GetSpecialValueFor("knockback_distance") / self:GetSpecialValueFor("knockback_duration")

		local duration_knock = self:GetSpecialValueFor("knockback_duration") * (1 - target:GetStatusResistance())

		local distance_knock = speed*duration_knock

		target:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", 
		{
			distance		= distance_knock,
			direction_x 	= target:GetAbsOrigin().x - ExtraData.x,
			direction_y 	= target:GetAbsOrigin().y - ExtraData.y,
			direction_z 	= target:GetAbsOrigin().z - ExtraData.z,
			duration 		= duration_knock,
			bGroundStop 	= false,
			bDecelerate 	= false,
			bInterruptible 	= false,
			bIgnoreTenacity	= false,
			bDestroyTreesAlongPath	= true
		})
		

end


function custom_queenofpain_sonic_wave:MakeOrder(target, last_order)
if not IsServer() then return end

local random = -1

repeat random = RandomInt(1, 3)
until random ~= last_order 

if random == 1 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_move", {duration = self.order_duration})
end
if random == 2 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_attack", {duration = self.order_duration})
end
if random == 3 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_cast", {duration = self.order_duration})
end

	target:EmitSound("QoP.Sonic_order")

end




modifier_custom_sonic_heal = class({})
function modifier_custom_sonic_heal:IsHidden() return true end
function modifier_custom_sonic_heal:IsPurgable() return false end



modifier_custom_sonic_tracker = class({})
function modifier_custom_sonic_tracker:IsHidden() return true end
function modifier_custom_sonic_tracker:IsPurgable() return false end
function modifier_custom_sonic_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_custom_sonic_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end
if not self:GetParent():HasModifier("modifier_queen_Sonic_cd") then return end
if self:GetParent():HasModifier("modifier_custom_sonic_attack_cd") then return end

params.target:EmitSound("QoP.Sonic_attack")
local scream_pfx = ParticleManager:CreateParticle("particles/qop_sonic_attack.vpcf", PATTACH_ABSORIGIN, params.target)
ParticleManager:SetParticleControl(scream_pfx, 0, params.target:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(scream_pfx)

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().attack_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
local damage = self:GetAbility():GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_custom_sonic_kills") then 
	damage = damage + self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills")
end


if self:GetCaster():HasModifier("modifier_queen_Sonic_damage") then 
	damage = damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_damage")
end


damage = damage*self:GetAbility().attack_damage
for _,unit in pairs(units) do 

	ApplyDamage({attacker = self:GetCaster(), victim = unit, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})
	SendOverheadEventMessage(unit, 4, unit, damage, nil)
end

my_game:GenericHeal(self:GetCaster(), damage*self:GetAbility().attack_heal, self:GetAbility())

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_attack_cd", {duration = self:GetAbility().attack_cd})
end



function modifier_custom_sonic_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

if not self:GetParent():HasModifier("modifier_custom_sonic_heal") then return end
if params.inflictor ~= self:GetAbility() then return end

local heal = params.damage*self:GetAbility().blink_heal

local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
     ParticleManager:ReleaseParticleIndex( particle )

 self:GetParent():Heal(heal, self:GetParent())
 SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

end


function modifier_custom_sonic_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if self:GetAbility() == params.ability then return end
if not self:GetParent():HasModifier("modifier_queen_Sonic_taken") then return end


self.caster = self:GetCaster()

Timers:CreateTimer(FrameTime(), function()

	local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self:GetAbility().stack_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )

	local particle = ParticleManager:CreateParticle("particles/troll_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

	for _,unit in pairs(units) do 
		unit:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_sonic_stack", {duration = self:GetAbility().stack_duration})
	end

end)

end


function modifier_custom_sonic_tracker:OnDeath(params)
if not IsServer() then return end
if params.inflictor ~= self:GetAbility() and not params.unit:HasModifier("modifier_custom_sonic_kill") then return end
if params.unit:IsIllusion() then return end


if self:GetParent():HasModifier("modifier_queen_Sonic_legendary") then 

	local damage = self:GetAbility().legendary_damage 

	local mod = self:GetParent():FindModifierByName("modifier_custom_sonic_kills")

	if not mod then 
		mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_kills", {})
	end

	mod:SetStackCount(mod:GetStackCount() + damage)


	if params.unit:IsRealHero() then 

		local mod_cd = self:GetParent():FindModifierByName("modifier_custom_sonic_kills_cd")

		if not mod_cd then 
			mod_cd = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_kills_cd", {})
		end

		if mod_cd:GetStackCount() < self:GetAbility().legendary_cd_max then 
			mod_cd:SetStackCount(mod_cd:GetStackCount() + self:GetAbility().legendary_cd_hero)
		end
	end


end



end



modifier_custom_sonic_kills = class({})
function modifier_custom_sonic_kills:IsHidden() return false end
function modifier_custom_sonic_kills:IsPurgable() return false end
function modifier_custom_sonic_kills:RemoveOnDeath() return false end
function modifier_custom_sonic_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_custom_sonic_kills:OnTooltip() return self:GetStackCount() end




modifier_custom_sonic_fire_thinker = class({})

function modifier_custom_sonic_fire_thinker:IsHidden() return true end

function modifier_custom_sonic_fire_thinker:IsPurgable() return false end


function modifier_custom_sonic_fire_thinker:OnCreated(table)
if not IsServer() then return end
			
	self.start_pos = self:GetParent():GetAbsOrigin()
	self.end_pos = Vector(table.end_x,table.end_y,table.end_z)
	self.damage = table.damage

	self:GetParent():EmitSound("QoP.Sonic_fire")



	self.pfx = ParticleManager:CreateParticle("particles/qop_sonic_fire.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.pfx, 0, self.start_pos)
    ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetAbility().fire_duration, 0, 0))
    ParticleManager:SetParticleControl(self.pfx, 1, self.end_pos)
    ParticleManager:SetParticleControl(self.pfx, 3, self.end_pos)
     ParticleManager:ReleaseParticleIndex(self.pfx)
 	self:AddParticle(self.pfx,false,false,-1,false,false)

self:StartIntervalThink(self:GetAbility().fire_interval)
self:OnIntervalThink()
end

function modifier_custom_sonic_fire_thinker:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("QoP.Sonic_fire")

end


function modifier_custom_sonic_fire_thinker:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInLine(self:GetParent():GetTeamNumber(), self.start_pos,self.end_pos, nil, self:GetAbility().fire_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_NONE)

for _,enemy in ipairs(enemies) do 
	if not enemy:IsMagicImmune() then 
		ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = enemy, ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(enemy, 4, enemy, self.damage, nil)
	end
end

end




modifier_custom_sonic_reduce = class({})

function modifier_custom_sonic_reduce:IsHidden() return false end
function modifier_custom_sonic_reduce:IsPurgable() return false end
function modifier_custom_sonic_reduce:GetTexture() return "buffs/sonic_reduce" end
function modifier_custom_sonic_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_custom_sonic_reduce:GetModifierTotalDamageOutgoing_Percentage() return 
self:GetAbility().reduce_init + self:GetAbility().reduce_inc*self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_reduce")
end



modifier_custom_sonic_kills_cd = class({})
function modifier_custom_sonic_kills_cd:IsHidden() return false end
function modifier_custom_sonic_kills_cd:IsPurgable() return false end
function modifier_custom_sonic_kills_cd:RemoveOnDeath() return false end
function modifier_custom_sonic_kills_cd:GetTexture() return "buffs/sonic_cd" end
function modifier_custom_sonic_kills_cd:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_custom_sonic_kills_cd:OnTooltip() return self:GetStackCount() end




modifier_custom_sonic_stack = class({})
function modifier_custom_sonic_stack:IsHidden() return false end
function modifier_custom_sonic_stack:IsPurgable() return false end
function modifier_custom_sonic_stack:GetTexture() return "buffs/sonic_stack" end

function modifier_custom_sonic_stack:OnCreated(table)
if not IsServer() then return end
 self.pfx = ParticleManager:CreateParticle("particles/sf_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.pfx,false, false, -1, false, false)
self:SetStackCount(1)
end

function modifier_custom_sonic_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().stack_max then return end

self:IncrementStackCount()
end

function modifier_custom_sonic_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.pfx then return end

ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end



function modifier_custom_sonic_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_custom_sonic_stack:OnTooltip()
return self:GetAbility().stack_damage[self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_taken")]*100*self:GetStackCount()
end



modifier_custom_sonic_attack_cd = class({})
function modifier_custom_sonic_attack_cd:IsHidden() return false end
function modifier_custom_sonic_attack_cd:IsPurgable() return false end
function modifier_custom_sonic_attack_cd:RemoveOnDeath() return false end
function modifier_custom_sonic_attack_cd:IsDebuff() return true end
function modifier_custom_sonic_attack_cd:GetTexture() return "buffs/sonic_cd" end
function modifier_custom_sonic_attack_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_custom_sonic_kill = class({})
function modifier_custom_sonic_kill:IsHidden() return true end
function modifier_custom_sonic_kill:IsPurgable() return false end
function modifier_custom_sonic_kill:RemoveOnDeath() return false end



modifier_custom_sonic_quest = class({})
function modifier_custom_sonic_quest:IsHidden() return true end
function modifier_custom_sonic_quest:IsPurgable() return false end
function modifier_custom_sonic_quest:RemoveOnDeath() return false end