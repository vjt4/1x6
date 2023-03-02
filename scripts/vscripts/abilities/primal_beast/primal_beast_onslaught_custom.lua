LinkLuaModifier( "modifier_primal_beast_onslaught_custom_cast", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_primal_beast_onslaught_legendary", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_tracker", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_speed", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_knockback", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_slow", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_armor", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_vision", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_mark", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_thinker", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )


primal_beast_onslaught_custom = class({})

primal_beast_onslaught_custom.cd = {-2,-3,-4}

primal_beast_onslaught_custom.damage = {0.6, 0.9, 1.2}

primal_beast_onslaught_custom.legendary_charge = 1
primal_beast_onslaught_custom.legendary_damage = 1
primal_beast_onslaught_custom.legendary_cd = 0.25

primal_beast_onslaught_custom.target_duration = 2
primal_beast_onslaught_custom.target_health = 50
primal_beast_onslaught_custom.target_radius = 2000

primal_beast_onslaught_custom.speed_duration = 3
primal_beast_onslaught_custom.speed_move = {20, 30, 40}

primal_beast_onslaught_custom.knockback_duration = 0.4
primal_beast_onslaught_custom.knockback_distance = 100
primal_beast_onslaught_custom.knockback_range = 400
primal_beast_onslaught_custom.knockback_slow = -80
primal_beast_onslaught_custom.knockback_slow_duration = 2

primal_beast_onslaught_custom.armor_reduction = -0.1
primal_beast_onslaught_custom.armor_duration = 5
primal_beast_onslaught_custom.armor_charge = 0.5

primal_beast_onslaught_custom.finish_radius = 400
primal_beast_onslaught_custom.finish_damage = {1, 1.6}
primal_beast_onslaught_custom.finish_delay = 4
primal_beast_onslaught_custom.finish_interval = 1

function primal_beast_onslaught_custom:GetIntrinsicModifierName()
return "modifier_primal_beast_onslaught_custom_tracker"
end



function primal_beast_onslaught_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_1") then 
  upgrade_cooldown = self.cd[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_1")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function primal_beast_onslaught_custom:OnSpellStart()
if not IsServer() then return end

local duration = self:GetSpecialValueFor( "chargeup_time" )
if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_7") then 
	duration = duration + self.legendary_charge
end


local point = self:GetCursorPosition()


self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_onslaught_custom_cast", { duration = duration } )



local release_ability = self:GetCaster():FindAbilityByName( "primal_beast_onslaught_release_custom" )

if release_ability then
	release_ability:UseResources( false, false, true )
end

self:GetCaster():SwapAbilities( "primal_beast_onslaught_custom", "primal_beast_onslaught_release_custom", false, true )


if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_5") then 

	local nFXIndex = ParticleManager:CreateParticle( "particles/primal_knockback.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.knockback_range, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	self:GetCaster():EmitSound("PBeast.Onslaught_knock_caster")

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.knockback_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do 

	  enemy:EmitSound("PBeast.Onslaught_knock")
	  enemy:AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_onslaught_custom_knockback", {duration = self.knockback_duration, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
	end
end


end

function primal_beast_onslaught_custom:OnChargeFinish( interrupt, target )
	if not IsServer() then return end

	self:GetCaster():SwapAbilities( "primal_beast_onslaught_release_custom", "primal_beast_onslaught_custom", false, true )

	local max_duration = self:GetSpecialValueFor( "chargeup_time" ) 
	local base_duration = max_duration

	if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_7") then 
		max_duration = max_duration + self.legendary_charge
	end

	local max_distance = self:GetSpecialValueFor( "max_distance" ) * (max_duration/base_duration)


	local speed = self:GetSpecialValueFor( "charge_speed" )
	local charge_duration = max_duration

	local charge_target = target 

	local mod = self:GetCaster():FindModifierByName( "modifier_primal_beast_onslaught_custom_cast" )
	if mod then
		if mod.effect_cast then
			ParticleManager:DestroyParticle(mod.effect_cast, true)
		end

		if mod.target then 
			charge_target = mod.target
		end 

		charge_duration = mod:GetElapsedTime()
		mod.charge_finish = true
		mod:Destroy()
	end

	local k = charge_duration / max_duration

	local charge = math.floor(charge_duration/self.armor_charge)

	if k == 1 then 
		local ult = self:GetCaster():FindAbilityByName("primal_beast_pulverize_custom")
		if ult and self:GetCaster():HasModifier("modifier_primal_beast_pulverize_7") then 
			ult:AddLegendaryStack()
		end 
	end


	local damage_amp = 1
	if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_7") then 

		if k == 1 then 
			local cd = self:GetCooldownTimeRemaining()
			self:EndCooldown()
			self:StartCooldown(cd - cd*self.legendary_cd)
		end

	--	k = 1
		damage_amp = damage_amp + self.legendary_damage*(charge_duration / max_duration)
	end

	local distance = max_distance * k

	local duration = distance / speed

	if interrupt then return end

 
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_onslaught_custom", {charge = charge, damage = damage_amp, duration = duration } )
	

	self:GetCaster():EmitSound("Hero_PrimalBeast.Onslaught")
end















-- Абилка внезапного побега

primal_beast_onslaught_release_custom = class({})

function primal_beast_onslaught_release_custom:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("primal_beast_onslaught_custom")
	if ability then
		ability:OnChargeFinish( false )
	end
end











modifier_primal_beast_onslaught_custom_cast = class({})

function modifier_primal_beast_onslaught_custom_cast:IsPurgable()
	return false
end

function modifier_primal_beast_onslaught_custom_cast:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "chargeup_time" ) 

	if not IsServer() then return end
	self.anim_return = 0
	self.origin = self:GetParent():GetOrigin()
	self.charge_finish = false
	self.target_angle = self:GetParent():GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true

	self.time = self:GetAbility():GetSpecialValueFor("max_distance") / self:GetAbility():GetSpecialValueFor( "charge_speed" ) 


	if kv.target then 
		self.target = EntIndexToHScript(kv.target)

		self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_mark", {})
	end

	self:StartIntervalThink( FrameTime() )
	
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_primal_beast_onslaught_custom_cast:OnRemoved()
if not IsServer() then return end

	
	if self.target then 
		self.target:RemoveModifierByName("modifier_primal_beast_onslaught_custom_mark")
	end

	self:GetParent():EmitSound("Hero_PrimalBeast.Onslaught.Channel")
	self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	if not self.charge_finish then
		self:GetAbility():OnChargeFinish( false, self.target )
	end

end

function modifier_primal_beast_onslaught_custom_cast:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_primal_beast_onslaught_custom_cast:OnOrder( params )
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
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:GetAbility():OnChargeFinish( false, self.target )
	end	
end

function modifier_primal_beast_onslaught_custom_cast:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_primal_beast_onslaught_custom_cast:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_primal_beast_onslaught_custom_cast:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	if self.target then 
		state = 
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		}
	end

	return state
end

function modifier_primal_beast_onslaught_custom_cast:OnIntervalThink()
	if IsServer() then
		self.anim_return = self.anim_return + FrameTime()
		if self.anim_return >= 1 then
			self.anim_return = 0
			self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
		end
	end



	if self.target and self.target:IsAlive() then 
		self:SetDirection(self.target:GetAbsOrigin())
	end

	if self:GetParent():IsRooted() or self:GetParent():IsStunned() or self:GetParent():IsSilenced() or
		self:GetParent():IsCurrentlyHorizontalMotionControlled() or self:GetParent():IsCurrentlyVerticalMotionControlled()
	then
		self:GetAbility():OnChargeFinish( true, self.target )
	end
	self:TurnLogic( FrameTime() )
	self:SetEffects()
end

function modifier_primal_beast_onslaught_custom_cast:TurnLogic( dt )
	if self.face_target then return end
	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		self.current_angle = self.target_angle
		self.face_target = true
	else
		self.current_angle = self.current_angle + sign*turn_speed
	end

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_primal_beast_onslaught_custom_cast:PlayEffects1()
	self.effect_cast = ParticleManager:CreateParticleForPlayer( "particles/beast_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	self:AddParticle( self.effect_cast, false, false, -1, false, false )
	self:SetEffects()
end

function modifier_primal_beast_onslaught_custom_cast:SetEffects()
	local time = self:GetElapsedTime()
	if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_7") then 
		--time = self:GetAbility():GetSpecialValueFor( "chargeup_time" ) 
	end
	local k =  time/self.max_time

	local speed_time = k*self.time
	local target_pos = self.origin + self:GetParent():GetForwardVector() * self.speed * speed_time


	ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_primal_beast_onslaught_custom_cast:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )
	self:GetParent():EmitSound("Hero_PrimalBeast.Onslaught.Channel")
end



























modifier_primal_beast_onslaught_custom = class({})

function modifier_primal_beast_onslaught_custom:IsPurgable()
	return false
end


function modifier_primal_beast_onslaught_custom:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end


function modifier_primal_beast_onslaught_custom:OnCreated( kv )
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )
	self.radius = self:GetAbility():GetSpecialValueFor( "knockback_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.stun = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	local damage = self:GetAbility():GetSpecialValueFor( "knockback_damage" )

	if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_2") then 
		damage = damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility().damage[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_2")]
	end




	self.tree_radius = 100
	self.height = 50
	self.duration = 0.3

	if not IsServer() then return end

	self.charge = kv.charge

	self.armor_stack = kv.charge

	damage = damage*kv.damage

	self.damage = damage

	self.target_angle = self:GetParent():GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true
	self.knockback_units = {}
	self.knockback_units[self:GetParent()] = true

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
		return
	end

	self.distance_pass = 0

	self.damageTable = { attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() }
end




function modifier_primal_beast_onslaught_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

	}

	return funcs
end

function modifier_primal_beast_onslaught_custom:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetDirection( params.new_pos )
	elseif
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetDirection( params.target:GetOrigin() )
	elseif
		params.order_type==DOTA_UNIT_ORDER_STOP or 
		params.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
		params.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_primal_beast_onslaught_custom:GetModifierDisableTurning()
	return 1
end

function modifier_primal_beast_onslaught_custom:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_primal_beast_onslaught_custom:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_primal_beast_onslaught_custom:GetActivityTranslationModifiers()
	return "onslaught_movement"
end


function modifier_primal_beast_onslaught_custom:TurnLogic( dt )
	if self.face_target then return end
	local angle_diff = AngleDiff( self.current_angle, self.target_angle )
	local turn_speed = self.turn_speed*dt

	local sign = -1
	if angle_diff<0 then sign = 1 end

	if math.abs( angle_diff )<1.1*turn_speed then
		self.current_angle = self.target_angle
		self.face_target = true
	else
		self.current_angle = self.current_angle + sign*turn_speed
	end

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_primal_beast_onslaught_custom:HitLogic()
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree_radius, false )
	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

	if #units > 0 and #self.knockback_units == 0 then 

	
	end

	for _,unit in pairs(units) do
		if not self.knockback_units[unit] then
			self.knockback_units[unit] = true


			local enemy = unit


			if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_6") then 
				local mod = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_armor", {duration = self:GetAbility().armor_duration})
				if mod then 
					mod:SetStackCount(self.armor_stack)
				end
			end

			self.damageTable.victim = enemy

			if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Beast.Quest_5" and self.charge/2 >= self:GetCaster().quest.number then 
				self:GetCaster():UpdateQuest(1)
			end

			ApplyDamage(self.damageTable)


			enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self.stun } )
		

			if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
				local direction = unit:GetOrigin()-self:GetParent():GetOrigin()
				direction.z = 0
				direction = direction:Normalized()

		        local knockbackProperties =
		        {
		            center_x = unit:GetOrigin().x,
		            center_y = unit:GetOrigin().y,
		            center_z = unit:GetOrigin().z,
		            duration = self.duration,
		            knockback_duration = self.duration,
		            knockback_distance = self.distance,
		            knockback_height = self.height
		        }
		        unit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )
			end

			self:PlayEffects( unit, self.radius )
		end
	end
end

function modifier_primal_beast_onslaught_custom:UpdateHorizontalMotion( me, dt )
	if self:GetParent():IsRooted() then
		return
	end

	self:HitLogic()
	self:TurnLogic( dt )
	local nextpos = me:GetOrigin() + me:GetForwardVector() * self.speed * dt
	me:SetOrigin(nextpos)

end

function modifier_primal_beast_onslaught_custom:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_onslaught_custom:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_primal_beast_onslaught_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_primal_beast_onslaught_custom:PlayEffects( target, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_PrimalBeast.Onslaught.Hit")
end



function modifier_primal_beast_onslaught_custom:OnDestroy()
if not IsServer() then return end

self:GetParent():RemoveHorizontalMotionController(self)
FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetOrigin(), false )

if self:GetParent():HasModifier("modifier_primal_beast_onslaught_4") then 

	 CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_thinker", {duration = self:GetAbility().finish_delay}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
     

end


if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_speed", {duration = self:GetAbility().speed_duration})
end

end



modifier_primal_beast_onslaught_custom_thinker = class({})

function modifier_primal_beast_onslaught_custom_thinker:IsHidden() return true end

function modifier_primal_beast_onslaught_custom_thinker:IsPurgable() return false end

function modifier_primal_beast_onslaught_custom_thinker:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(self:GetAbility().finish_interval)

end





function modifier_primal_beast_onslaught_custom_thinker:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end

local radius = self:GetAbility().finish_radius
local damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility().finish_damage[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_4")]

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
ParticleManager:DestroyParticle( effect_cast, false )
ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_PrimalBeast.Pulverize.Impact", self:GetCaster() )

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, }

for _,enemy in pairs(enemies) do 
	damageTable.victim = enemy
	ApplyDamage(damageTable)
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil )
end

  
end





modifier_primal_beast_onslaught_custom_speed = class({})
function modifier_primal_beast_onslaught_custom_speed:IsHidden() return false end
function modifier_primal_beast_onslaught_custom_speed:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_speed:GetTexture() return "buffs/onslaught_speed" end
function modifier_primal_beast_onslaught_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_primal_beast_onslaught_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_3")]
end

function modifier_primal_beast_onslaught_custom_speed:GetEffectName()
return "particles/beast_haste.vpcf"
end





modifier_primal_beast_onslaught_custom_knockback = class({})

function modifier_primal_beast_onslaught_custom_knockback:IsHidden() return true end

function modifier_primal_beast_onslaught_custom_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  self.knockback_distance   = math.max((self.ability.knockback_distance + self.ability.knockback_range)  - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(),  self:GetAbility().knockback_distance)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_primal_beast_onslaught_custom_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_primal_beast_onslaught_custom_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_primal_beast_onslaught_custom_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_primal_beast_onslaught_custom_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_slow", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().knockback_slow_duration})
end





modifier_primal_beast_onslaught_custom_slow = class({})
function modifier_primal_beast_onslaught_custom_slow:IsHidden() return false end
function modifier_primal_beast_onslaught_custom_slow:IsPurgable() return true end
function modifier_primal_beast_onslaught_custom_slow:GetTexture() return "buffs/onslaught_slow" end
function modifier_primal_beast_onslaught_custom_slow:GetEffectName()
 return "particles/lina_attack_slow.vpcf" end



function modifier_primal_beast_onslaught_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_primal_beast_onslaught_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().knockback_slow
end


modifier_primal_beast_onslaught_custom_armor = class({})
function modifier_primal_beast_onslaught_custom_armor:IsHidden() return false end
function modifier_primal_beast_onslaught_custom_armor:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_armor:GetTexture() return "buffs/moment_armor" end
function modifier_primal_beast_onslaught_custom_armor:OnCreated(table)
self.armor = self:GetParent():GetPhysicalArmorValue(false)*self:GetAbility().armor_reduction
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_primal_beast_onslaught_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_primal_beast_onslaught_custom_armor:GetModifierPhysicalArmorBonus()
if self.armor then 
	return self:GetStackCount()*self.armor
end

end


function modifier_primal_beast_onslaught_custom_armor:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetAbility().armor_reduction*100
end



modifier_primal_beast_onslaught_custom_mark = class({})


function modifier_primal_beast_onslaught_custom_mark:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_primal_beast_onslaught_custom_mark:IsHidden() return true end
function modifier_primal_beast_onslaught_custom_mark:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_mark:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_primal_beast_onslaught_custom_mark:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end




































































 modifier_primal_beast_onslaught_legendary = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_primal_beast_onslaught_legendary:IsHidden()
	return false
end

function modifier_primal_beast_onslaught_legendary:IsDebuff()
	return false
end

function modifier_primal_beast_onslaught_legendary:IsPurgable()
	return false
end

function modifier_primal_beast_onslaught_legendary:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_primal_beast_onslaught_legendary:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_primal_beast_onslaught_legendary:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_primal_beast_onslaught_legendary:GetActivityTranslationModifiers()
	return "onslaught_movement"
end





--------------------------------------------------------------------------------
-- Initializations
function modifier_primal_beast_onslaught_legendary:OnCreated( kv )
	self.parent = self:GetParent()


	if not IsServer() then return end
	self.armor_stack = kv.charge

	self.target = EntIndexToHScript( kv.target )
	self.direction = self:GetParent():GetForwardVector()
	self.targets = {}

	self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_mark", {})

	self.bonus_ms = self:GetAbility():GetSpecialValueFor( "charge_speed" )


	self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )
	self.radius = self:GetAbility():GetSpecialValueFor( "knockback_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "knockback_distance" )
	self.duration = self:GetAbility():GetSpecialValueFor( "knockback_duration" )
	self.stun = self:GetAbility():GetSpecialValueFor( "stun_duration" )
	local damage = self:GetAbility():GetSpecialValueFor( "knockback_damage" )

	if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_2") then 
		damage = damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility().damage[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_2")]
	end

	damage = damage*kv.damage

	self.dealt_damage = false
	self.tree_radius = 100
	self.height = 50
	self.duration = 0.3
	self.min_dist = 150
	self.interrupted = false
	self.radius = 200


	self.target_angle = self:GetParent():GetAnglesAsVector().y
	self.current_angle = self.target_angle
	self.face_target = true
	self.knockback_units = {}
	self.knockback_units[self:GetParent()] = true


	self.damageTable = { attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() }



	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

end

function modifier_primal_beast_onslaught_legendary:OnRefresh( kv )
	
end

function modifier_primal_beast_onslaught_legendary:OnRemoved()
end

function modifier_primal_beast_onslaught_legendary:OnDestroy()
	if not IsServer() then return end

	if self.target then 
		self.target:RemoveModifierByName("modifier_primal_beast_onslaught_custom_mark")
	end

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree_radius, true )

	self:GetParent():RemoveHorizontalMotionController( self )

	-- remove debuff
	if self.debuff and (not self.debuff:IsNull()) then
		self.debuff:Destroy()
	end


	if self.interrupted then return end
	
	-- bash
	if self.mod and (not self.mod:IsNull()) then
		self.mod:Bash( self.target, false )
	end

	self.target:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = self.duration } -- kv
	)



	if self.target:IsAlive() then

		local order = {
			UnitIndex = self.parent:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = self.target:entindex(),
		}
		ExecuteOrderFromTable( order )
	end

if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_speed", {duration = self:GetAbility().speed_duration})
end

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_primal_beast_onslaught_legendary:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end


function modifier_primal_beast_onslaught_legendary:CheckState()
return
{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
}

end


function modifier_primal_beast_onslaught_legendary:OnOrder( params )
	if params.unit~=self.parent then return end

	-- TODO: check more orders

	if
	--	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		--params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		--params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET or
		params.order_type==DOTA_UNIT_ORDER_STOP or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION or
		params.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
		params.order_type==DOTA_UNIT_ORDER_CAST_POSITION 
		--params.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
	--	params.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
	--	params.order_type==DOTA_UNIT_ORDER_CAST_TARGET_TREE or
	--	params.order_type==DOTA_UNIT_ORDER_CAST_RUNE or
	--	params.order_type==DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION
	then
		self.interrupted = true
		self:Destroy()
	end


end


--------------------------------------------------------------------------------
-- Motion Effects
function modifier_primal_beast_onslaught_legendary:UpdateHorizontalMotion( me, dt )
	-- bash logic
	self:HitLogic()

	-- cancel logic
	self:CancelLogic()

	-- get direction
	local direction = self.target:GetOrigin()-me:GetOrigin()
	local dist = direction:Length2D()
	direction.z = 0
	direction = direction:Normalized()

	-- check if near
	if dist<self.min_dist then
		self:Destroy()
		return
	end
	-- set target pos
	local pos = me:GetOrigin() + direction * self.bonus_ms * dt
	pos = GetGroundPosition( pos, me )

	me:SetOrigin( pos )
	self.direction = direction

	-- face towards
	self.parent:FaceTowards( self.target:GetOrigin() )
end

function modifier_primal_beast_onslaught_legendary:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Helper


function modifier_primal_beast_onslaught_legendary:HitLogic()
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree_radius, false )
	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )


	for _,unit in pairs(units) do
		if not self.knockback_units[unit] then
			self.knockback_units[unit] = true

			local enemy = unit
			self.damageTable.victim = enemy

			if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_6") then 
				local mod = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_armor", {duration = self:GetAbility().armor_duration})
				if mod then 
					mod:SetStackCount(self.armor_stack)
				end
			end


			ApplyDamage(self.damageTable)


			enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self.stun } )
		

			if is_enemy or not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
				local direction = unit:GetOrigin()-self:GetParent():GetOrigin()
				direction.z = 0
				direction = direction:Normalized()

		        local knockbackProperties =
		        {
		            center_x = unit:GetOrigin().x,
		            center_y = unit:GetOrigin().y,
		            center_z = unit:GetOrigin().z,
		            duration = self.duration,
		            knockback_duration = self.duration,
		            knockback_distance = self.distance,
		            knockback_height = self.height
		        }
		        unit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )
			end

			self:PlayEffects( unit, self.radius )
		end
	end
end





function modifier_primal_beast_onslaught_legendary:CancelLogic()
	-- check stun
	local check = self.parent:IsHexed() or self.parent:IsStunned() or self.parent:IsRooted()
	if check then
		self.interrupted = true
		self:Destroy()
	end

	if not self.target:IsAlive() then
		self.interrupted = true
		self:Destroy()
		return
	end
end



function modifier_primal_beast_onslaught_legendary:PlayEffects( target, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_PrimalBeast.Onslaught.Hit")
end









modifier_primal_beast_onslaught_custom_tracker = class({})
function modifier_primal_beast_onslaught_custom_tracker:IsHidden() return true end
function modifier_primal_beast_onslaught_custom_tracker:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_tracker:OnCreated(table)
if not IsServer() then return end
--self:StartIntervalThink(1)
end

function modifier_primal_beast_onslaught_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

if self:GetParent():HasModifier("modifier_primal_beast_onslaught_6") then 

	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().target_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, false )

	for _,unit in pairs(units) do 
		if unit:GetHealthPercent() <= self:GetAbility().target_health then 
			AddFOWViewer(self:GetCaster():GetTeamNumber(), unit:GetAbsOrigin(), 10, 0.2, false)
		end
	end


	self:StartIntervalThink(0.2)
end

end


