function CountNearbyUnits(centerDestruct, radius)
    local count = 0

    local centerX = GetDestructableX(centerDestruct)
    local centerY = GetDestructableY(centerDestruct)

    for i, unit in ipairs(ALL_UNITS) do
        if IsUnitInRangeXY(unit, centerX, centerY, radius) then
            count = count + 1
        end
    end

    return count
end

function CalculateDistance(unit1, unit2)
    local x1, y1 = GetUnitX(unit1), GetUnitY(unit1)
    local x2, y2 = GetUnitX(unit2), GetUnitY(unit2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function ApplyBuff(buff, target, spellType)
  local caster = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("u000"), GetUnitLoc(target), 0)
  if caster then
      UnitAddAbility(caster, buff)

      local timer = CreateTimer()
      local trigger = CreateTrigger()

      TriggerRegisterTimerExpireEvent(trigger, timer)
      TriggerAddAction(trigger, function()
          IssueTargetOrder(caster, spellType, target)
          UnitApplyTimedLife(caster, FourCC('BTLF'), 2)
          DestroyTimer(timer)
          DestroyTrigger(trigger)
      end)

      -- Set the timer for a 0.5 second delay (or whatever delay you need)
      TimerStart(timer, 0.1, false, nil)
  end
end

function GetRandomKey(table)
  local keys = {}
  for key in pairs(table) do
      table.insert(keys, key)
  end

  if #keys == 0 then
      return nil, nil -- The table is empty
  end

  local randomIndex = math.random(#keys)
  local randomKey = keys[randomIndex]
  return randomKey
end

do
    local expr_func = {}
  
    local oldFilter = Filter
    function Filter(filter_func)
      local filter_expr = oldFilter(filter_func)
      expr_func[filter_expr] = filter_func
      return filter_expr
    end
  
    Condition = Filter
  
    function Not(filter_expr)
      return Filter(function()
        return not expr_func[filter_expr]()
      end)
    end
  
    function And(left_filter_expr, right_filter_expr)
      return Filter(function()
        return expr_func[left_filter_expr]() and expr_func[right_filter_expr]()
      end)
    end
  
    function Or(left_filter_expr, right_filter_expr)
      return Filter(function()
        return expr_func[left_filter_expr]() or expr_func[right_filter_expr]()
      end)
    end
  
    --- Returns the corresponding function for the given boolexpr
    ---@param filter_expr boolexpr
    ---@return function
    function FilterToFunc(filter_expr)
      return expr_func[filter_expr]
    end
end