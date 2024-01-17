function CountNearbyUnits(centerUnit, radius)
    local count = 0

    local centerX = GetUnitX(centerUnit)
    local centerY = GetUnitY(centerUnit)

    for i, unit in ipairs(ALL_UNITS) do
        if unit ~= centerUnit and IsUnitInRangeXY(unit, centerX, centerY, radius) then
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

function ApplyBuff(buff, target)
    caster = CreateUnitAtLoc(Player(PLAYER_NEUTRAL_PASSIVE), buff, GetUnitLoc(target),0)
    UnitAddAbility(caster, buff)
    UnitApplyTimedLife(caster, FourCC('BTLF'), 1)
    IssueTargetOrder(caster, buff, target)
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