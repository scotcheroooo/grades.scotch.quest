' functionName is set by the caller to "queryApps" or "launchApp".

sub queryApps()
    base = ecpBase()
    x = CreateObject("roUrlTransfer")
    x.SetUrl(base + "/query/apps")
    body = x.GetToString()
    items = []
    xml = CreateObject("roXMLElement")
    if body <> invalid and body <> "" and xml.Parse(body)
        children = xml.GetChildElements()
        if children <> invalid
            for each a in children
                attrs = a.GetAttributes()
                if attrs["type"] = "appl" and attrs["id"] <> "dev"
                    items.Push({
                        title: a.GetText()
                        kind: "app"
                        appId: attrs["id"]
                        poster: base + "/query/icon/" + attrs["id"]
                    })
                end if
            end for
        end if
    end if

    if items.Count() > 0
        m.top.result = { ok: true, items: items }
        return
    end if

    ' ECP unavailable (usually "Control by mobile apps" is not Enabled) - show a static list.
    fallback = ParseJson(ReadAsciiFile("pkg:/data/apps.json"))
    if fallback = invalid then fallback = []
    for each app in fallback
        items.Push({ title: app.title, kind: "app", appId: str0(app.id), poster: "" })
    end for
    m.top.result = { ok: false, items: items }
end sub

sub launchApp()
    x = CreateObject("roUrlTransfer")
    x.SetUrl(ecpBase() + "/launch/" + m.top.appId)
    x.SetRequest("POST")
    code = x.PostFromString("")
    m.top.result = { ok: (code >= 200 and code < 300), code: code, appId: m.top.appId }
end sub
