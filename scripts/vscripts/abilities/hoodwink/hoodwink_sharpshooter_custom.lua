LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_debuff", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_blood", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_blood_count", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_hits", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_tracker", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_HORIZONTAL )

hoodwink_sharpshooter_custom = class({})

hoodwink_sharpshooter_custom.damage_heal = {0.3, 0.45, 0.6}
hoodwink_sharpshooter_custom.damage_heal_creeps = 0.25

hoodwink_sharpshooter_custom.blood_init = 0
hoodwink_sharpshooter_custom.blood_inc = 0.1
hoodwink_sharpshooter_custom.blood_duration = 5
hoodwink_sharpshooter_custom.blood_interval = 1

hoodwink_sharpshooter_custom.triple_hit_1 = 0.33
hoodwink_sharpshooter_custom.triple_hit_2 = 0.66
hoodwink_sharpshooter_custom.triple_hit_1_damage = {0.15, 0.25}
hoodwink_sharpshooter_custom.triple_hit_2_damage = {0.30, 0.50}

hoodwink_sharpshooter_custom.cast_vision = 1

hoodwink_sharpshooter_custom.legendary_damage = 30

hoodwink_sharpshooter_custom.cd = {-10, -15, -20}

hoodwink_sharpshooter_custom.healing_reduction = -50

hoodwink_sharpshooter_custom.max_time = 4
hoodwink_sharpshooter_custom.max_damage = 0.2 
hoodwink_sharpshooter_custom.max_cd = 0.25


function hoodwink_sharpshooter_custom:GetIntrinsicModifierName()
return "modifier_hoodwink_sharpshooter_custom_tracker"
end


function hoodwink_sharpshooter_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_2") then
	bonus = self.cd[self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_2")]
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end




function hoodwink_sharpshooter_custom:OnSpellStart()
	local point = self:GetCursorPosition()

	--if point.x == self:GetCaster():GetAbsOrigin().x and point.y == self:GetCaster():GetAbsOrigin().y then 
		--point = self:GetCaster():GetAbsOrigin() + 100*self:GetCaster():GetForwardVector()
	--end

	local duration = self:GetSpecialValueFor( "misfire_time" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom", { duration = duration, x = point.x, y = point.y, } )
end

function hoodwink_sharpshooter_custom:OnProjectileThink_ExtraData( location, ExtraData )
	local sound = EntIndexToHScript( ExtraData.sound )
	if not sound or sound:IsNull() then return end
	sound:SetOrigin( location )
end

function hoodwink_sharpshooter_custom:OnProjectileHit_ExtraData( target, location, ExtraData )
	local sound = EntIndexToHScript( ExtraData.sound )

	local reduce_cd = false
	if sound and sound.hit_hero == false then 
		reduce_cd = true
	end

	if false then 
		if not sound or sound:IsNull() then return end
		sound:StopSound("Hero_Hoodwink.Sharpshooter.Projectile")
		UTIL_Remove( sound )
	end


	if not target then 
		return false 
	end

	local k = 1
	local creep = false

	if target:IsCreep() then 
		k = self:GetSpecialValueFor("creeps")/100
	end



	local damageTable = { victim = target, attacker = self:GetCaster(), damage = ExtraData.damage*k, damage_type = self:GetAbilityDamageType(), ability = self, damage_flags = DOTA_DAMAGE_FLAG_NONE }
	ApplyDamage(damageTable)


	if target:IsRealHero() then 
		sound.hit_hero = true
	end

	if ExtraData.pct >= 1 and target:IsRealHero() and ExtraData.isIllusion == 0 and self:GetCaster():GetQuest() == "Hoodwink.Quest_8" then 
		self:GetCaster():UpdateQuest(1)
	end

	if ExtraData.pct >= 1 and target:IsRealHero() and ExtraData.isIllusion == 0 and self:GetCaster():HasModifier("modifier_hoodwink_sharp_legendary") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_hits", {})
	end

	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_3") and not target:IsBuilding() then 

		local damage = (self.blood_init + self.blood_inc*self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_3"))*ExtraData.damage*k
		target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_blood", {duration = self.blood_duration, damage = damage})
		target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_blood_count", {duration = self.blood_duration, damage = damage})


	end

	target:AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_debuff", { duration = ExtraData.duration*(1 - target:GetStatusResistance()), x = ExtraData.x, y = ExtraData.y } )
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, ExtraData.damage*k, self:GetCaster():GetPlayerOwner() )
	
	

	AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetOrigin(), 300, 4, false)

	local direction = Vector( ExtraData.x, ExtraData.y, 0 ):Normalized()

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_Hoodwink.Sharpshooter.Target")
	return creep
end



hoodwink_sharpshooter_release_custom = class({})

function hoodwink_sharpshooter_release_custom:OnSpellStart()
	local mod = self:GetCaster():FindModifierByName( "modifier_hoodwink_sharpshooter_custom" )
	if not mod then return end
	mod:Destroy()
end


modifier_hoodwink_sharpshooter_custom = class({})

function modifier_hoodwink_sharpshooter_custom:IsPurgable()
	return false
end





function modifier_hoodwink_sharpshooter_custom:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.team = self.parent:GetTeamNumber()
	self.charge = self:GetAbility():GetSpecialValueFor( "max_charge_time" )




	self.damage = self:GetAbility():GetSpecialValueFor( "max_damage" )

	if self:GetCaster():HasModifier("modifier_hoodwink_sharpshooter_custom_hits") then 
		self.damage = self.damage + (self:GetAbility().legendary_damage)*self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharpshooter_custom_hits")
	end

	self.duration = self:GetAbility():GetSpecialValueFor( "max_slow_debuff_duration" )
	self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )
	self.recoil_distance = self:GetAbility():GetSpecialValueFor( "recoil_distance" )
	self.recoil_duration = self:GetAbility():GetSpecialValueFor( "recoil_duration" )
	self.recoil_height = self:GetAbility():GetSpecialValueFor( "recoil_height" )


	self.interval = 0.03


	self.shot_1 = false
	self.shot_2 = false

	self:StartIntervalThink( self.interval)
	if not IsServer() then return end

	self.RemoveForDuel = true

	self.projectile_speed = self:GetAbility():GetSpecialValueFor( "arrow_speed" )



	self.projectile_range = self:GetAbility():GetSpecialValueFor( "arrow_range" )
	self.projectile_width = self:GetAbility():GetSpecialValueFor( "arrow_width" )
	local projectile_vision = self:GetAbility():GetSpecialValueFor( "arrow_vision" )
	local vec = Vector( kv.x, kv.y, 0 )
	self:SetDirection( vec )
	self.current_dir = self.target_dir
	self.face_target = true
	self.parent:SetForwardVector( self.current_dir )

	self.max_charge = false

	self.turn_speed = self.interval*self.turn_rate


	local type_target = DOTA_UNIT_TARGET_HERO
	local deleteonhit = true

	if true then 
		type_target = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		deleteonhit = false
	end


	self.info = {
		Source = self.parent,
		Ability = self:GetAbility(),
	    bDeleteOnHit = deleteonhit,
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = type_target,
	    EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf",
	    fDistance = self.projectile_range,
	    fStartRadius = self.projectile_width,
	    fEndRadius = self.projectile_width,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = true,
		bVisibleToEnemies = true,
		iVisionRadius = projectile_vision,
		iVisionTeamNumber = self.parent:GetTeamNumber(),
	}


	self.parent:SwapAbilities( "hoodwink_sharpshooter_custom", "hoodwink_sharpshooter_release_custom", false, true )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )

	EmitSoundOn("Hero_Hoodwink.Sharpshooter.Channel", self.parent)


end

function modifier_hoodwink_sharpshooter_custom:Shoot(new_pct)
if not IsServer() then return end

	local direction = self.current_dir
	local pct

	if new_pct == nil then 
		pct = math.min(1, (math.min( self:GetElapsedTime(), self.charge )/self.charge + 0.2))
 	else 
 		pct = new_pct
 	end

	local info = self.info

 	if self:GetElapsedTime() >= self:GetAbility().max_time and self:GetParent():HasModifier("modifier_hoodwink_sharp_5") then 
 		pct = 1 + self:GetAbility().max_damage
 		local cd = self:GetAbility():GetCooldownTimeRemaining()
 		info.EffectName = "particles/max_charge_hoodwink.vpcf",

 		self:GetAbility():EndCooldown()
 		self:GetAbility():StartCooldown(cd*(1 - self:GetAbility().max_cd))
 	end


	self.info.vSpawnOrigin = self.parent:GetOrigin()
	self.info.vVelocity = direction * self.projectile_speed

	local sound = CreateModifierThinker( self.parent, self, "", {}, self.parent:GetOrigin(), self.team, false )
	sound:EmitSound("Hero_Hoodwink.Sharpshooter.Projectile")
	sound.hit_hero = false


	local duration = self.duration * pct
	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
		duration = self.duration
	end

	local k = 1
	if self:GetParent() ~= self:GetCaster() then 
		k = self:GetCaster():FindAbilityByName("hoodwink_decoy_custom"):GetSpecialValueFor("sharpshooter_damage_pct") / 100
	end

	self.info.ExtraData = {isIllusion = self:GetParent():IsIllusion(), damage = self.damage * pct * k, pct = pct, duration = duration, x = direction.x, y = direction.y, sound = sound:entindex(), }




	ProjectileManager:CreateLinearProjectile( info )

end


function modifier_hoodwink_sharpshooter_custom:OnDestroy()
if not IsServer() then return end

	if self:GetParent():IsIllusion() and not self:GetParent():IsAlive() then
		StopSoundOn("Hero_Hoodwink.Sharpshooter.Channel",self.parent)
		return 
	end

	local direction = self.current_dir

	StopSoundOn("Hero_Hoodwink.Sharpshooter.Channel",self.parent)


	local illusion_modifier = self:GetParent():FindModifierByName("modifier_hoodwink_decoy_custom_illusion")
	if illusion_modifier then
		local ability = illusion_modifier:GetAbility()
		if ability then

			self:Shoot()
		end
	else
		self:Shoot()
	end

	local bump_point = self:GetCaster():GetAbsOrigin() + direction * self.recoil_distance

	local mod = self.parent:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_knockback", -- modifier name
		{
			duration = self.recoil_duration,
			knockback_height = self.recoil_height,
			knockback_distance = self.recoil_distance,
			knockback_duration = self.recoil_duration,
			center_x = bump_point.x,
			center_y = bump_point.y,
			center_z = bump_point.z,
		} -- kv
	)

	self.parent:SwapAbilities( "hoodwink_sharpshooter_release_custom", "hoodwink_sharpshooter_custom", false, true )

	if mod then
		local effect_cast = ParticleManager:CreateParticle( "particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		mod:AddParticle( effect_cast, false, false, -1, false, false )
	end

	self.parent:StopSound("Hero_Hoodwink.Sharpshooter.Cast")
	self.parent:EmitSound("Hero_Hoodwink.Sharpshooter.Cast")
	
end


function modifier_hoodwink_sharpshooter_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}

	return funcs
end


function modifier_hoodwink_sharpshooter_custom:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_6
end

function modifier_hoodwink_sharpshooter_custom:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	end
end

function modifier_hoodwink_sharpshooter_custom:IllusionScepterDirection( target )
	self:SetDirection( target:GetOrigin() )
end

function modifier_hoodwink_sharpshooter_custom:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_hoodwink_sharpshooter_custom:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

function modifier_hoodwink_sharpshooter_custom:GetModifierDisableTurning()
	return 1
end

function modifier_hoodwink_sharpshooter_custom:CheckState()
local state = {}
	state =
	{ 
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function modifier_hoodwink_sharpshooter_custom:OnIntervalThink()
	if not IsServer() then
		self:UpdateStack()
		return
	end
	self:TurnLogic()
	local startpos = self.parent:GetOrigin()
	local visions = self.projectile_range/self.projectile_width
	local delta = self.parent:GetForwardVector() * self.projectile_width


	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_legendary") and self:GetCaster() == self:GetParent() then 
		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetAbility():GetSpecialValueFor("arrow_range")*self:GetAbility().cast_vision, FrameTime(), false)
	end


 	if self:GetElapsedTime() >= self:GetAbility().max_time and self:GetParent():HasModifier("modifier_hoodwink_sharp_5") and self.max_charge == false then 

		EmitSoundOnEntityForPlayer("Hoodwink.Sharp_max", self:GetParent(), self:GetParent():GetPlayerOwnerID())
 		self.max_charge = true
 	end

	if self:GetCaster():HasModifier("modifier_hoodwink_sharp_4") then 

		if self:GetElapsedTime() >= self.charge*0.8*self:GetAbility().triple_hit_1 and self.shot_1 == false then 
			self:Shoot(self:GetAbility().triple_hit_1_damage[self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_4")])
			self.shot_1 = true 
		end


		if self:GetElapsedTime() >= self.charge*0.8*self:GetAbility().triple_hit_2 and self.shot_2 == false then 
			self:Shoot(self:GetAbility().triple_hit_2_damage[self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharp_4")])
			self.shot_2 = true 
		end
	end

	if not self.charged and self:GetElapsedTime()>self.charge*0.8 then
		self.charged = true
		self.parent:EmitSound("Hero_Hoodwink.Sharpshooter.MaxCharge")
	end
	local remaining = self:GetRemainingTime()
	local seconds = math.ceil( remaining )
	local isHalf = (seconds-remaining)>0.5
	if isHalf then seconds = seconds-1 end
	if self.half~=isHalf then
		self.half = isHalf
		local mid = 1
		if isHalf then mid = 8 end
		local len = 2
		if seconds<1 then len = 1 if not isHalf then return end end
		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, seconds, mid ) )
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( len, 0, 0 ) )
	end
	--self:UpdateEffect()
end

function modifier_hoodwink_sharpshooter_custom:SetDirection( vec )


	if vec.x == self:GetCaster():GetAbsOrigin().x and vec.y == self:GetCaster():GetAbsOrigin().y then 
		vec = self:GetCaster():GetAbsOrigin() + 100*self:GetCaster():GetForwardVector()
	end

	self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
	self.face_target = false
end

function modifier_hoodwink_sharpshooter_custom:TurnLogic()
	if self.face_target then return end
	local current_angle = VectorToAngles( self.current_dir ).y
	local target_angle = VectorToAngles( self.target_dir ).y
	local angle_diff = AngleDiff( current_angle, target_angle )
	local sign = -1
	if angle_diff<0 then sign = 1 end
	if math.abs( angle_diff )<1.1*self.turn_speed then
		self.current_dir = self.target_dir
		self.face_target = true
	else
		self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
	end
	local a = self.parent:IsCurrentlyHorizontalMotionControlled()
	local b = self.parent:IsCurrentlyVerticalMotionControlled()
	if not (a or b) then
		self.parent:SetForwardVector( self.current_dir )
	end
end

function modifier_hoodwink_sharpshooter_custom:UpdateStack()
	
	local pct = math.min(1, (math.min( self:GetElapsedTime(), self.charge )/self.charge + 0.2))
	pct = math.floor( pct*100 )
	self:SetStackCount( pct )
end

function modifier_hoodwink_sharpshooter_custom:OrderFilter( data )
	if #data.units>1 then return true end
	local unit
	for _,id in pairs(data.units) do
		unit = EntIndexToHScript( id )
	end
	if unit~=self.parent then return true end
	if data.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	elseif data.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or data.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET then
		local pos = EntIndexToHScript( data.entindex_target ):GetOrigin()
		data.order_type = DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
		data.position_x = pos.x
		data.position_y = pos.y
		data.position_z = pos.z
	end
	return true
end

function modifier_hoodwink_sharpshooter_custom:UpdateEffect()
	local startpos = self.parent:GetAbsOrigin()
	local endpos = startpos + self.current_dir * self.projectile_range
	ParticleManager:SetParticleControl( self.effect_cast, 0, startpos )
	ParticleManager:SetParticleControl( self.effect_cast, 1, endpos )
end

modifier_hoodwink_sharpshooter_custom_debuff = class({})

function modifier_hoodwink_sharpshooter_custom_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_sharpshooter_custom_debuff:OnCreated( kv )
	self.parent = self:GetParent()
	self.slow = -self:GetAbility():GetSpecialValueFor( "slow_move_pct" )
	if not IsServer() then return end
	local direction = Vector( kv.x, kv.y, 0 ):Normalized()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff.vpcf", PATTACH_POINT_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	self:AddParticle( effect_cast, false, false, -1, false, false )
end

function modifier_hoodwink_sharpshooter_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
	}

	return funcs
end


function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
local k = 0
if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
  k = self:GetAbility().healing_reduction
end 
    return k
end

function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
local k = 0
if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
  k = self:GetAbility().healing_reduction
end 
    return k
end

function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
local k = 0
if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then 
  k = self:GetAbility().healing_reduction
end 
    return k
end



function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_hoodwink_sharpshooter_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end





modifier_hoodwink_sharpshooter_custom_blood = class({})
function modifier_hoodwink_sharpshooter_custom_blood:IsHidden() return true end
function modifier_hoodwink_sharpshooter_custom_blood:IsPurgable() return true end
function modifier_hoodwink_sharpshooter_custom_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_hoodwink_sharpshooter_custom_blood:OnCreated(table)
if not IsServer() then return end

self.damage = table.damage
self.tick = self.damage/self:GetRemainingTime()
self.tick = self.tick*self:GetAbility().blood_interval

self:StartIntervalThink(self:GetAbility().blood_interval)
end


function modifier_hoodwink_sharpshooter_custom_blood:OnIntervalThink()
if not IsServer() then return end


local damageTable = 
{
  victim      = self:GetParent(),
  damage      = self.tick,
  damage_type   = DAMAGE_TYPE_MAGICAL,
  damage_flags  = DOTA_DAMAGE_FLAG_NONE,
  attacker    = self:GetCaster(),
  ability     = self:GetAbility()
}
                  
ApplyDamage(damageTable)
      
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.tick, nil)


end


function modifier_hoodwink_sharpshooter_custom_blood:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_hoodwink_sharpshooter_custom_blood_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end

modifier_hoodwink_sharpshooter_custom_blood_count = class({})
function modifier_hoodwink_sharpshooter_custom_blood_count:IsHidden() return false end
function modifier_hoodwink_sharpshooter_custom_blood_count:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_blood_count:GetTexture() return "buffs/sharp_blood" end
function modifier_hoodwink_sharpshooter_custom_blood_count:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end
function modifier_hoodwink_sharpshooter_custom_blood_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_hoodwink_sharpshooter_custom_blood_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


modifier_hoodwink_sharpshooter_custom_hits = class({})
function modifier_hoodwink_sharpshooter_custom_hits:IsHidden() return false end
function modifier_hoodwink_sharpshooter_custom_hits:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_hits:RemoveOnDeath() return false end
function modifier_hoodwink_sharpshooter_custom_hits:GetTexture() return "buffs/sharp_hits" end
function modifier_hoodwink_sharpshooter_custom_hits:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end
function modifier_hoodwink_sharpshooter_custom_hits:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()

end

function modifier_hoodwink_sharpshooter_custom_hits:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}

end
function modifier_hoodwink_sharpshooter_custom_hits:OnTooltip()
return self:GetStackCount()
end

function modifier_hoodwink_sharpshooter_custom_hits:OnTooltip2()
	return self:GetStackCount()*(self:GetAbility().legendary_damage)
end





modifier_hoodwink_sharpshooter_custom_tracker = class({})
function modifier_hoodwink_sharpshooter_custom_tracker:IsHidden() return true end
function modifier_hoodwink_sharpshooter_custom_tracker:IsPurgable() return false end




function modifier_hoodwink_sharpshooter_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_hoodwink_sharpshooter_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker ~= self:GetParent() then return end


if self:GetParent():HasModifier("modifier_hoodwink_sharp_1") and params.inflictor and params.inflictor == self:GetAbility() then 

  local k = 1
  if params.unit:IsCreep() then 
    k = self:GetAbility().damage_heal_creeps
  end

  local heal = params.damage*self:GetAbility().damage_heal[self:GetParent():GetUpgradeStack("modifier_hoodwink_sharp_1")]*k


  self:GetCaster():Heal(heal, self:GetAbility())

  SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

  local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:ReleaseParticleIndex( particle )
end
end