do
    function TriggerSetup()
        ShadowRemovalTrigger = CreateTrigger()
        TriggerAddCondition(ShadowRemovalTrigger, Filter(NearbyCondition))
        TriggerAddAction(ShadowRemovalTrigger, RemoveShadow)

        local leash = CreateTrigger()
        TriggerRegisterTimerEventPeriodic(leash, .5)
        TriggerAddAction(leash, EnforceLeash)

        local unitDeath = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ( unitDeath, EVENT_PLAYER_UNIT_DEATH )
        TriggerAddAction(unitDeath, UnitDeath)

        local unitBirth = CreateTrigger()
        TriggerRegisterEnterRectSimple(unitBirth, GetPlayableMapRect())
        TriggerAddAction(unitBirth, UnitBirth)

        local attackMoveForest = CreateTrigger()
        TriggerRegisterTimerEventPeriodic(attackMoveForest, 15)
        TriggerAddAction(attackMoveForest, AttackMove)

        local startWave = CreateTrigger()
        TriggerRegisterGameStateEventTimeOfDay(startWave, EQUAL, 18.0)
        TriggerAddAction(startWave, SpawnForestWave)

    end

    OnInit.trig(TriggerSetup)
end