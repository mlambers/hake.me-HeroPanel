-- HeroPanel.lua (Version 1.1)
-- Release Date: 3/8/2018

local HeroPanel = {}

HeroPanel.optionEnable = Menu.AddOption({ "Gravitycrusher7", "Hero Panel" }, "Enable", "Enabled/Disabled ?")
HeroPanel.offsetY = Menu.AddOption({ "Gravitycrusher7", "Hero Panel" }, "Y Offset", "", 100, 500, 10)

HeroPanel.cachedIcons = {}
HeroPanel.cachedIconsz = nil
HeroPanel.heroIconPath = "resource/flash3/images/heroes/"
HeroPanel.heroIconPath2 = "~/heroes/"
HeroPanel.itemsPath = "resource/flash3/images/items/"
HeroPanel.font = Renderer.LoadFont("Verdana", 13, Enum.FontWeight.LIGHT)
HeroPanel.fontCD = Renderer.LoadFont("Verdana", 13, Enum.FontWeight.BOLD)
HeroPanel.fontLevel = Renderer.LoadFont("Verdana", 13, Enum.FontWeight.MEDIUM)
handlers = {}
handlersz = {}
function HeroPanel.OnDraw()
	if not Menu.IsEnabled(HeroPanel.optionEnable) then return end
	
	local myHero = Heroes.GetLocal()
	
	if not myHero then return end
	local myTeam = Entity.GetTeamNum(myHero)
	
	-- draw parameters
	local drawX = 10
	local drawY = Menu.GetValue(HeroPanel.offsetY)
	local lineGap = 20
	local wordGap = 10
	local maxWidth = 200
	local maxGold = 1
	local rectHeight = lineGap - 1
	local heroIconWidth = math.floor(rectHeight * 128 / 72) 
	local w, h = Renderer.GetScreenSize()
	local isSameTeamTable = {}
	
	for i = 1, Heroes.Count() do
		local hero = Heroes.Get(i)
		local heroName = NPC.GetUnitName(hero)
		
		isSameTeamTable[#isSameTeamTable + 1] = {heroName, hero}
	end
		
	for i, v in ipairs(isSameTeamTable) do
		local heroName = v[1]
		local enemyHero = v[2]
		
		if not NPC.IsIllusion(enemyHero) and not Entity.IsSameTeam(myHero, enemyHero) or heroName == "npc_dota_hero_morphling" and NPC.HasModifier(enemyHero, "modifier_morphling_replicate_manager") and not Entity.IsSameTeam(myHero, enemyHero)  then
			--Log.Write(NPC.GetCurrentLevel(enemyHero))
			-- draw hero icon
			local tmpHeroName
			
			if heroName == "npc_dota_hero_dark_willow" then
				tmpHeroName = heroName
			elseif  heroName == "npc_dota_hero_pangolier" then
				tmpHeroName = "npc_dota_hero_pangolier"
			else
				tmpHeroName = string.gsub(heroName, "npc_dota_hero_", "")
			end
			--local tmpHeroName = string.gsub(heroName, "npc_dota_hero_", "")
			--tmpHeroName = heroName
			local imageHandle
			if handlers[tmpHeroName] then -- need to cache image handlers, instead of calling LoadImage() evrytime
				imageHandle = handlers[tmpHeroName]
			else
				if heroName == "npc_dota_hero_dark_willow" then
					imageHandle = Renderer.LoadImage(HeroPanel.heroIconPath2 .. tmpHeroName .. ".png")
					handlers[tmpHeroName] = imageHandle
				elseif  heroName == "npc_dota_hero_pangolier" then
					imageHandle = Renderer.LoadImage(HeroPanel.heroIconPath2 .. tmpHeroName .. ".png")
					handlers[tmpHeroName] = imageHandle
				else
					imageHandle = Renderer.LoadImage(HeroPanel.heroIconPath .. tmpHeroName .. ".png")
					handlers[tmpHeroName] = imageHandle
				end
			end
			
			-- Draw Item Bar border
			-- Slot 1
			Renderer.SetDrawColor(10, 18, 31, 150)
			Renderer.DrawFilledRect(w/2 - 630, drawY+24, 36, 28)
			
			Renderer.SetDrawColor(0, 0, 0, 150)
			Renderer.DrawFilledRect(w/2 - 626, drawY + 28, 28, 20)
			-- Slot 2
			Renderer.SetDrawColor(10, 18, 31, 150)
			Renderer.DrawFilledRect(w/2 - 595, drawY+24, 36, 28)
			
			Renderer.SetDrawColor(0, 0, 0, 150)
			Renderer.DrawFilledRect(w/2 - 591, drawY + 28, 28, 20)
			-- Slot 3
			Renderer.SetDrawColor(10, 18, 31, 150)
			Renderer.DrawFilledRect(w/2 - 560, drawY+24, 36, 28)
			
			Renderer.SetDrawColor(0, 0, 0, 150)
			Renderer.DrawFilledRect(w/2 - 556, drawY + 28, 28, 20)
			-- Slot 4
			Renderer.SetDrawColor(10, 18, 31, 150)
			Renderer.DrawFilledRect(w/2 - 525, drawY+24, 36, 28)
			
			Renderer.SetDrawColor(0, 0, 0, 150)
			Renderer.DrawFilledRect(w/2 - 521, drawY + 28, 28, 20)
			-- Slot 5
			Renderer.SetDrawColor(10, 18, 31, 150)
			Renderer.DrawFilledRect(w/2 - 490, drawY+24, 36, 28)
			
			Renderer.SetDrawColor(0, 0, 0, 150)
			Renderer.DrawFilledRect(w/2 - 486, drawY + 28, 28, 20)
			-- Slot 6
			Renderer.SetDrawColor(10, 18, 31, 150)
			Renderer.DrawFilledRect(w/2 - 455, drawY+24, 36, 28)
			
			Renderer.SetDrawColor(0, 0, 0, 150)
			Renderer.DrawFilledRect(w/2 - 451, drawY + 28, 28, 20)
			
			for i = 0, 5 do 
				local item = NPC.GetItemByIndex(enemyHero, i)
				
				if item ~= nil and Entity.IsAbility(item) then
					local cd = math.ceil(Ability.GetCooldown(item))
					
					local tempName = Ability.GetName(NPC.GetItemByIndex(enemyHero, i))
					tempName = tempName:gsub("item_", "")
					local imageHandle = HeroPanel.cachedIcons[tempName]
					if imageHandle == nil then
						imageHandle = Renderer.LoadImage(HeroPanel.itemsPath .. tempName .. ".png")
						HeroPanel.cachedIcons[tempName] = imageHandle
					end
					if i == 0 then
						
						if cd > 0 then
							Renderer.SetDrawColor(150, 150, 150, 255)
							Renderer.DrawImage(imageHandle, w/2 - 626, drawY + 28, 28, 20)
						
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawTextCentered(HeroPanel.fontCD, (w/2 - 626)+14, (drawY + 28)+10, cd, true)
						else
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawImage(imageHandle, w/2 - 626, drawY + 28, 28, 20)
							
							
						end
						
						if Input.IsCursorInRect(w/2 - 626, drawY + 28, 28, 20) then
								
							if Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_MIDDLE) then
									
								Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PING_ABILITY, 0, Vector(), item, 0, nil)
							end
						end
					elseif i == 1 then
						if cd > 0 then
							Renderer.SetDrawColor(150, 150, 150, 255)
							Renderer.DrawImage(imageHandle, w/2 - 591, drawY + 28, 28, 20)
							
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawTextCentered(HeroPanel.fontCD, (w/2 - 591)+14, (drawY + 28)+10, cd, true)
						else
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawImage(imageHandle, w/2 - 591, drawY + 28, 28, 20)
						end
						
						if Input.IsCursorInRect(w/2 - 591, drawY + 28, 28, 20) then
								
							if Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_MIDDLE) then
									
								Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PING_ABILITY, 0, Vector(), item, 0, nil)
							end
						end
					elseif i == 2 then
						if cd > 0 then
							Renderer.SetDrawColor(150, 150, 150, 255)
							Renderer.DrawImage(imageHandle, w/2 - 556, drawY + 28, 28, 20)
							
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawTextCentered(HeroPanel.fontCD, (w/2 - 556)+14, (drawY + 28)+10, cd, true)
						else
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawImage(imageHandle, w/2 - 556, drawY + 28, 28, 20)
						end
						
						if Input.IsCursorInRect(w/2 - 556, drawY + 28, 28, 20) then
								
							if Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_MIDDLE) then
									
								Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PING_ABILITY, 0, Vector(), item, 0, nil)
							end
						end
					elseif i == 3 then
						if cd > 0 then
							Renderer.SetDrawColor(150, 150, 150, 255)
							Renderer.DrawImage(imageHandle, w/2 - 521, drawY + 28, 28, 20)
							
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawTextCentered(HeroPanel.fontCD, (w/2 - 521)+14, (drawY + 28)+10, cd, true)
						else
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawImage(imageHandle, w/2 - 521, drawY + 28, 28, 20)
						end
						
						if Input.IsCursorInRect(w/2 - 521, drawY + 28, 28, 20) then
								
							if Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_MIDDLE) then
									
								Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PING_ABILITY, 0, Vector(), item, 0, nil)
							end
						end
					elseif i == 4 then
						if cd > 0 then
							Renderer.SetDrawColor(150, 150, 150, 255)
							Renderer.DrawImage(imageHandle, w/2 - 486, drawY + 28, 28, 20)
							
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawTextCentered(HeroPanel.fontCD, (w/2 - 486)+14, (drawY + 28)+10, cd, true)
						else
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawImage(imageHandle, w/2 - 486, drawY + 28, 28, 20)
						end
						
						if Input.IsCursorInRect(w/2 - 486, drawY + 28, 28, 20) then
								
							if Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_MIDDLE) then
									
								Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PING_ABILITY, 0, Vector(), item, 0, nil)
							end
						end
					elseif i == 5 then
						if cd > 0 then
							Renderer.SetDrawColor(150, 150, 150, 255)
							Renderer.DrawImage(imageHandle, w/2 - 451, drawY + 28, 28, 20)
							
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawTextCentered(HeroPanel.fontCD, (w/2 - 451)+14, (drawY + 28)+10, cd, true)
						else
							Renderer.SetDrawColor(255, 255, 255, 255)
							Renderer.DrawImage(imageHandle, w/2 - 451, drawY + 28, 28, 20)
						end
						
						if Input.IsCursorInRect(w/2 - 451, drawY + 28, 28, 20) then
								
							if Input.IsKeyDownOnce(Enum.ButtonCode.MOUSE_MIDDLE) then
									
								Player.PrepareUnitOrders(Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_PING_ABILITY, 0, Vector(), item, 0, nil)
							end
						end
					end
				end
			end
		
			--Draw border box
			Renderer.SetDrawColor(10, 18, 31, 150)
			--Renderer.SetDrawColor(80, 80, 80, 125)
			Renderer.DrawFilledRect(1, drawY - 5, heroIconWidth + 150 , 28 )
			--Draw heroes icon
			Renderer.SetDrawColor(255, 255, 255, 255)
			Renderer.DrawImage(imageHandle, drawX, drawY, heroIconWidth, rectHeight)
			
			if Entity.IsAlive(enemyHero) then
				if Entity.GetHealth(enemyHero) > Entity.GetMaxHealth(enemyHero)*0.85 then
					-- Draw HP 85%
					Renderer.SetDrawColor(0, 255, 0, 255)
					local rectWidth = math.floor( 125*(Entity.GetHealth(enemyHero) / Entity.GetMaxHealth(enemyHero)))
					Renderer.DrawFilledRect(w/2 - 630, drawY,rectWidth, 8)
					
					-- Draw HP Bar border
					Renderer.SetDrawColor(0, 0, 0, 255)
					Renderer.DrawOutlineRect(w/2 - 630, drawY, 125, 8)
				elseif Entity.GetHealth(enemyHero) > Entity.GetMaxHealth(enemyHero)*0.70 and Entity.GetHealth(enemyHero) < Entity.GetMaxHealth(enemyHero)*0.85 then
					-- Draw HP 70% - 85%
					Renderer.SetDrawColor(240, 255, 0, 255)
					local rectWidth = math.floor( 125*(Entity.GetHealth(enemyHero) / Entity.GetMaxHealth(enemyHero)))
					Renderer.DrawFilledRect(w/2 - 630, drawY,rectWidth, 8)
					
					-- Draw HP Bar border
					Renderer.SetDrawColor(0, 0, 0, 255)
					Renderer.DrawOutlineRect(w/2 - 630, drawY, 125, 8)
				elseif Entity.GetHealth(enemyHero) > Entity.GetMaxHealth(enemyHero)*0.55 and Entity.GetHealth(enemyHero) < Entity.GetMaxHealth(enemyHero)*0.70 then
					-- Draw HP 55% - 70%
					Renderer.SetDrawColor(255,206,0, 255)
					local rectWidth = math.floor( 125*(Entity.GetHealth(enemyHero) / Entity.GetMaxHealth(enemyHero)))
					Renderer.DrawFilledRect(w/2 - 630, drawY,rectWidth, 8)
					
					-- Draw HP Bar border
					Renderer.SetDrawColor(0, 0, 0, 255)
					Renderer.DrawOutlineRect(w/2 - 630, drawY, 125, 8)
				elseif Entity.GetHealth(enemyHero) > Entity.GetMaxHealth(enemyHero)*0.40 and Entity.GetHealth(enemyHero) < Entity.GetMaxHealth(enemyHero)*0.55 then
					-- Draw HP 40% - 55%
					Renderer.SetDrawColor(255,154,0, 255)
					local rectWidth = math.floor( 125*(Entity.GetHealth(enemyHero) / Entity.GetMaxHealth(enemyHero)))
					Renderer.DrawFilledRect(w/2 - 630, drawY,rectWidth, 8)
					
					-- Draw HP Bar border
					Renderer.SetDrawColor(0, 0, 0, 255)
					Renderer.DrawOutlineRect(w/2 - 630, drawY, 125, 8)
				elseif Entity.GetHealth(enemyHero) > Entity.GetMaxHealth(enemyHero)*0.25 and Entity.GetHealth(enemyHero) < Entity.GetMaxHealth(enemyHero)*0.40 then
					-- Draw HP 25% - 40%
					Renderer.SetDrawColor(255,90,0, 255)
					local rectWidth = math.floor( 125*(Entity.GetHealth(enemyHero) / Entity.GetMaxHealth(enemyHero)))
					Renderer.DrawFilledRect(w/2 - 630, drawY,rectWidth, 8)
					
					-- Draw HP Bar border
					Renderer.SetDrawColor(0, 0, 0, 255)
					Renderer.DrawOutlineRect(w/2 - 630, drawY, 125, 8)
				elseif Entity.GetHealth(enemyHero) > Entity.GetMaxHealth(enemyHero)*0.10 and Entity.GetHealth(enemyHero) < Entity.GetMaxHealth(enemyHero)*0.25 then
					-- Draw HP 10% - 25%
					Renderer.SetDrawColor(255,0,0, 255)
					local rectWidth = math.floor( 125*(Entity.GetHealth(enemyHero) / Entity.GetMaxHealth(enemyHero)))
					Renderer.DrawFilledRect(w/2 - 630, drawY,rectWidth, 8)
					
					-- Draw HP Bar border
					Renderer.SetDrawColor(0, 0, 0, 255)
					Renderer.DrawOutlineRect(w/2 - 630, drawY, 125, 8)
				elseif Entity.GetHealth(enemyHero) < Entity.GetMaxHealth(enemyHero)*0.10 then
					-- Draw HP < 10
					Renderer.SetDrawColor(200,40,48, 255)
					local rectWidth = math.floor( 125*(Entity.GetHealth(enemyHero) / Entity.GetMaxHealth(enemyHero)))
					Renderer.DrawFilledRect(w/2 - 630, drawY,rectWidth, 8)
					
					-- Draw HP Bar border
					Renderer.SetDrawColor(0, 0, 0, 255)
					Renderer.DrawOutlineRect(w/2 - 630, drawY, 125, 8)
				end
				
				-- Draw Mana Bar
				Renderer.SetDrawColor(41, 151, 255, 255)
				local rectWidth = math.floor( 125*(NPC.GetMana(enemyHero) /NPC.GetMaxMana(enemyHero)))
				Renderer.DrawFilledRect(w/2 - 630, drawY+11, rectWidth, 8)
			
			
				-- Draw Mana Bar border
				Renderer.SetDrawColor(0, 0, 0, 255)
				Renderer.DrawOutlineRect(w/2 - 630, drawY+11, 125, 8)
			elseif not Entity.IsAlive(enemyHero) then
				Renderer.SetDrawColor(255, 255, 255, 255)
				Renderer.DrawText(HeroPanel.font, w/2 - 590, drawY+1, "DEATH", 1)
			end
			
			-- Draw Text HP Bar
			Renderer.SetDrawColor(255, 255, 255, 255)
			Renderer.DrawText(HeroPanel.font, w/2 - 496, drawY-2,Entity.GetHealth(enemyHero) .. " / " .. Entity.GetMaxHealth(enemyHero), 1)
			
			-- Draw Text Mana Bar
			Renderer.SetDrawColor(255, 255, 255, 255)
			Renderer.DrawText(HeroPanel.font, w/2 - 496, drawY+10,  math.floor(NPC.GetMana(enemyHero) + 0.5) .. " / " .. math.floor(NPC.GetMaxMana(enemyHero) + 0.5) , 1)
			drawY = drawY + lineGap + 10 + 28
		end
	end
end



return HeroPanel
