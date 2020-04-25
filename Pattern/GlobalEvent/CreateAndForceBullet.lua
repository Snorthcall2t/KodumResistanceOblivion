---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bergi.
--- DateTime: 06.02.2020 12:47
---
function CreateAndForceBullet(hero,angle,speed,effectmodel,xs,ys,damage)
	local CollisionRange=100
	if not damage then damage=200 end
	local xhero,yhero=GetUnitX(hero),GetUnitY(hero)
	local zhero=GetUnitZ(hero)+60
	local bullet=AddSpecialEffect(effectmodel,xs,ys)
	local bam=nil--AddSpecialEffect("Abilities/Weapons/SteamTank/SteamTankImpact.mdl",xs,ys)
	local cloud=nil--AddSpecialEffect("Abilities/Weapons/SteamTank/SteamTankImpact.mdl",xs,ys)
	local CollisionEnemy=false
	local CollisisonDestr=false
	local DamagingUnit=nil
	BlzSetSpecialEffectScale(bam,0.1)
	BlzSetSpecialEffectScale(cloud,0.02)
	DestroyEffect(bam)
	DestroyEffect(cloud)
	BlzSetSpecialEffectZ(bullet,zhero)
	local angleCurrent=angle
	TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
		local x,y,z=BlzGetLocalSpecialEffectX(bullet),BlzGetLocalSpecialEffectY(bullet),BlzGetLocalSpecialEffectZ(bullet)
		local zGround=GetTerrainZ(MoveX(x,speed*2,angleCurrent),MoveY(y,speed*2,angleCurrent))
		BlzSetSpecialEffectPosition(bullet,MoveX(x,speed,angleCurrent),MoveY(y,speed,angleCurrent),z-2)
		--BlzSetSpecialEffectPosition(cloud,MoveX(x,speed/3,angle),MoveY(y,speed/3,angle),z-2)
		SetFogStateRadius(GetOwningPlayer(hero),FOG_OF_WAR_VISIBLE,x,y,400,true)-- Небольгая подсветка

		--local xbam,ybam=BlzGetLocalSpecialEffectX(bam),BlzGetLocalSpecialEffectY(bam)
		--BlzSetSpecialEffectPosition(bam,MoveX(xbam,2*data.CurrentSpeed,GetUnitFacing(hero)),MoveY(ybam,2*data.CurrentSpeed,GetUnitFacing(hero)),z-50)
		local ZBullet=BlzGetLocalSpecialEffectZ(bullet)
		--print("zGround ="..zGround.."z= "..z)
		--BlzSetSpecialEffectPosition(bam,MoveX(GetUnitX(hero),120,GetUnitFacing(hero)),MoveY(GetUnitY(hero),120,GetUnitFacing(hero)),z)
		CollisionEnemy,DamagingUnit=UnitDamageArea(hero,damage,x,y,CollisionRange,ZBullet)
		CollisisonDestr=PointContentDestructable(x,y,100,false)
		local PerepadZ=zGround-z
		if  z<=147 or CollisionEnemy or CollisisonDestr or IsUnitType(DamagingUnit,UNIT_TYPE_STRUCTURE) or PerepadZ>50 then --or zGround+z>=-70+z
			PointContentDestructable(x,y,100,true)
			if z<=-90 then
				--CreateTorrent(x,y)
				--BlzSetSpecialEffectPosition(bullet,4000,4000,0)
			end
			--print("Условие урона прошло")
			--UnitDamageArea(hero,100,x,y,CollisionRange,ZBullet)
			if IsUnitType(hero,UNIT_TYPE_HERO) then
				local data=HERO[GetPlayerId(GetOwningPlayer(hero))]
				if data.Perk16 and IsUnitEnemy(hero,GetOwningPlayer(DamagingUnit)) and DamagingUnit then
					--print("файрболим "..GetUnitName(DamagingUnit))
					local dummy=CreateUnit(GetOwningPlayer(hero), DummyID, x, y, 0)--
					UnitAddAbility(dummy,FourCC('A00G'))
					UnitApplyTimedLife(dummy,FourCC('BTLF'),0.1)
					Cast(dummy,0,0,DamagingUnit)
					--DestroyEffect(bullet)
					--DestroyTimer(GetExpiredTimer())
				end
			end
			--блок разворота снаряда
			if IsUnitType(DamagingUnit,UNIT_TYPE_HERO) then
				local data=HERO[GetPlayerId(GetOwningPlayer(DamagingUnit))]
				if data.ReleaseLMB and data.Perk14 then
					local AngleUnitRad = math.rad(GetUnitFacing(DamagingUnit))  -- data.LastTurn
					--local AngleSource = math.deg(AngleBetweenXY(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target)))
					local Vector3 = wGeometry.Vector3
					local UnitFacingVector = Vector3:new(math.cos(AngleUnitRad), math.sin(AngleUnitRad), 0)  -- вектор поворота юнита
					local AngleSourceVector = Vector3:new(GetUnitX(hero) - GetUnitX(DamagingUnit), GetUnitY(hero) - GetUnitY(DamagingUnit), 0)  -- вектор получения от урона (by Doc)
					AngleSourceVector = AngleSourceVector:normalize()
					local dot = UnitFacingVector:dotProduct(AngleSourceVector)
					--print(dot)
					if 0 < dot then
						--print("Отклонение снаряда щитом")
						angleCurrent=GetUnitFacing(DamagingUnit)
						BlzSetSpecialEffectPosition(bullet,MoveX(x,speed*2,angleCurrent),MoveY(y,speed*2,angleCurrent),z-2)
					else
						DestroyEffect(bullet)
						DestroyTimer(GetExpiredTimer())
					end
				else
					DestroyEffect(bullet)
					DestroyTimer(GetExpiredTimer())
				end
			else
				DestroyEffect(bullet)
				DestroyTimer(GetExpiredTimer())
			end

			if not DamagingUnit then
				DestroyEffect(bullet)
				DestroyTimer(GetExpiredTimer())
			end
		end
	end)
end

function SingleCannon(hero,angle,modelEff,damage)
	if not angle then angle=GetUnitFacing(hero) end
	local x=MoveX(GetUnitX(hero),80,angle)
	local y=MoveY(GetUnitY(hero),80,angle)
	--print("x создания="..x.." y="..y..GetUnitName(hero))
	if not modelEff then modelEff="Abilities/Weapons/BoatMissile/BoatMissile.mdl" end
	CreateAndForceBullet(hero,angle,30,modelEff,x,y,damage)
end

---@param board real
function BoardCannon(hero,board,cannon) -- left -90 right+90
	local facing=GetUnitFacing(hero)
	local angle=facing+board
	local x=MoveX(GetUnitX(hero),60,angle)
	local y=MoveY(GetUnitY(hero),60,angle)
	local inverse=-1
	if board==-90 then inverse =1 end
	local x1=MoveX(x,30,facing)
	local y1=MoveY(y,30,facing)
	local x2=MoveX(x,-30,facing)
	local y2=MoveY(y,-30,facing)
	local x3=MoveX(x,-60,facing)
	local y3=MoveY(y,-60,facing)
	local x4=MoveX(x,-90,facing)
	local y4=MoveY(y,-90,facing)
	if cannon>=1 then
		CreateAndForceBullet(hero,angle,30,"Abilities/Weapons/BoatMissile/BoatMissile.mdl",x,y)--Центр
	end
	if cannon>=2 then
		CreateAndForceBullet(hero,angle+5*inverse,30,"Abilities/Weapons/BoatMissile/BoatMissile.mdl",x1,y1)--Спереди
	end
	if cannon>=3 then
		CreateAndForceBullet(hero,angle-5*inverse,30,"Abilities/Weapons/BoatMissile/BoatMissile.mdl",x2,y2)--Сзади 1
	end
	if cannon>=4 then
		CreateAndForceBullet(hero,angle-10*inverse,30,"Abilities/Weapons/BoatMissile/BoatMissile.mdl",x3,y3)--Сзади 2
	end
	if cannon>=5 then
		CreateAndForceBullet(hero,angle-15*inverse,30,"Abilities/Weapons/BoatMissile/BoatMissile.mdl",x4,y4)--Сзади 3
	end
end

function CreateFire(hero,board)
	local data=HERO[GetPlayerId(GetOwningPlayer(hero))]
	local facing=GetUnitFacing(hero)
	--board=board+90
	local angle=facing+board
	local x=MoveX(GetUnitX(hero),60,angle)
	local y=MoveY(GetUnitY(hero),60,angle)

	--local fire=AddSpecialEffect("FireGun.mdl",x,y)
	local fire=AddSpecialEffect("Flame Thrower.mdl",x,y)
	local inverse=1
	if board==1 then inverse=-1 end
	BlzSetSpecialEffectMatrixScale(fire,1,1,1)

	TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
		--local xf,yf,zf=BlzGetLocalSpecialEffectX(fire),BlzGetLocalSpecialEffectY(fire),BlzGetLocalSpecialEffectZ(fire)
		local xhero,yhero=GetUnitX(hero),GetUnitY(hero)
		--local nx,ny=MoveX(xhero,80,GetUnitFacing(hero)-board),MoveY(yhero,80,GetUnitFacing(hero)-board)
		local nx,ny=MoveXY(xhero,yhero,10,GetUnitFacing(hero)-board)
		local z=GetUnitZ(hero)
		BlzSetSpecialEffectPosition(fire,nx,ny,z-140+89)
		BlzPlaySpecialEffect(fire,ANIM_TYPE_BIRTH)
		--HeroUpdateWeaponCharges(hero,4,1)

		--print("z Огня="..BlzGetLocalSpecialEffectZ(fire))

		if board==0 then
			BlzSetSpecialEffectYaw(fire,math.rad(GetUnitFacing(hero)+board-5-90))
			UnitDamageLine(hero,10,nx,ny,80,80*6,GetUnitFacing(hero)+board-5-90,GetUnitZ(hero)+50)
		else
			local problem=GetUnitFacing(hero)+board-5+90
			--print("проблемный угол="..problem)
			BlzSetSpecialEffectYaw(fire,math.rad(problem))
			UnitDamageLine(hero,10,nx,ny,80,80*6,GetUnitFacing(hero)+board-5+90,GetUnitZ(hero)+50)
		end
		if (data.ReleaseRMB==false and board==0)  then
			--print("отключен вручную")
			DestroyEffect(fire)
			DestroyTimer(GetExpiredTimer())
			BlzPlaySpecialEffect(fire,ANIM_TYPE_DEATH)
		end
		if (data.ReleaseLMB==false and board==1)  then
			DestroyEffect(fire)
			DestroyTimer(GetExpiredTimer())
			BlzPlaySpecialEffect(fire,ANIM_TYPE_DEATH)
		end
		if Ammo[GetPlayerId(GetOwningPlayer(hero))].Count.Fire<=0 then
			--print("закончились заряды")
			DestroyEffect(fire)
			DestroyTimer(GetExpiredTimer())
			BlzPlaySpecialEffect(fire,ANIM_TYPE_DEATH)
		end
		HeroUpdateWeaponCharges(hero,4,1)
	end)
end

function CreateBarrel(hero,angle,dist)
	local x,y=GetUnitXY(hero)
	local id=GetPlayerId(GetOwningPlayer(hero))
	local barrel=AddSpecialEffect("Barrel_Unit.mdl",x,y)
	if angle==nil then	angle=AngleBetweenXY(x,y,GetPlayerMouseX[id],GetPlayerMouseY[id])/bj_DEGTORAD end
	if dist==nil then dist=DistanceBetweenXY(x,y,GetPlayerMouseX[id],GetPlayerMouseY[id]) end
	if dist>=200 then dist=200 end
	if dist<=100 then dist=100 end
	BlzSetSpecialEffectYaw(barrel,math.rad(angle))
	BlzPlaySpecialEffect(barrel,ANIM_TYPE_WALK)
	BlzSetSpecialEffectZ(barrel,GetUnitZ(hero))
	JumpEffect(barrel,dist/20,150,angle,dist,hero,1)
end

function CreateArtToss(hero,effectmodel,angle,dist,flag)
	local x,y=GetUnitXY(hero)
	local id=GetPlayerId(GetOwningPlayer(hero))
	local art=AddSpecialEffect(effectmodel,x,y)
	if angle==nil then angle=AngleBetweenXY(x,y,GetPlayerMouseX[id],GetPlayerMouseY[id])/bj_DEGTORAD end
	if dist==nil then dist=DistanceBetweenXY(x,y,GetPlayerMouseX[id],GetPlayerMouseY[id]) end
	if dist>=1200 then dist=1200 end
	if dist<=200 then dist=200 end
	local speed=dist/50
	BlzSetSpecialEffectYaw(art,math.rad(angle))
	---BlzPlaySpecialEffect(barrel,ANIM_TYPE_WALK)
	if flag==nil then
		JumpEffect(art,speed,700,angle,dist,hero,2)
	elseif flag==3 then--Стрельба простых пушек
		JumpEffect(art,speed*2,200,angle,dist*.7,hero,flag,GetUnitZ(hero)+150)--осколочный мелкий
	else
		JumpEffect(art,speed,300,angle,dist,hero,flag)--любой другой
	end
end

function JumpEffect(eff,speed, maxHeight,angle,distance,hero,flag,ZStart)
	local i=0
	if ZStart==nil then ZStart=GetUnitZ(hero) end
	TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
		local x,y=BlzGetLocalSpecialEffectX(eff),BlzGetLocalSpecialEffectY(eff)
		local nx,ny=MoveXY(x,y,speed,angle)
		local f=ParabolaZ(maxHeight,distance,i*speed)+ZStart
		local z=BlzGetLocalSpecialEffectZ(eff)
		local zGround=GetTerrainZ(nx,ny)
		BlzSetSpecialEffectPosition(eff,nx,ny,f)
		i=i+1
		if i==10 then
			if flag==4 then
				EffectAddRegistrationCollision(eff,hero,150,0,1)
			end
		end


		if z<=zGround and i>5 then
			if flag==nil then -- без флага

			end

			if flag==1 then -- бочка со взрывчаткой и таймером
				BlzPlaySpecialEffect(eff,ANIM_TYPE_STAND)
				if CreateTorrent(nx,ny) then
					WaveEffect(eff)
					EffectAddExplodedTimer(eff,3,hero)
				else
					--BlzSetSpecialEffectZ(eff,z+30)
					ExplodeEffect(eff,3)
					UnitDamageArea(hero,500,nx,ny,250)
				end
			elseif flag==2 then -- навесной разделяющийся
				CreateTorrent(nx,ny)
				if ExplodeEffect(eff,3)==false then-- взрыв не на воде
					--print("разделяемся")
					--[[for i=1,7 do
						local cluster=AddSpecialEffect("Abilities/Spells/Other/Volcano/VolcanoMissile.mdl",nx,ny)
						BlzSetSpecialEffectZ(cluster,z)
						BlzSetSpecialEffectScale(cluster,0.4)
						JumpEffect(cluster,10,GetRandomInt(50,150),GetRandomInt(0,359),GetRandomInt(50,200),hero,3)
					end]]
				end
				DestroyEffect(eff)
				UnitDamageArea(hero,210,nx,ny,150,127)
				--print("урон прошел")
			elseif  flag==3 then-- осколки
				CreateTorrent(nx,ny)
				DestroyEffect(eff)
				UnitDamageArea(hero,100,nx,ny,200,z)
			elseif  flag==4 then-- выпрыгнул гоблин
				if CreateTorrent(nx,ny,0.1) then
					BlzSetSpecialEffectZ(eff,-90)

				else
					DestroyEffect(eff)
				end
			end
			DestroyTimer(GetExpiredTimer())
		end
	end)
end

function EffectAddRegistrationCollision(eff,hero,range,duration,flag)
	local sec=duration
	local infinity=false
	if duration==nil or duration==0 then infinity=true end
	TimerStart(CreateTimer(), 0.1, true, function()
		local x,y,z=BlzGetLocalSpecialEffectX(eff),BlzGetLocalSpecialEffectY(eff),BlzGetLocalSpecialEffectZ(eff)
		local e=nil
		GroupEnumUnitsInRange(perebor,x,y,range,nil)
		while true do
			e = FirstOfGroup(perebor)
			if e == nil then break end
			if UnitAlive(e) and IsUnitZCollision(e,z) then
				--print("Эффет столкнулся с "..GetUnitName(e))
				if flag==1 then-- орк в уточке
					if IsUnitType(hero,UNIT_TYPE_HERO) then
						RemoveEffect(eff)
						PlaySoundAtPointBJ( gg_snd_Load, 100, Location(x,y), 0 )
						DestroyTimer(GetExpiredTimer())
						HealUnit(hero,100)
						--print("Лечение подбор орка для"..GetUnitName(hero))
					end
				elseif flag==2 then-- глубоководная мина
					if IsUnitEnemy(e,GetOwningPlayer(hero)) then
						UnitDamageArea(hero,100,x,y,200,z)
					end
				end
			end
			GroupRemoveUnit(perebor,e)
		end
		sec=sec-1
		if sec<0 and infinity==false then
			DestroyEffect(eff)
			DestroyTimer(GetExpiredTimer())
		end
	end)
end

function CreateLightingCharges(hero)
	local data=HERO[GetPlayerId(GetOwningPlayer(hero))]
	--print("1")
	TimerStart(CreateTimer(), 0.7, true, function()
		if data.ReleaseRMB then
			HeroUpdateWeaponCharges(hero,7,-1)
			FindEnemyForLighting(hero,500)
		else
			DestroyTimer(GetExpiredTimer())
		end
	end)
end

function FindEnemyForLighting(hero, range)
	local e=nil
	local x,y=GetUnitXY(hero)

	GroupEnumUnitsInRange(perebor,x,y,range,nil)
	--print("2")
	while true do
		e = FirstOfGroup(perebor)
		if e == nil then break end
		if UnitAlive(e) and IsUnitEnemy(e,GetOwningPlayer(hero)) and IsUnitVisible(e,GetOwningPlayer(hero))  then
			--print("найден враг")
			if HeroUpdateWeaponCharges(hero,7,1) then
				local dummy=CreateUnit(GetOwningPlayer(hero), DummyID, GetUnitX(hero), GetUnitY(hero), 0)
				SetUnitZ(dummy,GetUnitZ(hero)+90)
				UnitAddAbility(dummy,FourCC('A00B'))-- молния
				UnitApplyTimedLife(dummy,DummyID,1)
				if not Cast(dummy,0,0,e) then
					HeroUpdateWeaponCharges(hero,7,-1)
				end
			else
				DestroyTimer(GetExpiredTimer())
			end
		end
		GroupRemoveUnit(perebor,e)
	end
end

function SawActivated(hero)
	local data=HERO[GetPlayerId(GetOwningPlayer(hero))]
	local saw=AddSpecialEffect(SawDiskModel,GetUnitXY(hero))
	local id=UnitGetPid(hero)
	BlzSetSpecialEffectScale(saw,0.7)
	--HeroUpdateWeaponCharges(hero,8,-1)
	--print("пила активирована")
	local CurAngle=GetUnitFacing(hero)
	TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
		local x,y=GetUnitXY(hero)
		local angle=AngleBetweenXY(x,y,GetPlayerMouseX[id],GetPlayerMouseY[id])/bj_DEGTORAD
		--angle=math.abs(angle)
		--print(angle)
		--if CurAngle>=angle-10 and CurAngle<=angle+10 then
		if data.ReleaseRMB then
			if CurAngle <=angle then
				if CurAngle<angle-10 then
					CurAngle=CurAngle+5
				end
			else
				CurAngle=CurAngle-5
			end
		end

		local nx,ny=MoveXY(x,y,130,angle)

		if UnitDamageArea(hero,30,nx,ny,150,GetUnitZ(hero)+50,"Abilities/Weapons/AncestralGuardianMissile/AncestralGuardianMissile.mdl") then
			--[[if HeroUpdateWeaponCharges(hero,8,1) then
			else
				DestroyTimer(GetExpiredTimer())
				DestroyEffect(saw)
			end]]
		end


		BlzSetSpecialEffectPosition(saw,nx,ny,GetUnitZ(hero)+20)
		if  data.WeaponIndex~=8 then
			DestroyTimer(GetExpiredTimer())
			DestroyEffect(saw)
		end
	end)
end