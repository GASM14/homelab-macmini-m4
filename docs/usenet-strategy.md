# Usenet Strategy (NzbDAV + AIOStreams)

## Current state
- Primary provider: Pure Usenet (monthly, 40 connections)
- Real-Debrid active as alternate source until 2027
- On-demand streaming via NzbDAV WebDAV (no persistent library, no disk growth)

## Known issue
- Some releases fail with "missing articles" (DMCA takedowns / retention gaps).
- A single provider cannot heal missing articles; retries fail identically.

## Backup plan (when Real-Debrid expires)
- Buy a **block** (non-expiring top-up) from a second provider.
- Add as second server in NzbDAV with **5-10 connections** (NOT 40 — blocks
  are consumed fast at high parallelism; a trial died in minutes at 40).
- Failover fills missing articles automatically.

## Automation (optional, later)
- Sonarr/Radarr unlock NzbDAV Background Repairs (requires Library Directory
  + arr instances). Repairs = replace unhealthy release with a new search,
  NOT fill missing articles (that still needs the second source).
- STRM import mode keeps disk usage ~zero; "Remove Orphaned Files"
  (Maintenance) cleans abandoned WebDAV content (>24h).

## NzbDAV settings worth keeping
- Ignored files: *.nfo, *.par2, *.sfv, *sample.mkv (not mounted on WebDAV,
  still used internally for repair)
- "Fail downloads for nzbs without video content" → forces arr re-search
