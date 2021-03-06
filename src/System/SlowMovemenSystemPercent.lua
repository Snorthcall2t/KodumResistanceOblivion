---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bergi.
--- DateTime: 15.06.2020 18:06
---
---
Slow10ID=FourCC("A029") --ускорение 10-100,0 -  10 уровней


function SetUnitSlowBonusMS(hero,ms)
	local lvl=ms//10
	UnitAddAbility(hero,Slow10ID)
	SetUnitAbilityLevel(hero,Slow10ID,lvl)
	if ms<=0 then
		UnitRemoveAbility(hero,Slow10ID)
		UnitRemoveAbility(hero,FourCC('B00F'))
	end
end

function GetUnitSlowBonusMS(hero)
	return GetUnitAbilityLevel(hero,Slow10ID)*10
end

function AddUnitSlowBonusMS(hero,ms)
	SetUnitSlowBonusMS(hero,GetUnitSlowBonusMS(hero)+ms)
end

function MakeUnitSlowTimed(hero,ms,sec,effModel)
	AddUnitSlowBonusMS(hero,ms)
	local chkfaststop=CreateTimer()
	if not effModel then
		effModel="Abilities\\Spells\\Human\\slow\\slowtarget"
	end
	local eff=AddSpecialEffectTarget(effModel,hero,"chest") --origin
	--local endTimer
	TimerStart(chkfaststop, 0.1, true, function()
		if UnitMagicImmuneGetState(hero) or not UnitAlive(hero) then
			AddUnitSlowBonusMS(hero,-ms)
			DestroyEffect(eff)
			DestroyTimer(GetExpiredTimer())
		end
	end)

	TimerStart(CreateTimer(), sec, false, function()
		AddUnitSlowBonusMS(hero,-ms)
		DestroyEffect(eff)
		DestroyTimer(chkfaststop)
	end)
end