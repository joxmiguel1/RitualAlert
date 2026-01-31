local addonName, addonTable = ...
local L = addonTable and addonTable.L or {}

-- ==== SAVED SETTINGS ====
local DEFAULT_SETTINGS = {
    enabled = {
        start = true,
        interrupt = true,
        eclipse = true,
        void = true,
    },
    tomtom = {
        enabled = true,
    },
    debug = false,
}
local function InitDB()
    if type(RitualAlertDB) ~= "table" then
        RitualAlertDB = {}
    end
    if type(RitualAlertDB.enabled) ~= "table" then
        RitualAlertDB.enabled = {}
    end
    if RitualAlertDB.enabled.start == nil then
        RitualAlertDB.enabled.start = DEFAULT_SETTINGS.enabled.start
    end
    if RitualAlertDB.enabled.interrupt == nil then
        RitualAlertDB.enabled.interrupt = DEFAULT_SETTINGS.enabled.interrupt
    end
    if RitualAlertDB.enabled.eclipse == nil then
        RitualAlertDB.enabled.eclipse = DEFAULT_SETTINGS.enabled.eclipse
    end
    if RitualAlertDB.enabled["void"] == nil then
        RitualAlertDB.enabled["void"] = DEFAULT_SETTINGS.enabled["void"]
    end
    if type(RitualAlertDB.tomtom) ~= "table" then
        RitualAlertDB.tomtom = {}
    end
    if RitualAlertDB.tomtom.enabled == nil then
        RitualAlertDB.tomtom.enabled = DEFAULT_SETTINGS.tomtom.enabled
    end
    if RitualAlertDB.debug == nil then
        RitualAlertDB.debug = DEFAULT_SETTINGS.debug
    end
end

local function NormalizeLoose(msg)
    if type(msg) ~= "string" then
        return ""
    end
    msg = msg:gsub("\n", " ")
    msg = msg:gsub("[^%w%s]", " ")
    msg = msg:gsub("%s+", " ")
    return msg:lower()
end

local function NormalizeList(list)
    if type(list) ~= "table" then return {} end
    local out = {}
    for i = 1, #list do
        out[i] = NormalizeLoose(list[i])
    end
    return out
end

local function GetMatchList(key, fallback)
    local match = (L.match and L.match[key]) or fallback or {}
    return NormalizeList(match)
end

local optionsPanelCreated = false
local function CreateOptionsPanel()
    if optionsPanelCreated then return end
    optionsPanelCreated = true

    local panel = CreateFrame("Frame", nil, UIParent)
    panel.name = "Ritual Alert"

    local purple = { 0.75, 0.2, 1 }

    local banner = panel:CreateTexture(nil, "ARTWORK")
    banner:SetSize(440, 122)
    banner:SetPoint("TOPLEFT", 16, -16)
    banner:SetTexture("Interface\\AddOns\\RitualAlert\\Textures\\banner.tga")

    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", banner, "BOTTOMLEFT", 0, -28)
    title:SetText("Ritual Alerts")
    title:SetTextColor(purple[1], purple[2], purple[3])

    local subtitle = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    subtitle:SetWidth(520)
    subtitle:SetJustifyH("LEFT")
    subtitle:SetText("Enable or disable alerts for Twilight Ascension ritual messages.")
    subtitle:SetTextColor(1, 1, 1)

    local alertsHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    alertsHeader:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -12)
    alertsHeader:SetText("Alerts")
    alertsHeader:SetTextColor(purple[1], purple[2], purple[3])

    local cbStart = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    cbStart:SetPoint("TOPLEFT", alertsHeader, "BOTTOMLEFT", -2, -6)
    cbStart.Text:SetText("Begun summoning (ritual started)")
    cbStart.Text:SetTextColor(1, 1, 1)

    local cbInterrupt = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    cbInterrupt:SetPoint("TOPLEFT", cbStart, "BOTTOMLEFT", 0, -8)
    cbInterrupt.Text:SetText("Ritual interrupted")
    cbInterrupt.Text:SetTextColor(1, 1, 1)

    local cbEclipse = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    cbEclipse:SetPoint("TOPLEFT", cbInterrupt, "BOTTOMLEFT", 0, -8)
    cbEclipse.Text:SetText("Voice of the Eclipse")
    cbEclipse.Text:SetTextColor(1, 1, 1)

    local cbVoid = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    cbVoid:SetPoint("TOPLEFT", cbEclipse, "BOTTOMLEFT", 0, -8)
    cbVoid.Text:SetText("Ephemeral Void manifested")
    cbVoid.Text:SetTextColor(1, 1, 1)

    local tomTomHeader = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    tomTomHeader:SetPoint("TOPLEFT", cbVoid, "BOTTOMLEFT", 2, -12)
    tomTomHeader:SetText("TomTom")
    tomTomHeader:SetTextColor(purple[1], purple[2], purple[3])

    local cbTomTom = CreateFrame("CheckButton", nil, panel, "InterfaceOptionsCheckButtonTemplate")
    cbTomTom:SetPoint("TOPLEFT", tomTomHeader, "BOTTOMLEFT", -2, -6)
    cbTomTom.Text:SetText("TomTom: Automatic waypoint for any alert")
    cbTomTom.Text:SetTextColor(1, 1, 1)

    local function Refresh()
        InitDB()
        cbStart:SetChecked(RitualAlertDB.enabled.start ~= false)
        cbInterrupt:SetChecked(RitualAlertDB.enabled.interrupt ~= false)
        cbEclipse:SetChecked(RitualAlertDB.enabled.eclipse ~= false)
        cbTomTom:SetChecked(RitualAlertDB.tomtom and RitualAlertDB.tomtom.enabled ~= false)
        cbVoid:SetChecked(RitualAlertDB.enabled["void"] ~= false)
    end

    cbStart:SetScript("OnClick", function(self)
        InitDB()
        RitualAlertDB.enabled.start = self:GetChecked() and true or false
    end)
    cbInterrupt:SetScript("OnClick", function(self)
        InitDB()
        RitualAlertDB.enabled.interrupt = self:GetChecked() and true or false
    end)
    cbEclipse:SetScript("OnClick", function(self)
        InitDB()
        RitualAlertDB.enabled.eclipse = self:GetChecked() and true or false
    end)
    cbTomTom:SetScript("OnClick", function(self)
        InitDB()
        RitualAlertDB.tomtom.enabled = self:GetChecked() and true or false
    end)
    cbVoid:SetScript("OnClick", function(self)
        InitDB()
        RitualAlertDB.enabled["void"] = self:GetChecked() and true or false
    end)

    panel.Refresh = Refresh
    panel:SetScript("OnShow", Refresh)

    if Settings and Settings.RegisterCanvasLayoutCategory then
        local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(category)
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(panel)
    end
end

-- ==== CONFIGURATION ====
local ALERTS = {
    start = {
        key = "start",
        -- Partial, case-insensitive matches.
        matchAny = GetMatchList("start", { "twilight's blade have begun summoning more forces" }),
        dynamicMessage = true,
        color = { 1, 0.55, 0.05 }, -- orange
        flashType = "ORANGE",
        sound = function()
            if PlaySound then
                local soundID = (SOUNDKIT and SOUNDKIT.RAID_WARNING) or 8959
                PlaySound(soundID, "Master")
            end
        end,
    },
    eclipse = {
        key = "eclipse",
        matchAny = GetMatchList("eclipse", { "the voice of the eclipse has emerged" }),
        dynamicMessage = true,
        color = { 0.75, 0.2, 1 }, -- purple
        flashType = "PURPLE",
        sound = function()
            if PlaySound then
                local soundID = (SOUNDKIT and SOUNDKIT.RAID_WARNING) or 8959
                PlaySound(soundID, "Master")
            end
        end,
    },
    void = {
        key = "void",
        matchAny = GetMatchList("void", { "ephemeral void has manifested" }),
        dynamicMessage = true,
        color = { 0.75, 0.2, 1 }, -- purple
        flashType = "PURPLE",
        sound = function()
            if PlaySound then
                local soundID = (SOUNDKIT and SOUNDKIT.RAID_WARNING) or 8959
                PlaySound(soundID, "Master")
            end
        end,
    },
    interrupt = {
        key = "interrupt",
        matchAny = GetMatchList("interrupt", { "ritual has been interrupted" }),
        dynamicMessage = true,
        color = { 1, 0.2, 0.2 }, -- red
        flashType = "RED",
        sound = function()
            if PlaySound then
                local soundID = (SOUNDKIT and SOUNDKIT.RAID_WARNING) or 8959
                PlaySound(soundID, "Master")
            end
        end,
    },
}

local ALERT_ORDER = { "start", "eclipse", "void", "interrupt" }

-- ==== ALERT UI (based on LootHunter) ====
local ACCENT_FONT = "Interface\\AddOns\\RitualAlert\\Fonts\\Prototype.ttf"

local alertMsgFrame = CreateFrame("MessageFrame", nil, UIParent)
alertMsgFrame:SetSize(760, 120)
alertMsgFrame:SetPoint("CENTER", 0, 160)
alertMsgFrame:SetFrameStrata("FULLSCREEN_DIALOG")
alertMsgFrame:SetInsertMode("TOP")
alertMsgFrame:SetFading(true)
alertMsgFrame:SetFadeDuration(0.5)
alertMsgFrame:SetTimeVisible(6.5)
alertMsgFrame:SetFont(ACCENT_FONT, 34, "THICKOUTLINE")

local flashFrame = CreateFrame("Frame", nil, UIParent)
flashFrame:SetAllPoints()
flashFrame:SetFrameStrata("FULLSCREEN_DIALOG")
flashFrame:Hide()

local flashTex = flashFrame:CreateTexture(nil, "BACKGROUND")
flashTex:SetAllPoints()
flashTex:SetBlendMode("ADD")

local function FlashScreen(flashType)
    if StaticPopup1 and StaticPopup1:IsVisible() then return end
    flashTex:SetAlpha(1)
    if flashType == "RED" then
        flashTex:SetTexture("Interface\\FullScreenTextures\\LowHealth")
        flashTex:SetVertexColor(1, 0.15, 0.15, 1)
    elseif flashType == "ORANGE" then
        flashTex:SetTexture("Interface\\Buttons\\WHITE8X8")
        flashTex:SetVertexColor(1, 0.6, 0, 0.35)
    elseif flashType == "PURPLE" then
        flashTex:SetTexture("Interface\\Buttons\\WHITE8X8")
        flashTex:SetVertexColor(0.6, 0.1, 1, 0.35)
    else
        flashTex:SetTexture("Interface\\Buttons\\WHITE8X8")
        flashTex:SetVertexColor(1, 1, 1, 0.25)
    end
    UIFrameFlash(flashFrame, 0.5, 2.0, 2.5, false, 0, 0)
end

local function ShowAlert(text, r, g, b)
    if StaticPopup1 and StaticPopup1:IsVisible() then return end
    alertMsgFrame:AddMessage(text, r, g, b)
end

-- ==== MESSAGE MATCHING ====
local lastAlertKey = nil
local lastAlertTime = 0
local function TriggerAlert(alertDef, rawMessage)
    if not alertDef then return end
    if RitualAlertDB and RitualAlertDB.enabled and RitualAlertDB.enabled[alertDef.key] == false then
        return
    end
    local now = GetTime and GetTime() or 0
    if lastAlertKey == alertDef.key and (now - lastAlertTime) < 2 then
        return
    end
    lastAlertKey = alertDef.key
    lastAlertTime = now
    FlashScreen(alertDef.flashType)
    local msg = rawMessage or ""
    if msg == "" then
        msg = "Ritual Alert"
    end
    ShowAlert(msg, alertDef.color[1], alertDef.color[2], alertDef.color[3])
    if alertDef.sound then alertDef.sound() end
end

local function TryTomTomWaypointFromMessage(rawMessage, attemptsLeft)
    if not (RitualAlertDB and RitualAlertDB.tomtom and RitualAlertDB.tomtom.enabled) then return end
    if not (TomTom and TomTom.AddWaypoint and C_VignetteInfo and C_VignetteInfo.GetVignettes) then return end
    if not (C_Map and C_Map.GetBestMapForUnit) then return end

    local playerMapID = C_Map.GetBestMapForUnit("player")
    if not playerMapID then return end

    local messageNorm = NormalizeLoose(rawMessage or "")
    local vignettes = C_VignetteInfo.GetVignettes()
    if type(vignettes) ~= "table" or #vignettes == 0 then
        if attemptsLeft and attemptsLeft > 0 and C_Timer then
            C_Timer.After(0.5, function()
                TryTomTomWaypointFromMessage(rawMessage, attemptsLeft - 1)
            end)
        end
        return
    end

    local candidates = {}
    local bestGUID = nil
    local bestName = nil
    for i = 1, #vignettes do
        local guid = vignettes[i]
        local info = guid and C_VignetteInfo.GetVignetteInfo(guid)
        local name = info and info.name
        if name and name ~= "" then
            local nameNorm = NormalizeLoose(name)
            local pos = C_VignetteInfo.GetVignettePosition(guid, playerMapID)
            if pos and pos.x and pos.y then
                table.insert(candidates, { guid = guid, name = name, nameNorm = nameNorm, pos = pos })
            end
            if nameNorm ~= "" and (messageNorm:find(nameNorm, 1, true) or nameNorm:find(messageNorm, 1, true)) then
                bestGUID = guid
                bestName = name
                break
            end
        end
    end
    local function IsEclipseCandidate(entry)
        return entry and entry.nameNorm and entry.nameNorm:find("eclipse", 1, true) ~= nil
    end

    if not bestGUID then
        if messageNorm:find("eclipse", 1, true) then
            for i = 1, #candidates do
                if candidates[i].nameNorm and candidates[i].nameNorm:find("eclipse", 1, true) then
                    bestGUID = candidates[i].guid
                    bestName = candidates[i].name
                    break
                end
            end
        end
    end
    if not bestGUID then
        if messageNorm:find("void", 1, true) then
            for i = 1, #candidates do
                if candidates[i].nameNorm and candidates[i].nameNorm:find("void", 1, true) then
                    bestGUID = candidates[i].guid
                    bestName = candidates[i].name
                    break
                end
            end
        end
    end
    if not bestGUID and #candidates >= 1 then
        local playerPos = C_Map.GetPlayerMapPosition(playerMapID, "player")
        if playerPos and playerPos.x and playerPos.y then
            local bestDist = nil
            for i = 1, #candidates do
                local dx = candidates[i].pos.x - playerPos.x
                local dy = candidates[i].pos.y - playerPos.y
                local dist = (dx * dx) + (dy * dy)
                if not bestDist or dist < bestDist then
                    bestDist = dist
                    bestGUID = candidates[i].guid
                    bestName = candidates[i].name
                end
            end
        else
            bestGUID = candidates[1].guid
            bestName = candidates[1].name
        end
    end
    if not bestGUID then
        if attemptsLeft and attemptsLeft > 0 and C_Timer then
            C_Timer.After(0.5, function()
                TryTomTomWaypointFromMessage(rawMessage, attemptsLeft - 1)
            end)
        end
        return
    end

    local function AddWaypointForGuid(guid, fallbackTitle)
        local pos = C_VignetteInfo.GetVignettePosition(guid, playerMapID)
        if not pos or not pos.x or not pos.y then
            return nil
        end
        local info = C_VignetteInfo.GetVignetteInfo(guid)
        local title = (info and info.name) or fallbackTitle or "World Event"
        return TomTom:AddWaypoint(playerMapID, pos.x, pos.y, { title = title, persistent = false })
    end

    local added = {}
    local firstGuid = bestGUID
    local firstName = bestName
    if #candidates >= 2 then
        local nonEclipse = {}
        for i = 1, #candidates do
            if not IsEclipseCandidate(candidates[i]) then
                table.insert(nonEclipse, candidates[i])
            end
        end
        if #nonEclipse >= 1 then
            local playerPos = C_Map.GetPlayerMapPosition(playerMapID, "player")
            local bestDist = nil
            local pick = nonEclipse[1]
            if playerPos and playerPos.x and playerPos.y then
                for i = 1, #nonEclipse do
                    local dx = nonEclipse[i].pos.x - playerPos.x
                    local dy = nonEclipse[i].pos.y - playerPos.y
                    local dist = (dx * dx) + (dy * dy)
                    if not bestDist or dist < bestDist then
                        bestDist = dist
                        pick = nonEclipse[i]
                    end
                end
            end
            firstGuid = pick.guid
            firstName = pick.name
        end
    end

    local firstUid = nil
    local firstTitle = firstName or "World Event"
    firstUid = AddWaypointForGuid(firstGuid, firstTitle)
    if firstUid then
        added[firstGuid] = true
    end

    if #candidates >= 2 then
        local playerPos = C_Map.GetPlayerMapPosition(playerMapID, "player")
        local bestAltGuid = nil
        local bestAltDist = nil
        for i = 1, #candidates do
            local guid = candidates[i].guid
            if not added[guid] then
                if playerPos and playerPos.x and playerPos.y then
                    local dx = candidates[i].pos.x - playerPos.x
                    local dy = candidates[i].pos.y - playerPos.y
                    local dist = (dx * dx) + (dy * dy)
                    if not bestAltDist or dist < bestAltDist then
                        bestAltDist = dist
                        bestAltGuid = guid
                    end
                else
                    bestAltGuid = guid
                    break
                end
            end
        end
        if bestAltGuid then
            AddWaypointForGuid(bestAltGuid, "World Event")
        end
    end

    if TomTom.SetCrazyArrow and firstUid then
        TomTom:SetCrazyArrow(firstUid, 0, firstTitle)
    end
end

local function IsPlayerGuid(guid)
    return type(guid) == "string" and guid:match("^Player%-") ~= nil
end

local function ShouldIgnoreEvent(event, sender, guid)
    if C_Map and C_Map.GetBestMapForUnit then
        local mapID = C_Map.GetBestMapForUnit("player")
        if mapID ~= 241 then
            return true
        end
    end
    if IsPlayerGuid(guid) then
        return true
    end
    if event == "CHAT_MSG_RAID_WARNING" and sender and sender ~= "" then
        return true
    end
    return false
end

local function TryMatchMessage(msg)
    local text = NormalizeLoose(msg)
    if text == "" then return end
    for i = 1, #ALERT_ORDER do
        local def = ALERTS[ALERT_ORDER[i]]
        if def and def.matchAny then
            for j = 1, #def.matchAny do
                if text:find(def.matchAny[j], 1, true) then
                    TriggerAlert(def, msg)
                    C_Timer.After(0.2, function()
                        TryTomTomWaypointFromMessage(msg, 6)
                    end)
                    break
                end
            end
        end
    end
end

-- ==== EVENTS ====
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
local events = {
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_RAID_WARNING",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_SYSTEM",
}
for i = 1, #events do
    f:RegisterEvent(events[i])
end
f:SetScript("OnEvent", function(_, event, ...)
    local arg1 = ...
    if event == "ADDON_LOADED" and arg1 == addonName then
        InitDB()
        CreateOptionsPanel()
        print("|cff9a6bff[Ritual Alert]|r loaded. Configure in Esc > Options > AddOns > Ritual Alert.")
        return
    end
    local _, sender, _, _, _, _, _, _, _, _, guid = ...
    if ShouldIgnoreEvent(event, sender, guid) then
        return
    end
    TryMatchMessage(arg1)
end)

-- ==== SLASH COMMANDS ====
SLASH_RITUALALERT1 = "/ritualalert"
SLASH_RITUALALERT2 = "/ra"
SlashCmdList.RITUALALERT = function(msg)
    InitDB()
    local cmd = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if cmd == "start" then
        RitualAlertDB.enabled.start = not RitualAlertDB.enabled.start
        local state = RitualAlertDB.enabled.start and "ON" or "OFF"
        print("|cffffa500Ritual Alert|r: Begun summoning alert " .. state)
        return
    end
    if cmd == "interrupt" then
        RitualAlertDB.enabled.interrupt = not RitualAlertDB.enabled.interrupt
        local state = RitualAlertDB.enabled.interrupt and "ON" or "OFF"
        print("|cffffa500Ritual Alert|r: Ritual interrupted alert " .. state)
        return
    end
    if cmd == "eclipse" then
        RitualAlertDB.enabled.eclipse = not RitualAlertDB.enabled.eclipse
        local state = RitualAlertDB.enabled.eclipse and "ON" or "OFF"
        print("|cffffa500Ritual Alert|r: Voice of the Eclipse alert " .. state)
        return
    end
    if cmd == "debug" then
        RitualAlertDB.debug = not RitualAlertDB.debug
        local state = RitualAlertDB.debug and "ON" or "OFF"
        print("|cffffa500Ritual Alert|r: Debug logging " .. state)
        return
    end
    print("|cffffa500Ritual Alert|r: /ra start | /ra interrupt | /ra eclipse | /ra debug | /ra status")
    print("|cffffa500Ritual Alert|r: start=" .. tostring(RitualAlertDB.enabled.start) .. " interrupt=" .. tostring(RitualAlertDB.enabled.interrupt) .. " eclipse=" .. tostring(RitualAlertDB.enabled.eclipse) .. " debug=" .. tostring(RitualAlertDB.debug))
end
