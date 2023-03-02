LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_fow", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_slow", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_knockback", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_kills", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_kills_tracker", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_legendary_vision", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_legendary_thinker", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_legendary_teleport", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_cloud", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_cloud_legendary", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_shield", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_tracker", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)

zuus_thundergods_wrath_custom = class({})

zuus_thundergods_wrath_custom.cd_inc = {-10, -20, -30}

zuus_thundergods_wrath_custom.damage_inc = {50, 100, 150}

zuus_thundergods_wrath_custom.slow_duration = 4
zuus_thundergods_wrath_custom.slow_move = -80
zuus_thundergods_wrath_custom.root_knockback_distance = 700
zuus_thundergods_wrath_custom.root_knockback_duration = 0.3
zuus_thundergods_wrath_custom.root_knockback_range = 100

zuus_thundergods_wrath_custom.kills_max = 8
zuus_thundergods_wrath_custom.kills_spell = 10
zuus_thundergods_wrath_custom.kills_damage = 40
zuus_thundergods_wrath_custom.kills_duration = 8

zuus_thundergods_wrath_custom.legendary_duration = 10

zuus_thundergods_wrath_custom.cloud_duration = 5
zuus_thundergods_wrath_custom.cloud_chance = 25
zuus_thundergods_wrath_custom.cloud_damage = {0.15, 0.25}
zuus_thundergods_wrath_custom.cloud_radius = 500

zuus_thundergods_wrath_custom.shield_health = {0.5, 0.75, 1}
zuus_thundergods_wrath_custom.shield_duration = 15
zuus_thundergods_wrath_custom.shield_status = 25


function zuus_thundergods_wrath_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_zuus_wrath_1") then 
  bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_zuus_wrath_1")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end

function zuus_thundergods_wrath_custom:GetIntrinsicModifierName()
return "modifier_zuus_thundergods_wrath_custom_tracker"
end


function zuus_thundergods_wrath_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("damage_range")
end


function zuus_thundergods_wrath_custom:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath.PreCast")
	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
	local attack_lock2 = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack2"))

	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetOrigin(), true );
	ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetOrigin(), true );
	

	return true
end

function zuus_thundergods_wrath_custom:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end


function zuus_thundergods_wrath_custom:GetWrathDamage()
if not IsServer() then return end

local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_zuus_wrath_2") then 
	damage = damage + self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_zuus_wrath_2")]
end

if self:GetCaster():HasModifier("modifier_zuus_thundergods_wrath_custom_kills") and self:GetCaster():HasModifier("modifier_zuus_wrath_6") then 
	damage = damage + self.kills_damage*self:GetCaster():FindModifierByName("modifier_zuus_thundergods_wrath_custom_kills"):GetStackCount()
end

return damage
end


function zuus_thundergods_wrath_custom:OnSpellStart() 
	if not IsServer() then return end
	local ability 				= self
	local caster 				= self:GetCaster()
	local true_sight_radius 	= ability:GetSpecialValueFor("sight_radius_day")
	local sight_radius_day 		= ability:GetSpecialValueFor("sight_radius_day")
	local sight_radius_night 	= ability:GetSpecialValueFor("sight_radius_night")
	local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
	local pierce_spellimmunity 	= false
	local damage_radius = ability:GetSpecialValueFor("damage_range")
	local damage_reduction = ability:GetSpecialValueFor("damage_reduction")/100

	local position = self:GetCaster():GetAbsOrigin()	

	if self.thundergod_spell_cast then
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end

	EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Zuus.GodsWrath", self:GetCaster())

		
	local damage = self:GetWrathDamage()

	if self:GetCaster():HasModifier("modifier_zuus_wrath_7") then 
		self:GetCaster():SwapAbilities(self:GetAbilityName(), "zuus_thundergods_wrath_custom_legendary", false, true)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_thundergods_wrath_custom_legendary_vision", {duration = self.legendary_duration})
	end


	if self:GetCaster():HasModifier("modifier_zuus_wrath_3") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_thundergods_wrath_custom_shield", {duration = self.shield_duration})
	end

	if self:GetCaster():HasModifier("modifier_zuus_wrath_5") then 
		self:GetCaster():EmitSound("Zuus.Wrath_knockback")

		local qangle_rotation_rate = 60
		local line_position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 400
		for i = 1, 6 do

			local qangle = QAngle(0, qangle_rotation_rate, 0)
			line_position = RotatePosition(self:GetCaster():GetAbsOrigin() , qangle, line_position)

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			local n = RandomInt(1, 2)
			ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack"..n, self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(particle, 1, line_position)
			ParticleManager:DestroyParticle(particle, false)	
			ParticleManager:ReleaseParticleIndex(particle)
		end

	end

	local damage_table = {attacker = self:GetCaster(), damage = damage, ability = ability, damage_type = ability:GetAbilityDamageType() }

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	
	local buff = false

	for _,hero in pairs(units) do 
		if (hero:IsRealHero() or (hero:IsCreep() and (hero:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self:GetSpecialValueFor("creeps_range")))
		 and not hero:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and hero:GetUnitName() ~= "npc_teleport" then 

			local target_point = hero:GetAbsOrigin()
			local vStartPosition = target_point + Vector(0,0,4000)

			local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, hero )
			ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
			ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true )
			ParticleManager:DestroyParticle(nFXIndex, false)
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			if (not hero:IsMagicImmune()) and not hero:IsInvulnerable() and not hero:IsOutOfGame() and (not hero:IsInvisible() or caster:CanEntityBeSeenByMyTeam(hero)) then
	
				damage_table.victim  = hero

				if buff == false then 
					buff = true
					if self:GetCaster():HasModifier("modifier_zuus_jump_4") then 
						local ability = self:GetCaster():FindAbilityByName("zuus_heavenly_jump_custom")

						if ability and ability:GetLevel() > 0 then 
							self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_zuus_heavenly_jump_custom_attack_speed", {duration = ability.speed_duration})
						end
					end
				end

				local zuus_static_field_custom = self:GetCaster():FindAbilityByName("zuus_static_field_custom")
				if zuus_static_field_custom and zuus_static_field_custom:GetLevel() > 0 then
					zuus_static_field_custom:ApplyDamageStatic(hero)
				end

				if self:GetCaster():HasModifier("modifier_zuus_wrath_5") then

					local near = 0
					if (self:GetCaster():GetAbsOrigin() - hero:GetAbsOrigin()):Length2D() <= self.root_knockback_distance then 

 						hero:AddNewModifier(self:GetCaster(), self, "modifier_zuus_thundergods_wrath_custom_knockback", {duration = self.root_knockback_duration, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
						local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
						local n = RandomInt(1, 2)
						ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack"..n, self:GetCaster():GetAbsOrigin(), true)
						ParticleManager:SetParticleControlEnt(particle, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
						near = 1

					end 	
					

					hero:AddNewModifier(self:GetCaster(), self, "modifier_zuus_thundergods_wrath_custom_slow", {near = near, duration = (1 - hero:GetStatusResistance())*self.slow_duration})
					

				end

				local k = 1
				if (hero:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > damage_radius then 
					k = damage_reduction
				end

				damage_table.damage = damage*k

				if hero:IsRealHero() then 
					hero:AddNewModifier(self:GetCaster(), self, "modifier_zuus_thundergods_wrath_custom_kills_tracker", {duration = self.kills_duration})
				end

				ApplyDamage(damage_table)
			end

			hero:AddNewModifier(caster, ability, "modifier_zuus_thundergods_wrath_custom_fow", {duration = sight_duration})

			hero:EmitSound("Hero_Zuus.GodsWrath.Target")
		end
	end
end

modifier_zuus_thundergods_wrath_custom_fow = class({})

function modifier_zuus_thundergods_wrath_custom_fow:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_fow:IsPurgable() return false end

function modifier_zuus_thundergods_wrath_custom_fow:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_zuus_thundergods_wrath_custom_fow:OnIntervalThink()
	if not IsServer() then return end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("sight_radius_day"), FrameTime() * 2, false)
end

function modifier_zuus_thundergods_wrath_custom_fow:GetAuraRadius()
	return 900
end

function modifier_zuus_thundergods_wrath_custom_fow:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_zuus_thundergods_wrath_custom_fow:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_zuus_thundergods_wrath_custom_fow:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_zuus_thundergods_wrath_custom_fow:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_zuus_thundergods_wrath_custom_fow:GetAuraDuration()
    return 0.5
end






modifier_zuus_thundergods_wrath_custom_slow = class({})

function modifier_zuus_thundergods_wrath_custom_slow:IsPurgable() return false end

function modifier_zuus_thundergods_wrath_custom_slow:IsHidden() return false end 
function modifier_zuus_thundergods_wrath_custom_slow:IsDebuff() return true end
function modifier_zuus_thundergods_wrath_custom_slow:GetTexture() return "buffs/wrath_slow" end


function modifier_zuus_thundergods_wrath_custom_slow:GetEffectName() return "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf" end

function modifier_zuus_thundergods_wrath_custom_slow:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end


function modifier_zuus_thundergods_wrath_custom_slow:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(table.near)

if self:GetStackCount() == 1 then 
  self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)
end

end

function modifier_zuus_thundergods_wrath_custom_slow:GetModifierMoveSpeedBonus_Percentage() 
return 
self:GetAbility().slow_move
end



function modifier_zuus_thundergods_wrath_custom_slow:CheckState()
if self:GetStackCount() == 0 then return end
return
{
	[MODIFIER_STATE_PASSIVES_DISABLED] = true
}
end









modifier_zuus_thundergods_wrath_custom_knockback = class({})

function modifier_zuus_thundergods_wrath_custom_knockback:IsHidden() return true end

function modifier_zuus_thundergods_wrath_custom_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.root_knockback_duration
  local distance_beetween = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

  self.knockback_distance   = math.max(self:GetAbility().root_knockback_distance - distance_beetween, 0)
  self.knockback_distance = math.max(self.knockback_distance, self:GetAbility().root_knockback_range)


  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_zuus_thundergods_wrath_custom_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_zuus_thundergods_wrath_custom_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_zuus_thundergods_wrath_custom_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_zuus_thundergods_wrath_custom_knockback:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController( self )
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)

end



modifier_zuus_thundergods_wrath_custom_kills = class({})
function modifier_zuus_thundergods_wrath_custom_kills:IsHidden() return false end
function modifier_zuus_thundergods_wrath_custom_kills:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_kills:RemoveOnDeath() return false end
function modifier_zuus_thundergods_wrath_custom_kills:GetTexture() return "buffs/wrath_kills" end
function modifier_zuus_thundergods_wrath_custom_kills:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_thundergods_wrath_custom_kills:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().kills_max then  return end
self:IncrementStackCount()
end


function modifier_zuus_thundergods_wrath_custom_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_zuus_thundergods_wrath_custom_kills:GetModifierSpellAmplify_Percentage()
if not self:GetParent():HasModifier("modifier_zuus_wrath_6") then return 0 end
if self:GetStackCount() < self:GetAbility().kills_max then return end
return self:GetAbility().kills_spell
end


function modifier_zuus_thundergods_wrath_custom_kills:OnTooltip()
return self:GetStackCount()
end


function modifier_zuus_thundergods_wrath_custom_kills:OnTooltip2()
if not self:GetParent():HasModifier("modifier_zuus_wrath_6") then return 0 end
return self:GetStackCount()*self:GetAbility().kills_damage
end




modifier_zuus_thundergods_wrath_custom_kills_tracker = class({})
function modifier_zuus_thundergods_wrath_custom_kills_tracker:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_kills_tracker:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_kills_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_zuus_thundergods_wrath_custom_kills_tracker:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():IsReincarnating() then return end


local hero = self:GetCaster()
if (hero:GetQuest() == "Zuus.Quest_8") then 
	hero:UpdateQuest(1)
end

local particle = ParticleManager:CreateParticle("particles/zuus_wrath_kill.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin())
	


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_thundergods_wrath_custom_kills", {})
self:Destroy()
end





modifier_zuus_thundergods_wrath_custom_legendary_vision = class({})
function modifier_zuus_thundergods_wrath_custom_legendary_vision:IsHidden() return false end
function modifier_zuus_thundergods_wrath_custom_legendary_vision:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_legendary_vision:RemoveOnDeath() return false end
function modifier_zuus_thundergods_wrath_custom_legendary_vision:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(0.2)
end

function modifier_zuus_thundergods_wrath_custom_legendary_vision:OnIntervalThink()
if not IsServer() then return end

local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)


for _,hero in pairs(heroes) do 
	if not hero:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
    	AddFOWViewer(self:GetCaster():GetTeamNumber(), hero:GetAbsOrigin(), 10, 0.2, false)
    end
end

end


function modifier_zuus_thundergods_wrath_custom_legendary_vision:OnDestroy()
if not IsServer() then return end
if self:GetAbility():IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetAbility():GetName() , "zuus_thundergods_wrath_custom_legendary", true, false)
end

end



zuus_thundergods_wrath_custom_legendary = class({})



function zuus_thundergods_wrath_custom_legendary:OnSpellStart()
if not IsServer() then return end

local heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)


local position = self:GetCaster():GetAbsOrigin()
for _,hero in pairs(heroes) do 
	if not hero:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and (hero == self:GetCaster() or hero:GetTeamNumber() ~= self:GetCaster():GetTeamNumber()) then 
		position = hero:GetAbsOrigin()
		break
	end
end



self:GetCaster():SwapAbilities(self:GetAbilityName(), "zuus_thundergods_wrath_custom", false, true)

CreateModifierThinker(self:GetCaster(), self, "modifier_zuus_thundergods_wrath_custom_legendary_thinker", {duration = 2.5, radius = self:GetSpecialValueFor("aoe")}, position, self:GetCaster():GetTeamNumber(), false)
			
if self:GetCaster():HasModifier("modifier_zuus_thundergods_wrath_custom_cloud") then 

	local duration = math.min(2.5, self:GetCaster():FindModifierByName("modifier_zuus_thundergods_wrath_custom_cloud"):GetRemainingTime() )

	self:GetCaster().cloud_unit = CreateUnitByName("npc_dota_companion", position, false, self:GetCaster(), nil, self:GetCaster():GetTeam())
	self:GetCaster().cloud_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_phased", {})
	self:GetCaster().cloud_unit:AddNewModifier(self:GetCaster(), self, "modifier_zuus_thundergods_wrath_custom_cloud_legendary", {duration = duration})
end

end





modifier_zuus_thundergods_wrath_custom_cloud_legendary = class({})
function modifier_zuus_thundergods_wrath_custom_cloud_legendary:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_cloud_legendary:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_cloud_legendary:CheckState()
return	
	{
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

end
function modifier_zuus_thundergods_wrath_custom_cloud_legendary:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}

	return funcs
end

function modifier_zuus_thundergods_wrath_custom_cloud_legendary:GetVisualZDelta()
	return 300
end

function modifier_zuus_thundergods_wrath_custom_cloud_legendary:OnCreated(table)
if not IsServer() then return end

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/zeus_wrath_cloud.vpcf", PATTACH_WORLDORIGIN, nil)	
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, self:GetParent():GetAbsOrigin())
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)
end

function modifier_zuus_thundergods_wrath_custom_cloud_legendary:OnDestroy()
if not IsServer() then return end
self:GetCaster().cloud_unit = nil
UTIL_Remove(self:GetParent())
end




modifier_zuus_thundergods_wrath_custom_legendary_thinker = class({})
function modifier_zuus_thundergods_wrath_custom_legendary_thinker:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_legendary_thinker:IsPurgable() return false end

function modifier_zuus_thundergods_wrath_custom_legendary_thinker:OnCreated()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("zuus_thundergods_wrath_custom")
self.damage = ability:GetWrathDamage()*self:GetAbility():GetSpecialValueFor("damage")

self.ability = ability

local particle_cast = "particles/zuus_wrath_legendary.vpcf"
self.radius = self:GetAbility():GetSpecialValueFor("aoe")

point = self:GetParent():GetAbsOrigin()

GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.radius, true)

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_thundergods_wrath_custom_legendary_teleport", {duration = self:GetAbility():GetSpecialValueFor("delay")})
FindClearSpaceForUnit(self:GetCaster(), self:GetParent():GetAbsOrigin(), true)


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, point )
ParticleManager:SetParticleControl( effect_cast, 1, point )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
self:AddParticle(effect_cast, false, false, -1, false, false )

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, point)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Zuus.Wrath_legendary_aoe", self:GetCaster())

self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("delay"))
end





function modifier_zuus_thundergods_wrath_custom_legendary_thinker:OnIntervalThink()
if not IsServer() then return end

EmitSoundOnLocationWithCaster( self:GetParent():GetAbsOrigin(), "Zuus.Wrath_legendary_impact", self:GetCaster() )

self:GetParent():EmitSound("Hero_Zuus.GodsWrath.Target")

local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
for _,unit in pairs(units) do

	local target_point = unit:GetAbsOrigin()
	local vStartPosition = target_point + Vector(0,0,4000)

	local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, unit )
	ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex)

	EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.LightningBolt", self:GetCaster())
	unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - unit:GetStatusResistance())*self:GetAbility():GetSpecialValueFor("stun")})

	local damage_table = {victim = unit, attacker = self:GetCaster(), damage = self.damage, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL }
	ApplyDamage(damage_table)

end

local effect_cast = ParticleManager:CreateParticle( "particles/zeus_landing.vpcf", PATTACH_WORLDORIGIN,  nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

end
















modifier_zuus_thundergods_wrath_custom_legendary_teleport = class({})
function modifier_zuus_thundergods_wrath_custom_legendary_teleport:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_legendary_teleport:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_legendary_teleport:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:GetParent():AddNoDraw()

AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 500, 3, false)

EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Zuus.Wrath_legendary_start", self:GetCaster())
EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Zuus.Wrath_legendary_start_2", self:GetCaster())



local part = ParticleManager:CreateParticle("particles/zeus_blinks_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(part, 1, self:GetParent():GetAbsOrigin())

local part2 = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part2, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(part2, 1, self:GetParent():GetAbsOrigin())
end


function modifier_zuus_thundergods_wrath_custom_legendary_teleport:CheckState()
return
{
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}
end


function modifier_zuus_thundergods_wrath_custom_legendary_teleport:OnDestroy()
if not IsServer() then return end
local unit = self:GetParent()

local target_point = unit:GetAbsOrigin()
local vStartPosition = target_point + Vector(0,0,4000)

local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, unit )
ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( nFXIndex )


local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_WORLDORIGIN, nil)

ParticleManager:SetParticleControl(particle2, 0, vStartPosition)
ParticleManager:SetParticleControl(particle2, 1, unit:GetOrigin())

local qangle_rotation_rate = 72

local line_position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self:GetAbility():GetSpecialValueFor("aoe")


for i = 1, 5 do

	local qangle = QAngle(0, qangle_rotation_rate, 0)
	line_position = RotatePosition(self:GetCaster():GetAbsOrigin() , qangle, line_position)

	local z_pos = 3000

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
			

	ParticleManager:SetParticleControl(particle, 0, Vector(line_position.x, line_position.y, z_pos))
	ParticleManager:SetParticleControl(particle, 1, Vector(line_position.x, line_position.y, line_position.z))

end


local part = ParticleManager:CreateParticle("particles/zeus_wrath_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(part, 1, self:GetParent():GetAbsOrigin())
self:GetParent():RemoveNoDraw()

self:GetParent():StartGesture(ACT_DOTA_SPAWN)
end












modifier_zuus_thundergods_wrath_custom_cloud = class({})
function modifier_zuus_thundergods_wrath_custom_cloud:IsHidden() return false end
function modifier_zuus_thundergods_wrath_custom_cloud:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_cloud:GetTexture() return "buffs/wrath_cloud" end

function modifier_zuus_thundergods_wrath_custom_cloud:OnCreated(table)
if not IsServer() then return end

self.damage = self:GetAbility():GetWrathDamage()*self:GetAbility().cloud_damage[self:GetCaster():GetUpgradeStack("modifier_zuus_wrath_4")]

local target_point = self:GetParent():GetAbsOrigin()
self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/zeus_wrath_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, self:GetParent():GetAbsOrigin())
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self:StartIntervalThink(FrameTime())
end

function modifier_zuus_thundergods_wrath_custom_cloud:OnIntervalThink()
if not IsServer() then return end

local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().cloud_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

if #units > 0 then 
	point = 
	my_game:GenericHeal(self:GetCaster(), self.damage, self:GetAbility())
	for _,unit in pairs(units) do 

		local damage_table = {victim = unit, attacker = self:GetCaster(), damage = self.damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL }
		ApplyDamage(damage_table)


		local particle

		if self:GetCaster().cloud_unit ~= nil and not self:GetCaster().cloud_unit:IsNull() then
			particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster().cloud_unit)
			ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster().cloud_unit, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetCaster().cloud_unit:GetAbsOrigin(), true) 
		else 
			particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_OVERHEAD_FOLLOW, "attach_spawn", self:GetCaster():GetAbsOrigin(), true)
		end

		ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:DestroyParticle(particle, false)	
		ParticleManager:ReleaseParticleIndex(particle)

		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit ) )


		unit:EmitSound("Hero_Zuus.StaticField")
	end
	EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Zuus.Wrath_cloud_ground", self:GetCaster())
	self:StartIntervalThink(1)
else 
	self:StartIntervalThink(FrameTime())

end


end


modifier_zuus_thundergods_wrath_custom_shield = class({})
function modifier_zuus_thundergods_wrath_custom_shield:IsHidden() return false end
function modifier_zuus_thundergods_wrath_custom_shield:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_shield:GetTexture() return "buffs/laguna_shield" end


function modifier_zuus_thundergods_wrath_custom_shield:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_thundergods_wrath_custom_shield:StatusEffectPriority() return 11111 end

function modifier_zuus_thundergods_wrath_custom_shield:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

local shield_size = self:GetParent():GetModelRadius() 

local particle = ParticleManager:CreateParticle("particles/zuus_shield_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local common_vector = Vector(shield_size,0,shield_size)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)

ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)

self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")

self.shield = self:GetAbility():GetWrathDamage()*self:GetAbility().shield_health[self:GetCaster():GetUpgradeStack("modifier_zuus_wrath_3")]
self:SetStackCount(self.shield)
end


function modifier_zuus_thundergods_wrath_custom_shield:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("DOTA_Item.Mjollnir.Loop")
self:GetParent():EmitSound("DOTA_Item.Mjollnir.DeActivate")
end



function modifier_zuus_thundergods_wrath_custom_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end

function modifier_zuus_thundergods_wrath_custom_shield:GetModifierStatusResistanceStacking() 
	return self:GetAbility().shield_status
end


function modifier_zuus_thundergods_wrath_custom_shield:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end

if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end


    if params.damage>self.shield then
        self:Destroy()
        return self.shield
    else
        self.shield = self.shield-params.damage
        self:SetStackCount(self.shield)
        return params.damage
    end

end





modifier_zuus_thundergods_wrath_custom_tracker = class({})
function modifier_zuus_thundergods_wrath_custom_tracker:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_tracker:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

function modifier_zuus_thundergods_wrath_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_zuus_wrath_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if params.ability:IsItem() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

local random = RollPseudoRandomPercentage(self:GetAbility().cloud_chance,78,self:GetCaster())


if not random then return end

self:GetCaster():EmitSound("Zuus.Wrath_cloud")
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_thundergods_wrath_custom_cloud", {duration = self:GetAbility().cloud_duration})

end
