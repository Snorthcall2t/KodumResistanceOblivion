---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bergi.
--- DateTime: 10.01.2020 22:05
--
---Глобалки
TIMER_PERIOD = 0.03125
HERO={}
do
	local InitGlobalsOrigin = InitGlobals -- записываем InitGlobals в переменную
	function InitGlobals()
		InitGlobalsOrigin() -- вызываем оригинальную InitGlobals из переменной
		InitHEROTable()
		--InitMouseMoveTrigger()
		InitDamage()
		InitSpellTrigger()
		InitUnitDeath()
		--InitAllZones()
		LeavePlayer()
		LearnEvent()
		InitTrig_Entire()
		HideEverything()
		KeyRegistration()
		InitSelectionRegister()
		InitMouseMoveTrigger()
		--BadChat() -- Функция для починки чата
	end
end

function InitHEROTable()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		HERO[i]={
			pid=i,
			UnitHero=nil,
			MarkIsActivated=false,
		}
	end
end