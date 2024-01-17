do
    local function TriggerSetup()
        local shadowRemoval = CreateTrigger()
        TriggerRegisterDestDeathInRegionEvent(shadowRemoval, GetPlayableMapRect())
        TriggerAddCondition(shadowRemoval, Filter(NearbyCondition))
        TriggerAddAction(shadowRemoval, RemoveShadow)

        local leash = CreateTrigger()
        TriggerRegisterTimerEventPeriodic(leash, 1)
        TriggerAddAction(leash, EnforceLeash)

        local unitDeath = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ( unitDeath, EVENT_PLAYER_UNIT_DEATH )
        TriggerAddAction(unitDeath, UnitDeath)

        local unitBirth = CreateTrigger()
        TriggerRegisterEnterRectSimple(unitBirth, GetPlayableMapRect())
        TriggerAddAction(unitBirth, UnitBirth)

    end

    OnInit.trig(TriggerSetup)
end