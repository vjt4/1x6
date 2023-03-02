LinkLuaModifier( "modifier_mars_spear_custom_debuff_knockback", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_blocker", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_thinker", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_wall_aura", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_spear_aura", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_projectile_aura", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_tracker", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_no_damage", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_legendary", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_legendary_damage", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_attack_speed", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_arena_of_blood_custom_soldier", "abilities/mars/mars_arena_of_blood_custom", LUA_MODIFIER_MOTION_NONE )

mars_arena_of_blood_custom = class({})

mars_arena_of_blood_custom.duration_inc = {1, 1.5, 2}

mars_arena_of_blood_custom.cd_inc = {-10, -20, -30}

mars_arena_of_blood_custom.damage_inc = {0.15, 0.2, 0.25}

mars_arena_of_blood_custom.spells_silence = 2
mars_arena_of_blood_custom.spells_damage_duration = 5
mars_arena_of_blood_custom.spells_damage = 10
mars_arena_of_blood_custom.spells_regen = 5

mars_arena_of_blood_custom.fear_health = 30
mars_arena_of_blood_custom.fear_radius = 500
mars_arena_of_blood_custom.fear_duration = 1.5

mars_arena_of_blood_custom.legendary_bva = 1.6
mars_arena_of_blood_custom.legendary_bva_stack = 5
mars_arena_of_blood_custom.legendary_damage = 15

mars_arena_of_blood_custom.soldier_damage = {0.25, 0.4}
mars_arena_of_blood_custom.soldier_speed = {0.25, 0.4}
mars_arena_of_blood_custom.soldier_duration = 8
mars_arena_of_blood_custom.soldier_chance = 15



function mars_arena_of_blood_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function mars_arena_of_blood_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_mars_arena_1") then  
  upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_mars_arena_1")]
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function mars_arena_of_blood_custom:GetIntrinsicModifierName()
return "modifier_mars_arena_of_blood_custom_tracker"
end


function mars_arena_of_blood_custom:CreateSoldier(point, duration)
if not IsServer() then return end

local unit = CreateUnitByName( "mars_arena_soldier", point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
unit:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = duration})
unit.owner = self:GetCaster()



unit:AddNewModifier(self:GetCaster(), self, "modifier_mars_arena_of_blood_custom_soldier", {})
unit:EmitSound("Mars.Soldier_spawn")

end


function mars_arena_of_blood_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()



CreateModifierThinker( self:GetCaster(), self, "modifier_mars_arena_of_blood_custom_thinker", {}, point, self:GetCaster():GetTeamNumber(), false )
end

mars_arena_of_blood_custom.projectiles = {}

function mars_arena_of_blood_custom:OnProjectileHitHandle( target, location, id )
	local data = self.projectiles[id]
	self.projectiles[id] = nil
	if data.destroyed then return end
	local attacker = EntIndexToHScript( data.entindex_source_const )
	attacker:PerformAttack( target, true, true, true, true, false, false, true )
end

modifier_mars_arena_of_blood_custom_thinker = class({})

function modifier_mars_arena_of_blood_custom_thinker:IsHidden()
	return true
end

function modifier_mars_arena_of_blood_custom_thinker:OnCreated( kv )
	self.delay = self:GetAbility():GetSpecialValueFor( "formation_time" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_mars_arena_5") then 
		self.delay = 0
	end


	if self:GetCaster():HasModifier("modifier_mars_arena_3") then 
		self.duration = self.duration + self:GetAbility().duration_inc[self:GetCaster():GetUpgradeStack("modifier_mars_arena_3")]
	end

	if self:GetCaster():HasModifier("modifier_mars_arena_4") then 
		self:GetAbility():CreateSoldier(self:GetParent():GetAbsOrigin(), self.duration)
	end


	self.thinkers = {}
	self.phase_delay = true
	self:StartIntervalThink( self.delay )
	self:PlayEffects()
end

function modifier_mars_arena_of_blood_custom_thinker:OnRemoved()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Mars.ArenaOfBlood.End")
	StopSoundOn("Hero_Mars.ArenaOfBlood", self:GetParent())
end

function modifier_mars_arena_of_blood_custom_thinker:OnDestroy()
	if not IsServer() then return end
	local modifiers = {}
	for k,v in pairs(self:GetParent():FindAllModifiers()) do
		modifiers[k] = v
	end
	for k,v in pairs(modifiers) do
		v:Destroy()
	end
	UTIL_Remove( self:GetParent() ) 
end

function modifier_mars_arena_of_blood_custom_thinker:OnIntervalThink()
	if self.phase_delay then
		self.phase_delay = false

		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.radius, self.duration, false)

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_arena_of_blood", {})
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mars_arena_of_blood_custom_wall_aura", {} )
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mars_arena_of_blood_custom_spear_aura", {} )

		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mars_arena_of_blood_custom_projectile_aura", {thinker = self:GetParent():entindex()} )

		self:SummonBlockers()
		EmitSoundOn("Hero_Mars.ArenaOfBlood", self:GetParent())
		self:StartIntervalThink( self.duration )
		self.phase_duration = true
		return
	end

	if self.phase_duration then
		self:Destroy()
		return
	end
end

function modifier_mars_arena_of_blood_custom_thinker:SummonBlockers()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local teamnumber = caster:GetTeamNumber()
	local origin = self:GetParent():GetOrigin()
	local angle = 0
	local vector = origin + Vector(self.radius,0,0)
	local zero = Vector(0,0,0)
	local one = Vector(1,0,0)
	local count = 28
	local angle_diff = 360/count

	for i=0,count-1 do
		local location = RotatePosition( origin, QAngle( 0, angle_diff*i, 0 ), vector )
		local facing = RotatePosition( zero, QAngle( 0, 200+angle_diff*i, 0 ), one )

		local callback = function( unit )
			unit:SetForwardVector( facing )
			unit:SetNeverMoveToClearSpace( true )
			unit:AddNewModifier( caster, self:GetAbility(), "modifier_mars_arena_of_blood_custom_blocker", { duration = self.duration, model = i%2==0 } )
		end

		--local unit = CreateUnitByNameAsync( "npc_dota_companion", location, false, caster, nil, caster:GetTeamNumber(), callback )

		local unit = CreateUnitByName("npc_dota_companion", location, false, caster, nil, caster:GetTeamNumber())

		unit:SetForwardVector( facing )
		unit:SetNeverMoveToClearSpace( true )
		unit:AddNewModifier( caster, self:GetAbility(), "modifier_mars_arena_of_blood_custom_blocker", { duration = self.duration, model = i%2==0 } )
	end
end

function modifier_mars_arena_of_blood_custom_thinker:PlayEffects()
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_arena_of_blood.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius + 50, 0, 0 ) )
	ParticleManager:SetParticleControl( particle, 2, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( particle, 3, self:GetParent():GetOrigin() )
	self:AddParticle( particle, false, false, -1, false, false )
	self:GetParent():EmitSound("Hero_Mars.ArenaOfBlood.Start")
end

modifier_mars_arena_of_blood_custom_blocker = class({})

function modifier_mars_arena_of_blood_custom_blocker:IsHidden()
	return true
end

function modifier_mars_arena_of_blood_custom_blocker:IsPurgable()
	return false
end

function modifier_mars_arena_of_blood_custom_blocker:OnCreated( kv )
	if not IsServer() then return end
	if kv.model==1 then
		self.fade_min = self:GetAbility():GetSpecialValueFor( "warrior_fade_min_dist" )
		self.fade_max = self:GetAbility():GetSpecialValueFor( "warrior_fade_max_dist" )
		self.fade_range = self.fade_max-self.fade_min
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.origin = self.parent:GetOrigin()
		self:GetParent():SetOriginalModel( "models/heroes/mars/mars_soldier.vmdl" )
		self:GetParent():SetRenderAlpha( 0 )
		self:GetParent().model = 1
		self:StartIntervalThink( 0.1 )
	end
end

function modifier_mars_arena_of_blood_custom_blocker:OnDestroy()
	if not IsServer() then return end
	self:GetParent():ForceKill( false )
end

function modifier_mars_arena_of_blood_custom_blocker:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}
	return state
end

function modifier_mars_arena_of_blood_custom_blocker:OnIntervalThink()
	local alpha = 0
	self.parent:SetRenderAlpha( alpha )
end

function modifier_mars_arena_of_blood_custom_blocker:Interpolate( value, min, max )
	return value*(max-min) + min
end

modifier_mars_arena_of_blood_custom_projectile_aura = class({})

function modifier_mars_arena_of_blood_custom_projectile_aura:IsPurgable()
	return false
end

function modifier_mars_arena_of_blood_custom_projectile_aura:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.width = self:GetAbility():GetSpecialValueFor( "width" )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if not IsServer() then return end



	self.owner = kv.isProvidedByAura~=1


	self.fear = false
	if not self.owner then return end
	if not self:GetCaster():HasModifier("modifier_mars_arena_7") then return end
	self:StartIntervalThink( 0.03 )

end




function modifier_mars_arena_of_blood_custom_projectile_aura:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end




function modifier_mars_arena_of_blood_custom_projectile_aura:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)

for _,enemy in pairs(enemies) do 
	if enemy:IsRealHero() and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and not enemy:HasModifier("modifier_mars_arena_of_blood_custom_legendary") then 
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_arena_of_blood_custom_legendary", {thinker = self:GetParent():entindex()})
	end
end

end



function modifier_mars_arena_of_blood_custom_projectile_aura:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= self:GetCaster() then return end
if not self:GetParent():HasModifier("modifier_mars_arena_5") then return end
if self:GetParent() ~= params.unit then return end
if self.fear == true then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().fear_health then return end

self.fear = true
self:GetParent():Purge(false, true, false, true, false)
self:GetParent():EmitSound("BS.Rupture_fear")
self:GetParent():EmitSound("Mars.Fear_voice")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

local wave_particle = ParticleManager:CreateParticle( "particles/mars_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(wave_particle)


local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().fear_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

for _,enemy in pairs(enemies) do
	local name = "modifier_stunned"
	if enemy:IsHero() then 
		name = "modifier_nevermore_requiem_fear"
	end
	enemy:AddNewModifier(self:GetCaster(), enemy, name, {duration = (1 - enemy:GetStatusResistance())*self:GetAbility().fear_duration})
end

end





function modifier_mars_arena_of_blood_custom_projectile_aura:IsAura()
	return self.owner
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetModifierAura()
	return "modifier_mars_arena_of_blood_custom_projectile_aura"
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetAuraRadius()
	return self.radius
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetAuraDuration()
	return 0.3
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_mars_arena_of_blood_custom_projectile_aura:GetAuraEntityReject( hEntity )
	if IsServer() then end
	return false
end




function modifier_mars_arena_of_blood_custom_projectile_aura:PlayEffects( loc )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_arena_of_blood_impact.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( loc, "Hero_Mars.Block_Projectile", self:GetCaster() )
end

modifier_mars_arena_of_blood_custom_spear_aura = class({})

function modifier_mars_arena_of_blood_custom_spear_aura:IsPurgable()
	return true
end

function modifier_mars_arena_of_blood_custom_spear_aura:OnCreated( kv )
if true then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.width = self:GetAbility():GetSpecialValueFor( "spear_distance_from_wall" )
	self.duration = self:GetAbility():GetSpecialValueFor( "spear_attack_interval" )
	self.damage = self:GetAbility():GetSpecialValueFor( "spear_damage" )
	self.knockback_duration = 0.2

	self.parent = self:GetParent()
	self.spear_radius = self.radius-self.width

	if not IsServer() then return end
	self.owner = kv.isProvidedByAura~=1
	self.aura_origin = self:GetParent():GetOrigin()
	self:StartIntervalThink(FrameTime())

	if not self.owner then
		self.aura_origin = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
		local direction = self.aura_origin-self:GetParent():GetOrigin()
		direction.z = 0

		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(),
		}
		ApplyDamage(damageTable)

		local arena_walls = Entities:FindAllByClassnameWithin( "npc_dota_companion", self.parent:GetOrigin(), 160 )
		for _,arena_wall in pairs(arena_walls) do
			if arena_wall:HasModifier( "modifier_mars_arena_of_blood_custom_blocker" ) and arena_wall.model then
				arena_wall:FadeGesture( ACT_DOTA_ATTACK )
				arena_wall:StartGesture( ACT_DOTA_ATTACK )
				break
			end
		end

		self:PlayEffects( direction:Normalized() )

		if self:GetParent():HasModifier( "modifier_mars_spear_custom" ) then return end
		if self:GetParent():HasModifier( "modifier_mars_spear_custom_debuff" ) then return end
		self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_mars_spear_custom_debuff_knockback", { duration = self.knockback_duration, distance = self.width, height = 5, direction_x = direction.x, direction_y = direction.y } )
	end
end


function modifier_mars_arena_of_blood_custom_spear_aura:OnIntervalThink()
if not IsServer() then return end

if not self.owner then 
	self:GetParent():InterruptMotionControllers(true)
end

end

function modifier_mars_arena_of_blood_custom_spear_aura:IsAura()
	return self.owner
end

function modifier_mars_arena_of_blood_custom_spear_aura:GetModifierAura()
	return "modifier_mars_arena_of_blood_custom_spear_aura"
end

function modifier_mars_arena_of_blood_custom_spear_aura:GetAuraRadius()
	return self.radius
end

function modifier_mars_arena_of_blood_custom_spear_aura:GetAuraDuration()
	return self.duration
end

function modifier_mars_arena_of_blood_custom_spear_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_mars_arena_of_blood_custom_spear_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_mars_arena_of_blood_custom_spear_aura:GetAuraSearchFlags()
	return 0
end
function modifier_mars_arena_of_blood_custom_spear_aura:GetAuraEntityReject( unit )
	if not IsServer() then return end
	if unit:HasFlyMovementCapability() then return true end
	if unit:IsCurrentlyVerticalMotionControlled() then return true end
	if unit:FindModifierByNameAndCaster( "modifier_mars_arena_of_blood_custom_spear_aura", self:GetCaster() ) then
		return true
	end
	local distance = (unit:GetOrigin()-self.aura_origin):Length2D()
	if (distance-self.spear_radius)<0 then
		return true
	end
	return false
end

function modifier_mars_arena_of_blood_custom_spear_aura:PlayEffects( direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_arena_of_blood_spear.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Mars.Phalanx.Attack", self:GetCaster() )
	self:GetParent():EmitSound("Hero_Mars.Phalanx.Target")
end

modifier_mars_arena_of_blood_custom_wall_aura = class({})

function modifier_mars_arena_of_blood_custom_wall_aura:IsHidden()
	return true
end

function modifier_mars_arena_of_blood_custom_wall_aura:IsDebuff()
	return true
end

function modifier_mars_arena_of_blood_custom_wall_aura:IsPurgable()
	return false
end

function modifier_mars_arena_of_blood_custom_wall_aura:OnCreated( kv )
	if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.width = self:GetAbility():GetSpecialValueFor( "width" )
	self.parent = self:GetParent()
	self.twice_width = self.width*2
	self.aura_radius = self.radius + self.twice_width
	self.MAX_SPEED = 550
	self.MIN_SPEED = 1
	self.owner = kv.isProvidedByAura~=1
	if not self.owner then
		self.aura_origin = Vector( kv.aura_origin_x, kv.aura_origin_y, 0 )
	else
		self.aura_origin = self:GetParent():GetOrigin()
	end
end

function modifier_mars_arena_of_blood_custom_wall_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}
	return funcs
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetModifierMoveSpeed_Limit( params )
	if not IsServer() then return end
	if self.owner then return 0 end

	local parent_vector = self.parent:GetOrigin()-self.aura_origin
	local parent_direction = parent_vector:Normalized()

	local actual_distance = parent_vector:Length2D()
	local wall_distance = actual_distance-self.radius
	local isInside = (wall_distance)<0
	wall_distance = math.min( math.abs( wall_distance ), self.twice_width )
	wall_distance = math.max( wall_distance, self.width ) - self.width

	local parent_angle = 0
	if isInside then
		parent_angle = VectorToAngles(parent_direction).y
	else
		parent_angle = VectorToAngles(-parent_direction).y
	end
	local unit_angle = self:GetParent():GetAnglesAsVector().y
	local wall_angle = math.abs( AngleDiff( parent_angle, unit_angle ) )

	local limit = 0
	if wall_angle>90 then
		limit = 0
	else
		limit = self:Interpolate( wall_distance/self.width, self.MIN_SPEED, self.MAX_SPEED )
	end

	return limit
end

function modifier_mars_arena_of_blood_custom_wall_aura:Interpolate( value, min, max )
	return value*(max-min) + min
end

function modifier_mars_arena_of_blood_custom_wall_aura:IsAura()
	return self.owner
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetModifierAura()
	return "modifier_mars_arena_of_blood_custom_wall_aura"
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetAuraDuration()
	return 0.3
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetAuraSearchFlags()
	return 0
end

function modifier_mars_arena_of_blood_custom_wall_aura:GetAuraEntityReject( unit )
	if not IsServer() then return end
	return false
end


modifier_mars_arena_of_blood_custom_tracker = class({})
function modifier_mars_arena_of_blood_custom_tracker:IsHidden() return true end
function modifier_mars_arena_of_blood_custom_tracker:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end



function modifier_mars_arena_of_blood_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if self:GetParent() ~= params.attacker then return end

if self:GetParent():HasModifier("modifier_mars_arena_4") and params.inflictor == nil and not params.unit:IsBuilding() then 

	local chance = self:GetAbility().soldier_chance
	if RollPseudoRandomPercentage(chance,124,self:GetParent()) then

		local point = params.unit:GetAbsOrigin() + RandomVector(150)
		self:GetAbility():CreateSoldier(point, self:GetAbility().soldier_duration)
	end

end


if not self:GetParent():HasModifier("modifier_mars_arena_2") then return end
if not params.inflictor then return end
if not self:GetParent():IsAlive() then return end
if params.inflictor ~= self:GetAbility() then return end
if self:GetParent():HasModifier("modifier_mars_arena_of_blood_custom_no_damage") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_mars_arena_of_blood_custom_no_damage", {})

local damage = self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_mars_arena_2")]*self:GetCaster():GetAverageTrueAttackDamage(nil)

local damageTable = {victim = params.unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), }
ApplyDamage(damageTable)

self:GetParent():RemoveModifierByName("modifier_mars_arena_of_blood_custom_no_damage")

SendOverheadEventMessage(params.unit, 4, params.unit, damage, nil)
end


modifier_mars_arena_of_blood_custom_legendary = class({})
function modifier_mars_arena_of_blood_custom_legendary:IsHidden() return true end
function modifier_mars_arena_of_blood_custom_legendary:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.thinker = EntIndexToHScript(table.thinker)
self:StartIntervalThink(FrameTime())
end

function modifier_mars_arena_of_blood_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():IsOutOfGame() then return end
if self:GetParent():IsInvulnerable() then return end

if not self.thinker or self.thinker:IsNull() then 
	self:Destroy()
	return
end

local abs = self.thinker:GetAbsOrigin()
local dir = self:GetParent():GetAbsOrigin() - abs
local length = dir:Length2D()

dir.z = 0
dir = dir:Normalized()


if length >= self.radius then 
	local point = abs + dir*self.radius*0.7
	self:GetParent():SetOrigin(point)
	FindClearSpaceForUnit(self:GetParent(), point, false)
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.2})
end

end


function modifier_mars_arena_of_blood_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end


function modifier_mars_arena_of_blood_custom_legendary:OnDeath(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if self:GetParent():IsReincarnating() then return end
if not self:GetCaster():IsAlive() then return end
local attacker = params.attacker
if not attacker then return end

if attacker.owner then 
	attacker = attacker.owner
end

if self:GetCaster() ~= attacker then return end

local duel_victory_particle = ParticleManager:CreateParticle("particles/mars_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
self:GetCaster():EmitSound("Hero_LegionCommander.Duel.Victory")

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_arena_of_blood_custom_legendary_damage", {})
end



modifier_mars_arena_of_blood_custom_legendary_damage = class({})
function modifier_mars_arena_of_blood_custom_legendary_damage:IsHidden() return false end
function modifier_mars_arena_of_blood_custom_legendary_damage:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_legendary_damage:RemoveOnDeath() return false end
function modifier_mars_arena_of_blood_custom_legendary_damage:GetTexture() return "buffs/arena_damage" end

function modifier_mars_arena_of_blood_custom_legendary_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_mars_arena_of_blood_custom_legendary_damage:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_mars_arena_of_blood_custom_legendary_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2,
}
end

function modifier_mars_arena_of_blood_custom_legendary_damage:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()*self:GetAbility().legendary_damage
end



function modifier_mars_arena_of_blood_custom_legendary_damage:GetModifierBaseAttackTimeConstant()
if self:GetStackCount() < self:GetAbility().legendary_bva_stack then return end
return self:GetAbility().legendary_bva
end


function modifier_mars_arena_of_blood_custom_legendary_damage:OnTooltip()
return self:GetStackCount()
end
function modifier_mars_arena_of_blood_custom_legendary_damage:OnTooltip2()
return self:GetAbility().legendary_bva_stack
end


modifier_mars_arena_of_blood_custom_attack_speed = class({})
function modifier_mars_arena_of_blood_custom_attack_speed:IsHidden() return false end
function modifier_mars_arena_of_blood_custom_attack_speed:IsPurgable() return false end
function modifier_mars_arena_of_blood_custom_attack_speed:GetTexture() return "buffs/arena_speed" end
function modifier_mars_arena_of_blood_custom_attack_speed:OnCreated(table)
self.speed = self:GetAbility().cast_speed[self:GetCaster():GetUpgradeStack('modifier_mars_arena_4')] 
self.range = self:GetAbility().cast_range

end

function modifier_mars_arena_of_blood_custom_attack_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_mars_arena_of_blood_custom_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self.speed
end

function modifier_mars_arena_of_blood_custom_attack_speed:GetModifierAttackRangeBonus()
return self.range
end

function modifier_mars_arena_of_blood_custom_attack_speed:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
local enemy = params.target

if enemy:HasModifier("modifier_mars_spear_custom_debuff") then return end
      
local dir = (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()

enemy:AddNewModifier(self:GetParent(), self:GetAbility(),
          "modifier_generic_knockback",
          {
            duration = 0.2,
            distance = 200,
            height = 0,
            direction_x = dir.x,
            direction_y = dir.y,
          }
        )

end


modifier_mars_arena_of_blood_custom_soldier = class({})
function modifier_mars_arena_of_blood_custom_soldier:IsHidden() return false end
function modifier_mars_arena_of_blood_custom_soldier:IsPurgable() return false end

function modifier_mars_arena_of_blood_custom_soldier:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end


function modifier_mars_arena_of_blood_custom_soldier:OnCreated(table)
if not IsServer() then return end
self.damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility().soldier_damage[self:GetCaster():GetUpgradeStack("modifier_mars_arena_4")]
self.speed = self:GetCaster():GetDisplayAttackSpeed()*self:GetAbility().soldier_speed[self:GetCaster():GetUpgradeStack("modifier_mars_arena_4")]

self:StartIntervalThink(0.2)
end


function modifier_mars_arena_of_blood_custom_soldier:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end
self.damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility().soldier_damage[self:GetCaster():GetUpgradeStack("modifier_mars_arena_4")]
self.speed = self:GetCaster():GetDisplayAttackSpeed()*self:GetAbility().soldier_speed[self:GetCaster():GetUpgradeStack("modifier_mars_arena_4")]

end

function modifier_mars_arena_of_blood_custom_soldier:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_mars_arena_of_blood_custom_soldier:GetModifierPreAttack_BonusDamage()
return self.damage
end


function modifier_mars_arena_of_blood_custom_soldier:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_mars_arena_of_blood_custom_soldier:GetModifierTotalDamageOutgoing_Percentage(params)
if params.target and params.target:IsBuilding() then 
	return -100
end

end