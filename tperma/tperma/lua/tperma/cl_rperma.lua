tperma.pages = {
	{
		name = "UNOWNED WEAPONS",
		content = function(frame, ent, purchases)
			local self = tperma
			
			local sp = vgui.Create("XeninUI.ScrollPanel", frame)
			sp:Dock(FILL)
			
			for _, v in pairs(self.config.categories) do
				local category = vgui.Create("DPanel", sp)
				category:Dock(TOP)
				category:SetTall(30)
				category:DockMargin(5, 5, 5, 5)
				category.Paint = function(s, w, h)
					draw.RoundedBox(0, 0, 0, w, h, v[2])
					draw.SimpleText(v[1], "tpermaTitle", 10, h / 2, Color(220, 220, 220), 0, 1)
				end
				
				local row = vgui.Create("DPanel", sp)
				row:Dock(TOP)
				row:SetTall(84)
				row.Paint = function() end
				
				local n = 0
				
				for k2, v2 in pairs(tperma.config.weapons) do
					if v2.category == v[1] then
						if n != 0 and n % 3 == 0 then
							row = vgui.Create("DPanel", sp)
							row:Dock(TOP)
							row:SetTall(84 + 5)
							row.Paint = function() end
						end
					
						local wepinfo = weapons.Get(k2)
						
						local item = vgui.Create("DPanel", row)
						item:Dock(LEFT)
						item:DockMargin(5, n > 2 and 5 or 0, 0, 0)
						item:SetWide((frame:GetWide() / 3) - 11)
						item.Paint = function(s, w, h)
							draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 2))
							draw.SimpleText(wepinfo.PrintName, "tpermaTitle", 10, 5, Color(220, 220, 220))
							draw.SimpleText(DarkRP.formatMoney(v2.price), "tpermaPrice", 10, 30, LocalPlayer():canAfford(v2.price) and Color(0, 195, 165) or Color(255, 50, 50))
						end
						
						if not purchases[k2] then
							local h = vgui.Create("DPanel", item)
							h:Dock(BOTTOM)
							h:SetTall(26)
							h:DockMargin(5, 10, 5, 5)
							h.Paint = function() end
							
							local btn = vgui.Create("DButton", h)
							btn:SetWide((item:GetWide() / 2) - 5)
							btn:Dock(LEFT)
							btn:SetText("Purchase")
							btn:SetFont("tpermaBTN")
							btn:DockMargin(0, 0, 5, 0)
							btn:SetTextColor(Color(220, 220, 220))
							btn.DoClick = function()
								net.Start("tperma_purchase")
									net.WriteEntity(ent)
									net.WriteString(k2)
								net.SendToServer()
							end
							btn.Paint = function(s, w, h)
								draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 3))
								if s:IsHovered() then
									draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 2))
								end
							end
							
							local btn = vgui.Create("DButton", h)
							btn:SetWide((item:GetWide() / 2) - 5)
							btn:Dock(LEFT)
							btn:SetText("Preview")
							btn:SetFont("tpermaBTN")
							btn:SetTextColor(Color(220, 220, 220))
							btn.Paint = function(s, w, h)
								draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 3))
								if s:IsHovered() then
									draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 2))
								end
							end
							btn.DoClick = function()
								if self.config.previewstyle == 1 then
									local f = vgui.Create("XeninUI.Frame")
									f:SetSize(200, 250)
									f:Center()
									f:MakePopup()
									f:SetTitle("Preview")
									f.Think = function()
										if !frame:IsValid() then f:Remove() end
									end
									
									local holder = vgui.Create("DPanel", f)
									holder:Dock(FILL)
									holder:DockMargin(20, 20, 20, 20)
									holder.Paint = function(s, w, h)
										surface.SetDrawColor(Color(255, 255, 255))
										surface.SetMaterial(Material("vgui/entities/"..k2..".vmt"))
										surface.DrawTexturedRect(0, 0, h, h)
									end
								else
									local f = vgui.Create("DFrame")
									f:SetSize(200, 200)
									f:Center()
									f:MakePopup()
									f:ShowCloseButton(false)
									f:SetTitle("")
									f.Think = function(s)
										if not frame:IsValid() then f:Close() end
									end
									f.Paint = function(s, w, h)
										draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20))
										surface.SetDrawColor(Color(255, 255, 255))
										surface.SetMaterial(Material("vgui/entities/"..k2..".vmt"))
										surface.DrawTexturedRect(5, 5, w - 10, h - 10)
										surface.SetDrawColor(XeninUI.Theme.Primary)
										for i=0, 2 - 1 do
											surface.DrawOutlinedRect( 0 + i, 0 + i, w - i * 2, h - i * 2 )
										end
									end
								end
							end
						else
							local btn = vgui.Create("DButton", item)
							btn:Dock(BOTTOM)
							btn:SetTall(26)
							btn:SetText("")
							btn:DockMargin(5, 0, 5, 5)
							btn.Paint = function(s, w, h)
								draw.RoundedBox(4, 0, 0, w, h, purchases[k2].equipped == 0 and Color(0, 195, 165, 10) or Color(255, 50, 50, 10))
								if s:IsHovered() then
									draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 1))
								end
								draw.SimpleText(purchases[k2].equipped == 0 and "Equip" or "Unequip", "tpermaBTN", w/2, h/2, Color(220, 220, 220), 1, 1)
							end
							btn.DoClick = function()
								net.Start("tperma_equip")
									net.WriteEntity(ent)
									net.WriteString(k2)
									net.WriteInt(purchases[k2].equipped == 0 and 1 or 0, 3)
								net.SendToServer()
								
								purchases[k2].equipped = purchases[k2].equipped == 0 and 1 or 0
							end
						end
					
						n = n + 1
					end
				end
			end
			
			local gap = vgui.Create("DPanel", sp)
			gap:SetTall(5)
			gap:Dock(TOP)
			gap.Paint = function() end
			
			return sp
		end,
	},
	
	{
		name = "OWNED WEAPONS",
		content = function(frame, ent, purchases)
			local self = tperma
			
			local sp = vgui.Create("XeninUI.ScrollPanel", frame)
			sp:Dock(FILL)
			
			local n = 0
			
			if table.Count(purchases) > 0 then
				row = vgui.Create("DPanel", sp)
				row:Dock(TOP)
				row:SetTall(84)
				row.Paint = function() end
				
				for k, v in pairs(purchases) do
					if n != 0 and n % 3 == 0 then
						row = vgui.Create("DPanel", sp)
						row:Dock(TOP)
						row:SetTall(84 + 5)
						row.Paint = function() end
					end
					
					local wepinfo = weapons.Get(k)
							
					local item = vgui.Create("DPanel", row)
					item:Dock(LEFT)
					item:DockMargin(5, 5, 0, 0)
					item:SetWide((frame:GetWide() / 3) - 11)
					item.Paint = function(s, w, h)
						draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 2))
						draw.RoundedBox(4, 5, 29, w - 10, 15, Color(0, 0, 0, 50))
						draw.RoundedBox(4, 5, 29, v.durability * ((w - 10) / v.durability), 15, Color(255, 50, 50, 20))
						draw.SimpleText("DURABILITY: "..tostring(v.durability).." / 100", "tpermaSmall", w / 2, 29, Color(220, 220, 220), 1)
						draw.SimpleText(wepinfo.PrintName, "tpermaTitle", 10, 5, Color(220, 220, 220))
					end
					
					local btn = vgui.Create("DButton", item)
					btn:Dock(BOTTOM)
					btn:SetTall(26)
					btn:SetText("")
					btn:DockMargin(5, 0, 5, 5)
					btn.Paint = function(s, w, h)
						draw.RoundedBox(4, 0, 0, w, h, purchases[k].equipped == 0 and Color(0, 195, 165, 10) or Color(255, 50, 50, 10))
						if s:IsHovered() then
							draw.RoundedBox(4, 0, 0, w, h, Color(255, 255, 255, 1))
						end
						draw.SimpleText(purchases[k].equipped == 0 and "Equip" or "Unequip", "tpermaBTN", w/2, h/2, Color(220, 220, 220), 1, 1)
					end
					btn.DoClick = function()
						net.Start("tperma_equip")
							net.WriteEntity(ent)
							net.WriteString(k)
							net.WriteInt(purchases[k].equipped == 0 and 1 or 0, 3)
						net.SendToServer()
						
						purchases[k].equipped = purchases[k].equipped == 0 and 1 or 0
					end
					
					n = n + 1
				end
			else
				local notings = vgui.Create("DPanel", sp)
				notings:Dock(TOP)
				notings:SetTall(60)
				notings.Paint = function(s, w, h)
					draw.SimpleText("You don't own any items!", "tpermaLarge", w / 2, h / 2, Color(220, 220, 220), 1, 1)
				end
			end
			
			return sp
		end
	}
}

function tperma:OpenMenu(ply, ent, purchases)
	XeninUI:CreateFont("tpermaLarge", 30)
	XeninUI:CreateFont("tpermaTitle", 20)
	XeninUI:CreateFont("tpermaPrice", 18)
	XeninUI:CreateFont("tpermaBTN", 18)
	XeninUI:CreateFont("tpermaSmall", 14)
	
	local frame = vgui.Create("XeninUI.Frame")
	frame:SetSize(900, 600)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Permanent Weapon Store")
	
	local nav = vgui.Create("XeninUI.Navbar", frame)
	nav:Dock(TOP)
	nav:SetTall(40)
	
	for k, v in pairs(self.pages) do
		nav:AddTab(v.name)
		nav.buttons[v.name].DoClick = function()
			self.curpage:Remove()
			
			self.curpage = self.pages[k].content(frame, ent, purchases)
			self.curpagename = self.pages[k].name
	
			nav:SetActive(self.curpagename)
		end
	end
	
	self.curpagename = self.pages[1].name
	self.curpage = self.pages[1].content(frame, ent, purchases)
	
	nav:SetActive(self.curpagename)
	
	net.Receive("tperma_success", function()
		frame:Remove()
	end)
end

net.Receive("tperma_openmenu", function()
	tperma:OpenMenu(LocalPlayer(), net.ReadEntity(), net.ReadTable())
end)
