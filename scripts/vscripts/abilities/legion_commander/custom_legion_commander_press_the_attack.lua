LinkLuaModifier("modifier_press_the_attack_buff", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_tracker", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_lowhp_cd", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_count", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_bkb", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_root", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_legendary_damage", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_burn_stack", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)



custom_legion_commander_press_the_attack = class({})


custom_legion_commander_press_the_attack.resist = {10,15,20}
custom_legion_commander_press_the_attack.resist_move = {5,10,15}

custom_legion_commander_press_the_attack.regen_inc = {50, 75, 100}

custom_legion_commander_press_the_attack.root_radius = 400
custom_legion_commander_press_the_attack.root_duration = 1.5

custom_legion_commander_press_the_attack.bkb_duration = 1.5
custom_legion_commander_press_the_attack.bkb_heal = 0.15


custom_legion_commander_press_the_attack.legendary_reduce = 0.5
custom_legion_commander_press_the_attack.legendary_damage_duration = 4
custom_legion_commander_press_the_attack.legendary_interval = 1
custom_legion_commander_press_the_attack.legendary_radius = 350
custom_legion_commander_press_the_attack.legendary_creeps = 0.5


custom_legion_commander_press_the_attack.bonus_str = {0.05, 0.1 ,0.15}

custom_legion_commander_press_the_attack.burn_radius = 400
custom_legion_commander_press_the_attack.burn_interval = 1
custom_legion_commander_press_the_attack.burn_duration = 1.5
custom_legion_commander_press_the_attack.burn_damage = {0.02, 0.03}
custom_legion_commander_press_the_attack.burn_damage_inc = 0.3
custom_legion_commander_press_the_attack.burn_stack_max = 9



function custom_legion_commander_press_the_attack:GetIntrinsicModifierName()
return "modifier_press_the_attack_tracker"
end





function custom_legion_commander_press_the_attack:OnSpellStart()
if not IsServer() then return end
self.target = self:GetCaster()


local before = #self.target:FindAllModifiers()


self.target:Purge(false , true, false , true, false)

local after = #self.target:FindAllModifiers()

if self:GetCaster():GetQuest() == "Legion.Quest_6" and after < before then 
	self:GetCaster():UpdateQuest(1)
end





self.duration = self:GetSpecialValueFor("duration")

self:GetCaster():EmitSound("Hero_LegionCommander.PressTheAttack")


if self:GetCaster():HasModifier("modifier_legion_press_lowhp") then 
	self.target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_bkb", {duration = self.bkb_duration})

	  local heal = self.bkb_heal*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())


	  self:GetCaster():Heal(heal, self)

	  SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

	  local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	  ParticleManager:ReleaseParticleIndex( particle )
end




self.target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_buff", {duration = self.duration})



if self:GetCaster():HasModifier("modifier_legion_press_after") then 

	local wave_particle = ParticleManager:CreateParticle( "particles/lc_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(wave_particle)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self.root_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
	for _,target in ipairs(enemies) do 
		if target:GetUnitName() ~= "npc_teleport" then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_press_the_attack_root", {duration = (1 - target:GetStatusResistance())*self.root_duration})
			target:EmitSound("Lc.Press_Root")
		end
	end

end

end




modifier_press_the_attack_buff = class({})

function modifier_press_the_attack_buff:IsHidden() return false end
function modifier_press_the_attack_buff:IsPurgable() 
	return not self:GetParent():HasModifier("modifier_legion_press_legendary")
 end


function modifier_press_the_attack_buff:OnCreated(table)

self.RemoveForDuel = true

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )

self.cast = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_hands.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt( self.cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )

if self:GetParent():HasModifier("modifier_legion_press_legendary") then 
	self.legen = ParticleManager:CreateParticle("particles/lc_press_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl( self.legen, 1, self:GetParent():GetAbsOrigin() )
end

self.speed = self:GetAbility():GetSpecialValueFor("attack_speed")

self.damage_count = 0

self.regen = self:GetAbility():GetSpecialValueFor("hp_regen")

self.str_percentage = 0

if self:GetCaster():HasModifier("modifier_legion_press_speed") then 
  self.str_percentage = self:GetAbility().bonus_str[self:GetCaster():GetUpgradeStack("modifier_legion_press_speed")]
end

if not IsServer() then return end

	self:OnIntervalThink()
	self:StartIntervalThink(self:GetAbility().burn_interval)



end








function modifier_press_the_attack_buff:OnIntervalThink()
if not IsServer() then return end

self.str  = 0
self.str   = self:GetParent():GetStrength() * self.str_percentage

self:GetParent():CalculateStatBonus(true)

if self:GetParent():HasModifier("modifier_legion_press_duration") then 

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(),nil,self:GetAbility().burn_radius,DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)

	local original_damage = self:GetParent():GetMaxHealth()*self:GetAbility().burn_damage[self:GetParent():GetUpgradeStack("modifier_legion_press_duration")]

	self:GetParent():EmitSound("LC.Press_burn")

	local particle = ParticleManager:CreateParticle("particles/lc_press_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

	for _,enemy in pairs(enemies) do 

		local damage = original_damage

		local mod = enemy:FindModifierByName("modifier_press_the_attack_burn_stack")
		if mod then 
			damage = damage*(1 + mod:GetStackCount()*self:GetAbility().burn_damage_inc)
		end


		local damageTable = {victim = enemy,  damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetParent(), ability = self:GetAbility()}
		ApplyDamage(damageTable)
		SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil )

		enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_burn_stack", {duration = self:GetAbility().burn_duration})

	end
end

end






function modifier_press_the_attack_buff:OnDestroy()

ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)
ParticleManager:DestroyParticle(self.cast, false)
ParticleManager:ReleaseParticleIndex(self.cast)

if self.effect_target then 
	ParticleManager:DestroyParticle(self.effect_target, false)
    ParticleManager:ReleaseParticleIndex(self.effect_target)
end

if self:GetParent():HasModifier("modifier_legion_press_legendary") and self.legen ~= nil then 
	ParticleManager:DestroyParticle(self.legen, false)
	ParticleManager:ReleaseParticleIndex(self.legen)
end

if not IsServer() then return end

if self:GetParent():HasModifier("modifier_legion_press_legendary") then 

	local mod = self:GetParent():FindModifierByName("modifier_press_the_attack_count")
	if mod then 

		local damage = mod:GetStackCount()
		mod:Destroy()
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_legendary_damage", {damage = damage, duration = self:GetAbility().legendary_damage_duration})
	end
end


end


function modifier_press_the_attack_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}

end


function modifier_press_the_attack_buff:GetModifierBonusStats_Strength()
return self.str
end


function modifier_press_the_attack_buff:GetModifierStatusResistanceStacking()
local bonus = 0
if self:GetCaster():HasModifier("modifier_legion_press_cd") then 
	bonus = self:GetAbility().resist[self:GetCaster():GetUpgradeStack("modifier_legion_press_cd")]
end
return bonus
end

function modifier_press_the_attack_buff:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetCaster():HasModifier("modifier_legion_press_cd") then 
	bonus = self:GetAbility().resist_move[self:GetCaster():GetUpgradeStack("modifier_legion_press_cd")]
end
return bonus
end





function modifier_press_the_attack_buff:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_legion_press_legendary") then return end

if self:GetParent() == params.attacker then return end

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

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_count", {})
if mod then 
	mod:SetStackCount(mod:GetStackCount() + params.damage * self:GetAbility().legendary_reduce)
end

return params.damage * self:GetAbility().legendary_reduce

end





function modifier_press_the_attack_buff:GetModifierConstantHealthRegen()

local bonus = 0
if self:GetCaster():HasModifier("modifier_legion_press_regen") then 
	bonus = self:GetAbility().regen_inc[self:GetCaster():GetUpgradeStack("modifier_legion_press_regen")]
end

return (self.regen + bonus)

end


function modifier_press_the_attack_buff:GetModifierAttackSpeedBonus_Constant() 

return self.speed 
end






modifier_press_the_attack_tracker = class({})
function modifier_press_the_attack_tracker:IsHidden() return true end
function modifier_press_the_attack_tracker:IsPurgable() return false  end





modifier_press_the_attack_lowhp_cd = class({})
function modifier_press_the_attack_lowhp_cd:IsHidden() return false end
function modifier_press_the_attack_lowhp_cd:IsPurgable() return false end
function modifier_press_the_attack_lowhp_cd:RemoveOnDeath() return false end
function modifier_press_the_attack_lowhp_cd:IsDebuff() return true end
function modifier_press_the_attack_lowhp_cd:GetTexture() return "buffs/lowhp_cd" end
function modifier_press_the_attack_lowhp_cd:OnCreated(table)
	self.RemoveForDuel = true
end



modifier_press_the_attack_count = class({})
function modifier_press_the_attack_count:IsHidden() return false end
function modifier_press_the_attack_count:IsPurgable() return false end
function modifier_press_the_attack_count:GetTexture() return "buffs/press_legendary" end

function modifier_press_the_attack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_press_the_attack_count:OnTooltip() return self:GetStackCount() end


modifier_press_the_attack_bkb = class({})
function modifier_press_the_attack_bkb:IsHidden() return true end
function modifier_press_the_attack_bkb:IsPurgable() return false end 
function modifier_press_the_attack_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_press_the_attack_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end

modifier_press_the_attack_root = class({})
function modifier_press_the_attack_root:IsHidden() return false end
function modifier_press_the_attack_root:IsPurgable() return true end
function modifier_press_the_attack_root:GetTexture() return "buffs/press_root" end
function modifier_press_the_attack_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end
function modifier_press_the_attack_root:GetEffectName() return "particles/lc_root.vpcf" end


modifier_press_the_attack_legendary_damage = class({})
function modifier_press_the_attack_legendary_damage:IsHidden() return false end
function modifier_press_the_attack_legendary_damage:IsPurgable() return false end
function modifier_press_the_attack_legendary_damage:IsDebuff() return true end
function modifier_press_the_attack_legendary_damage:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true
self.damage = table.damage
self.tick = self.damage/(self:GetAbility().legendary_damage_duration + self:GetAbility().legendary_interval)

self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().legendary_interval)
end

function modifier_press_the_attack_legendary_damage:OnIntervalThink()
if not IsServer() then return end

self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - self.tick))

--self:GetParent():EmitSound("Lc.Press_legendary") 

self:GetParent():EmitSound("Lc.Press_Heal")
local effect_target = ParticleManager:CreateParticle( "particles/lc_press_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
ParticleManager:ReleaseParticleIndex( effect_target )


local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self:GetAbility().legendary_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

for _,target in ipairs(enemies) do 
	local damage = self.tick 
	if target:IsCreep() then 
		damage = damage*self:GetAbility().legendary_creeps
	end

	local damageTable = {victim = target,  damage = damage, damage_type = DAMAGE_TYPE_PURE, attacker = self:GetParent(), ability = self:GetAbility()}
	 ApplyDamage(damageTable)
end

end


modifier_press_the_attack_burn_stack = class({})
function modifier_press_the_attack_burn_stack:IsHidden() return false end
function modifier_press_the_attack_burn_stack:IsPurgable() return false end
function modifier_press_the_attack_burn_stack:GetTexture() return "buffs/press_after" end

function modifier_press_the_attack_burn_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_press_the_attack_burn_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().burn_stack_max then return end
self:IncrementStackCount()
end


function modifier_press_the_attack_burn_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_press_the_attack_burn_stack:OnTooltip()
return self:GetAbility().burn_damage_inc*100*self:GetStackCount()
end


function modifier_press_the_attack_burn_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end
