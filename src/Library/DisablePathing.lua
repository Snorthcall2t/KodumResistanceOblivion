---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bergi.
--- DateTime: 25.05.2020 1:01
---

--[[function DisablePathing(hero)
	if IsUnitType(hero,UNIT_TYPE_HERO) then
		UnitAddItemById(hero,FourCC('I000'))
	else
		UnitAddAbility(hero,FourCC('AInv'))
		UnitAddItemById(hero,FourCC('I000'))
		UnitRemoveAbility(hero,FourCC('AInv'))
	end
end]]