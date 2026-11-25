sub init()
    m.top.functionName = "resolve"
end sub

sub resolve()
    id = m.top.identifier
    data = ParseJson(httpGet("https://archive.org/metadata/" + id))
    if data = invalid or data.files = invalid
        m.top.result = { ok: false, error: "Could not look up this title." }
        return
    end if

    ' Prefer h.264 encodes, then any MPEG4, then any .mp4 file.
    best = ""
    bestScore = 0
    for each f in data.files
        name = str0(f.name)
        fmt = LCase(str0(f.format))
        score = 0
        if LCase(Right(name, 4)) = ".mp4"
            score = 1
            if Instr(1, fmt, "mpeg4") > 0 then score = 2
            if Instr(1, fmt, "h.264") > 0 then score = 3
        end if
        if score > bestScore
            best = name
            bestScore = score
        end if
    end for

    if best = ""
        m.top.result = { ok: false, error: "No Roku-playable video file for this title." }
        return
    end if

    x = CreateObject("roUrlTransfer")
    path = x.Escape(best).Replace("%2F", "/")
    title = id
    if data.metadata <> invalid
        t = str0(data.metadata.title)
        if t <> "" then title = t
    end if
    m.top.result = { ok: true, url: "https://archive.org/download/" + id + "/" + path, title: title }
end sub
