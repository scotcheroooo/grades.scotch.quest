' Shared networking helpers for Task nodes.
function newXfer(url as string) as object
    x = CreateObject("roUrlTransfer")
    x.SetUrl(url)
    x.SetCertificatesFile("common:/certs/ca-bundle.crt")
    x.InitClientCertificates()
    x.RetainBodyOnError(true)
    x.AddHeader("User-Agent", "HomeHub-Roku/1.0")
    return x
end function

function httpGet(url as string) as string
    if Left(url, 5) = "pkg:/" then return ReadAsciiFile(url)
    x = newXfer(url)
    result = x.GetToString()
    if result = invalid then return ""
    return result
end function

function ecpBase() as string
    di = CreateObject("roDeviceInfo")
    ips = di.GetIPAddrs()
    for each k in ips
        return "http://" + ips[k] + ":8060"
    end for
    return "http://127.0.0.1:8060"
end function

function str0(v as dynamic) as string
    if v = invalid then return ""
    t = type(v)
    if t = "String" or t = "roString" then return v
    if t = "Integer" or t = "roInt" or t = "LongInteger" then return v.ToStr()
    if t = "Float" or t = "roFloat" or t = "Double" then return Str(v).Trim()
    if t = "Boolean" or t = "roBoolean" then
        if v then return "true"
        return "false"
    end if
    return ""
end function
