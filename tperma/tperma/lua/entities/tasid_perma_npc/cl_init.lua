include("shared.lua")

surface.CreateFont("XeninUI.NPC", {
  size = 90,
  font = "Montserrat"
})

local icon = Material("upload-your-own", "smooth")

function ENT:Draw()
  self:DrawModel()

  local ply = LocalPlayer()
  local pos = self:GetPos()
  local eyePos = ply:GetPos()
  local dist = pos:Distance(eyePos)
  local alpha = math.Clamp(1500 - dist * 2.7, 0, 255)

  if (alpha <= 0) then return end

  local angle = self:GetAngles()
  local eyeAngle = ply:EyeAngles()

  angle:RotateAroundAxis(angle:Forward(), 90)
  angle:RotateAroundAxis(angle:Right(), - 90)

  cam.Start3D2D(pos + self:GetUp() * 90, Angle(0, eyeAngle.y - 90, 90), 0.04)
    local alpha = alpha
    local text = "Permanent Weapons"
    local icon = icon
    local hover = true
    local xOffset = 0
    local textOffset = -10
    local col = XeninUI.Theme.Red
    col = ColorAlpha(col, alpha)

    local str = text
    surface.SetFont("XeninUI.NPC")
    local width = surface.GetTextSize(str)
    width = width + 40
    if (icon) then
      width = width + (64 * 3)
    else
      width = width + 64
    end

    local center = 900 / 2
    local x = -width / 2 - 30 + (xOffset or 0)
    local y = 180
    local sin = math.sin(CurTime() * 2)
    if (hover) then
      y = math.Round(y + (sin * 30))
    end
    local h = 64 * 3

    XeninUI:DrawRoundedBox(h / 2, x, y, width, h, col)
    XeninUI:DrawRoundedBox(h / 2, x + 4, y + 4, width - 8, h - 8, Color(32, 32, 32, alpha))
    draw.SimpleText(str, "XeninUI.NPC", x + h + (icon and 0 or 32 + 14) + textOffset, h / 2 + y, Color(225, 225, 225, alpha), icon and TEXT_ALIGN_LEFT or TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if (icon) then
      surface.SetDrawColor(ColorAlpha(XeninUI.Theme.Primary, alpha))
      surface.SetMaterial(icon)
      local margin = 40
      surface.DrawTexturedRect(x + margin, y + margin, h - (margin * 2), h - (margin * 2))
    end

  cam.End3D2D()
end
