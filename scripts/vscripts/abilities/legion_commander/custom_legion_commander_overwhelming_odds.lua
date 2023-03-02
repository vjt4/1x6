LinkLuaModifier("modifier_overwhelming_odds_speed", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_stack", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_proc", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_proc_silence", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_passive", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_mark", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_mark_speed", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_mark_anim", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_legendary", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_overwhelming_odds_proc_slow", "abilities/legion_commander/custom_legion_commander_overwhelming_odds", LUA_MODIFIER_MOTION_NONE)





custom_legion_commander_overwhelming_odds = class({})


custom_legion_commander_overwhelming_odds.cd_inc = {-1, -2, -3}

custom_legion_commander_overwhelming_odds.damage_attack = {0.15, 0.2, 0.25}

custom_legion_commander_overwhelming_odds.attack_speed = {30, 45, 60}

custom_legion_commander_overwhelming_odds.triple_count_init = 0
custom_legion_commander_overwhelming_odds.triple_count_inc = 1
custom_legion_commander_overwhelming_odds.triple_timer = 2

custom_legion_commander_overwhelming_odds.proc_max = 6
custom_legion_commander_overwhelming_odds.proc_duraion = 1.5
custom_legion_commander_overwhelming_odds.proc_slow = -100
custom_legion_commander_overwhelming_odds.proc_damage = {0.3 , 0.5}

custom_legion_commander_overwhelming_odds.mark_duration = 5
custom_legion_commander_overwhelming_odds.mark_speed_duration = 3
custom_legion_commander_overwhelming_odds.mark_speed = 800
custom_legion_commander_overwhelming_odds.mark_stun = 1
custom_legion_commander_overwhelming_odds.mark_max_range = 2000
custom_legion_commander_overwhelming_odds.mark_min_range = 300

custom_legion_commander_overwhelming_odds.legendary_duration = 8
custom_legion_commander_overwhelming_odds.legendary_max = 3
custom_legion_commander_overwhelming_odds.legendary_max_creeps = 5

custom_legion_commander_overwhelming_odds.slow_move = 10
custom_legion_commander_overwhelming_odds.slow_silence = 2


custom_legion_commander_overwhelming_odds_slow = class({})




function custom_legion_commander_overwhelming_odds:GetIntrinsicModifierName() return "modifier_overwhelming_odds_passive" end

function custom_legion_commander_overwhelming_odds:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_legion_odds_cd") then  
	upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_legion_odds_cd")]
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end







function custom_legion_commander_overwhelming_odds:GetAOERadius() 
return self:GetSpecialValueFor("radius") 
end


function custom_legion_commander_overwhelming_odds:OnAbilityPhaseStart()
if not IsServer() then return end
    self.cast = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( self.cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )

	self:GetCaster():EmitSound("Hero_LegionCommander.Overwhelming.Cast")
return true 
end

function custom_legion_commander_overwhelming_odds:OnAbilityPhaseInterrupted()
if not IsServer() then return end

		ParticleManager:DestroyParticle(self.cast, false)
        ParticleManager:ReleaseParticleIndex(self.cast)
end


function custom_legion_commander_overwhelming_odds:OnSpellStart( point )
if not IsServer() then return end
self.caster = self:GetCaster()

if point == nil then 
	self.point = self:GetCursorPosition()
else 
	self.point = point
end



self.radius = self:GetSpecialValueFor("radius")
self.damage = self:GetSpecialValueFor("damage")
self.illusion_damage = self:GetSpecialValueFor("illusion_dmg_pct")
self.duration = self:GetSpecialValueFor("duration")
self.speed_change = self:GetSpecialValueFor("speed_change")

if self:GetCaster():HasModifier("modifier_legion_odds_triple") then 
	self.damage = self.damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self.damage_attack[self:GetCaster():GetUpgradeStack("modifier_legion_odds_triple")]
end


EmitSoundOnLocationWithCaster(self.point, "Hero_LegionCommander.Overwhelming.Location", self.caster)

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( particle, 0, self.point )
    ParticleManager:SetParticleControl( particle, 1, self:GetCaster():GetAbsOrigin() )
    ParticleManager:SetParticleControl( particle, 2, self.point )
    ParticleManager:SetParticleControl( particle, 3, self.point )
    ParticleManager:SetParticleControl( particle, 4, Vector( self.radius, self.radius, self.radius ) )
    ParticleManager:SetParticleControl( particle, 6, self.point )
    ParticleManager:ReleaseParticleIndex( particle )


local flag = DOTA_UNIT_TARGET_FLAG_NONE

self.enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),self.point,nil,self.radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,flag,FIND_ANY_ORDER,false)


if self:GetCaster():HasModifier("modifier_legion_odds_legendary") and point == nil then 
 	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_legendary", {duration = self.legendary_duration})
end
  



local proc_mod = self:GetCaster():FindModifierByName("modifier_overwhelming_odds_proc")

if proc_mod then 

	self.damage = self.damage*(1 + self.proc_damage[self:GetCaster():GetUpgradeStack("modifier_legion_odds_proc")])

	EmitSoundOnLocationWithCaster(self.point, "Lc.Odds_Proc_Damage", self.caster)

	local particle = ParticleManager:CreateParticle( "particles/lc_odd_proc_burst.vpcf", PATTACH_WORLDORIGIN, nil )
 	ParticleManager:SetParticleControl( particle, 0, self.point )
 	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, self.radius, self.radius ) )
  	ParticleManager:ReleaseParticleIndex( particle )
end






if #self.enemies > 0 then 

	for _,enemy in ipairs(self.enemies) do 
		local effect_name = ""
		enemy:EmitSound("Hero_LegionCommander.Overwhelming.Creep")
		effect_name = "particles/units/heroes/hero_legion_commander/legion_commander_odds_dmga.vpcf"

		local particle_peffect = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(particle_peffect , 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_peffect , 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
    	ParticleManager:SetParticleControl(particle_peffect, 3, self:GetCaster():GetAbsOrigin())
    	ParticleManager:ReleaseParticleIndex(particle_peffect)

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_speed", {duration = self.duration*(1 - enemy:GetStatusResistance())})

		if proc_mod then 
			local slow_duration = (1 - enemy:GetStatusResistance())*self.proc_duraion
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_proc_slow", {duration = slow_duration })	
		end

		if self:GetCaster():HasModifier("modifier_legion_odds_solo") and point == nil then 
			local silence_duration = (1 - enemy:GetStatusResistance())*self.slow_silence
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_proc_silence", {duration = silence_duration })	
		end


		local illusion = 0
		if enemy:IsIllusion() then 
			illusion = enemy:GetMaxHealth()*self.illusion_damage / 100
		end

		local damageTable = {victim = enemy,  damage = self.damage + illusion, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self}
		local actualy_damage = ApplyDamage(damageTable)
	end


	if self:GetCaster():HasModifier("modifier_legion_odds_mark") and point == nil then 
		local random = RandomInt(1, #self.enemies)
		self.enemies[random]:AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_mark", {duration = self.mark_duration})
	end


	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_overwhelming_odds_speed", {duration = self.duration})
end 
	

if proc_mod then proc_mod:Destroy() end




end




modifier_overwhelming_odds_speed = class({})

function modifier_overwhelming_odds_speed:IsHidden() return false end
function modifier_overwhelming_odds_speed:IsPurgable() return true end
function modifier_overwhelming_odds_speed:OnCreated(table)

self.move = self:GetAbility():GetSpecialValueFor("speed_change")

if self:GetCaster():HasModifier("modifier_legion_odds_solo") and self:GetParent() ~= self:GetCaster() then 
	self.move = self.move + self:GetAbility().slow_move
end

if self:GetCaster() ~= self:GetParent() then
	self.move = self.move*-1
end

if not IsServer() then return end

self.poof = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.poof, 0, self:GetParent():GetAbsOrigin())

end


function modifier_overwhelming_odds_speed:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end



function modifier_overwhelming_odds_speed:GetModifierAttackSpeedBonus_Constant()
if self:GetParent():HasModifier("modifier_legion_odds_creep") then 
	return self:GetAbility().attack_speed[self:GetCaster():GetUpgradeStack("modifier_legion_odds_creep")]
end
return
end

function modifier_overwhelming_odds_speed:OnDestroy()
if not IsServer() then return end
	ParticleManager:DestroyParticle(self.poof, false)
	ParticleManager:ReleaseParticleIndex(self.poof)
end




function modifier_overwhelming_odds_speed:GetModifierMoveSpeedBonus_Percentage() 
	return self.move 
end

function modifier_overwhelming_odds_speed:GetActivityTranslationModifiers() 
if self:GetCaster() == self:GetParent() then 
	return "overwhelmingodds" 
end

end








modifier_overwhelming_odds_passive = class({})

function modifier_overwhelming_odds_passive:IsHidden() return true end
function modifier_overwhelming_odds_passive:IsPurgable() return false end
function modifier_overwhelming_odds_passive:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_overwhelming_odds_passive:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_odds_proc") then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_overwhelming_odds_proc") then return end


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_stack", {})

end


modifier_overwhelming_odds_stack = class({})

function modifier_overwhelming_odds_stack:IsHidden() return false end
function modifier_overwhelming_odds_stack:IsPurgable() return false end
function modifier_overwhelming_odds_stack:GetTexture() return "buffs/odds_proc" end
function modifier_overwhelming_odds_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_overwhelming_odds_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_overwhelming_odds_stack:OnTooltip() return self:GetAbility().proc_max end

function modifier_overwhelming_odds_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
if self:GetStackCount() >= self:GetAbility().proc_max then 
	EmitSoundOnEntityForPlayer("Lc.Odds_Proc", self:GetParent(), self:GetParent():GetPlayerOwnerID())
	
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_proc", {})

	local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
   	ParticleManager:ReleaseParticleIndex(particle_peffect)

	

	self:Destroy()

end
end


modifier_overwhelming_odds_proc = class({})
function modifier_overwhelming_odds_proc:IsHidden() return false end
function modifier_overwhelming_odds_proc:IsPurgable() return false end
function modifier_overwhelming_odds_proc:GetTexture() return "buffs/odds_proc" end
function modifier_overwhelming_odds_proc:GetEffectName() return "particles/lc_odd_proc_hands.vpcf" end



modifier_overwhelming_odds_proc_silence = class({})
function modifier_overwhelming_odds_proc_silence:IsHidden() return false end
function modifier_overwhelming_odds_proc_silence:IsPurgable() return true end
function modifier_overwhelming_odds_proc_silence:GetTexture() return "buffs/odds_proc" end
function modifier_overwhelming_odds_proc_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_overwhelming_odds_proc_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_overwhelming_odds_proc_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end





modifier_overwhelming_odds_mark = class({})
function modifier_overwhelming_odds_mark:IsHidden() return false end
function modifier_overwhelming_odds_mark:IsPurgable() return true end
function modifier_overwhelming_odds_mark:GetTexture() return "buffs/odds_mark" end
function modifier_overwhelming_odds_mark:GetEffectName() return "particles/lc_odd_charge_mark.vpcf" end
function modifier_overwhelming_odds_mark:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_overwhelming_odds_mark:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ORDER,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end
function modifier_overwhelming_odds_mark:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end

self:SetDuration(self:GetAbility().mark_duration*(1 - self:GetParent():GetStatusResistance()), true)
end


function modifier_overwhelming_odds_mark:OnOrder( ord )
if not IsServer() then return end
if ord.order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET and ord.order_type ~= DOTA_UNIT_ORDER_MOVE_TO_TARGET then return end
if ord.target ~= self:GetParent() then return end
if (self:GetParent():GetAbsOrigin() - ord.unit:GetAbsOrigin()):Length2D() < self:GetAbility().mark_min_range then return end
if (self:GetParent():GetAbsOrigin() - ord.unit:GetAbsOrigin()):Length2D() > self:GetAbility().mark_max_range then return end
if self:GetCaster() ~= ord.unit then return end



ord.unit:AddNewModifier(ord.unit, self:GetAbility(), "modifier_overwhelming_odds_mark_speed", {duration = self:GetAbility().mark_speed_duration, target = self:GetParent():entindex()})
ord.unit:EmitSound("Lc.Odds_Charge")

self:Destroy()

end

modifier_overwhelming_odds_mark_speed = class({})
function modifier_overwhelming_odds_mark_speed:IsHidden() return false end
function modifier_overwhelming_odds_mark_speed:IsPurgable() return false end
function modifier_overwhelming_odds_mark_speed:GetTexture() return "buffs/odds_mark" end

function modifier_overwhelming_odds_mark_speed:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
self.stun = false 
self:GetParent():SetForceAttackTarget(self.target)
self:StartIntervalThink(FrameTime())
end

function modifier_overwhelming_odds_mark_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_EVENT_ON_ATTACK_START
}

end


function modifier_overwhelming_odds_mark_speed:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self.stun = true 
self:Destroy()

end


function modifier_overwhelming_odds_mark_speed:OnIntervalThink()
if not IsServer() then return end

if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= 200 then 
	self.stun = true 
end


if self.stun
or not self.target:IsAlive()  
or self.target:IsInvulnerable() 
or self.target:IsInvisible() 
or self.target:IsAttackImmune()
or self:GetParent():IsStunned()
or self:GetParent():IsAttackImmune()
or self:GetParent():IsHexed()
or self:GetParent():IsRooted() then 
 	self:Destroy()
end

end

function modifier_overwhelming_odds_mark_speed:OnDestroy()
if not IsServer() then return end
local stun = self:GetAbility().mark_stun

	if self.stun then 

		local anim = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_overwhelming_odds_mark_anim", {})
		self:GetParent():EmitSound("Lc.Odds_ChargeHit")
		self:GetParent():StartGesture(ACT_DOTA_ATTACK)
		if anim then 
			anim:Destroy()
		end
		if not  self.target:IsMagicImmune() then
			self.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = stun})

			local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_charge_hit_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		
    		ParticleManager:SetParticleControl(particle_peffect, 0, self.target:GetAbsOrigin())
    		ParticleManager:SetParticleControl(particle_peffect, 1, self.target:GetAbsOrigin())
    	 	ParticleManager:SetParticleControl(particle_peffect, 3, self.target:GetAbsOrigin())
    		ParticleManager:ReleaseParticleIndex(particle_peffect)
			

		end
	end


self:GetParent():SetForceAttackTarget(nil)
end
function modifier_overwhelming_odds_mark_speed:GetEffectName() return "particles/lc_odd_charge.vpcf" end

function modifier_overwhelming_odds_mark_speed:GetModifierMoveSpeed_Absolute() return self:GetAbility().mark_speed
 end
function modifier_overwhelming_odds_mark_speed:GetActivityTranslationModifiers() return "overwhelmingodds" end



modifier_overwhelming_odds_mark_anim = class({})
function modifier_overwhelming_odds_mark_anim:IsHidden() return true end
function modifier_overwhelming_odds_mark_anim:IsPurgable() return false end
function modifier_overwhelming_odds_mark_anim:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}

end
function modifier_overwhelming_odds_mark_anim:GetActivityTranslationModifiers() return "duel_kill" end



modifier_overwhelming_odds_legendary = class({})
function modifier_overwhelming_odds_legendary:IsHidden() return false end
function modifier_overwhelming_odds_legendary:IsPurgable() return false end
function modifier_overwhelming_odds_legendary:GetTexture() return "buffs/odds_legendary" end
function modifier_overwhelming_odds_legendary:GetEffectName() return "particles/lc_odds_l.vpcf" end
function modifier_overwhelming_odds_legendary:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_overwhelming_odds_legendary:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_overwhelming_odds_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 
self:SetStackCount(0)
end


function modifier_overwhelming_odds_legendary:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_overwhelming_odds_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end

local max = self:GetAbility().legendary_max
if params.target:IsCreep() then 
	max = self:GetAbility().legendary_max_creeps
end

if self:GetStackCount() < max then
	self:IncrementStackCount()
end

if self:GetStackCount() >= max then 
	self:SetStackCount(0)

	self:GetAbility():OnSpellStart(params.target:GetAbsOrigin())

end




end











modifier_overwhelming_odds_proc_slow = class({})

function modifier_overwhelming_odds_proc_slow:IsHidden() return true end
function modifier_overwhelming_odds_proc_slow:IsPurgable() return true end
function modifier_overwhelming_odds_proc_slow:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end



function modifier_overwhelming_odds_proc_slow:GetModifierMoveSpeedBonus_Percentage() 
	return self:GetAbility().proc_slow
end
