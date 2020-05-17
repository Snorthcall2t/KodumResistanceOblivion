---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bergi.
--- DateTime: 06.05.2020 3:13
---
function CreateIceBlast(caster,spellId,x,y)
	local lvl=GetUnitAbilityLevel(caster,spellId)
	if lvl==0 then return end
	local damage={60,80,100,120}
	local range={200,220,260,300}
	local delay={4,3,2,1}
	local eff={}
	for i=1,7 do
		local angle=60
		if i==1 then
			eff[i]=AddSpecialEffect("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt",x,y)
		else
			eff[i]=AddSpecialEffect("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTargetArt",MoveXY(x,y,range[lvl]*.3,angle*i))
		end
	end

	TimerStart(CreateTimer(), delay[lvl], false, function()
		--print("destroy")
		UnitDamageArea(caster,damage[lvl],x,y,range[lvl])
		for i=1,7 do
			--print(i.." d")
			DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostNova\\FrostNovaTarget",BlzGetLocalSpecialEffectX(eff[i]),BlzGetLocalSpecialEffectY(eff[i])))
			DestroyEffect(eff[i])
		end
	end)
end