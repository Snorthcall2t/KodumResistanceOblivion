---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bergi.
--- DateTime: 19.04.2020 17:39
function LeavePlayer()
	local this = CreateTrigger()
	TriggerRegisterPlayerEventLeave(this, Player(0))
	TriggerRegisterPlayerEventLeave(this, Player(1))
	TriggerRegisterPlayerEventLeave(this, Player(2))
	TriggerRegisterPlayerEventLeave(this, Player(3))

	TriggerAddAction(this, function()
		local p=GetTriggerPlayer()
		local data=HERO[GetPlayerId(p)]
		StartPeonAI(data.UnitHero)
	end)
end