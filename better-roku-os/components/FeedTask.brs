' ---------- Home media / custom feed ----------
' JSON format:
' { "rows": [ { "title": "Row name", "items": [ { "title": "...", "poster": "https://...", "url": "https://.../video.mp4", "format": "mp4|hls|dash" } ] } ] }
' M3U playlists (#EXTINF lines with optional tvg-logo / group-title) are also accepted.
sub loadFeed()
    url = m.top.url
    if url = "" then url = "pkg:/data/feed.json"
    text = httpGet(url)
    if text = ""
        m.top.result = { ok: false, error: "Could not load feed: " + url, rows: [] }
        return
    end if

    if Instr(1, text, "#EXTM3U") > 0 or Instr(1, text, "#EXTINF") > 0
        rows = parseM3U(text)
    else
        rows = parseJsonFeed(text)
    end if

    if rows.Count() = 0
        m.top.result = { ok: false, error: "Feed had no playable items: " + url, rows: [] }
    else
        m.top.result = { ok: true, rows: rows }
    end if
end sub

function parseJsonFeed(text as string) as object
    rows = []
    data = ParseJson(text)
    if data = invalid or data.rows = invalid then return rows
    for each r in data.rows
        items = []
        if r.items <> invalid
            for each it in r.items
                if str0(it.url) <> ""
                    items.Push({
                        title: str0(it.title)
                        poster: str0(it.poster)
                        kind: "video"
                        url: str0(it.url)
                        format: str0(it.format)
                    })
                end if
            end for
        end if
        if items.Count() > 0 then rows.Push({ title: str0(r.title), items: items })
    end for
    return rows
end function

function parseM3U(text as string) as object
    groups = {}
    order = []
    pending = invalid
    logoRe = CreateObject("roRegex", "tvg-logo=" + Chr(34) + "([^" + Chr(34) + "]*)" + Chr(34), "i")
    groupRe = CreateObject("roRegex", "group-title=" + Chr(34) + "([^" + Chr(34) + "]*)" + Chr(34), "i")
    lines = text.Tokenize(Chr(10))
    for each raw in lines
        line = raw.Trim()
        if Left(line, 7) = "#EXTINF"
            comma = Instr(1, line, ",")
            title = "Untitled"
            if comma > 0 then title = Mid(line, comma + 1).Trim()
            logo = ""
            lm = logoRe.Match(line)
            if lm.Count() > 1 then logo = lm[1]
            group = "Home Media"
            gm = groupRe.Match(line)
            if gm.Count() > 1 and gm[1] <> "" then group = gm[1]
            pending = { title: title, poster: logo, group: group }
        else if line <> "" and Left(line, 1) <> "#"
            if pending = invalid then pending = { title: line, poster: "", group: "Home Media" }
            if not groups.DoesExist(pending.group)
                groups[pending.group] = []
                order.Push(pending.group)
            end if
            groups[pending.group].Push({ title: pending.title, poster: pending.poster, kind: "video", url: line, format: "" })
            pending = invalid
        end if
    end for
    rows = []
    for each g in order
        rows.Push({ title: g, items: groups[g] })
    end for
    return rows
end function

' ---------- Internet Archive (public domain) ----------
sub loadArchive()
    collections = [
        { title: "Free Public Domain Movies", q: "collection:(feature_films) AND mediatype:(movies)" }
        { title: "Classic TV", q: "collection:(classic_tv) AND mediatype:(movies)" }
        { title: "Classic Cartoons", q: "collection:(classic_cartoons) AND mediatype:(movies)" }
    ]
    x = CreateObject("roUrlTransfer")
    rows = []
    for each c in collections
        url = "https://archive.org/advancedsearch.php?q=" + x.Escape(c.q) + "&fl%5B%5D=identifier&fl%5B%5D=title&sort%5B%5D=downloads%20desc&rows=40&page=1&output=json"
        data = ParseJson(httpGet(url))
        items = []
        if data <> invalid and data.response <> invalid and data.response.docs <> invalid
            for each d in data.response.docs
                id = str0(d.identifier)
                if id <> ""
                    items.Push({
                        title: str0(d.title)
                        poster: "https://archive.org/services/img/" + id
                        kind: "archive"
                        identifier: id
                    })
                end if
            end for
        end if
        if items.Count() > 0 then rows.Push({ title: c.title, items: items })
    end for
    if rows.Count() = 0
        m.top.result = { ok: false, error: "Internet Archive unavailable right now.", rows: [] }
    else
        m.top.result = { ok: true, rows: rows }
    end if
end sub
