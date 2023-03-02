LinkLuaModifier( "modifier_monkey_king_tree_dance_custom_jump", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_custom", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_custom_cooldown", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_regen", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_NONE )

monkey_king_tree_dance_custom = class({})

monkey_king_tree_dance_custom.legendary_cd = -0.7

monkey_king_tree_dance_custom.damage_cooldown = -0.5
monkey_king_tree_dance_custom.damage_tree = 10
monkey_king_tree_dance_custom.damage_regen = 4
monkey_king_tree_dance_custom.damage_regen_duration = 3

function monkey_king_tree_dance_custom:GetIntrinsicModifierName()
	return "modifier_monkey_king_tree_dance_custom_cooldown"
end


function monkey_king_tree_dance_custom:GetBehavior()
  if not self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") and self:GetCaster():HasModifier("modifier_monkey_king_tree_5") then 
    return  DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_POINT
  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function monkey_king_tree_dance_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") then 
  bonus = self.legendary_cd
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end




function monkey_king_tree_dance_custom:OnSpellStart()
if not IsServer() then return end

	local tree = self:GetCursorTarget()

	if not tree then 
		tree = CreateTempTreeWithModel( self:GetCursorPosition(), self.damage_tree, "models/heroes/hoodwink/hoodwink_tree_model.vmdl" )

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
		for _,enemy in pairs(enemies) do
			if enemy:GetUnitName() ~= "npc_teleport" then 
				FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), true)
			end
		end
	end



	if not self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then 
		self.ability = self:GetCaster():FindAbilityByName("monkey_king_primal_spring_custom")
		self.ability:SetActivated(true)
	end

	local speed = self:GetSpecialValueFor( "leap_speed" ) + 200
	local perched_spot_height = 256
	local distance = (tree:GetOrigin()-self:GetCaster():GetOrigin()):Length2D()
	local duration = distance / speed

	local perch = 0

	if self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then
		perch = 1
	end

	local modifier = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_monkey_king_tree_dance_custom_jump", { target_x = tree:GetOrigin().x, target_y = tree:GetOrigin().y, distance = distance, speed = speed, height = perched_spot_height, fix_end = false, fix_height = false, isStun = true, activity = ACT_DOTA_MK_TREE_SOAR, start_offset = perched_spot_height*perch, end_offset = perched_spot_height } )
	
	if modifier then
		modifier:SetEndCallback(function()
			if tree and not tree:IsNull() then 
				self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_monkey_king_tree_dance_custom", { tree = tree:entindex() } )
			else 
				FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)
			end
		end)

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		modifier:AddParticle( particle, false, false, -1, false, false )
		self:GetCaster():EmitSound("Hero_MonkeyKing.TreeJump.Cast")
	end

	self:StartCooldown(duration + self:GetCooldown(self:GetLevel()))

end

modifier_monkey_king_tree_dance_custom_cooldown = class({})

function modifier_monkey_king_tree_dance_custom_cooldown:IsHidden() return true end
function modifier_monkey_king_tree_dance_custom_cooldown:IsPurgable() return false end
function modifier_monkey_king_tree_dance_custom_cooldown:RemoveOnDeath() return false end

function modifier_monkey_king_tree_dance_custom_cooldown:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_monkey_king_tree_dance_custom_cooldown:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.unit:HasModifier( "modifier_monkey_king_tree_dance_custom" ) then return end
	if not params.attacker then return end
	if not params.attacker:IsHero() and not params.attacker:IsBuilding() then return end

	
	local cooldown = self:GetAbility():GetSpecialValueFor("jump_damage_cooldown")
	if self:GetParent():HasModifier("modifier_monkey_king_tree_5") then 
		cooldown = cooldown + self:GetAbility().damage_cooldown
	end

	self:GetAbility():StartCooldown( cooldown )
end

modifier_monkey_king_tree_dance_custom = class({})

function modifier_monkey_king_tree_dance_custom:IsHidden()
	return true
end

function modifier_monkey_king_tree_dance_custom:IsPurgable()
	return false
end

function modifier_monkey_king_tree_dance_custom:OnCreated( kv )
	self.perched_spot_height = 256
	self.perched_day_vision = self:GetAbility():GetSpecialValueFor( "perched_day_vision" )
	self.perched_night_vision = self:GetAbility():GetSpecialValueFor( "perched_night_vision" )
	self.unperched_stunned_duration = self:GetAbility():GetSpecialValueFor( "unperched_stunned_duration" )


	if not IsServer() then return end

	self:GetParent():RemoveModifierByName("modifier_monkey_king_tree_dance_regen")
	if self:GetParent():HasModifier("modifier_monkey_king_tree_5") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_tree_dance_regen", {})
	end

	self.ability = self:GetParent():FindAbilityByName("monkey_king_primal_spring_custom")
	self.ability:SetActivated(true)

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_tree_dance_hidden", {})

	self.tree = EntIndexToHScript( kv.tree )
	self.origin = self.tree:GetOrigin()

	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	if not self:ApplyVerticalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()

	self:GetParent():EmitSound("Hero_MonkeyKing.TreeJump.Tree")
end

function modifier_monkey_king_tree_dance_custom:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_monkey_king_tree_dance_regen") then 
		self:GetParent():FindModifierByName("modifier_monkey_king_tree_dance_regen"):SetDuration(self:GetAbility().damage_regen_duration, true)
	end

	local pos = self:GetParent():GetOrigin()
	if not self:GetParent():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") and not self:GetParent():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
		self.ability:SetActivated(false)
	end
	self:GetParent():RemoveModifierByName("modifier_monkey_king_tree_dance_hidden")
	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	if not self.unperched then
		self:GetParent():SetOrigin( pos )
	end
end

function modifier_monkey_king_tree_dance_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	}

	return funcs
end




function modifier_monkey_king_tree_dance_custom:GetActivityTranslationModifiers()
    return "perch"
end

function modifier_monkey_king_tree_dance_custom:OnOrder( params )
	if params.unit ~= self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET then
		
		if not self:GetAbility():IsCooldownReady() then
			local order = {
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP,
			}
			ExecuteOrderFromTable( order )
			return
		end

		local pos = params.new_pos

		if params.target then pos = params.target:GetOrigin() end

		local direction = (pos-self:GetParent():GetOrigin())
		direction.z = 0
		direction = direction:Normalized()

		self:GetParent():SetForwardVector( direction )

		local modifier = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_monkey_king_tree_dance_custom_jump", { dir_x = direction.x, activity = ACT_DOTA_MK_STRIKE_END, dir_y = direction.y, distance = 150, speed = 550, height = 1, start_offset = self.perched_spot_height, fix_end = false, isForward = true } )
		
		local parent = self:GetParent()

		if modifier then
			modifier:SetEndCallback(function()
				FindClearSpaceForUnit( parent, parent:GetOrigin(), true )
			end)

			local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			modifier:AddParticle( particle, false, false, -1, false, false )
		end

		self:GetAbility():UseResources(false, false, true)

		self:Destroy()
	end
end

function modifier_monkey_king_tree_dance_custom:GetFixedDayVision()
	return self.perched_day_vision
end

function modifier_monkey_king_tree_dance_custom:GetFixedNightVision()
	return self.perched_night_vision
end

function modifier_monkey_king_tree_dance_custom:CheckState()
	local state = 
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true,
		--[MODIFIER_STATE_FLYING] = true,
	}
	return state
end

function modifier_monkey_king_tree_dance_custom:OnIntervalThink()
	if not IsServer() then return end
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end
		return
	end
	if self.tree:IsStanding() then return end
	local mod = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self.unperched_stunned_duration } )
	self.unperched = true
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom:UpdateHorizontalMotion( me, dt )
	me:SetOrigin( self.origin )
end

function modifier_monkey_king_tree_dance_custom:UpdateVerticalMotion( me, dt )
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end
		return
	end
	local pos = self.tree:GetOrigin()
	pos.z = pos.z + self.perched_spot_height
	me:SetOrigin( pos )
end

function modifier_monkey_king_tree_dance_custom:OnVerticalMotionInterrupted()
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom:OnHorizontalMotionInterrupted()
	self:Destroy()
end

modifier_monkey_king_tree_dance_custom_jump = class({})

function modifier_monkey_king_tree_dance_custom_jump:IsHidden()
	return true
end

function modifier_monkey_king_tree_dance_custom_jump:IsPurgable()
	return true
end

function modifier_monkey_king_tree_dance_custom_jump:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_monkey_king_tree_dance_custom_jump:OnCreated( kv )
	if not IsServer() then return end
	self.interrupted = false
	self:SetJumpParameters( kv )
	self:Jump()
end

function modifier_monkey_king_tree_dance_custom_jump:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_monkey_king_tree_dance_custom_jump:OnDestroy()
	if not IsServer() then return end

	local pos = self:GetParent():GetOrigin()

	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	if self.end_offset~=0 then
		self:GetParent():SetOrigin( pos )
	end

	if self.endCallback then
		self.endCallback( self.interrupted )
	end
end

function modifier_monkey_king_tree_dance_custom_jump:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	if self:GetStackCount()>0 then
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
	end

	return funcs
end






function modifier_monkey_king_tree_dance_custom_jump:GetModifierDisableTurning()
	if not self.isForward then return end
	return 1
end

function modifier_monkey_king_tree_dance_custom_jump:GetOverrideAnimation()
	return self:GetStackCount()
end

function modifier_monkey_king_tree_dance_custom_jump:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.isStun or false,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_monkey_king_tree_dance_custom_jump:UpdateHorizontalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end
	local pos = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( pos )
end

function modifier_monkey_king_tree_dance_custom_jump:UpdateVerticalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end
	local pos = me:GetOrigin()
	local time = self:GetElapsedTime()
	local height = pos.z
	local speed = self:GetVerticalSpeed( time )
	pos.z = height + speed * dt
	me:SetOrigin( pos )

	if not self.fix_duration then
		local ground = GetGroundHeight( pos, me ) + self.end_offset
		if pos.z <= ground then
			pos.z = ground
			me:SetOrigin( pos )
			self:Destroy()
		end
	end
end

function modifier_monkey_king_tree_dance_custom_jump:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom_jump:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom_jump:SetJumpParameters( kv )
	self.parent = self:GetParent()
	self.fix_end = true
	self.fix_duration = true
	self.fix_height = true
	if kv.fix_end then
		self.fix_end = kv.fix_end==1
	end
	if kv.fix_duration then
		self.fix_duration = kv.fix_duration==1
	end
	if kv.fix_height then
		self.fix_height = kv.fix_height==1
	end

	self.isStun = kv.isStun==1
	self.isRestricted = kv.isRestricted==1
	self.isForward = kv.isForward==1
	self.activity = kv.activity or 0
	self:SetStackCount( self.activity )

	if kv.target_x and kv.target_y then
		local origin = self.parent:GetOrigin()
		local dir = Vector( kv.target_x, kv.target_y, 0 ) - origin
		dir.z = 0
		dir = dir:Normalized()
		self.direction = dir
	end
	if kv.dir_x and kv.dir_y then
		self.direction = Vector( kv.dir_x, kv.dir_y, 0 ):Normalized()
	end
	if not self.direction then
		self.direction = self.parent:GetForwardVector()
	end

	self.duration = kv.duration
	self.distance = kv.distance
	self.speed = kv.speed
	if not self.duration then
		self.duration = self.distance/self.speed
	end
	if not self.distance then
		self.speed = self.speed or 0
		self.distance = self.speed*self.duration
	end
	if not self.speed then
		self.distance = self.distance or 0
		self.speed = self.distance/self.duration
	end

	self.height = kv.height or 0
	self.start_offset = kv.start_offset or 0
	self.end_offset = kv.end_offset or 0

	local pos_start = self.parent:GetOrigin()
	local pos_end = pos_start + self.direction * self.distance
	local height_start = GetGroundHeight( pos_start, self.parent ) + self.start_offset
	local height_end = GetGroundHeight( pos_end, self.parent ) + self.end_offset
	local height_max

	if not self.fix_height then
		self.height = math.min( self.height, self.distance/4 )
	end
	if self.fix_end then
		height_end = height_start
		height_max = height_start + self.height
	else
		-- calculate height
		local tempmin, tempmax = height_start, height_end
		if tempmin>tempmax then
			tempmin,tempmax = tempmax, tempmin
		end
		local delta = (tempmax-tempmin)*2/3

		height_max = tempmin + delta + self.height
	end
	if not self.fix_duration then
		self:SetDuration( -1, false )
	else
		self:SetDuration( self.duration, true )
	end
	self:InitVerticalArc( height_start, height_max, height_end, self.duration )
end

function modifier_monkey_king_tree_dance_custom_jump:Jump()
	if self.distance>0 then
		if not self:ApplyHorizontalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
	if self.height>0 then
		if not self:ApplyVerticalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
end

function modifier_monkey_king_tree_dance_custom_jump:InitVerticalArc( height_start, height_max, height_end, duration )
	local height_end = height_end - height_start
	local height_max = height_max - height_start

	-- fail-safe1: height_max cannot be smaller than height delta
	if height_max<height_end then
		height_max = height_end+0.01
	end

	-- fail-safe2: height-max must be positive
	if height_max<=0 then
		height_max = 0.01
	end

	-- math magic
	local duration_end = ( 1 + math.sqrt( 1 - height_end/height_max ) )/2
	self.const1 = 4*height_max*duration_end/duration
	self.const2 = 4*height_max*duration_end*duration_end/(duration*duration)
end

function modifier_monkey_king_tree_dance_custom_jump:GetVerticalPos( time )
	return self.const1*time - self.const2*time*time
end

function modifier_monkey_king_tree_dance_custom_jump:GetVerticalSpeed( time )
	return self.const1 - 2*self.const2*time
end

function modifier_monkey_king_tree_dance_custom_jump:SetEndCallback( func )
	self.endCallback = func
end










modifier_monkey_king_tree_dance_regen = class({})
function modifier_monkey_king_tree_dance_regen:IsHidden() return false end
function modifier_monkey_king_tree_dance_regen:IsPurgable() return false end
function modifier_monkey_king_tree_dance_regen:GetTexture() return "buffs/tree_regen" end

function modifier_monkey_king_tree_dance_regen:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end


function modifier_monkey_king_tree_dance_regen:GetModifierHealthRegenPercentage()
return self:GetAbility().damage_regen
end


function modifier_monkey_king_tree_dance_regen:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_monkey_king_tree_dance_regen:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end