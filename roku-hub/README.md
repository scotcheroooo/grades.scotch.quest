# Home Hub — free, open-source Roku home screen

One channel that puts everything on one screen:

| Row | What it does |
|---|---|
| **Your Streaming Apps** | Lists every app installed on your Roku (Netflix, YouTube, Disney+, Pluto TV…) with its real icon. Select one to open it — you sign in with your own account. |
| **Free Public Domain Movies / Classic TV / Classic Cartoons** | Legal, free films streamed straight from the Internet Archive. |
| **Open Movies + Home Media** | Plays a JSON or M3U feed — the built-in one has Creative Commons films; point it at your own files or legal free IPTV playlist. |
| **Settings** | Set your feed URL, refresh apps, help. |

> Home Hub does not unlock paid services. Paid apps still need your own subscription; it simply gives you one launcher for them plus free, legal content.

## Install (sideload, takes ~5 minutes)

1. **Turn on developer mode on the Roku:** on the remote press
   `Home ×3, Up ×2, Right, Left, Right, Left, Right`. Note the IP address shown, accept the agreement, set a password, and let it reboot.
2. **Let the channel see your apps:** Settings → System → Advanced system settings →
   Control by mobile apps → Network access → **Enabled**.
3. **Build and install** (on any computer on the same Wi-Fi):
   ```bash
   ./package.sh 192.168.1.50 yourDevPassword
   ```
   Or run `./package.sh`, open `http://<roku-ip>` in a browser, log in as `rokudev`, and upload `out/homehub.zip`.

Home Hub then appears in the Roku's channel list as **dev**.

## Your own home media feed

Serve a file on your network (e.g. `python3 -m http.server` in a folder of videos) and choose
**Settings → Set Home Media Feed URL**.

JSON:
```json
{ "rows": [ { "title": "Family Videos", "items": [
  { "title": "Beach 2025", "poster": "http://192.168.1.20:8000/beach.jpg",
    "url": "http://192.168.1.20:8000/beach.mp4", "format": "mp4" } ] } ] }
```
`format` is `mp4`, `hls` or `dash` (guessed from the URL when left out).

M3U works too — `#EXTINF` entries with `tvg-logo` and `group-title` become poster tiles and rows.

Roku plays MP4 (H.264/AAC), HLS, DASH and MKV. For a big library, install the free
open-source **Jellyfin** app and server — it appears in the apps row automatically.

## Remote keys
- **OK** – open app / play
- **Back** – stop video
- **\*** – help

## Project layout
```
manifest                 channel metadata
source/main.brs          entry point
components/HomeScene.*   home screen, playback, settings
components/HubItem.*     tile
components/EcpTask.*     lists/launches installed apps via the Roku's local control API
components/FeedTask.*    JSON/M3U feeds + Internet Archive rows
components/ResolveTask.* finds the playable MP4 for an archive title
data/                    built-in feed and fallback app list
```

MIT licensed.
