LinkLuaModifier("modifier_conjure_image_tracker", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_reduce_aura", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura_damage", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aura_damage_count", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_invun", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_invun_illusion", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_legendary_cd", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_aoe_slow", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_visual", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_conjure_image_legendary_incoming", "abilities/terrorblade/custom_terrorblade_conjure_image", LUA_MODIFIER_MOTION_NONE)


custom_terrorblade_conjure_image = class({})

custom_terrorblade_conjure_image.duration_init = 1
custom_terrorblade_conjure_image.duration_inc = 1

custom_terrorblade_conjure_image.outgoing_inc = {10, 15, 20}

custom_terrorblade_conjure_image.double_chance = 25
custom_terrorblade_conjure_image.double_heal = 10
custom_terrorblade_conjure_image.double_radius = 1200

custom_terrorblade_conjure_image.union_move = {3, 4.5, 6}
custom_terrorblade_conjure_image.union_resist = {3, 4.5, 6}
custom_terrorblade_conjure_image.union_radius = 600

custom_terrorblade_conjure_image.incoming_health = 80
custom_terrorblade_conjure_image.incoming_damage = -60
custom_terrorblade_conjure_image.incoming_hero = -20



custom_terrorblade_conjure_image.legendary_radius = 600
custom_terrorblade_conjure_image.legendary_delay = 0.25
custom_terrorblade_conjure_image.legendary_health = 60
custom_terrorblade_conjure_image.legendary_cd = 5

custom_terrorblade_conjure_image.burn_radius = 400
custom_terrorblade_conjure_image.burn_damage = {0.2, 0.3}
custom_terrorblade_conjure_image.burn_slow = {-5, -8}
custom_terrorblade_conjure_image.burn_interval = 1



function custom_terrorblade_conjure_image:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_terror_illusion_duration") then 
	upgrade_cooldown = self.duration_init + self.duration_inc*self:GetCaster():GetUpgradeStack("modifier_terror_illusion_duration")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
end



function custom_terrorblade_conjure_image:GetIntrinsicModifierName()
return "modifier_conjure_image_tracker"
end

function custom_terrorblade_conjure_image:OnSpellStart()
	if not IsServer() then return end



	self.duration = self:GetSpecialValueFor("illusion_duration")


	self.outgoing = self:GetSpecialValueFor("illusion_outgoing_damage")
	self.incoming = self:GetSpecialValueFor("illusion_incoming_damage")

	if self:GetCaster():HasModifier("modifier_terror_illusion_incoming") then 
		self.outgoing = self.outgoing + self.outgoing_inc[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_incoming")]
	end

	local position = 108
 	local scramble = false 
 	local count = 1

 	if self:GetCaster():HasModifier("modifier_terror_illusion_resist") then 
		local chance = self.double_chance

		local random = RollPseudoRandomPercentage(chance,41,self:GetCaster())
		if random then
			count = 2
		end

	end


	local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
		outgoing_damage = self.outgoing,
		incoming_damage	= self.incoming,
		bounty_base		= nil, 
		bounty_growth	= nil,
		outgoing_damage_structure	= nil,
		outgoing_damage_roshan		= nil,
		duration		= self.duration
	}
	, count, position, scramble, true)

	if illusions then
		for _, illusion in pairs(illusions) do



		self:GetCaster():EmitSound("Hero_Terrorblade.ConjureImage")
		illusion.owner = self:GetCaster()	

		illusion:AddNewModifier(self:GetCaster(), self, "modifier_terrorblade_conjureimage", {})

	    for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
          if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
            illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
          end
        end

			illusion:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
		end
	end



end




modifier_conjure_image_tracker = class({})
function modifier_conjure_image_tracker:IsHidden() return true end
function modifier_conjure_image_tracker:IsPurgable() return false end
function modifier_conjure_image_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
	--MODIFIER_EVENT_ON_DEATH

}
end


function modifier_conjure_image_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_terror_illusion_resist") then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end
if params.target:GetUnitName() == "npc_teleport" then return end
if (self:GetParent() ~= params.attacker) and (not params.attacker.owner or params.attacker.owner ~= self:GetParent() or not params.attacker:IsIllusion()) then return end

local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, self:GetAbility().double_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false) 
	
for _,unit in pairs(all_illusions) do
	if unit == self:GetParent() or (unit.owner and unit.owner == self:GetParent() and unit:IsIllusion()) then 
		my_game:GenericHeal(unit, self:GetAbility().double_heal, self:GetAbility())
	end
end


end

function modifier_conjure_image_tracker:GetModifierIncomingDamage_Percentage()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_terror_illusion_texture") then return end
if self:GetParent():GetHealthPercent() < self:GetAbility().incoming_health then return end


if self:GetParent():IsRealHero() then 
	return self:GetAbility().incoming_hero
else 
	if self:GetParent():IsIllusion() then 
		return self:GetAbility().incoming_damage
	end
end

end


function modifier_conjure_image_tracker:OnCreated(table)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end

self:StartIntervalThink(1)
end


function modifier_conjure_image_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_terror_illusion_legendary") then return end

local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().legendary_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	
if #all_illusions > 0 and self:GetParent():HasModifier("modifier_backdoor_knock_aura_damage") then 

	for i = 1,#all_illusions do 
		if all_illusions[i] and not all_illusions[i]:HasModifier("modifier_backdoor_knock_aura_damage") then
			table.remove(all_illusions, i)
		end
	end

end




if #all_illusions > 1 and not self:GetParent():HasModifier("modifier_conjure_image_legendary_visual") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_visual", {})
end

if #all_illusions < 2 and self:GetParent():HasModifier("modifier_conjure_image_legendary_visual") then 

	self:GetParent():RemoveModifierByName("modifier_conjure_image_legendary_visual")
end


self:StartIntervalThink(0.2)
end



function modifier_conjure_image_tracker:OnDeath1(params)
if not IsServer() then return end
if self:GetParent():IsIllusion() then return end
if not params.unit:IsIllusion() then return end
if not params.unit.owner then return end
if params.unit.owner ~= self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_terror_illusion_double") then return end
if params.unit.is_reflection then return end

local particle_cast = "particles/am_spell_damage.vpcf"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN,  nil)
ParticleManager:SetParticleControl( effect_cast, 0, params.unit:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 150 , 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

params.unit:EmitSound("TB.Image_aoe")

local damage = self:GetAbility().aoe_damage[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_double")]*self:GetCaster():GetMaxHealth()

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), nil, self:GetAbility().aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false )
   
for _,unit in pairs(units) do  
    ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), })
    unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_conjure_image_legendary_aoe_slow", {duration = (1 - unit:GetStatusResistance())*self:GetAbility().aoe_slow_duration})
end

end

function modifier_conjure_image_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():GetHealth() > 1 then return end 
if self:GetParent():IsIllusion() then return end
if not self:GetParent():HasModifier("modifier_terror_illusion_legendary") then return end
if self:GetParent() ~= params.unit then return end
if params.attacker == self:GetParent() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():HasModifier("modifier_up_res") and not self:GetParent():HasModifier("modifier_up_res_cd") then return end
if self:GetParent():HasModifier("modifier_terror_meta_lowhp")
and self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis") and not self:GetParent():HasModifier("modifier_custom_terrorblade_metamorphosis_lowhp_cd") then return end
if self:GetParent():HasModifier("modifier_conjure_image_legendary_legendary_cd") then return end



local all_illusions = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().legendary_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	if #all_illusions < 1 then return end	
	for _,i in ipairs(all_illusions) do

		local barrier = true
		if self:GetParent():HasModifier("modifier_backdoor_knock_aura_damage") and not i:HasModifier("modifier_backdoor_knock_aura_damage") then 
			barrier = false
		end


		if i:IsAlive() and i:GetHealth() > 1 and barrier == true
			and i:FindModifierByName("modifier_illusion"):GetRemainingTime() > self:GetAbility().legendary_delay + 0.1 then 
			self:GetParent():SetHealth(1)

			--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_legendary_cd", {duration = self:GetAbility().legendary_cd})
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_invun", {duration = self:GetAbility().legendary_delay, target = i:entindex()})
 			i:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_legendary_invun_illusion", {})

			self:GetParent():EmitSound("TB.Image_legendary") 



 			break

		end
end


end










modifier_conjure_image_reduce_aura = class({})
function modifier_conjure_image_reduce_aura:IsHidden() return false end
function modifier_conjure_image_reduce_aura:IsPurgable() return false end
function modifier_conjure_image_reduce_aura:RemoveOnDeath() return false end
function modifier_conjure_image_reduce_aura:GetTexture() return "buffs/image_reduce" end
function modifier_conjure_image_reduce_aura:OnCreated(table)
if not IsServer() then return end
self.radius = self:GetAbility().union_radius
self:StartIntervalThink(0.3)
end


function modifier_conjure_image_reduce_aura:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsIllusion() then 

	if not self:GetParent():IsAlive() then self:SetStackCount(0) return end


	local all_illusions = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED  , FIND_CLOSEST, false) 
	local count = 0

	for _,i in ipairs(all_illusions) do 
		if not i:HasModifier("modifier_custom_terrorblade_reflection_invulnerability") and i ~= self:GetParent() then 

				local mod = i:FindModifierByName("modifier_conjure_image_reduce_aura") 
				if not mod then 
					mod = i:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_conjure_image_reduce_aura", {})
				end

				count = count + 1
			end
	end

	self:SetStackCount(count)



else
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.radius
	or not self:GetCaster():IsAlive() then self:Destroy() return end

	local mod = self:GetCaster():FindModifierByName("modifier_conjure_image_reduce_aura")
	if mod then 
		self:SetStackCount(mod:GetStackCount())
	end
end


end

function modifier_conjure_image_reduce_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end

function modifier_conjure_image_reduce_aura:GetModifierMoveSpeedBonus_Percentage() return
self:GetStackCount()*self:GetAbility().union_move[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_stack")]
end

function modifier_conjure_image_reduce_aura:GetModifierStatusResistanceStacking() return 
self:GetStackCount()*self:GetAbility().union_resist[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_stack")]
end






modifier_conjure_image_legendary_invun = class({})
function modifier_conjure_image_legendary_invun:IsHidden() return true end
function modifier_conjure_image_legendary_invun:IsPurgable() return false end
function modifier_conjure_image_legendary_invun:CheckState() 
return 
{
	[MODIFIER_STATE_INVULNERABLE] = true , 
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true
} 
end


function modifier_conjure_image_legendary_invun:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNoDraw()

ProjectileManager:ProjectileDodge(self:GetParent())

self.target = EntIndexToHScript(table.target)
self.origin = self.target:GetAbsOrigin()

local point_1 = self.origin + Vector(0,0,150)
local point_2 = self:GetParent():GetAbsOrigin() + Vector(0,0,150)
local sunder_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
ParticleManager:SetParticleControl(sunder_particle_2, 0, point_1)
ParticleManager:SetParticleControl(sunder_particle_2, 1, point_2)
ParticleManager:SetParticleControl(sunder_particle_2, 61, Vector(1,0,0))
ParticleManager:SetParticleControl(sunder_particle_2, 60, Vector(150,150,150))
ParticleManager:ReleaseParticleIndex(sunder_particle_2)

end

function modifier_conjure_image_legendary_invun:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveNoDraw()
self.origin = self.target:GetAbsOrigin()


local face_origin = self.target:GetForwardVector()*50 + self.origin

self:GetParent():SetHealth(math.max(1,self.target:GetHealth()*self:GetAbility().legendary_health/100))
	
for _,mod in ipairs(self.target:FindAllModifiers()) do 
    mod:Destroy()
end


self.target:ForceKill(false)

self:GetParent():SetOrigin(self.origin)
FindClearSpaceForUnit( self:GetParent(), self.origin, true )
if IsServer() then

   local angel = face_origin - self:GetParent():GetAbsOrigin()
   angel.z = 0.0
   angel = angel:Normalized()

   self:GetParent():SetForwardVector(angel)
   self:GetParent():FaceTowards(face_origin)
end


end



function modifier_conjure_image_legendary_invun:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH
}
end
function modifier_conjure_image_legendary_invun:GetMinHealth()
if not self:GetParent():HasModifier("modifier_death") then 
	return 1
end

end


modifier_conjure_image_legendary_invun_illusion = class({})
function modifier_conjure_image_legendary_invun_illusion:IsHidden() return true  end
function modifier_conjure_image_legendary_invun_illusion:IsPurgable() return false end
function modifier_conjure_image_legendary_invun_illusion:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true
}
end


modifier_conjure_image_legendary_aura = class({})

function modifier_conjure_image_legendary_aura:IsHidden() return true end
function modifier_conjure_image_legendary_aura:IsPurgable() return false end
function modifier_conjure_image_legendary_aura:IsDebuff() return false end



function modifier_conjure_image_legendary_aura:GetAuraRadius()
	return self:GetAbility().burn_radius
end

function modifier_conjure_image_legendary_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_conjure_image_legendary_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_conjure_image_legendary_aura:GetModifierAura()
	return "modifier_conjure_image_legendary_aura_damage"
end

function modifier_conjure_image_legendary_aura:IsAura()
	return true
end


modifier_conjure_image_legendary_aura_damage = class({})
function modifier_conjure_image_legendary_aura_damage:IsHidden() return true end
function modifier_conjure_image_legendary_aura_damage:IsPurgable() return false end
function modifier_conjure_image_legendary_aura_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_conjure_image_legendary_aura_damage:OnCreated(table)
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_conjure_image_legendary_aura_damage_count", {})

end

function modifier_conjure_image_legendary_aura_damage:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_conjure_image_legendary_aura_damage_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() < 1 then 
		mod:Destroy()
	end
end

end


modifier_conjure_image_legendary_aura_damage_count = class({})
function modifier_conjure_image_legendary_aura_damage_count:IsHidden() return false end
function modifier_conjure_image_legendary_aura_damage_count:IsPurgable() return false end
function modifier_conjure_image_legendary_aura_damage_count:GetTexture() return "buffs/illusion_burn" end

function modifier_conjure_image_legendary_aura_damage_count:OnCreated(table)
if not IsServer() then return end


self.damage = self:GetAbility().burn_interval*self:GetAbility().burn_damage[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_double")]*self:GetCaster():GetAgility()


self:SetStackCount(1)
self:StartIntervalThink(self:GetAbility().burn_interval)

end

function modifier_conjure_image_legendary_aura_damage_count:OnIntervalThink()
if not IsServer() then return end


ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetStackCount()*self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
end



function modifier_conjure_image_legendary_aura_damage_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_conjure_image_legendary_aura_damage_count:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_conjure_image_legendary_aura_damage_count:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




function modifier_conjure_image_legendary_aura_damage_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_conjure_image_legendary_aura_damage_count:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().burn_slow[self:GetCaster():GetUpgradeStack("modifier_terror_illusion_double")]*self:GetStackCount()
end


modifier_conjure_image_legendary_legendary_cd = class({})
function modifier_conjure_image_legendary_legendary_cd:IsHidden() return false end
function modifier_conjure_image_legendary_legendary_cd:IsPurgable() return false end
function modifier_conjure_image_legendary_legendary_cd:RemoveOnDeath() return false end
function modifier_conjure_image_legendary_legendary_cd:IsDebuff() return true end






modifier_conjure_image_legendary_aoe_slow = class({})
function modifier_conjure_image_legendary_aoe_slow:IsHidden() return false end
function modifier_conjure_image_legendary_aoe_slow:IsPurgable() return true end
function modifier_conjure_image_legendary_aoe_slow:GetTexture() return "buffs/step_cd" end

function modifier_conjure_image_legendary_aoe_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end
function modifier_conjure_image_legendary_aoe_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().aoe_slow
 end



function modifier_conjure_image_legendary_aoe_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end


function modifier_conjure_image_legendary_aoe_slow:OnCreated(table)
if not IsServer() then return end
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
end



function modifier_conjure_image_legendary_aoe_slow:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end


modifier_conjure_image_legendary_visual = class({})
function modifier_conjure_image_legendary_visual:IsHidden() return true end
function modifier_conjure_image_legendary_visual:IsPurgable() return false end
function modifier_conjure_image_legendary_visual:OnCreated(table)
if not IsServer() then return end

  self.effect = ParticleManager:CreateParticleForTeam("particles/tb_illusion_legendary.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent(), self:GetParent():GetTeamNumber())
  ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.effect, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.effect, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  self:AddParticle(self.effect, false, false, -1, true, false)
end









modifier_conjure_image_legendary_incoming = class({})
function modifier_conjure_image_legendary_incoming:IsHidden() return self:GetParent():GetHealthPercent() < self:GetAbility().incoming_health end
function modifier_conjure_image_legendary_incoming:IsPurgable() return false end
function modifier_conjure_image_legendary_incoming:GetTexture() return "buffs/image_damage" end
function modifier_conjure_image_legendary_incoming:RemoveOnDeath() return false end
function modifier_conjure_image_legendary_incoming:OnCreated(table)
if not IsServer() then return end
self.effect = nil

self:StartIntervalThink(0.2)
end


function modifier_conjure_image_legendary_incoming:OnIntervalThink()
if not IsServer() then return end

if self.effect == nil and self:GetParent():GetHealthPercent() >= self:GetAbility().incoming_health then 

	self.effect = ParticleManager:CreateParticle("particles/items2_fx/eternal_shroud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.effect, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.effect, 2, Vector(125, 0, 0))

end

if self.effect ~= nil and self:GetParent():GetHealthPercent() < self:GetAbility().incoming_health then 
	ParticleManager:DestroyParticle(self.effect, false)
	ParticleManager:ReleaseParticleIndex(self.effect)
	self.effect = nil

end

end


