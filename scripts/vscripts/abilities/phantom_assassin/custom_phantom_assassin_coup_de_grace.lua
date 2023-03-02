LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_legendary", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_legendaryself", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_speed", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_armor", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_blood", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_cd", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_silence", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_damage", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_kill", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_slow", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_phantom_assassin_phantom_coup_de_grace_quest", "abilities/phantom_assassin/custom_phantom_assassin_coup_de_grace", LUA_MODIFIER_MOTION_NONE )




    
custom_phantom_assassin_coup_de_grace = class({})

custom_phantom_assassin_coup_de_grace.legendary_gold_max = 250
custom_phantom_assassin_coup_de_grace.legendary_gold_avg = 350
custom_phantom_assassin_coup_de_grace.legendary_gold_k = 0.4
custom_phantom_assassin_coup_de_grace.legendary_gold_init = 100
custom_phantom_assassin_coup_de_grace.legendary_gold_net = 0.04
custom_phantom_assassin_coup_de_grace.legendary_cd = 60
custom_phantom_assassin_coup_de_grace.legendary_duration = 90
custom_phantom_assassin_coup_de_grace.legendary_chance = 10

custom_phantom_assassin_coup_de_grace.armor_reduction = {-4, -6, -8}
custom_phantom_assassin_coup_de_grace.armor_duration = 3

custom_phantom_assassin_coup_de_grace.damage_stack = {10, 20}
custom_phantom_assassin_coup_de_grace.damage_stack_max = 8


custom_phantom_assassin_coup_de_grace.silence_duration = 1
custom_phantom_assassin_coup_de_grace.silence_slow = -100


custom_phantom_assassin_coup_de_grace.resist_max = 3
custom_phantom_assassin_coup_de_grace.resist_duration = 5
custom_phantom_assassin_coup_de_grace.resist_status = {4, 6, 8}
custom_phantom_assassin_coup_de_grace.resist_move = {4, 6, 8}


custom_phantom_assassin_coup_de_grace.crit_heal = {0.1, 0.15, 0.2}

custom_phantom_assassin_coup_de_grace.kill_damage = 6
custom_phantom_assassin_coup_de_grace.kill_max = 15
custom_phantom_assassin_coup_de_grace.kill_chance = 5
custom_phantom_assassin_coup_de_grace.kill_radius = 700


custom_phantom_assassin_coup_de_grace.blood_damage = {0.15, 0.25}
custom_phantom_assassin_coup_de_grace.blood_duration = 5
custom_phantom_assassin_coup_de_grace.blood_heal = 0.7

custom_phantom_assassin_coup_de_grace.cleave_damage = {0.2, 0.3 ,0.4}
custom_phantom_assassin_coup_de_grace.cleave_slow = {-20, -30, -40}
custom_phantom_assassin_coup_de_grace.cleave_slow_duration = 2



function custom_phantom_assassin_coup_de_grace:GetIntrinsicModifierName()
  return "modifier_phantom_assassin_phantom_coup_de_grace"
end

function custom_phantom_assassin_coup_de_grace:GetBehavior()
  if self:GetCaster():HasModifier("modifier_phantom_assassin_crit_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end


function custom_phantom_assassin_coup_de_grace:OnSpellStart()
if not IsServer() then return end


  local p = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES +  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)
  
  if #p < 1 then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#vendetta_notargets"})
    return 
  end


  self:GetCaster():EmitSound("Phantom_Assassin.SuperCrit")


 local particle = ParticleManager:CreateParticle( "particles/pa_cry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() ) 
     
 ParticleManager:ReleaseParticleIndex( particle )


 self.target = p[RandomInt(1, #p)]


 if #p > 1 and self:GetCaster().last_target then 
 	repeat self.target = p[RandomInt(1, #p)]
 	until self:GetCaster().last_target ~= self.target
 end

 self:GetCaster().last_target = self.target


  self:SetActivated(false)
  local mod = self.target:AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_coup_de_grace_legendary", {duration = self.legendary_duration})
  mod.pa_mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_phantom_assassin_phantom_coup_de_grace_legendaryself", {duration = self.legendary_duration})
 

end


modifier_phantom_assassin_phantom_coup_de_grace_legendary = class({})

function modifier_phantom_assassin_phantom_coup_de_grace_legendary:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:GetTexture() return "buffs/odds_fow" end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnCreated(table) 
if not IsServer() then  return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.RemoveForDuel = true

self.duration = 0

self.gold = 0
local k = 1
local diff = 1

local net_target = PlayerResource:GetNetWorth(self:GetParent():GetPlayerOwnerID())
local net_killer = PlayerResource:GetNetWorth(self:GetCaster():GetPlayerOwnerID())

if net_target < net_killer then 
	k = -1
	diff = 1 - net_target / net_killer
else 
	diff = 1 - net_killer / net_target
end


--self.gold = math.floor(math.min((diff / self:GetAbility().legendary_gold_k), 1) * self:GetAbility().legendary_gold_max * k + self:GetAbility().legendary_gold_avg)
self.gold = self:GetAbility().legendary_gold_init + math.floor(PlayerResource:GetNetWorth(self:GetParent():GetPlayerOwnerID())*self:GetAbility().legendary_gold_net)


self.particle_trail = ParticleManager:CreateParticleForTeam("particles/lc_odd_charge_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
self:AddParticle(self.particle_trail, false, false, -1, false, false)

self.particle_trail_fx = ParticleManager:CreateParticleForTeam("particles/pa_vendetta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)

self.kill_done = false
self:StartIntervalThink(FrameTime())
end


function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), true)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'pa_hunt_think',  {hero = self:GetParent():GetUnitName(), timer = math.floor(self:GetRemainingTime()), gold = self.gold})

end


function modifier_phantom_assassin_phantom_coup_de_grace_legendary:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_DEATH,
}

end

function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnDeath(params)
if not IsServer() then return end

if params.unit == self:GetCaster() and not self:GetCaster():IsReincarnating() then 
  self:Destroy()
end

if params.unit == self:GetParent() and (self:GetCaster() == params.attacker or
    (params.attacker.owner and params.attacker.owner == self:GetCaster())) then  

    self.kill_done = true 
    self:Destroy()

end




end




function modifier_phantom_assassin_phantom_coup_de_grace_legendary:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'pa_hunt_end',  {})

self:GetAbility():SetActivated(true)

local mod = self:GetCaster():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_legendaryself")
if mod then 
  mod:Destroy()
end


self:GetAbility():StartCooldown(self:GetAbility().legendary_cd)

if self:GetParent():IsRealHero() and self.kill_done then 

  self.particle = ParticleManager:CreateParticle( "particles/pa_arc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() ) 
     
  self:GetCaster():EmitSound("Phantom_Assassin.SuperCrit")

  Timers:CreateTimer(1,function()
   ParticleManager:DestroyParticle( self.particle , false)
   ParticleManager:ReleaseParticleIndex( self.particle )
  end)


   local more_gold = self.gold

   self:GetCaster():ModifyGold(more_gold, true, DOTA_ModifyGold_HeroKill)
   SendOverheadEventMessage(self:GetCaster(), 0, self:GetCaster(), more_gold, nil)

end





end





modifier_phantom_assassin_phantom_coup_de_grace = class({})

function modifier_phantom_assassin_phantom_coup_de_grace:IsHidden()
  return true
end

function modifier_phantom_assassin_phantom_coup_de_grace:IsPurgable()
  return false
end

function modifier_phantom_assassin_phantom_coup_de_grace:OnCreated( kv )

  self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
  self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
 
end

function modifier_phantom_assassin_phantom_coup_de_grace:OnRefresh( kv )

  self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
  self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_phantom_assassin_phantom_coup_de_grace:GetCritDamage() 
local damage = self:GetAbility():GetSpecialValueFor("damage")

if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_kill") then 
	damage = damage + self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_kill"):GetStackCount()*self:GetAbility().kill_damage
end

	return damage 
end

function modifier_phantom_assassin_phantom_coup_de_grace:DeclareFunctions()
 return  {
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_DEATH
  }

end


function modifier_phantom_assassin_phantom_coup_de_grace:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if true then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_stack") then return end
if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_damage") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_damage", {target = params.target:entindex()})
end



function modifier_phantom_assassin_phantom_coup_de_grace:OnDeath(params)
if not IsServer() then return end
if self:GetParent():GetTeamNumber() == params.unit:GetTeamNumber() then return end
if not params.unit:IsRealHero() then return end
if params.unit:IsReincarnating() then return end
if ((params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self:GetAbility().kill_radius)
	and self:GetParent() ~= params.attacker then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_kill", {})
end






function modifier_phantom_assassin_phantom_coup_de_grace:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_damage") then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor ~= nil then return end
if params.unit:IsBuilding() then return end

if self.record then 

    local heal = params.damage*(self:GetAbility().crit_heal[self:GetParent():GetUpgradeStack("modifier_phantom_assassin_crit_damage")])
	SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

    self:GetParent():Heal(heal, self:GetParent())

    local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( particle )
end

end

function modifier_phantom_assassin_phantom_coup_de_grace:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end

self.record = nil

if self:GetParent():PassivesDisabled() then return end

if not self:GetParent():HasModifier("modifier_custom_phantom_assassin_fan_of_crit") then 
  if self:GetParent():HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_cd") and self:GetParent():HasModifier("modifier_phantom_assassin_crit_legendary") then return end
  if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_legendary") and not self:GetAbility():IsFullyCastable() then return end
end

if params.target:IsBuilding() then return end 
   
self.chance = self:GetAbility():GetSpecialValueFor( "chance" )


if params.target:HasModifier("modifier_phantom_assassin_phantom_coup_de_grace_legendary") then 
    self.chance = self.chance + self:GetAbility().legendary_chance
end

local mod = self:GetParent():FindModifierByName("modifier_phantom_assassin_phantom_coup_de_grace_kill")

if mod and mod:GetStackCount() >= self:GetAbility().kill_max and self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal") then 
    self.chance = self.chance + self:GetAbility().kill_chance
end


local random = RollPseudoRandomPercentage(self.chance,123,self:GetParent())


if not random and not self:GetParent():HasModifier("modifier_custom_phantom_assassin_fan_of_crit")
 then return end

self.record = params.record

self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 

if self:GetParent():HasModifier("modifier_phantom_assassin_crit_chance") then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_armor", {duration = self:GetAbility().armor_duration})
end

if mod then 
	self.damage = self.damage + mod:GetStackCount()*self:GetAbility().kill_damage
end

return self.damage

end


function modifier_phantom_assassin_phantom_coup_de_grace:GetModifierProcAttack_Feedback( params )
if self:GetParent():PassivesDisabled() then return end
if not IsServer() then return end
if not self.record or params.target:IsBuilding() then return end

if self:GetParent():GetQuest() == "Phantom.Quest_8" and params.target:IsRealHero() then 
  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_quest", {duration = 3})
end


if self:GetParent():HasModifier("modifier_phantom_assassin_crit_stack") then 
  local damage = params.damage*(self:GetAbility().blood_damage[self:GetParent():GetUpgradeStack("modifier_phantom_assassin_crit_stack")])

  params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_blood", {duration = self:GetAbility().blood_duration, damage = damage})
 end


if false  then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_speed", {duration = self:GetAbility().resist_duration})
end

if self:GetParent():HasModifier("modifier_phantom_assassin_crit_lowhp") and not params.target:IsMagicImmune() then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_silence", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().silence_duration})
end



if self:GetParent():HasModifier("modifier_phantom_assassin_crit_speed") and not self:GetParent():HasModifier("modifier_custom_phantom_assassin_fan_of_crit") then 
  DoCleaveAttack(self:GetParent(), params.target, nil, params.damage*(self:GetAbility().cleave_damage[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_speed")]), 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")

  params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_slow", {duration = self:GetAbility().cleave_slow_duration*(1 - params.target:GetStatusResistance())})
end

      
self:PlayEffects( params.target )

if self:GetParent():HasModifier("modifier_custom_phantom_assassin_fan_of_crit") then 
  self:GetParent():RemoveModifierByName("modifier_custom_phantom_assassin_fan_of_crit")
  return
end

if self:GetParent():HasModifier("modifier_phantom_assassin_crit_legendary") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phantom_assassin_phantom_coup_de_grace_cd", {duration = self:GetAbility().BaseClass.GetCooldown(self:GetAbility(), self:GetAbility():GetLevel())})
else 
	self:GetAbility():UseResources(false, false, true)
end

end




function modifier_phantom_assassin_phantom_coup_de_grace:PlayEffects( target )

local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"

local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt(coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(coup_pfx, 1, target:GetAbsOrigin())
        local line = (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
        ParticleManager:SetParticleControlOrientation(coup_pfx, 1, line*-1, self:GetParent():GetRightVector(), self:GetParent():GetUpVector())
        ParticleManager:ReleaseParticleIndex(coup_pfx)

      target:EmitSound(sound_cast)

     if self:GetCaster():GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl" then 
       target:EmitSound("Hero_PhantomAssassin.Arcana_Layer")
        local coup_pfx = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControlEnt(coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(coup_pfx, 1, target:GetAbsOrigin())
        local line = (target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
        ParticleManager:SetParticleControlOrientation(coup_pfx, 1, line*-1, self:GetParent():GetRightVector(), self:GetParent():GetUpVector())
        ParticleManager:ReleaseParticleIndex(coup_pfx)

       
    end


end







modifier_phantom_assassin_phantom_coup_de_grace_armor = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_armor:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_armor:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_armor:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
}
end

function modifier_phantom_assassin_phantom_coup_de_grace_armor:OnCreated(table)
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_phantom_assassin_phantom_coup_de_grace_armor:GetModifierPhysicalArmorBonus() 
	return self:GetAbility().armor_reduction[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_chance")]
end




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------ТАЛАНТ CКОРОСТЬ--------------------------------------------------------------------------------------------
modifier_phantom_assassin_phantom_coup_de_grace_speed = class({})


function modifier_phantom_assassin_phantom_coup_de_grace_speed:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_speed:IsPurgable() return true end


function modifier_phantom_assassin_phantom_coup_de_grace_speed:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self:GetAbility().resist_max then 
	self:IncrementStackCount()
	if self:GetStackCount() == self:GetAbility().resist_max then 
		local particle = ParticleManager:CreateParticle( "particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		self:AddParticle( particle, false, false, -1, false, false  )
	end

end

end

function modifier_phantom_assassin_phantom_coup_de_grace_speed:GetTexture() return "buffs/Crit_speed" end

function modifier_phantom_assassin_phantom_coup_de_grace_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end





function modifier_phantom_assassin_phantom_coup_de_grace_speed:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility().resist_move[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_speed")]*self:GetStackCount()
 end




function modifier_phantom_assassin_phantom_coup_de_grace_speed:GetModifierStatusResistanceStacking()
	return self:GetAbility().resist_status[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_speed")]*self:GetStackCount()
 end





modifier_phantom_assassin_phantom_coup_de_grace_legendaryself = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_legendaryself:GetTexture() return "buffs/odds_fow" end



modifier_phantom_assassin_phantom_coup_de_grace_blood = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_blood:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:GetTexture() return "buffs/Crit_blood" end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_phantom_assassin_phantom_coup_de_grace_blood:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

self.damage = table.damage/self:GetRemainingTime()

self:StartIntervalThink(1)
end 

function modifier_phantom_assassin_phantom_coup_de_grace_blood:OnIntervalThink()
if not IsServer() then return end


local damageTable = 
{
  victim      = self:GetParent(),
  damage      = self.damage,
  damage_type   = DAMAGE_TYPE_MAGICAL,
  damage_flags  = DOTA_DAMAGE_FLAG_NONE,
  attacker    = self:GetCaster(),
  ability     = self:GetAbility()
}
                  
ApplyDamage(damageTable)
      
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)

if self:GetCaster() and self:GetCaster():IsAlive() then 
  my_game:GenericHeal(self:GetCaster(), self.damage*self:GetAbility().blood_heal, self:GetAbility())
end

end





modifier_phantom_assassin_phantom_coup_de_grace_cd = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_cd:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_cd:IsPurgable() return false end




modifier_phantom_assassin_phantom_coup_de_grace_silence = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_silence:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_silence:IsPurgable() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetTexture() return "buffs/strike_stack" end
function modifier_phantom_assassin_phantom_coup_de_grace_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


function modifier_phantom_assassin_phantom_coup_de_grace_silence:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_phantom_assassin_phantom_coup_de_grace_silence:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().silence_slow
end




modifier_phantom_assassin_phantom_coup_de_grace_damage = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_damage:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_damage:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_damage:GetTexture() return "buffs/culling_attack" end
function modifier_phantom_assassin_phantom_coup_de_grace_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_phantom_assassin_phantom_coup_de_grace_damage:OnTooltip()
return self:GetAbility().damage_stack[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_stack")]*self:GetStackCount()
end

function modifier_phantom_assassin_phantom_coup_de_grace_damage:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
self.target = EntIndexToHScript(table.target)
end



function modifier_phantom_assassin_phantom_coup_de_grace_damage:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_phantom_assassin_phantom_coup_de_grace_damage:OnTooltip()
return self:GetAbility():GetSpecialValueFor("damage") + self:GetStackCount()*self:GetAbility().damage_stack[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_stack")]
end

function modifier_phantom_assassin_phantom_coup_de_grace_damage:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_custom_phantom_assassin_stifling_dagger_attack") then return end
if self:GetParent():HasModifier("modifier_custom_phantom_assassin_fan_of_crit_2") then return end

if params.target == self.target then 
	if self:GetStackCount() < self:GetAbility().damage_stack_max then 
		self:IncrementStackCount()
	end
else
	self:Destroy()
end

end



function modifier_phantom_assassin_phantom_coup_de_grace_damage:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 1 then 
    self.effect_cast = ParticleManager:CreateParticle( "particles/axe_culling_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    self:AddParticle(self.effect_cast,false, false, -1, false, false)
end 

if self.effect_cast then 
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

end


modifier_phantom_assassin_phantom_coup_de_grace_kill = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_kill:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:RemoveOnDeath() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:GetTexture() return "buffs/crit_resist" end
--function modifier_phantom_assassin_phantom_coup_de_grace_kill:GetEffectName() return "particles/lc_odd_proc_hands.vpcf" end
function modifier_phantom_assassin_phantom_coup_de_grace_kill:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnTooltip()
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal") then return end
return self:GetAbility().kill_damage*self:GetStackCount()
end

function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnTooltip2()
if not self:GetParent():HasModifier("modifier_phantom_assassin_crit_steal") then return end
if self:GetStackCount() < self:GetAbility().kill_max then return end
return self:GetAbility().kill_chance
end


function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_kill:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().kill_max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().kill_max then 

  local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)
  self:GetCaster():EmitSound("BS.Thirst_legendary_active")
end

end


modifier_phantom_assassin_phantom_coup_de_grace_slow = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_slow:IsHidden() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_slow:IsPurgable() return true end



function modifier_phantom_assassin_phantom_coup_de_grace_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_phantom_assassin_phantom_coup_de_grace_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().cleave_slow[self:GetCaster():GetUpgradeStack("modifier_phantom_assassin_crit_speed")]
end






modifier_phantom_assassin_phantom_coup_de_grace_quest = class({})
function modifier_phantom_assassin_phantom_coup_de_grace_quest:IsHidden() return true end
function modifier_phantom_assassin_phantom_coup_de_grace_quest:IsPurgable() return false end
function modifier_phantom_assassin_phantom_coup_de_grace_quest:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_phantom_assassin_phantom_coup_de_grace_quest:OnRefresh(table)
if not IsServer() then return end
if not self:GetCaster():GetQuest() then return end

self:IncrementStackCount()


if self:GetStackCount() >= self:GetCaster().quest.number then 
  self:GetCaster():UpdateQuest(1)
  self:Destroy()
end

end