sub init()
    m.bg = m.top.findNode("bg")
    m.poster = m.top.findNode("poster")
    m.label = m.top.findNode("label")
end sub

sub onContent()
    c = m.top.itemContent
    if c = invalid then return
    m.label.text = c.title
    if c.HDPosterUrl <> invalid and c.HDPosterUrl <> ""
        m.poster.uri = c.HDPosterUrl
        m.poster.visible = true
        m.label.translation = [14, 186]
        m.label.height = 48
        m.label.wrap = false
        m.label.font = "font:SmallSystemFont"
        m.label.horizAlign = "left"
    else
        ' Text-only tile (settings actions, apps without an icon).
        m.poster.visible = false
        m.label.translation = [20, 20]
        m.label.height = 200
        m.label.width = 280
        m.label.wrap = true
        m.label.font = "font:MediumBoldSystemFont"
        m.label.horizAlign = "center"
    end if
end sub

sub onFocus()
    if m.top.focusPercent > 0.5
        m.bg.color = "0x2E3A4AFF"
    else
        m.bg.color = "0x1C232DFF"
    end if
end sub
