-- Creating the main frame
local frame = CreateFrame("Frame", "COMBATLOG", UIParent, "BasicFrameTemplate")
frame:SetSize(700, 500)
frame:SetPoint("CENTER", UIParent, "CENTER")

-- Makes the fram movable
frame:SetMovable(true)
frame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" then
	  self:StartMoving()
  end
end)
frame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" then
	  self:StopMovingOrSizing()
  end
end)

-- Add a title to the window
frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
frame.title:SetPoint("TOP", frame, "TOP", 0, -5)
frame.title:SetText("COMBATLOG")


-- Create a scrollable text area inside the window
frame.scrollArea = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
frame.scrollArea:SetSize(680, 440)
frame.scrollArea:SetPoint("TOPLEFT", 8, -30)
frame.scrollArea:SetPoint("BOTTOMRIGHT", -28, 8)

frame.scrollChild = CreateFrame("Frame")
frame.scrollArea:SetScrollChild(frame.scrollChild)
frame.scrollChild:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth()-18)
frame.scrollChild:SetHeight(1)

-- Create a text frame inside the scrollable area
frame.scrollArea.text = frame.scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
frame.scrollArea.text:SetPoint("TOPLEFT", frame.scrollChild, "TOPLEFT", 5, -5)
frame.scrollArea.text:SetWidth(680)
frame.scrollArea.text:SetJustifyH("LEFT")
frame.scrollArea.text:SetJustifyV("TOP")

frame.scrollArea.text:SetText("\n")





local function AppendText(text)
    local currentText = frame.scrollArea.text:GetText()
    frame.scrollArea.text:SetText(text .. "\n" .. currentText)
end

-- Slash command handler
SLASH_BCL1 = "/bcl"
SlashCmdList["BCL"] = function()
    frame:Show()
end


local playerGUID = UnitGUID("player")
local MSG_HIT = "[%s] %s hit you for %d damage with %s"

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT")
f:SetScript("OnEvent", function(self, event)


  local timestamp, subevent, _, sourceGUID, sourceName, _, _, destGUID, _ = CombatLogGetCurrentEventInfo()
  local spellId, amount, critical

  local clockTime = date("%H:%M", timestamp)

  local prefixType = string.match(subevent, "([^_]+)")
  local suffixType = string.match(subevent, "[^_]+$")


	if prefixType == "SWING" and suffixType == "DAMAGE" then
		amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
	elseif prefixType == "SPELL" and suffixType == "DAMAGE" then
		spellId, _, _, amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
	elseif prefixType == "RANGE" and suffixType == "DAMAGE" then
		spellId, _, _, amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
	end

  if destGUID == playerGUID and sourceGUID ~= playerGUID then
    if amount ~= nil and amount > 0 then
      local action = spellId and GetSpellLink(spellId) or MELEE
      AppendText(MSG_HIT:format(clockTime, sourceName, amount, action))
    end
  end

end)