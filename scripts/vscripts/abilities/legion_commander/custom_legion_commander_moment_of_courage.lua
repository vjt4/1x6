LinkLuaModifier("modifier_moment_of_courage_tracker", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_speed", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_heal", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_reduction", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_lowhp", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_lowhp_cd", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_crit_attack", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_legendary_defence", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_legendary_attack", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_slow", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_heal_mark", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_no_trigger", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_cd", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moment_of_courage_crit_stack", "abilities/legion_commander/custom_legion_commander_moment_of_courage", LUA_MODIFIER_MOTION_NONE)


custom_legion_commander_moment_of_courage = class({})

custom_legion_commander_moment_of_courage.chance_inc = {4,6,8}

custom_legion_commander_moment_of_courage.damage_init = 5
custom_legion_commander_moment_of_courage.damage_inc = 5

custom_legion_commander_moment_of_courage.reduction_init = 0
custom_legion_commander_moment_of_courage.reduction_inc = -2
custom_legion_commander_moment_of_courage.reduction_duration = 4
custom_legion_commander_moment_of_courage.reduction_max = 3


custom_legion_commander_moment_of_courage.lowhp_heal = 1.5
custom_legion_commander_moment_of_courage.lowhp_armor = 30
custom_legion_commander_moment_of_courage.lowhp_cd = 30
custom_legion_commander_moment_of_courage.lowhp_duration = 5
custom_legion_commander_moment_of_courage.lowhp_health = 30


custom_legion_commander_moment_of_courage.legendary_cd = 5
custom_legion_commander_moment_of_courage.legendary_move = 10
custom_legion_commander_moment_of_courage.legendary_incoming = -10
custom_legion_commander_moment_of_courage.legendary_cd_attack = 0.5
custom_legion_commander_moment_of_courage.legendary_chance = 2


custom_legion_commander_moment_of_courage.crit_max = 4
custom_legion_commander_moment_of_courage.crit_damage = {140, 200}
custom_legion_commander_moment_of_courage.crit_bash = {0.5, 0.5}
custom_legion_commander_moment_of_courage.crit_cleave = 1
custom_legion_commander_moment_of_courage.crit_duration = 5
custom_legion_commander_moment_of_courage.crit_stack_duration = 10


custom_legion_commander_moment_of_courage.stack_armor = -4
custom_legion_commander_moment_of_courage.stack_move = -20
custom_legion_commander_moment_of_courage.stack_duration = 4
custom_legion_commander_moment_of_courage.stack_max = 3


function custom_legion_commander_moment_of_courage:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_moment_of_courage_legendary_attack") then 
	return "Moment_of_curage_attack"
end

return "legion_commander_moment_of_courage"

end


function custom_legion_commander_moment_of_courage:GetBehavior()
  if self:GetCaster():HasModifier("modifier_legion_moment_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end


function custom_legion_commander_moment_of_courage:GetCooldown(iLevel)
--if self:GetCaster():HasModifier("modifier_legion_moment_legendary") then
	--return self.legendary_cd
--end

 return self.BaseClass.GetCooldown(self, iLevel)

end


--------------------------------------------------------------------------------
-- Toggle
function custom_legion_commander_moment_of_courage:OnToggle() 
local caster = self:GetCaster()

if self:GetToggleState() then
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_moment_of_courage_legendary_attack", {})
    self:GetCaster():RemoveModifierByName("modifier_moment_of_courage_legendary_defence")

else
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_moment_of_courage_legendary_defence", {})
    self:GetCaster():RemoveModifierByName("modifier_moment_of_courage_legendary_attack")
end


self:StartCooldown(self.legendary_cd)

end


function custom_legion_commander_moment_of_courage:GetIntrinsicModifierName() return "modifier_moment_of_courage_tracker" end 

modifier_moment_of_courage_tracker = class({})

function modifier_moment_of_courage_tracker:IsHidden() return true end
function modifier_moment_of_courage_tracker:IsPurgable() return false end
function modifier_moment_of_courage_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_RECORD,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_RESPAWN
}

end


function modifier_moment_of_courage_tracker:OnRespawn(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_legion_moment_legendary") then return end


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_moment_of_courage_legendary_defence", {})
end




function modifier_moment_of_courage_tracker:OnTakeDamage(params)
if not IsServer() then return end

if self:GetParent() == params.unit and self:GetParent():HasModifier("modifier_legion_moment_lowhp") and 
	not self:GetParent():HasModifier("modifier_moment_of_courage_lowhp_cd") and self:GetParent():GetHealthPercent() <= self:GetAbility().lowhp_health 
	and not self:GetParent():HasModifier("modifier_death") then 

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_lowhp", {duration = self:GetAbility().lowhp_duration})
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_lowhp_cd", {duration = self:GetAbility().lowhp_cd})

end





if self:GetParent() ~= params.attacker then return end

if params.unit:HasModifier("modifier_moment_of_courage_heal_mark") and params.inflictor == nil then 


	self.heal = self:GetAbility():GetSpecialValueFor("hp_leech_percent")/100

	if self:GetParent():HasModifier("modifier_moment_of_courage_lowhp") then 
		self.heal = self:GetAbility().lowhp_heal
	end


	local heal = params.damage*self.heal

	if not params.unit:IsBuilding() and not params.unit:IsIllusion() then 

		if self:GetParent():GetQuest() == "Legion.Quest_7" and params.unit:IsRealHero() and self:GetParent():GetHealthPercent() < 100 then 
		  self:GetParent():UpdateQuest( math.floor( math.min( (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()), heal )))
		end

		self:GetParent():Heal(heal, self:GetParent())

		local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
 		ParticleManager:ReleaseParticleIndex( particle )

 		SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
	end
	params.unit:RemoveModifierByName("modifier_moment_of_courage_heal_mark")
end 

end

function modifier_moment_of_courage_tracker:OnAttackRecord(params)
if not IsServer() then return end
if params.target ~= self:GetParent() then return end
if not self:GetAbility():IsFullyCastable() and not self:GetParent():HasModifier("modifier_legion_moment_legendary") then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_cd") then return end
if self:GetParent():PassivesDisabled() then return end

self:TriggerAttack()

end

function modifier_moment_of_courage_tracker:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end


if not self:GetParent():HasModifier("modifier_moment_of_courage_legendary_attack") then return end
if not self:GetAbility():IsFullyCastable() and not self:GetParent():HasModifier("modifier_legion_moment_legendary") then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_no_trigger") then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_cd") then return end
if self:GetParent():PassivesDisabled() then return end

self:TriggerAttack()

end



function modifier_moment_of_courage_tracker:TriggerAttack()
if not IsServer() then return end

self.chance = self:GetAbility():GetSpecialValueFor("trigger_chance")

local bonus = 0
if self:GetParent():HasModifier("modifier_legion_moment_chance") then 
	bonus = self:GetAbility().chance_inc[self:GetParent():GetUpgradeStack("modifier_legion_moment_chance")]
end
self.chance = self.chance + bonus


if self:GetParent():HasModifier("modifier_moment_of_courage_legendary_defence") then 
	self.chance = self.chance*self:GetAbility().legendary_chance
end

local random = RollPseudoRandomPercentage(self.chance,27,self:GetParent())


if not random then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_speed", {duration = self:GetAbility():GetSpecialValueFor("buff_duration")})


local cd = self:GetAbility().BaseClass.GetCooldown(self:GetAbility(), self:GetAbility():GetLevel())

if self:GetParent():HasModifier("modifier_moment_of_courage_legendary_defence") then 
	cd = self:GetAbility().legendary_cd_attack
end

if not self:GetParent():HasModifier("modifier_legion_moment_legendary") then 
	self:GetAbility():StartCooldown(cd)
else
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_cd", {duration = cd})
end

end






modifier_moment_of_courage_speed = class({})
function modifier_moment_of_courage_speed:IsHidden() return false end
function modifier_moment_of_courage_speed:IsPurgable() return false end
function modifier_moment_of_courage_speed:OnCreated(table)
if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end




function modifier_moment_of_courage_speed:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():GetAttackTarget() then return end

local target = self:GetParent():GetAttackTarget()

if not target or target:IsNull() or not target:IsAlive()
 then self:Destroy() return end


self:GetParent():EmitSound("Hero_LegionCommander.Courage")

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_heal", {})

self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2)


local particle = ParticleManager:CreateParticle( "particles/lc_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
   ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin() )
   ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )
   ParticleManager:SetParticleControl( particle, 2, Vector(1,1,1) )

ParticleManager:SetParticleControlForward( particle, 5, (target:GetOrigin() - self:GetParent():GetOrigin() ):Normalized() )


if self:GetParent():HasModifier("modifier_legion_moment_bkb") and not target:IsBuilding() then 
	target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_slow", {duration = self:GetAbility().stack_duration})
end

local no_trigger = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_no_trigger", {})
self:GetParent():PerformAttack(target, true, true, true, false, true, false, false)

if no_trigger then 
	no_trigger:Destroy()
end

if self:GetParent():HasModifier("modifier_legion_moment_armor") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_crit_stack", {duration = self:GetAbility().crit_stack_duration})
end






self:Destroy()


end







modifier_moment_of_courage_heal = class({})
function modifier_moment_of_courage_heal:IsHidden() return true end
function modifier_moment_of_courage_heal:IsPurgable() return false end
function modifier_moment_of_courage_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_moment_of_courage_heal:GetModifierDamageOutgoing_Percentage()
local bonus = 0

if self:GetCaster():HasModifier("modifier_legion_moment_damage") then 
	bonus = self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_legion_moment_damage")
end

return bonus
end



function modifier_moment_of_courage_heal:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_heal_mark", {})

if self:GetParent():HasModifier("modifier_legion_moment_defence") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_moment_of_courage_reduction", {duration = self:GetAbility().reduction_duration})
end





self:Destroy()

end

modifier_moment_of_courage_reduction = class({})
function modifier_moment_of_courage_reduction:IsHidden() return false end
function modifier_moment_of_courage_reduction:IsPurgable() return true end

function modifier_moment_of_courage_reduction:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_moment_of_courage_reduction:OnRefresh(table)
if not IsServer() then return end
	if self:GetStackCount() < self:GetAbility().reduction_max then 
		self:IncrementStackCount()
	end
end


function modifier_moment_of_courage_reduction:GetTexture() return "buffs/moment_reduce" end
function modifier_moment_of_courage_reduction:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_moment_of_courage_reduction:GetModifierIncomingDamage_Percentage()
 return self:GetStackCount()*(self:GetAbility().reduction_init + self:GetAbility().reduction_inc*self:GetParent():GetUpgradeStack("modifier_legion_moment_defence"))
end

function modifier_moment_of_courage_reduction:OnTooltip()
 return self:GetStackCount()*(self:GetAbility().reduction_init + self:GetAbility().reduction_inc*self:GetParent():GetUpgradeStack("modifier_legion_moment_defence"))
end














modifier_moment_of_courage_crit_attack = class({})
function modifier_moment_of_courage_crit_attack:IsHidden() return false end
function modifier_moment_of_courage_crit_attack:IsPurgable() return false end
function modifier_moment_of_courage_crit_attack:GetTexture() return "buffs/Crit_speed" end

function modifier_moment_of_courage_crit_attack:OnCreated(table)
if not IsServer() then return end
self.record = nil

self:GetParent():EmitSound("Lc.Courage_crit")
local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

end

function modifier_moment_of_courage_crit_attack:OnDestroy()
if not IsServer() then return end
if not self.particle_peffect then return end

ParticleManager:DestroyParticle(self.particle_peffect, false)
   ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end


function modifier_moment_of_courage_crit_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_ATTACK_START
}
end

function modifier_moment_of_courage_crit_attack:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_no_trigger") then return end
self:GetParent():EmitSound("Lc.Odds_ChargeHit")
end

function modifier_moment_of_courage_crit_attack:GetActivityTranslationModifiers() return "duel_kill" end


function modifier_moment_of_courage_crit_attack:GetCritDamage() 
return self:GetAbility().crit_damage[self:GetCaster():GetUpgradeStack("modifier_legion_moment_armor")] 
end


function modifier_moment_of_courage_crit_attack:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_moment_of_courage_no_trigger") then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.record ~= self.record then return end



params.target:EmitSound("BB.Goo_stun")   

DoCleaveAttack(self:GetParent(), params.target, nil, params.damage*(self:GetAbility().crit_cleave), 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bashed", {duration = self:GetAbility().crit_bash[self:GetCaster():GetUpgradeStack("modifier_legion_moment_armor")] *(1 - params.target:GetStatusResistance())})
self:Destroy()

end

function modifier_moment_of_courage_crit_attack:GetModifierPreAttack_CriticalStrike(params)
if self:GetParent():HasModifier("modifier_moment_of_courage_no_trigger") then return end
	self.record = params.record
	return self:GetAbility().crit_damage[self:GetCaster():GetUpgradeStack("modifier_legion_moment_armor")] 
end













modifier_moment_of_courage_slow = class({})
function modifier_moment_of_courage_slow:IsHidden() return false end
function modifier_moment_of_courage_slow:IsPurgable() return true end
function modifier_moment_of_courage_slow:GetTexture() return "buffs/moment_armor" end

function modifier_moment_of_courage_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end
function modifier_moment_of_courage_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().stack_move*self:GetStackCount()
 end


function modifier_moment_of_courage_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_moment_of_courage_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().stack_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().stack_max then 
	self:GetParent():EmitSound("Item.StarEmblem.Enemy")
	self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

end


function modifier_moment_of_courage_slow:GetModifierPhysicalArmorBonus() 
return self:GetAbility().stack_armor*self:GetStackCount()
end



modifier_moment_of_courage_heal_mark = class({})
function modifier_moment_of_courage_heal_mark:IsHidden() return true end
function modifier_moment_of_courage_heal_mark:IsPurgable() return false end
function modifier_moment_of_courage_heal_mark:RemoveOnDeath() return false end

modifier_moment_of_courage_no_trigger = class({})
function modifier_moment_of_courage_no_trigger:IsHidden() return true end
function modifier_moment_of_courage_no_trigger:IsPurgable() return false end



modifier_moment_of_courage_cd = class({})
function modifier_moment_of_courage_cd:IsHidden() return true end
function modifier_moment_of_courage_cd:IsPurgable() return false end





modifier_moment_of_courage_crit_stack = class({})
function modifier_moment_of_courage_crit_stack:IsHidden() return true end
function modifier_moment_of_courage_crit_stack:IsPurgable() return false end
function modifier_moment_of_courage_crit_stack:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/lc_charges.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)
self:SetStackCount(1)

end

function modifier_moment_of_courage_crit_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().crit_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().crit_max then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_moment_of_courage_crit_attack", {duration = self:GetAbility().crit_duration})
	self:Destroy()
end


end



function modifier_moment_of_courage_crit_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.particle then return end

for i = 1,self:GetAbility().crit_max do 
	
	if i <= self:GetStackCount() then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end


function modifier_moment_of_courage_crit_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_moment_of_courage_crit_stack:OnTooltip()
return self:GetAbility().crit_max
end






modifier_moment_of_courage_legendary_attack = class({})
function modifier_moment_of_courage_legendary_attack:IsHidden() return false end
function modifier_moment_of_courage_legendary_attack:IsPurgable() return false end
function modifier_moment_of_courage_legendary_attack:RemoveOnDeath() return false end
function modifier_moment_of_courage_legendary_attack:GetTexture() return "buffs/moment_attack" end
function modifier_moment_of_courage_legendary_attack:GetEffectName() return "particles/lc_attack_buf.vpcf" end
function modifier_moment_of_courage_legendary_attack:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Lc.Moment_Attack")
self.particle_peffect = ParticleManager:CreateParticle("particles/lc_attack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())

self:StartIntervalThink(self:GetAbility().legendary_cd)
end



function modifier_moment_of_courage_legendary_attack:DestroyPart()
if not IsServer() then return end
if not self.particle_peffect then return end

ParticleManager:DestroyParticle(self.particle_peffect, false)
ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end


function modifier_moment_of_courage_legendary_attack:OnDestroy()
if not IsServer() then return end
self:DestroyPart()
end


function modifier_moment_of_courage_legendary_attack:OnIntervalThink()
if not IsServer() then return end
self:DestroyPart()
self:StartIntervalThink(-1)
end




function modifier_moment_of_courage_legendary_attack:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_moment_of_courage_legendary_attack:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().legendary_move
end



modifier_moment_of_courage_legendary_defence = class({})
function modifier_moment_of_courage_legendary_defence:IsHidden() return false end
function modifier_moment_of_courage_legendary_defence:GetTexture() return "buffs/moment_defence" end
function modifier_moment_of_courage_legendary_defence:IsPurgable() return false end
function modifier_moment_of_courage_legendary_defence:RemoveOnDeath() return false end
function modifier_moment_of_courage_legendary_defence:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Lc.Moment_Defence")
self.particle_peffect = ParticleManager:CreateParticle("particles/lc_defence.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self.particle_peffect_2 = ParticleManager:CreateParticle("particles/items3_fx/star_emblem_friend_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect_2, 0, self:GetParent():GetAbsOrigin())

self:StartIntervalThink(self:GetAbility().legendary_cd)
end





function modifier_moment_of_courage_legendary_defence:OnDestroy()
if not IsServer() then return end

if self.particle_peffect then 
		
	ParticleManager:DestroyParticle(self.particle_peffect, false)
	ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end
if self.particle_peffect_2 then
	ParticleManager:DestroyParticle(self.particle_peffect_2, false)
	ParticleManager:ReleaseParticleIndex(self.particle_peffect_2)
end

end

function modifier_moment_of_courage_legendary_defence:OnIntervalThink()
if not IsServer() then return end

if self.particle_peffect_2 then
	ParticleManager:DestroyParticle(self.particle_peffect_2, false)
	ParticleManager:ReleaseParticleIndex(self.particle_peffect_2)
end

self:StartIntervalThink(-1)
end


function modifier_moment_of_courage_legendary_defence:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_moment_of_courage_legendary_defence:GetModifierIncomingDamage_Percentage()
return self:GetAbility().legendary_incoming
end



modifier_moment_of_courage_lowhp = class({})
function modifier_moment_of_courage_lowhp:IsHidden() return false end
function modifier_moment_of_courage_lowhp:IsPurgable() return false end
function modifier_moment_of_courage_lowhp:GetTexture() return "buffs/moment_lowhp" end

function modifier_moment_of_courage_lowhp:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true	
  
  self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
  self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
  self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
  self.sound = "LC.Courage_armor"
  self.buff_particles = {}

  self:GetCaster():EmitSound( self.sound)
 -- self:GetCaster():EmitSound("LC.Courage_armor2")


  self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
  self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
  ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

  self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
  self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

  self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
  self:AddParticle(self.buff_particles[3], false, false, -1, true, false)
end


function modifier_moment_of_courage_lowhp:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_moment_of_courage_lowhp:GetModifierPhysicalArmorBonus()
return self:GetAbility().lowhp_armor
end


modifier_moment_of_courage_lowhp_cd = class({})
function modifier_moment_of_courage_lowhp_cd:IsHidden() return false end
function modifier_moment_of_courage_lowhp_cd:IsPurgable() return false end
function modifier_moment_of_courage_lowhp_cd:GetTexture() return "buffs/moment_lowhp" end
function modifier_moment_of_courage_lowhp_cd:IsDebuff() return true end
function modifier_moment_of_courage_lowhp_cd:RemoveOnDeath() return false end
function modifier_moment_of_courage_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true
end