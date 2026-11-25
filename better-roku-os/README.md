# Better Roku OS — a free, open-source home screen for Roku

A replacement home screen that runs on your existing Roku. Your real Netflix, Hulu, Disney+,
Max, Prime Video, YouTube… apps all appear here — open one and sign in with your own subscription.

> **What it is and isn't:** Roku devices only boot Roku-signed firmware, so no one can swap out the
> actual operating system. Better Roku OS is a channel that acts as your home screen on top of it.
> Paid apps still need your own subscription.

| Row | What it does |
|---|---|
| **Favorites** | Your pinned apps. Press **✱** on any app to pin/unpin it. |
| **All Apps** | Every app installed on your Roku (Netflix, Hulu, Disney+, Pluto TV…) with its real icon. Select one to open it. |
| **Free Public Domain Movies / Classic TV / Classic Cartoons** | Legal, free films streamed straight from the Internet Archive. |
| **Open Movies + Home Media** | Plays a JSON or M3U feed — the built-in one has Creative Commons films; point it at your own files or legal free IPTV playlist. |
| **Settings** | Set your feed URL, refresh apps, help. |

Also: a clock and date in the corner, and everything remembered between launches.

## Install (sideload, takes ~5 minutes)

1. **Turn on developer mode on the Roku:** on the remote press
   `Home ×3, Up ×2, Right, Left, Right, Left, Right`. Note the IP address shown, accept the agreement, set a password, and let it reboot.
2. **Let the channel see your apps:** Settings → System → Advanced system settings →
   Control by mobile apps → Network access → **Enabled**.
3. **Build and install** (on any computer on the same Wi-Fi):
   ```bash
   ./package.sh 192.168.1.50 yourDevPassword
   ```
   Or run `./package.sh`, open `http://<roku-ip>` in a browser, log in as `rokudev`, and upload `out/better-roku-os.zip`.

Better Roku OS then appears in the Roku's channel list as **dev**. Move it to the top of your Roku home screen (✱ → Move channel) so it's the first thing you open.

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
- **✱** – add/remove the focused app from Favorites

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
