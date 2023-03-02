LinkLuaModifier( "modifier_monkey_king_primal_spring_custom", "abilities/monkey_king/monkey_king_primal_spring_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_speed", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_instant", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_tracker", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_banana", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_legendary", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_invul", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_incoming", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)



monkey_king_primal_spring_custom = class({})

monkey_king_primal_spring_custom.range_speed_duration = 3
monkey_king_primal_spring_custom.range_bonus = {100,150,200}
monkey_king_primal_spring_custom.range_speed = {10, 15, 20}

monkey_king_primal_spring_custom.damage_bonus = {0.08, 0.12, 0.16}
monkey_king_primal_spring_custom.damage_creeps = 0.33

monkey_king_primal_spring_custom.incoming = {20, 30, 40}
monkey_king_primal_spring_custom.incoming_duration = 4
monkey_king_primal_spring_custom.incoming_cast = {-0.4, -0.6, -0.8}

monkey_king_primal_spring_custom.double_k = {0.5, 0.8}
monkey_king_primal_spring_custom.double_duration = 6

monkey_king_primal_spring_custom.silence_duration = 3
monkey_king_primal_spring_custom.silence_radius = 100

monkey_king_primal_spring_custom.legendary_radius = 120
monkey_king_primal_spring_custom.legendary_duration = 60
monkey_king_primal_spring_custom.legendary_duration_buff = 100
monkey_king_primal_spring_custom.legendary_banana_cd = 5
monkey_king_primal_spring_custom.legendary_cd = -9
monkey_king_primal_spring_custom.legendary_vision = 500



function monkey_king_primal_spring_custom:OnUpgrade()
if self:GetLevel() == 1 then 
self:SetActivated(false)
end

end


function monkey_king_primal_spring_custom:GetChannelTime()

local bonus = 0

if self:GetCaster():HasModifier("modifier_monkey_king_tree_3") then 
  bonus = self.incoming_cast[self:GetCaster():GetUpgradeStack("modifier_monkey_king_tree_3")]
end

return self:GetSpecialValueFor( "channel_time" ) + bonus
end



function monkey_king_primal_spring_custom:GetAOERadius()
local bonus = 0
if self:GetCaster():HasModifier("modifier_monkey_king_tree_6") then 
  bonus = self.silence_radius
end
return self:GetSpecialValueFor("impact_radius") + bonus
end

function monkey_king_primal_spring_custom:GetCastRange(location, target)
if IsServer() then 
  return 99999
else 


  local bonus = 0
  local k = 1
  if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
    k = self.double_k[self:GetCaster():GetUpgradeStack("modifier_monkey_king_tree_4")]
  end

  if self:GetCaster():HasModifier("modifier_monkey_king_tree_1") then
    bonus = self.range_bonus[self:GetCaster():GetUpgradeStack('modifier_monkey_king_tree_1')]
  end
  return (self:GetSpecialValueFor( "max_distance" ) + bonus)*k

end

end



function monkey_king_primal_spring_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") then 
  bonus = self.legendary_cd
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end




function monkey_king_primal_spring_custom:GetIntrinsicModifierName()
return "modifier_monkey_king_primal_spring_custom_tracker"
end





function monkey_king_primal_spring_custom:OnSpellStart()
  -- unit identifier
  local caster = self:GetCaster()
  local point = self:GetCursorPosition()

  self.max_distance = self:GetSpecialValueFor( "max_distance" ) + self:GetCaster():GetCastRangeBonus()

  if self:GetCaster():HasModifier("modifier_monkey_king_tree_1") then
    self.max_distance = self.max_distance + self.range_bonus[self:GetCaster():GetUpgradeStack('modifier_monkey_king_tree_1')]
  end


  if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
    self.max_distance = self.max_distance*self.double_k[self:GetCaster():GetUpgradeStack("modifier_monkey_king_tree_4")]
  end


  local radius = self:GetSpecialValueFor( "impact_radius" )

  local direction = (point-caster:GetOrigin())

  direction.z = 0
  if direction:Length2D() > self.max_distance  then
    point = caster:GetOrigin() + direction:Normalized() * self.max_distance
    point.z = GetGroundHeight( point, caster )
  end

  AddFOWViewer(self:GetCaster():GetTeamNumber(), point, radius, 2, false)

  self:GetCaster():StartGesture(ACT_DOTA_MK_SPRING_CAST)

  self.point = point

 
  if not self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then 
    self:GetCaster():SetOrigin(Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, self:GetCaster():GetAbsOrigin().z + 50))
  end

  if self.point == self:GetCaster():GetAbsOrigin() then 
    self.point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*25
  end


  if not self.sub then

    local sub = caster:FindAbilityByName( 'monkey_king_primal_spring_early_custom' )
    if not sub then
      sub = caster:AddAbility( 'monkey_king_primal_spring_early_custom' )
    end
    self.sub = sub
    self.sub.main = self
  end

  self.sub:SetLevel( self:GetLevel() )


  self:PlayEffects1()
  self:PlayEffects2( self.point )
  self.new_pct = 0


  if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
      self.new_pct = self.double_k[self:GetCaster():GetUpgradeStack("modifier_monkey_king_tree_4")]
      self:GetCaster():RemoveModifierByName("modifier_monkey_king_primal_spring_custom_instant")
      self:GetCaster():Interrupt()
  else 

    caster:SwapAbilities( 'monkey_king_primal_spring_custom', 'monkey_king_primal_spring_early_custom',  false, true )
  end

end



function monkey_king_primal_spring_custom:OnChannelFinish( bInterrupted )

  self:GetCaster():FadeGesture(ACT_DOTA_MK_SPRING_CAST)
  self:GetCaster():FadeGesture(ACT_DOTA_MK_SPRING_END)

  self:GetCaster():SetOrigin(Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, self:GetCaster():GetAbsOrigin().z - 50))

  local caster = self:GetCaster()
  local point = self.point
  local channel_pct =  math.min(1, (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime() + 0.01)

  -- limit distance
  local direction = (point-caster:GetOrigin())
  direction.z = 0
  if direction:Length2D()> self.max_distance then
    point = caster:GetOrigin() + direction:Normalized() * self.max_distance
    point.z = GetGroundHeight( point, caster )
  end

  if self.new_pct ~= 0 then 
    channel_pct = self.new_pct
  end

  -- load data
  local damage = self:GetSpecialValueFor( "impact_damage" )*channel_pct
  local slow = self:GetSpecialValueFor( "impact_movement_slow" )*channel_pct
  local duration = self:GetSpecialValueFor( "impact_slow_duration" )
  local radius = self:GetSpecialValueFor( "impact_radius" )

  if self:GetCaster():HasModifier("modifier_monkey_king_tree_6") then 
    radius = radius + self.silence_radius
  end

  local speed = self:GetSpecialValueFor( "speed" )
  local distance = (point-caster:GetOrigin()):Length2D()


  local perch_height = -192
 
  if not self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then 
    perch_height = 0
  end


  local height = 150
  if distance < 80 then 
    height = 0
  end

  self:GetCaster():FaceTowards(point)
  self:GetCaster():SetForwardVector(direction)

  if self:GetCaster():HasModifier("modifier_monkey_king_tree_4") and channel_pct > 0.98 and self.new_pct == 0 then 

    self:EndCooldown()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_primal_spring_custom_instant", {duration = self.double_duration})

    local particle = ParticleManager:CreateParticle("particles/mk_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)
    
    self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")  

  end

  

  -- jump
  local arc = caster:AddNewModifier(
    caster,
    self,
    "modifier_generic_arc",
    {
      target_x = point.x,
      target_y = point.y,
      distance = distance,
      speed = speed,
      height = height,
      fix_end = false,
      isStun = true,
      activity = ACT_DOTA_MK_SPRING_SOAR,
      end_offset = perch_height,
      end_anim = ACT_DOTA_MK_SPRING_END,

    }
  )


  if self.sub and self.sub:IsHidden() == false then
    caster:SwapAbilities( 'monkey_king_primal_spring_custom', 'monkey_king_primal_spring_early_custom', true, false)
  end

  self:StopEffects()

if not arc then return end
  self:PlayEffects4( arc )

  arc:SetEndCallback(function()

    if self:GetCaster():HasModifier("modifier_monkey_king_tree_3") and channel_pct > 0.98 then 
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_primal_spring_incoming", { duration = self.incoming_duration})
    end

    if self:GetCaster():HasModifier("modifier_monkey_king_tree_1") then 
      self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_movespeed",
      {
        movespeed = self.range_speed[self:GetCaster():GetUpgradeStack("modifier_monkey_king_tree_1")],
        effect = "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf",
        duration = self.range_speed_duration
      })
    end

    local dir = self:GetCaster():GetForwardVector()
    dir.z = 0

    if (self:GetCaster():GetAbsOrigin() - point):Length2D() > 200 then 
      FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)
      return 
    end

    FindClearSpaceForUnit(self:GetCaster(), point, false)
    self:GetCaster():SetForwardVector(dir)


    local ability = self:GetCaster():FindAbilityByName("monkey_king_wukongs_command_custom") 
    if ability and ability:GetLevel() > 0 and self:GetCaster():HasModifier("modifier_monkey_king_command_4") then 
      ability:SpawnMonkeyKingPointScepter(self:GetCaster():GetAbsOrigin(), ability.spells_duration, true)
    end


    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    local damageTable = {attacker = caster, damage = damage, damage_type = self:GetAbilityDamageType(), ability = self,}

    for _,enemy in pairs(enemies) do

      local bonus = 0
      if self:GetCaster():HasModifier("modifier_monkey_king_tree_2") then 
        bonus = enemy:GetMaxHealth()*self.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_monkey_king_tree_2")]*channel_pct
        
        if enemy:IsCreep() then 
          bonus = bonus*self.damage_creeps
        end


        SendOverheadEventMessage(enemy, 4, enemy, bonus, nil)     
      end
      
      if self:GetCaster():GetQuest() == "Monkey.Quest_6" and channel_pct > 0.98 and enemy:IsRealHero() then 
        self:GetCaster():UpdateQuest(1)
      end

      damageTable.damage = damage + bonus

      damageTable.victim = enemy
      ApplyDamage(damageTable)

      if self:GetCaster():HasModifier("modifier_monkey_king_tree_6") then
        local duration = self.silence_duration*channel_pct
        enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_silence", {duration = (1 - enemy:GetStatusResistance())*duration})
      end

      local mod = enemy:FindModifierByName("modifier_monkey_king_primal_spring_custom")
      if not mod then 
        mod = enemy:AddNewModifier( caster, self, "modifier_monkey_king_primal_spring_custom", {duration = duration})
      end

      if mod and mod:GetStackCount() < slow then 
        mod:SetStackCount(slow)
      end

    end
 
    self:PlayEffects3( point, radius )
  end)

end

--------------------------------------------------------------------------------
-- Graphics & Animations
function monkey_king_primal_spring_custom:PlayEffects1()
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring_channel.vpcf"

  -- Get Data
  local caster = self:GetCaster()

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
  ParticleManager:SetParticleControlEnt(
    effect_cast,
    1,
    caster,
    PATTACH_POINT_FOLLOW,
    "attach_hitloc",
    Vector(0,0,0), -- unknown
    true -- unknown, true
  )
  -- ParticleManager:ReleaseParticleIndex( effect_cast )
  self.effect_cast1 = effect_cast
end

function monkey_king_primal_spring_custom:PlayEffects2( point )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring_cast.vpcf"
  local sound_cast = "Hero_MonkeyKing.Spring.Channel"

  -- Get Data
  local caster = self:GetCaster()

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
  ParticleManager:SetParticleControl( effect_cast, 0, point )
  ParticleManager:SetParticleControl( effect_cast, 4, point )
  -- ParticleManager:ReleaseParticleIndex( effect_cast )

  -- Create Sound
  EmitSoundOnLocationWithCaster( point, sound_cast, caster )

  self.effect_cast2 = effect_cast
end

function monkey_king_primal_spring_custom:StopEffects()
  ParticleManager:DestroyParticle( self.effect_cast1, false )
  ParticleManager:DestroyParticle( self.effect_cast2, false )
  ParticleManager:ReleaseParticleIndex( self.effect_cast1 )
  ParticleManager:ReleaseParticleIndex( self.effect_cast2 )

  local sound_cast = "Hero_MonkeyKing.Spring.Channel"
  StopSoundOn( sound_cast, caster )
end

function monkey_king_primal_spring_custom:PlayEffects3( point, radius )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring.vpcf"
  local sound_cast = "Hero_MonkeyKing.Spring.Impact"

  -- Get Data
  local caster = self:GetCaster()

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
  ParticleManager:SetParticleControl( effect_cast, 0, point )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  -- Create Sound
  EmitSoundOnLocationWithCaster( point, sound_cast, caster )
end

function monkey_king_primal_spring_custom:PlayEffects4( modifier )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf"
  local sound_cast = "Hero_MonkeyKing.TreeJump.Cast"

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

  -- buff particle
  modifier:AddParticle(
    effect_cast,
    false, -- bDestroyImmediately
    false, -- bStatusEffect
    -1, -- iPriority
    false, -- bHeroEffect
    false -- bOverheadEffect
  )
  self:GetCaster():EmitSound(sound_cast)
end





modifier_monkey_king_primal_spring_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_monkey_king_primal_spring_custom:IsHidden()
  return false
end

function modifier_monkey_king_primal_spring_custom:IsPurgable()
  return true
end

--------------------------------------------------------------------------------
-- Initializations

function modifier_monkey_king_primal_spring_custom:OnRefresh( kv )
self:OnCreated(kv)

end

function modifier_monkey_king_primal_spring_custom:OnRemoved()
end

function modifier_monkey_king_primal_spring_custom:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_monkey_king_primal_spring_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }

  return funcs
end

function modifier_monkey_king_primal_spring_custom:GetModifierMoveSpeedBonus_Percentage()
  return -self:GetStackCount()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_monkey_king_primal_spring_custom:GetEffectName()
  return "particles/units/heroes/hero_monkey_king/monkey_king_spring_slow.vpcf"
end

function modifier_monkey_king_primal_spring_custom:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_monkey_king_primal_spring_custom:GetStatusEffectName()
  return "particles/status_fx/status_effect_monkey_king_spring_slow.vpcf"
end

function modifier_monkey_king_primal_spring_custom:StatusEffectPriority()
  return MODIFIER_PRIORITY_NORMAL
end




monkey_king_primal_spring_early_custom = class({})
function monkey_king_primal_spring_early_custom:OnSpellStart()
  self.main:EndChannel( true )
end



modifier_monkey_king_primal_spring_custom_instant = class({})
function modifier_monkey_king_primal_spring_custom_instant:IsHidden() return false end
function modifier_monkey_king_primal_spring_custom_instant:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_instant:GetTexture() return "buffs/spring_double" end
function modifier_monkey_king_primal_spring_custom_instant:GetEffectName() return "particles/mk_double_proc.vpcf"
end

function modifier_monkey_king_primal_spring_custom_instant:OnCreated(table)
if not IsServer() then return end
self:GetAbility():SetActivated(true)

end

function modifier_monkey_king_primal_spring_custom_instant:OnDestroy()
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_monkey_king_tree_dance_custom") and not self:GetParent():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") then 
  self:GetAbility():SetActivated(false)
end

end








modifier_monkey_king_primal_spring_custom_tracker = class({})
function modifier_monkey_king_primal_spring_custom_tracker:IsHidden() return true end
function modifier_monkey_king_primal_spring_custom_tracker:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_tracker:OnCreated(table)
if not IsServer() then return end
self:GetAbility().banana = nil
self:GetAbility().banana_cd = 0

self:StartIntervalThink(1)
end

function modifier_monkey_king_primal_spring_custom_tracker:OnIntervalThink()
if not IsServer() then return end



if not self:GetParent():HasModifier("modifier_monkey_king_tree_7") then return end
local show_timer = true 

if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") then 
  show_timer = false

  local time = math.max(0, math.floor(self:GetCaster():FindModifierByName("modifier_monkey_king_primal_spring_custom_legendary"):GetRemainingTime()))
  local max_time = self:GetAbility().legendary_duration_buff

  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'mk_banana_change',  
    {
      buff_timer = time,
      max_time = max_time,
    })
end


if self:GetAbility().banana ~= nil then
  local banana_timer = math.max(0, math.floor(self:GetAbility().banana:FindModifierByName("modifier_monkey_king_primal_spring_custom_banana"):GetRemainingTime()))

  if show_timer == true then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'mk_banana_change',  
      { 
        buff_timer = -1,
        banana_timer = banana_timer
      })
  end
  return
end

if self:GetAbility().banana_cd > 0 then 
  self:GetAbility().banana_cd = self:GetAbility().banana_cd - 1
  return
end

local point = Vector(RandomInt(-7800,7800), RandomInt(-7800,7800), 215)

self:GetAbility().banana = CreateUnitByName("npc_monkey_king_banana", point, true, nil, nil, self:GetCaster():GetTeamNumber())

self:GetAbility().banana:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monkey_king_primal_spring_custom_banana", {duration = self:GetAbility().legendary_duration})
GameRules:ExecuteTeamPing(self:GetCaster():GetTeamNumber(), point.x, point.y, self:GetCaster(), 0 )


FindClearSpaceForUnit(self:GetAbility().banana, self:GetAbility().banana:GetAbsOrigin(), false)

end



function modifier_monkey_king_primal_spring_custom_tracker:DeclareFunctions()
return
{
  --MODIFIER_EVENT_ON_DEATH
}
end

function modifier_monkey_king_primal_spring_custom_tracker:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

local ability = self:GetParent():FindAbilityByName("monkey_king_primal_spring_early_custom")
if ability and not ability:IsHidden() then 
  self:GetParent():SwapAbilities("monkey_king_primal_spring_early_custom", "monkey_king_primal_spring_custom", false, true)
end

end


modifier_monkey_king_primal_spring_custom_banana = class({})
function modifier_monkey_king_primal_spring_custom_banana:IsHidden() return true end
function modifier_monkey_king_primal_spring_custom_banana:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_banana:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
}
end

function modifier_monkey_king_primal_spring_custom_banana:OnCreated(table)
if not IsServer() then return end

local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, self:GetParent():GetAbsOrigin())
self:GetParent():EmitSound("Hero_MonkeyKing.Transform.On")

self.particle_ally_fx = ParticleManager:CreateParticleForTeam("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

self:StartIntervalThink(0.2)
end


function modifier_monkey_king_primal_spring_custom_banana:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end
AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility().legendary_vision, 0.2, false)

if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self:GetAbility().legendary_radius 
  and self:GetCaster():IsAlive() then 


  self:GetCaster():EmitSound("MK.Tree_legendary_buff")
  local particle_peffect = ParticleManager:CreateParticle("particles/mk_buff_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)


  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monkey_king_primal_spring_custom_legendary", {duration = self:GetAbility().legendary_duration_buff})

  local minute = math.floor(GameRules:GetDOTATime(false, false) / 60)
  local gold = bounty_gold_init + minute * bounty_gold_per_minute
  local blue = bounty_blue_init + minute * bounty_blue_per_minute
  my_game:AddBluePoints(self:GetCaster(), blue)

  self:GetCaster():ModifyGold(gold, true, DOTA_ModifyGold_BountyRune)
  SendOverheadEventMessage(self:GetCaster(), 0, self:GetCaster(), gold, nil)
  self:GetCaster():EmitSound("MK.Tree_bounty")

  self:Destroy()
end

end


function modifier_monkey_king_primal_spring_custom_banana:OnDestroy()
if not IsServer() then return end

  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, self:GetParent():GetAbsOrigin())
  self:GetParent():EmitSound("Hero_MonkeyKing.Transform.On")

  self:GetAbility().banana_cd = self:GetRemainingTime()
  self:GetAbility().banana = nil
  UTIL_Remove(self:GetParent())
end




modifier_monkey_king_primal_spring_custom_legendary = class({})
function modifier_monkey_king_primal_spring_custom_legendary:IsHidden() return false end
function modifier_monkey_king_primal_spring_custom_legendary:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_legendary:GetTexture() return "buffs/rebound_resist" end
function modifier_monkey_king_primal_spring_custom_legendary:RemoveOnDeath() return false end
function modifier_monkey_king_primal_spring_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_shredder_whirl.vpcf" end
function modifier_monkey_king_primal_spring_custom_legendary:StatusEffectPriority() return 111111 end
function modifier_monkey_king_primal_spring_custom_legendary:OnCreated(table)
if not IsServer() then return end

self:GetAbility():SetActivated(true)

self.particle_ally_fx = ParticleManager:CreateParticle("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 
end

function modifier_monkey_king_primal_spring_custom_legendary:OnDestroy()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_monkey_king_tree_dance_custom") and not self:GetParent():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
  self:GetAbility():SetActivated(false)
end

end


modifier_monkey_king_primal_spring_custom_invul = class({})
function modifier_monkey_king_primal_spring_custom_invul:IsHidden() return true end
function modifier_monkey_king_primal_spring_custom_invul:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_invul:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end 


modifier_monkey_king_primal_spring_incoming = class({})
function modifier_monkey_king_primal_spring_incoming:IsHidden() return false end
function modifier_monkey_king_primal_spring_incoming:IsPurgable() return true end
function modifier_monkey_king_primal_spring_incoming:GetTexture() return "buffs/leap_shield" end
function modifier_monkey_king_primal_spring_incoming:OnCreated(table)
if not IsServer() then return end

  self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
  self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
  self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
  self.sound = "Hero_Pangolier.TailThump.Shield"
  self.buff_particles = {}
  self.part = true
  self:GetCaster():EmitSound( self.sound)


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



function modifier_monkey_king_primal_spring_incoming:DeclareFunctions()
return
{
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_monkey_king_primal_spring_incoming:GetModifierIncomingDamage_Percentage() return 
self:GetAbility().incoming[self:GetCaster():GetUpgradeStack("modifier_monkey_king_tree_3")]
end



