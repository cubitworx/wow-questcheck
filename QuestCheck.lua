local questCheckPasteFrame = CreateFrame("Frame", "QuestCheckFrame", UIParent, "BackdropTemplate")
questCheckPasteFrame:SetSize(550, 350)
questCheckPasteFrame:SetPoint("CENTER")
questCheckPasteFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 12,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
questCheckPasteFrame:Hide()

questCheckPasteFrame.title = questCheckPasteFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
questCheckPasteFrame.title:SetPoint("TOP", 0, -10)
questCheckPasteFrame.title:SetText("Quest Completion Checker")

local editBox = CreateFrame("EditBox", nil, questCheckPasteFrame, "BackdropTemplate")
editBox:SetPoint("TOPLEFT", questCheckPasteFrame, "TOPLEFT", 5, -30)
editBox:SetPoint("BOTTOMRIGHT", questCheckPasteFrame, "BOTTOMRIGHT", -5, 30)
editBox:SetMultiLine(true)
editBox:SetAutoFocus(false)
editBox:SetFontObject(GameFontHighlight)
editBox:SetTextInsets(4, 4, 4, 4)
editBox:SetMaxLetters(2048)

editBox:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 32, edgeSize = 12,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
editBox:SetBackdropColor(0, 0, 0, 0.5)
editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

editBox:SetJustifyH("LEFT")
editBox:SetJustifyV("TOP")

local buttonWidth, buttonHeight = 60, 20

local checkButton = CreateFrame("Button", nil, questCheckPasteFrame, "GameMenuButtonTemplate")
checkButton:SetSize(buttonWidth, buttonHeight)
checkButton:SetPoint("BOTTOMLEFT", questCheckPasteFrame, "BOTTOMLEFT", 10, 5)
checkButton:SetText("Check")

local closeButton = CreateFrame("Button", nil, questCheckPasteFrame, "GameMenuButtonTemplate")
closeButton:SetSize(buttonWidth, buttonHeight)
closeButton:SetPoint("BOTTOMRIGHT", questCheckPasteFrame, "BOTTOMRIGHT", -10, 5)
closeButton:SetText("Close")
closeButton:SetScript("OnClick", function()
	questCheckPasteFrame:Hide()
end)

local function CheckQuests()
	local text = editBox:GetText()
	local questIDs = {}

	for line in text:gmatch("[^\r\n]+") do
		local questID, questTitle = line:match("^(%d+)%s*(.*)")
		if questID then
			local id = tonumber(questID)
			if id then
				local completed = C_QuestLog.IsQuestFlaggedCompleted(id) and "|cff00ff00complete|r" or "|cffff0000incomplete|r"
				local displayTitle = (questTitle ~= "" and questTitle) or questID
				table.insert(questIDs, displayTitle .. ": " .. completed)
			end
		end
	end

	-- Print results to chat window
	for _, result in ipairs(questIDs) do
		print(result)
	end
end

checkButton:SetScript("OnClick", CheckQuests)

-- Slash command to show the dialog
SLASH_QUESTCHECK1 = "/qcheck"
SlashCmdList["QUESTCHECK"] = function()
	questCheckPasteFrame:Show()
end
