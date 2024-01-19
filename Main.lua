do
        -- Make player unit spawner
    local function SpawnPlayerUnits()
        for index = 0, bj_MAX_PLAYER_SLOTS do
            if GetPlayerSlotState(Player(index)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(index)) == MAP_CONTROL_USER then
                PLAYER_SKELETONS[index] = CreateUnitAtLoc(Player(index), FourCC("n000"), STARTING_LOCATION, 0)
                PLAYER_DOGS[index] = CreateUnitAtLoc(Player(index), FourCC("n001"), STARTING_LOCATION_DOG, 0)
            end
        end

    end

    local function TreeShadows()
        EnumDestructablesInRectAll(GetPlayableMapRect(), AddShadow)
    end
 
    function AddShadow()
        local tree = GetEnumDestructable()
        local treeLoc = GetDestructableLoc(tree)
        local treeType = GetDestructableTypeId(tree)
        local treeSize = math.random(MINIMUM_TREE_SIZE*10, MAXIMUM_TREE_SIZE*10)/10
        local shadowSize = 6 * treeSize + 0.4

        RemoveDestructable(tree)
        local shadow = CreateDestructableLoc(FourCC("B001"), treeLoc, 1, shadowSize, 0)
        local newTree = CreateDestructableLoc(treeType, treeLoc, 1, treeSize, 0)
        TREE_SHADOW_PAIRS[newTree] = shadow

        TriggerRegisterDeathEvent(ShadowRemovalTrigger, newTree)
    end

    function RemoveShadow()
        local destruct = GetTriggerDestructable()
        RemoveDestructable(TREE_SHADOW_PAIRS[destruct])
        TREE_SHADOW_PAIRS[destruct] = nil
        FOREST_ANGER = FOREST_ANGER + FOREST_ANGER_GROWTH
        FOREST_EVOLUTION = FOREST_EVOLUTION + FOREST_EVOLUTION_GROWTH
        UpdateForestInfo()
    end

    function LeaderBoardSetup()
        AngerTextFrame = BlzCreateFrameByType("TEXT", "ForestAngerText", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        BlzFrameSetPoint(AngerTextFrame, FRAMEPOINT_TOPRIGHT, BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), FRAMEPOINT_TOPRIGHT, -0.2, -0.05)
        BlzFrameSetText(AngerTextFrame, "Forest Anger: "..FOREST_ANGER)
        
        -- Create a frame for the evolution text
        EvolutionTextFrame = BlzCreateFrameByType("TEXT", "ForestEvolutionText", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        BlzFrameSetPoint(EvolutionTextFrame, FRAMEPOINT_TOPRIGHT, AngerTextFrame, FRAMEPOINT_BOTTOMRIGHT, 0, 0)
        BlzFrameSetText(EvolutionTextFrame, "Forest Evolution: "..FOREST_EVOLUTION)        
    end

    function UpdateForestInfo()
        BlzFrameSetText(AngerTextFrame, "Forest Anger: " .. FOREST_ANGER)
        BlzFrameSetText(EvolutionTextFrame, "Forest Evolution: " .. FOREST_EVOLUTION)
    end

    function EnforceLeash()
        for index = 0, bj_MAX_PLAYER_SLOTS do
            if CalculateDistance(PLAYER_SKELETONS[index], PLAYER_DOGS[index]) > DOG_MAX_RADIUS_WALK then
                IssuePointOrderLoc(PLAYER_DOGS[index], "move", GetUnitLoc(PLAYER_SKELETONS[index]))
                if CalculateDistance(PLAYER_SKELETONS[index], PLAYER_DOGS[index]) > DOG_MAX_RADIUS then
                    ApplyBuff(FourCC('A000'), PLAYER_DOGS[index], "slow")
                end
            end
        end
    end

    function UnitBirth()
        table.insert(ALL_UNITS, GetTriggerUnit())
    end

    function UnitDeath()
        local corpse

        for i, unit in ipairs(ALL_UNITS) do
            if unit == GetTriggerUnit() then
                corpse = i
                break
            end
        end

        table.remove(ALL_UNITS, corpse)
    end

    function TreeHitpoints(size)
        local hitpoints = QUADCOEF_TREE_HP * size^2 + LINEARCOEF_TREE_HP * size + CONSTANT_TREE_HP
        return hitpoints
    end

    function AttackMove()
        for unit in ALL_UNITS do
            if GetOwningPlayer(unit) == Player(11) then
                IssuePointOrderLoc(unit, "AttackMove", PLAYER_SKELETONS[math.random(3)])
            end
        end
    end

    function GenerateUnitByCost(cost)
        local unitsOfCost
        for _, unitAttributes in pairs(UNIT_INFO) do
            if unitAttributes.Cost == cost then
                table.insert(unitsOfCost, unitAttributes.Code)
            end
        end

        local randomIndex = math.random(#unitsOfCost)
        local randomValue = unitsOfCost[randomIndex]

        return randomValue
    end

    function SpawnUnitAtTree(unitName)
        local tree = GetRandomKey(TREE_SHADOW_PAIRS)
        CreateUnitAtLoc(Player(11), FourCC(unitName), GetDestructableLoc(tree), 0)
    end

    function SpawnForestWave()
        local distribution = DetermineWaveComposition()
        local foodSupply = FOREST_ANGER + (FOREST_EVOLUTION * EVOLUTION_SUPPLY_MULT)
        local maxEvolution = math.max(1, math.floor(FOREST_EVOLUTION)) -- Rounding down, but not lower than 1

        FOREST_ANGER = 0
    
        for _, level in ipairs(distribution) do
            if level > maxEvolution then
                -- Skip levels higher than maxEvolution
                goto continue
            end
    
            local halfFood = foodSupply / 2
            local unitName = GenerateUnitByCost(level) -- Function to determine unit name based on level
            local unitIdentifier = nil

            for id, info in pairs(UNIT_INFO) do
                if info.Code == unitName then
                    unitIdentifier = id
                end
            end
    
            while foodSupply > halfFood and foodSupply >= UNIT_INFO[unitIdentifier].Cost do
                SpawnUnitAtTree(unitName) -- Function to spawn a unit of the given name
                foodSupply = foodSupply - UNIT_INFO[unitIdentifier].Cost
            end
    
            if foodSupply < UNIT_INFO[unitIdentifier].Cost then
                break -- No more food supply to spawn units
            end
    
            ::continue::
        end
    end

    function DetermineWaveComposition()
        local waveTypeDistribution = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}

        for i = #waveTypeDistribution, 2, -1 do
            local j = math.random(i)
            waveTypeDistribution[i], waveTypeDistribution[j] = waveTypeDistribution[j], waveTypeDistribution[i]
        end

        return waveTypeDistribution
    end

    function NearbyCondition()
        if CountNearbyUnits(GetTriggerDestructable(), 50) > 0 then
            return false
        else
            return true
        end
    end

    OnInit.map(TreeShadows)
    OnInit.map(SpawnPlayerUnits)
    OnInit.map(LeaderBoardSetup)
end
