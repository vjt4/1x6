LinkLuaModifier( "modifier_templar_assassin_meld_custom_buff", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_debuff", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_speed", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_slow", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_invun", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_charge", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_heal", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_meld_custom_quest", "abilities/templar_assasssin/templar_assassin_meld_custom", LUA_MODIFIER_MOTION_NONE )

templar_assassin_meld_custom = class({})

templar_assassin_meld_custom.armor_bonus = {-2, -3, -4}

templar_assassin_meld_custom.attack_speed = 100
templar_assassin_meld_custom.attack_speed_duration = {1.5, 2, 2.5}

templar_assassin_meld_custom.slow_duration = 4
templar_assassin_meld_custom.slow_attack = {-40, -60, -80}
templar_assassin_meld_custom.slow_move = {-20, -30, -40}

templar_assassin_meld_custom.invun = 0.3

templar_assassin_meld_custom.charge_max_charges = 5
templar_assassin_meld_custom.charge_max = 2
templar_assassin_meld_custom.charge_damage = {100, 200}
templar_assassin_meld_custom.charge_stun = {1, 1.5}

templar_assassin_meld_custom.legendary_damage = 30
templar_assassin_meld_custom.legendary_incoming = 50
templar_assassin_meld_custom.legendary_duration = 6
templar_assassin_meld_custom.legendary_speed = 25
templar_assassin_meld_custom.legendary_duration_move = 3

templar_assassin_meld_custom.invis_damage = -25
templar_assassin_meld_custom.invis_heal = 3
templar_assassin_meld_custom.invis_delay = 2.5
templar_assassin_meld_custom.invis_after = 4




function templar_assassin_meld_custom:OnSpellStart()
if not IsServer() then return end

self:GiveMeld(self:GetCaster())

if self:GetCaster():HasModifier("modifier_templar_assassin_meld_7") then 

    local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=self.legendary_duration, outgoing_damage= -100 + self.legendary_damage,incoming_damage=self.legendary_incoming}, 1, 0, false, false )  
    for k, v in pairs(illusion) do

        for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
            if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
                v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
            end

            if mod:GetName() == "modifier_templar_assassin_refraction_custom_absorb" then 
                local shield = v:AddNewModifier(v, v:FindAbilityByName("templar_assassin_refraction_custom"), mod:GetName(), {})
                shield:SetStackCount(mod:GetStackCount())
            end

        end

        v.owner = self:GetCaster()
        FindClearSpaceForUnit(v, self:GetCaster():GetAbsOrigin(), true)
        self:GiveMeld(v)
    end

end

end


function templar_assassin_meld_custom:OnProjectileHit_ExtraData(hTarget, vLocation, table)
if not IsServer() then return end

local unit = EntIndexToHScript(table.caster)

unit:RemoveModifierByName("modifier_templar_assassin_meld_custom_buff")

end

function templar_assassin_meld_custom:GiveMeld(target)
if not IsServer() then return end

target:AddNewModifier(target, self, "modifier_templar_assassin_meld_custom_buff", {})
target:EmitSound("Hero_TemplarAssassin.Meld")

if target:HasModifier("modifier_templar_assassin_meld_5") then 
    target:Purge(false,true, false, false, false)
    target:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_meld_custom_invun", {duration = self.invun})
end




target:Stop()
end




modifier_templar_assassin_meld_custom_buff = class({})

function modifier_templar_assassin_meld_custom_buff:IsPurgable() return false end

function modifier_templar_assassin_meld_custom_buff:OnCreated()
self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")



self.duration = self:GetAbility():GetSpecialValueFor("duration")
if not IsServer() then return end


if self:GetParent():HasModifier("modifier_templar_assassin_meld_4") then 
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_charge", {})
end

self.abs = self:GetParent():GetAbsOrigin()
self.record = nil
self.attack = true
self.time = 0
self.moved = false
self:StartIntervalThink(0.1)
end

function modifier_templar_assassin_meld_custom_buff:OnRefresh()
self:OnCreated()
end

function modifier_templar_assassin_meld_custom_buff:OnDestroy()
if not IsServer() then return end

if self:GetCaster():GetQuest() == "Templar.Quest_6" then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_quest", {duration = self:GetCaster().quest.number})
end


self:GetParent():EmitSound("Hero_TemplarAssassin.Meld.Move")
self:GetParent():RemoveModifierByName("modifier_templar_assassin_meld_custom_charge")

if self:GetParent():HasModifier("modifier_templar_assassin_meld_custom_heal") then 
    self:GetParent():FindModifierByName("modifier_templar_assassin_meld_custom_heal"):SetDuration(self:GetAbility().invis_after, true)
end

end

function modifier_templar_assassin_meld_custom_buff:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_CANCELLED,
    }
    return funcs
end


function modifier_templar_assassin_meld_custom_buff:GetModifierMoveSpeedBonus_Percentage()
if self:GetParent():HasModifier("modifier_templar_assassin_meld_7") then 
    return self:GetAbility().legendary_speed
end

end




function modifier_templar_assassin_meld_custom_buff:GetActivityTranslationModifiers()
	return "meld"
end

function modifier_templar_assassin_meld_custom_buff:OnAttack(params)
    if self:GetParent() ~= params.attacker then return end
    if self.attack then
        self.record = params.record
        local projectile =
        {
            Target = params.target,
            Source = self:GetParent(),
            Ability = self:GetAbility(),
            EffectName = "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf",
            iMoveSpeed = self:GetParent():GetProjectileSpeed(),
            vSourceLoc = self:GetParent():GetAbsOrigin(),
            bDodgeable = false,
            bProvidesVision = false,
            ExtraData = {caster = self:GetParent():entindex()}
        }

        local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )
        self.attack = false

        if self:GetCaster():HasModifier("modifier_templar_assassin_meld_3") then 
          self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_speed", {duration = self:GetAbility().attack_speed_duration[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_meld_3")]})
       end

    end
end



function modifier_templar_assassin_meld_custom_buff:OnOrder(params)
    if not IsServer() then return end
    
    if params.unit == self:GetParent() then
        local cancel_commands = 
        {
            [DOTA_UNIT_ORDER_MOVE_TO_POSITION]  = true,
            [DOTA_UNIT_ORDER_CAST_POSITION]    = true,
            [DOTA_UNIT_ORDER_CAST_TARGET]       = true,
            [DOTA_UNIT_ORDER_CAST_NO_TARGET]     = true,
            [DOTA_UNIT_ORDER_CAST_TOGGLE]     = true,
            [DOTA_UNIT_ORDER_MOVE_ITEM]       = true,
            [DOTA_UNIT_ORDER_MOVE_TO_DIRECTION]  = true,
            [DOTA_UNIT_ORDER_MOVE_RELATIVE]     = true,
        }

        if params.ability then
            if params.ability:GetAbilityName() == "templar_assassin_trap_teleport_custom" then
                return
            end
        end
        
        if cancel_commands[params.order_type] then
            if self.attack then

                if self:GetParent():HasModifier("modifier_templar_assassin_meld_7") then 
                       if self.moved == false then  
                	       self:SetDuration(self:GetAbility().legendary_duration_move, true)
                           self.moved = true
                       end
                else 
                    self:Destroy()
                end
            end
        end
    end
end



function modifier_templar_assassin_meld_custom_buff:OnIntervalThink()

self.time = self.time + 0.1

if self:GetParent():HasModifier("modifier_templar_assassin_meld_6") and 
    not self:GetParent():HasModifier("modifier_templar_assassin_meld_custom_heal") and 
    self.time >= self:GetAbility().invis_delay then 

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_meld_custom_heal", {})
end


if self:GetParent():GetAbsOrigin() == self.abs then return end
if not self.attack then return end
        
if self:GetParent():HasModifier("modifier_templar_assassin_meld_7") then 

    if self.moved == false then  
        self:SetDuration(self:GetAbility().legendary_duration_move, true)
        self.moved = true
    end
else 
  self:Destroy()
end

end

function modifier_templar_assassin_meld_custom_buff:OnAttackLanded(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end

    if params.record == self.record then

       bonus = 0
       local mod = self:GetCaster():FindModifierByName("modifier_templar_assassin_meld_custom_charge")
       if mod then 
          bonus = self:GetAbility().charge_damage[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_meld_4")]*( mod:GetStackCount() / (self:GetAbility().charge_max_charges  ))
          
          local stun = self:GetAbility().charge_stun[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_meld_4")]*( mod:GetStackCount() / (self:GetAbility().charge_max_charges)  )
          
          params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = stun*(1 - params.target:GetStatusResistance())})
          mod:Destroy()
       end
       
        
        params.target:EmitSound("Hero_TemplarAssassin.Meld.Attack")
       if not params.target:IsBuilding() then 

    	   params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_debuff", { duration = self.duration})
           SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, params.target, (self.bonus_damage + bonus), nil)

           local k = 1
           if self:GetParent():IsIllusion() then 
             --k = self:GetAbility().legendary_damage/100
           end

           ApplyDamage({victim = params.target, attacker = self:GetCaster(), damage = (self.bonus_damage + bonus)*k, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
      end

       if self:GetCaster():HasModifier("modifier_templar_assassin_meld_2") then 
        params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_meld_custom_slow", {duration = self:GetAbility().slow_duration*(1 - params.target:GetStatusResistance())})
       end


	   self:Destroy()
    end
end

function modifier_templar_assassin_meld_custom_buff:OnAttackFail(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
    if params.record == self.record then
	   self:Destroy()
    end
end

function modifier_templar_assassin_meld_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf"
end

function modifier_templar_assassin_meld_custom_buff:GetModifierInvisibilityLevel()
    return 1
end

function modifier_templar_assassin_meld_custom_buff:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end














modifier_templar_assassin_meld_custom_debuff = class({})

function modifier_templar_assassin_meld_custom_debuff:OnCreated(table)
if not IsServer() then return end

self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")

if self:GetCaster():HasModifier("modifier_templar_assassin_meld_1") then 
    self.armor = self.armor + self:GetAbility().armor_bonus[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_meld_1")]
end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

self:SetHasCustomTransmitterData(true)
end

function modifier_templar_assassin_meld_custom_debuff:AddCustomTransmitterData()
    return {
        armor = self.armor,
    }
end

function modifier_templar_assassin_meld_custom_debuff:HandleCustomTransmitterData( data )
    self.armor = data.armor
end

function modifier_templar_assassin_meld_custom_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_templar_assassin_meld_custom_debuff:GetModifierPhysicalArmorBonus()
if ((not self:GetCaster() or self:GetCaster():IsNull()) or self:GetCaster():IsIllusion()) and IsClient() then  


	return self.armor
end 

if self:GetCaster() and not self:GetCaster():IsNull() and not self:GetCaster():IsIllusion() then 
    return self.armor
end

end

function modifier_templar_assassin_meld_custom_debuff:GetAttributes()
return MODIFIER_ATTRIBUTE_MULTIPLE
end


modifier_templar_assassin_meld_custom_speed = class({})
function modifier_templar_assassin_meld_custom_speed:IsHidden() return false end
function modifier_templar_assassin_meld_custom_speed:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_speed:GetTexture() return "buffs/meld_speed" end
function modifier_templar_assassin_meld_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_templar_assassin_meld_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().attack_speed
end





modifier_templar_assassin_meld_custom_slow = class({})
function modifier_templar_assassin_meld_custom_slow:IsHidden() return false end
function modifier_templar_assassin_meld_custom_slow:IsPurgable() return true end
function modifier_templar_assassin_meld_custom_slow:GetTexture() return "buffs/meld_slow" end


function modifier_templar_assassin_meld_custom_slow:GetEffectName()
    return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end



function modifier_templar_assassin_meld_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end

function modifier_templar_assassin_meld_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_meld_2")]
end
function modifier_templar_assassin_meld_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().slow_attack[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_meld_2")]
end


modifier_templar_assassin_meld_custom_invun = class({})
function modifier_templar_assassin_meld_custom_invun:IsHidden() return true end
function modifier_templar_assassin_meld_custom_invun:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_invun:CheckState()
return
{
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end


modifier_templar_assassin_meld_custom_charge = class({})
function modifier_templar_assassin_meld_custom_charge:IsHidden() return true end
function modifier_templar_assassin_meld_custom_charge:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_charge:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)

self:StartIntervalThink(self:GetAbility().charge_max/self:GetAbility().charge_max_charges)
end

function modifier_templar_assassin_meld_custom_charge:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().charge_max_charges then return end

self:IncrementStackCount()

end




function modifier_templar_assassin_meld_custom_charge:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self:GetStackCount() == 0 then 
    local name = "particles/beast_ult_count.vpcf"
    self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    self:AddParticle(self.particle, false, false, -1, false, false)
end

for i = 1,self:GetAbility().charge_max_charges do 
    
    if i <= self:GetStackCount() then 
        ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))   
    else 
        ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))   
    end
end

end



modifier_templar_assassin_meld_custom_heal = class({})
function modifier_templar_assassin_meld_custom_heal:IsHidden() return false end
function modifier_templar_assassin_meld_custom_heal:IsPurgable() return false end
function modifier_templar_assassin_meld_custom_heal:GetTexture() return "buffs/meld_heal" end

function modifier_templar_assassin_meld_custom_heal:GetEffectName()
return "particles/econ/items/oracle/oracle_ti10_immortal/ta_meld_heal.vpcf"
end


function modifier_templar_assassin_meld_custom_heal:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("TA.Meld_heal")
end

function modifier_templar_assassin_meld_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end


function modifier_templar_assassin_meld_custom_heal:GetModifierIncomingDamage_Percentage()
return self:GetAbility().invis_damage
end

function modifier_templar_assassin_meld_custom_heal:GetModifierHealthRegenPercentage()
return self:GetAbility().invis_heal
end






modifier_templar_assassin_meld_custom_quest = class({})
function modifier_templar_assassin_meld_custom_quest:IsHidden() return true end
function modifier_templar_assassin_meld_custom_quest:IsPurgable() return false end