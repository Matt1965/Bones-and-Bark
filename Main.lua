do
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
    end

    function RemoveShadow(isPlayer)
        if isPlayer then
            return
        end
        local destruct = GetTriggerDestructable()
        RemoveDestructable(TREE_SHADOW_PAIRS[destruct])
        TREE_SHADOW_PAIRS[destruct] = nil
        FOREST_ANGER = FOREST_ANGER + FOREST_ANGER_GROWTH
        FOREST_HATRED = FOREST_HATRED + FOREST_HATRED_GROWTH
    end

    -- Make player unit spawner
    local function SpawnPlayerUnits()
        for index = 0, bj_MAX_PLAYER_SLOTS do
            if GetPlayerSlotState(Player(index)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(index)) == MAP_CONTROL_USER then
                PLAYER_SKELETONS[index] = CreateUnitAtLoc(Player(index), FourCC("n000"), STARTING_LOCATION, 0)
                PLAYER_DOGS[index] = CreateUnitAtLoc(Player(index), FourCC("n001"), STARTING_LOCATION_DOG, 0)
            end
        end

    end

    function EnforceLeash()
        for index = 0, bj_MAX_PLAYER_SLOTS do
            if CalculateDistance(PLAYER_SKELETONS[index], PLAYER_DOGS[index]) > DOG_MAX_RADIUS then
                ApplyBuff(FourCC('A000'), PLAYER_DOGS[index])
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
        print(hitpoints)
        return hitpoints
    end

    function NearbyCondition()
        if CountNearbyUnits(GetTriggerDestructable(), 150) > 0 then
            return false
        else
            return true
        end
    end

    OnInit.map(TreeShadows)
    OnInit.map(SpawnPlayerUnits)
end
