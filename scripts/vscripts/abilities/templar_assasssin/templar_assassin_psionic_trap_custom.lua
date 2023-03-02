LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_counter", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_debuff", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_vision", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_illusion", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_legendary", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_incoming", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )


-- Способность поставить ловушку

templar_assassin_psionic_trap_custom = class({})
templar_assassin_psionic_trap_custom_2 = class({})

templar_assassin_psionic_trap_custom.blast_damage = {50, 100, 150}

templar_assassin_psionic_trap_custom.charge_timer = 0.5

templar_assassin_psionic_trap_custom.vision_duration = 40

templar_assassin_psionic_trap_custom.illusion_damage = {0.02, 0.03}
templar_assassin_psionic_trap_custom.illusion_duration = 4
templar_assassin_psionic_trap_custom.illusion_max = 1
templar_assassin_psionic_trap_custom.illusion_creeps = 0.25

templar_assassin_psionic_trap_custom.incoming_damage = {6,9,12}

templar_assassin_psionic_trap_custom.heal = {0.1, 0.15, 0.2}

function templar_assassin_psionic_trap_custom:GetIntrinsicModifierName()
    return "modifier_templar_assassin_psionic_trap_custom_counter"
end



function templar_assassin_psionic_trap_custom:ExplodeTrap(point, timer, double)
if not IsServer() then return end

local min_silence = self:GetSpecialValueFor("shard_min_silence")
local max_silence = self:GetSpecialValueFor("shard_max_silence")

local max_timer = self:GetSpecialValueFor("trap_max_charge_duration")

if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_5") then 
    max_timer = max_timer - self.charge_timer
end



if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_4") and (self:GetCaster():GetAbsOrigin() - point):Length2D() < 2000 then 

    local count = 0

    for _,illusion in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)) do
        if illusion:IsIllusion() and illusion.templar_illusion == true then 
            count = count + 1
        end
    end

    if count < self.illusion_max then

        local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=self.illusion_duration, outgoing_damage= -100,incoming_damage=0}, 1, 0, false, false )  
        for k, v in pairs(illusion) do

            for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
                 if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
                    v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
                end
            end

            v.templar_illusion = true
            v.owner = self:GetCaster()
            FindClearSpaceForUnit(v, point, true)

            v:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_illusion", {})
            Timers:CreateTimer(0.1, function()
                v:MoveToPositionAggressive(v:GetAbsOrigin())
            end)
        end
    end
end


local explode_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(explode_particle, 0, point)
ParticleManager:ReleaseParticleIndex(explode_particle)

EmitSoundOnLocationWithCaster(point, "Hero_TemplarAssassin.Trap.Explode", self:GetCaster())

local radius = self:GetCaster():FindAbilityByName("templar_assassin_trap_custom"):GetSpecialValueFor("trap_radius")

local search = DOTA_UNIT_TARGET_TEAM_ENEMY
if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_3") then 
    search = DOTA_UNIT_TARGET_TEAM_BOTH
end

if timer == max_timer and double == 1 then 
    self:SetTrap(point, nil, false)

end


for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, search , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
     
    if enemy:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 


        local duration = self:GetSpecialValueFor("trap_duration_tooltip")*(1 - enemy:GetStatusResistance())

        if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_2") and timer == max_timer then 
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_incoming", {duration = duration})
        end

        enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_debuff", {duration = duration, active = timer == max_timer, timer = timer})
        
        if self:GetCaster():HasShard() then
            local silence_duration = math.max(min_silence, (max_silence * (tonumber(timer)/max_timer)))
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_silence", {duration = silence_duration*(1 - enemy:GetStatusResistance())})
        end
    else 
        local heal = self:GetCaster():GetMaxHealth()*self.heal[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_psionic_3")] * (timer/max_timer)
        my_game:GenericHeal(self:GetCaster(), heal, self)
    end

end

end



function templar_assassin_psionic_trap_custom:OnAbilityPhaseStart()
if not self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7") then return true end
if not self:GetCursorTarget() then return true end

if self:GetCursorTarget():HasModifier("modifier_templar_assassin_psionic_trap_custom_trap_legendary") then  
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#has_trap"})
    return false
end

return true
end

function templar_assassin_psionic_trap_custom_2:OnAbilityPhaseStart()
if not self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7") then return true end
if not self:GetCursorTarget() then return true end

if self:GetCursorTarget():HasModifier("modifier_templar_assassin_psionic_trap_custom_trap_legendary") then  
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#has_trap"})

    return false
end

return true
end


function templar_assassin_psionic_trap_custom:GetBehavior()
    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7") then
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end



function templar_assassin_psionic_trap_custom_2:GetBehavior()
    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7") then
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end




function templar_assassin_psionic_trap_custom:OnSpellStart()
if not IsServer() then return end
self:SetTrap(self:GetCursorPosition(), self:GetCursorTarget(), self:GetCaster():HasModifier("modifier_templar_assassin_psionic_6"))
end

function templar_assassin_psionic_trap_custom:SetTrap(point, target, double)
if not IsServer() then return end

local max_timer = self:GetSpecialValueFor("trap_max_charge_duration")

if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_5") then 
    max_timer = max_timer - self.charge_timer
end


self:GetCaster():EmitSound("Hero_TemplarAssassin.Trap.Cast")


if target then 
    local target = self:GetCursorTarget()
    target:EmitSound("Hero_TemplarAssassin.Trap")
    target:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_legendary", {duration = max_timer, double = double})
else 

    local max_traps = self:GetSpecialValueFor("max_traps")
    if self:GetCaster():HasShard() then
       max_traps = max_traps + self:GetSpecialValueFor("shard_bonus_max_traps")
    end

    if not self.counter_modifier or self.counter_modifier:IsNull() then
        self.counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
    end

    if self.counter_modifier and self.counter_modifier.trap_count then
        local trap = CreateUnitByName("npc_dota_templar_assassin_psionic_trap", point, false, nil, nil, self:GetCaster():GetTeamNumber())
       -- trap:AddNewModifier(trap, self, "modifier_templar_assassin_trap", {})

        trap.ta_owner = self:GetCaster()
        
        FindClearSpaceForUnit(trap, trap:GetAbsOrigin(), false)
        local trap_modifier = trap:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap", {double = double})
        trap:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

        EmitSoundOnLocationWithCaster(point, "Hero_TemplarAssassin.Trap", self:GetCaster())

        local remove_default = trap:FindAbilityByName("templar_assassin_self_trap")
        if remove_default then
            trap:RemoveAbility("templar_assassin_self_trap")
        end
        local custom_ability = trap:AddAbility("templar_assassin_self_trap_custom")

        if trap:HasAbility("templar_assassin_self_trap_custom") then
            trap:FindAbilityByName("templar_assassin_self_trap_custom"):SetHidden(false)
            trap:FindAbilityByName("templar_assassin_self_trap_custom"):SetLevel(self:GetLevel())
        end

        table.insert(self.counter_modifier.trap_count, trap_modifier)

        if #self.counter_modifier.trap_count > max_traps then
            if self.counter_modifier.trap_count[1]:GetParent() then
                self.counter_modifier.trap_count[1]:GetParent():ForceKill(false)
            end
        end

        self.counter_modifier:SetStackCount(#self.counter_modifier.trap_count)
    end

end

end




function templar_assassin_psionic_trap_custom_2:OnSpellStart()
if not IsServer() then return end
local main = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom")

main:SetTrap(self:GetCursorPosition(), self:GetCursorTarget(), self:GetCaster():HasModifier("modifier_templar_assassin_psionic_6"))

end












-- Модификатор на ловушке с функцией взрыва и эффектом

modifier_templar_assassin_psionic_trap_custom_trap = class({})

function modifier_templar_assassin_psionic_trap_custom_trap:IsHidden() return true end
function modifier_templar_assassin_psionic_trap_custom_trap:IsPurgable() return false end

function modifier_templar_assassin_psionic_trap_custom_trap:OnCreated(params)
    if not IsServer() then return end
    self.self_particle      = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.self_particle, 60, Vector(96, 0, 132))
    ParticleManager:SetParticleControl(self.self_particle, 61, Vector(1, 0, 0))
    self:AddParticle(self.self_particle, false, false, -1, false, false)
    local vision = 400
    if self:GetCaster():HasShard() then
        vision = vision + 125
    end
    self:GetParent():SetDayTimeVisionRange(vision)
    self:GetParent():SetNightTimeVisionRange(vision)
    self.trap_counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
    self.activated = false
    self.invis = false
    self.timer = 0

    self.double = params.double

    self.main_ability = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom")



    self.max_timer = self.main_ability:GetSpecialValueFor("trap_max_charge_duration")

    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_5") then 
        self.max_timer = self.max_timer - self.main_ability.charge_timer
    end

    self:StartIntervalThink(0.5)
end

function modifier_templar_assassin_psionic_trap_custom_trap:OnDestroy()
    if not IsServer() then return end
    if self.trap_counter_modifier and self.trap_counter_modifier.trap_count then
        for trap_modifier = 1, #self.trap_counter_modifier.trap_count do
            if self.trap_counter_modifier.trap_count[trap_modifier] == self then
                table.remove(self.trap_counter_modifier.trap_count, trap_modifier)
                if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_trap_custom_counter") then
                    self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter"):DecrementStackCount()
                end
                break
            end
        end
    end
end

function modifier_templar_assassin_psionic_trap_custom_trap:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE]          = self.invis,
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
    }
end

function modifier_templar_assassin_psionic_trap_custom_trap:Explode(ability, radius)
if not IsServer() then return end
    
    self.main_ability:ExplodeTrap(self:GetParent():GetAbsOrigin(), self.timer, self.double)

    self:GetParent():ForceKill(false)

    if not self:IsNull() then
        self:Destroy()
    end
end

function modifier_templar_assassin_psionic_trap_custom_trap:OnIntervalThink()
if not IsServer() then return end
if self.timer >= self.max_timer then return end
    self.timer = self.timer + 0.5
    if self.timer >= 2 then
        self.invis = true
    end
    if self.timer >= self.max_timer then
        self.activated = true
        ParticleManager:SetParticleControl(self.self_particle, 60, Vector(0, 0, 0))
        ParticleManager:SetParticleControl(self.self_particle, 61, Vector(0, 0, 0))
    end
end








-- Модификатор количества ловушек

modifier_templar_assassin_psionic_trap_custom_counter = class({})

function modifier_templar_assassin_psionic_trap_custom_counter:OnCreated()
    if not IsServer() then return end
    self.trap_count = {}
end

-- Способность у самой ловушки на взрыва

templar_assassin_self_trap_custom = class({})

function templar_assassin_self_trap_custom:OnSpellStart()
    local modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_trap")
    if modifier then
        if self:GetCaster().ta_owner then
           modifier:Explode(self, radius)
        end
    end
end

-- Уничтожить ловушку через скилл темпларки

templar_assassin_trap_custom  = class({})

function templar_assassin_trap_custom:OnSpellStart()
    if not IsServer() then return end




    if not self.trap_ability then
        self.trap_ability = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom")
    end
    
    if not self.counter_modifier or self.counter_modifier:IsNull() then
        self.counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
    end
    
    if self.trap_ability and self.counter_modifier and self.counter_modifier.trap_count and #self.counter_modifier.trap_count > 0 then
        local distance  = nil
        local index     = nil
        for trap_number = 1, #self.counter_modifier.trap_count do
            if self.counter_modifier.trap_count[trap_number] and not self.counter_modifier.trap_count[trap_number]:IsNull() then
                if not distance then
                    index       = trap_number
                    distance    = (self:GetCaster():GetAbsOrigin() - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()
                elseif ((self:GetCaster():GetAbsOrigin() - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D() < distance) then
                    index       = trap_number
                    distance    = (self:GetCaster():GetAbsOrigin() - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()
                end
            end
        end
        if index then
            self.counter_modifier.trap_count[index]:Explode(self.trap_ability)
        end
    end
end

-- Телепорт на ловушку







templar_assassin_trap_teleport_custom = class({})

function templar_assassin_trap_teleport_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)
    else
        self:SetHidden(true)
    end
end

function templar_assassin_trap_teleport_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end

function templar_assassin_trap_teleport_custom:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function templar_assassin_trap_teleport_custom:GetChannelTime()
    return self.BaseClass.GetChannelTime(self)
end

function templar_assassin_trap_teleport_custom:GetBehavior()
    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7") then
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
end


function templar_assassin_trap_teleport_custom:OnAbilityPhaseStart()
if self:GetCursorTarget() and self:GetCursorTarget():HasModifier("modifier_templar_assassin_psionic_trap_custom_trap_legendary") then return true end

if not self.counter_modifier or self.counter_modifier:IsNull() then
    self.counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
end


for trap_number = 1, #self.counter_modifier.trap_count do

    if self.counter_modifier.trap_count[trap_number] and not self.counter_modifier.trap_count[trap_number]:IsNull()
        and  (self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() < self:GetSpecialValueFor("max_range") then
                    
    
            return true
    end


end
       CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#no_trap"})
   
return false
end


function templar_assassin_trap_teleport_custom:OnSpellStart()
if not IsServer() then return end

self.target = nil
if self:GetCursorTarget() and self:GetCursorTarget():HasModifier("modifier_templar_assassin_psionic_trap_custom_trap_legendary") then 
    self.target = self:GetCursorTarget()
end




end



function templar_assassin_trap_teleport_custom:OnChannelFinish(bInterrupted)
if not IsServer() then return end
if bInterrupted then return end

if not self.trap_ability then
    self.trap_ability = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom")
end
        
if not self.counter_modifier or self.counter_modifier:IsNull() then
    self.counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
end
        

if self.target and self.target:HasModifier("modifier_templar_assassin_psionic_trap_custom_trap_legendary") then 
    self.target:FindModifierByName("modifier_templar_assassin_psionic_trap_custom_trap_legendary"):Destroy()
    FindClearSpaceForUnit(self:GetCaster(), self.target:GetAbsOrigin(), false)
return
end 



if self.trap_ability and self.counter_modifier and self.counter_modifier.trap_count and #self.counter_modifier.trap_count > 0 then
    local distance  = nil
    local index     = nil

    for trap_number = 1, #self.counter_modifier.trap_count do

        if self.counter_modifier.trap_count[trap_number] and not self.counter_modifier.trap_count[trap_number]:IsNull()
            and  (self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() < self:GetSpecialValueFor("max_range") then
                    
            if not distance then
                index       = trap_number
                distance    = (self:GetCursorPosition() - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()
            elseif ((self:GetCursorPosition() - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D() < distance) then
                index       = trap_number
                 distance    = (self:GetCursorPosition() - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()
            end

         end


     end

    if index then
        FindClearSpaceForUnit(self:GetCaster(), self.counter_modifier.trap_count[index]:GetParent():GetAbsOrigin(), false)
        self.counter_modifier.trap_count[index]:Explode(self.trap_ability)
    end


end



end














-- Дебафф

modifier_templar_assassin_psionic_trap_custom_trap_debuff = class({})

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:IsPurgable() return true end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:OnCreated(params)
if not IsServer() then return end
    if params.timer and params.active then
        self.movement_speed_min = self:GetAbility():GetSpecialValueFor("movement_speed_min")
        self.movement_speed_max = self:GetAbility():GetSpecialValueFor("movement_speed_max")

        self.main_ability = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom")
        self.max_timer = self.main_ability:GetSpecialValueFor("trap_max_charge_duration")

            
        if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_5") then 
             self.max_timer = self.max_timer - self:GetAbility().charge_timer
        end


        self.movespeed_reduced = (math.max(self.movement_speed_min, (self.movement_speed_max * (tonumber(params.timer) / self.max_timer)))) * -1

        self.damage = self:GetAbility():GetSpecialValueFor("trap_bonus_damage") / self.main_ability:GetSpecialValueFor("trap_duration_tooltip") 

        if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_1") then 
            self.damage = self.damage + self.main_ability.blast_damage[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_psionic_1")]/self:GetRemainingTime()
        end

        if params.active == 1 then 

            if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7")  then 
                SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage*self.main_ability:GetSpecialValueFor("trap_duration_tooltip"), nil)
                ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage*self.main_ability:GetSpecialValueFor("trap_duration_tooltip"), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
            else
                self:StartIntervalThink(self:GetRemainingTime() / self.main_ability:GetSpecialValueFor("trap_duration_tooltip"))
            end
        end
    end
    self:SetHasCustomTransmitterData(true)
end



function modifier_templar_assassin_psionic_trap_custom_trap_debuff:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:AddCustomTransmitterData()
    return {
        movespeed_reduced = self.movespeed_reduced,
    }
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:HandleCustomTransmitterData( data )
    self.movespeed_reduced = data.movespeed_reduced
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:OnIntervalThink()
    if not IsServer() then return end
    self:SendBuffRefreshToClients()
    ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_reduced
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:GetTexture()  return "templar_assassin_psionic_trap" end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:GetEffectName()
    return "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_slow.vpcf"
end



modifier_templar_assassin_psionic_trap_custom_trap_vision = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_vision:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_vision:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_vision:GetTexture() return "buffs/psionic_vision" end


function modifier_templar_assassin_psionic_trap_custom_trap_vision:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.parent = self:GetParent()
self.caster = self:GetCaster()


if self.parent:IsHero() then 
    self.particle_trail_fx = ParticleManager:CreateParticleForTeam("particles/pa_vendetta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
    self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)
end

self:StartIntervalThink(FrameTime())
end

function modifier_templar_assassin_psionic_trap_custom_trap_vision:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), false )
end




modifier_templar_assassin_psionic_trap_custom_trap_illusion = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_illusion:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_illusion:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_dark_seer_normal_punch_replica.vpcf" end

function modifier_templar_assassin_psionic_trap_custom_trap_illusion:StatusEffectPriority()
    return 10010
end


function modifier_templar_assassin_psionic_trap_custom_trap_illusion:CheckState()
return
{
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_UNTARGETABLE] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_ROOTED] = true,
}
end

function modifier_templar_assassin_psionic_trap_custom_trap_illusion:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end





function modifier_templar_assassin_psionic_trap_custom_trap_illusion:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end

local damage = params.target:GetMaxHealth()*self:GetAbility().illusion_damage[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_psionic_4")]

if params.target:IsCreep() then 
    damage = damage*self:GetAbility().illusion_creeps
end

SendOverheadEventMessage(params.target, 4, params.target, damage, nil)
ApplyDamage({victim = params.target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})



end



modifier_templar_assassin_psionic_trap_custom_trap_legendary = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:IsHidden() return true end
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:GetEffectName()
return "particles/ta_trap_target.vpcf"
end
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_templar_assassin_psionic_trap_custom_trap_legendary:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)



self.max_silence = self:GetAbility():GetSpecialValueFor("shard_max_silence")


self.max_timer = self:GetAbility():GetSpecialValueFor("trap_max_charge_duration")

if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_5") then 
     self.max_timer = self.max_timer - self:GetAbility().charge_timer
end

self.double = table.double
self.t = -1
self.mini_t = 0.4
self.timer = self.max_timer*2 
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_templar_assassin_psionic_trap_custom_trap_legendary:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 400, 0.1, true)
self.mini_t = self.mini_t + 0.1 

if self.mini_t < 0.5 then return end

self.mini_t = 0
self.t = self.t + 1

local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number

if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
   decimal = 8
else 
   decimal = 1
end

local particleName = "particles/ta_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end







function modifier_templar_assassin_psionic_trap_custom_trap_legendary:OnDestroy()
if not IsServer() then return end
    self:GetAbility():ExplodeTrap(self:GetParent():GetAbsOrigin(), self.max_timer , self.double)
end



modifier_templar_assassin_psionic_trap_custom_trap_incoming = class({})

function modifier_templar_assassin_psionic_trap_custom_trap_incoming:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_incoming:GetTexture() return "buffs/orb_attack_speed" end
function modifier_templar_assassin_psionic_trap_custom_trap_incoming:IsPurgable() return true end

function modifier_templar_assassin_psionic_trap_custom_trap_incoming:OnCreated(table)
if not IsServer() then return end



self.particle_peffect = ParticleManager:CreateParticle("particles/ta_trap_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end

function modifier_templar_assassin_psionic_trap_custom_trap_incoming:DeclareFunctions()
return 
{ 
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_templar_assassin_psionic_trap_custom_trap_incoming:GetModifierIncomingDamage_Percentage()
return self:GetAbility().incoming_damage[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_psionic_2")]
end 
  
