' Better Roku OS main screen.
' Sections (in display order): favorites, apps, feed, archive, settings.

sub init()
    m.rows = m.top.findNode("rows")
    m.player = m.top.findNode("player")
    m.status = m.top.findNode("status")
    m.registry = CreateObject("roRegistrySection", "BetterRokuOS")
    m.clock = m.top.findNode("clock")
    m.date = m.top.findNode("date")
    m.clockTimer = m.top.findNode("clockTimer")
    m.clockTimer.observeField("fire", "updateClock")
    m.clockTimer.control = "start"
    updateClock()
    m.favs = loadFavs()
    m.allApps = []

    m.rows.observeField("rowItemSelected", "onItemSelected")
    m.player.observeField("state", "onPlayerState")

    m.sections = { favs: invalid, apps: invalid, feed: invalid, archive: invalid, settings: settingsRows() }
    m.messages = {}

    refreshApps()
    loadFeed()
    loadArchive()
    rebuild()
    m.rows.setFocus(true)
end sub

' ---------------- data loading ----------------

sub refreshApps()
    setMessage("apps", "Loading your apps...")
    m.appsTask = CreateObject("roSGNode", "EcpTask")
    m.appsTask.functionName = "queryApps"
    m.appsTask.observeField("result", "onApps")
    m.appsTask.control = "RUN"
end sub

sub onApps()
    r = m.appsTask.result
    m.allApps = r.items
    m.sections.apps = [{ title: "All Apps", items: r.items }]
    buildFavs()
    if r.ok
        setMessage("apps", "")
    else
        setMessage("apps", "Tip: set Settings > System > Advanced system settings > Control by mobile apps > Network access to 'Enabled' to show and launch your installed apps.")
    end if
    rebuild()
end sub

sub loadFeed()
    url = ""
    if m.registry.Exists("feedUrl") then url = m.registry.Read("feedUrl")
    m.feedTask = CreateObject("roSGNode", "FeedTask")
    m.feedTask.functionName = "loadFeed"
    m.feedTask.url = url
    m.feedTask.observeField("result", "onFeed")
    m.feedTask.control = "RUN"
end sub

sub onFeed()
    r = m.feedTask.result
    m.sections.feed = r.rows
    if r.ok then setMessage("feed", "") else setMessage("feed", r.error)
    rebuild()
end sub

sub loadArchive()
    m.archiveTask = CreateObject("roSGNode", "FeedTask")
    m.archiveTask.functionName = "loadArchive"
    m.archiveTask.observeField("result", "onArchive")
    m.archiveTask.control = "RUN"
end sub

sub onArchive()
    r = m.archiveTask.result
    m.sections.archive = r.rows
    if r.ok then setMessage("archive", "") else setMessage("archive", r.error)
    rebuild()
end sub

function settingsRows() as object
    return [{
        title: "Settings"
        items: [
            { title: "Set Home Media Feed URL", kind: "action", action: "seturl" }
            { title: "Use Built-in Feed", kind: "action", action: "reseturl" }
            { title: "Refresh Apps", kind: "action", action: "refreshapps" }
            { title: "Help", kind: "action", action: "help" }
        ]
    }]
end function

' ---------------- building the RowList ----------------

sub rebuild()
    ' Remember focus so async loads don't throw the user back to the top.
    focused = invalid
    if m.rows.content <> invalid then focused = m.rows.rowItemFocused

    root = CreateObject("roSGNode", "ContentNode")
    for each name in ["favs", "apps", "feed", "archive", "settings"]
        rows = m.sections[name]
        if rows <> invalid
            for each r in rows
                if r.items <> invalid and r.items.Count() > 0
                    rowNode = root.createChild("ContentNode")
                    rowNode.title = r.title
                    for each it in r.items
                        n = rowNode.createChild("ContentNode")
                        n.title = it.title
                        n.HDPosterUrl = s(it.poster)
                        n.addFields({
                            kind: s(it.kind)
                            appId: s(it.appId)
                            url: s(it.url)
                            format: s(it.format)
                            identifier: s(it.identifier)
                            action: s(it.action)
                        })
                    end for
                end if
            end for
        end if
    end for
    m.rows.content = root

    if focused <> invalid and focused.Count() = 2 and focused[0] >= 0 and focused[0] < root.getChildCount()
        m.rows.jumpToRowItem = focused
    end if
end sub

function s(v as dynamic) as string
    if v = invalid then return ""
    return v
end function

sub setMessage(key as string, msg as string)
    m.messages[key] = msg
    text = ""
    for each k in ["apps", "feed", "archive", "play"]
        if m.messages[k] <> invalid and m.messages[k] <> ""
            text = m.messages[k]
            exit for
        end if
    end for
    m.status.text = text
end sub

' ---------------- selection ----------------

sub onItemSelected()
    sel = m.rows.rowItemSelected
    row = m.rows.content.getChild(sel[0])
    if row = invalid then return
    item = row.getChild(sel[1])
    if item = invalid then return

    if item.kind = "app"
        launchApp(item.appId)
    else if item.kind = "video"
        playUrl(item.url, item.title, item.format)
    else if item.kind = "archive"
        resolveArchive(item.identifier, item.title)
    else if item.kind = "action"
        runAction(item.action)
    end if
end sub

sub launchApp(appId as string)
    setMessage("play", "Opening app...")
    m.launchTask = CreateObject("roSGNode", "EcpTask")
    m.launchTask.functionName = "launchApp"
    m.launchTask.appId = appId
    m.launchTask.observeField("result", "onLaunch")
    m.launchTask.control = "RUN"
end sub

sub onLaunch()
    r = m.launchTask.result
    if r.ok
        setMessage("play", "")
    else
        setMessage("play", "Couldn't open that app (code " + r.code.ToStr() + "). Make sure it's installed and 'Control by mobile apps' is Enabled.")
    end if
end sub

sub resolveArchive(identifier as string, title as string)
    setMessage("play", "Finding video for " + title + "...")
    m.resolveTask = CreateObject("roSGNode", "ResolveTask")
    m.resolveTask.identifier = identifier
    m.resolveTask.observeField("result", "onResolved")
    m.resolveTask.control = "RUN"
end sub

sub onResolved()
    r = m.resolveTask.result
    if r.ok
        setMessage("play", "")
        playUrl(r.url, r.title, "mp4")
    else
        setMessage("play", r.error)
    end if
end sub

' ---------------- playback ----------------

sub playUrl(url as string, title as string, format as string)
    if format = ""
        lower = LCase(url)
        if Instr(1, lower, ".m3u8") > 0
            format = "hls"
        else if Instr(1, lower, ".mpd") > 0
            format = "dash"
        else
            format = "mp4"
        end if
    end if
    c = CreateObject("roSGNode", "ContentNode")
    c.url = url
    c.title = title
    c.streamFormat = format
    m.player.content = c
    m.player.visible = true
    m.player.setFocus(true)
    m.player.control = "play"
end sub

sub stopVideo()
    m.player.control = "stop"
    m.player.visible = false
    m.rows.setFocus(true)
end sub

sub onPlayerState()
    state = m.player.state
    if state = "error"
        setMessage("play", "Playback error: " + m.player.errorMsg)
        stopVideo()
    else if state = "finished"
        stopVideo()
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false
    if key = "back" and m.player.visible
        stopVideo()
        return true
    end if
    if key = "options" and not m.player.visible
        toggleFocusedFav()
        return true
    end if
    return false
end function

' ---------------- settings actions ----------------

sub runAction(action as string)
    if action = "seturl"
        dlg = CreateObject("roSGNode", "StandardKeyboardDialog")
        dlg.title = "Home Media Feed URL"
        dlg.message = ["JSON or M3U playlist URL, e.g. http://192.168.1.20:8000/feed.json"]
        if m.registry.Exists("feedUrl") then dlg.text = m.registry.Read("feedUrl") else dlg.text = "http://"
        dlg.buttons = ["Save", "Cancel"]
        dlg.observeField("buttonSelected", "onUrlDialog")
        m.top.dialog = dlg
    else if action = "reseturl"
        m.registry.Delete("feedUrl")
        m.registry.Flush()
        loadFeed()
    else if action = "refreshapps"
        refreshApps()
    else if action = "help"
        dlg = CreateObject("roSGNode", "StandardMessageDialog")
        dlg.title = "Better Roku OS Help"
        dlg.message = [
            "All Apps: opens the real Netflix, Hulu, Disney+ and other apps installed on this Roku. Sign in with your own subscriptions."
            "Favorites: press * on any app to pin or unpin it at the top."
            "Free Public Domain rows: legal free films from the Internet Archive."
            "Home Media: point 'Set Home Media Feed URL' at a JSON or M3U file on your network."
            "Press Back to stop a video."
        ]
        dlg.buttons = ["OK"]
        dlg.observeField("buttonSelected", "closeDialog")
        m.top.dialog = dlg
    end if
end sub

sub onUrlDialog()
    dlg = m.top.dialog
    if dlg.buttonSelected = 0
        url = dlg.text.Trim()
        if url = "" or url = "http://"
            m.registry.Delete("feedUrl")
        else
            m.registry.Write("feedUrl", url)
        end if
        m.registry.Flush()
        loadFeed()
    end if
    dlg.close = true
end sub

sub closeDialog()
    m.top.dialog.close = true
end sub

' ---------------- clock ----------------

sub updateClock()
    dt = CreateObject("roDateTime")
    dt.ToLocalTime()
    h = dt.GetHours()
    ampm = "AM"
    if h >= 12 then ampm = "PM"
    h = h MOD 12
    if h = 0 then h = 12
    mins = dt.GetMinutes().ToStr()
    if Len(mins) < 2 then mins = "0" + mins
    m.clock.text = h.ToStr() + ":" + mins + " " + ampm
    m.date.text = dt.GetWeekday() + ", " + dt.AsDateString("long-date")
end sub

' ---------------- favorites ----------------

function loadFavs() as object
    if m.registry.Exists("favs")
        favs = ParseJson(m.registry.Read("favs"))
        if favs <> invalid then return favs
    end if
    return []
end function

sub saveFavs()
    m.registry.Write("favs", FormatJson(m.favs))
    m.registry.Flush()
end sub

sub buildFavs()
    byId = {}
    for each a in m.allApps
        byId[a.appId] = a
    end for
    items = []
    for each id in m.favs
        if byId.DoesExist(id) then items.Push(byId[id])
    end for
    m.sections.favs = [{ title: "Favorites", items: items }]
end sub

sub toggleFocusedFav()
    f = m.rows.rowItemFocused
    if f = invalid or f.Count() <> 2 or m.rows.content = invalid then return
    row = m.rows.content.getChild(f[0])
    if row = invalid then return
    item = row.getChild(f[1])
    if item = invalid or item.kind <> "app"
        setMessage("play", "Only apps can be added to Favorites.")
        return
    end if
    newFavs = []
    removed = false
    for each id in m.favs
        if id = item.appId then removed = true else newFavs.Push(id)
    end for
    if not removed then newFavs.Push(item.appId)
    m.favs = newFavs
    saveFavs()
    buildFavs()
    if removed
        setMessage("play", item.title + " removed from Favorites")
    else
        setMessage("play", item.title + " added to Favorites")
    end if
    rebuild()
end sub
