# Little Atlas city packs

Public catalog for the Little Atlas iOS app. City JSON is served by GitHub Pages. Photos are GitHub Release assets, one archive per city. Nothing in this repository is a photo.

No city pack is published yet. `manifest.json` lists zero cities until a built pack is checked in. The app is Calgary-only until storage is settled. Calgary is the first city to publish, and no other city goes up before that.

| What | Where |
|---|---|
| Manifest and `pack.json` | This repo, published from `docs/` |
| `<slug>-media.tar` and `<slug>-attribution.json` | A GitHub Release, never git |
| Pipeline that builds the packs | Private repo `wzsgrmsz9g-png/LittleAtlas-iOS`, branch `feature/city-scale-pipeline` |

Pages URL, once GitHub has finished the first deploy: <https://wzsgrmsz9g-png.github.io/littleatlas-packs/>

Release asset names, when a city is published: `https://github.com/wzsgrmsz9g-png/littleatlas-packs/releases/download/packs/<slug>-media.tar`

The tar unpacks onto a pack root (`media/<aa>/<sha256>.webp`). The manifest field `mediaBase` stays `media/`.

## Publishing a city

1. Build the city in LittleAtlas-iOS with `--no-legacy`. This repo must not contain `atlas.zip` or legacy-only places.
2. Run `scripts/guard.sh` in this repo. It refuses `atlas.zip`, map extracts, WebP files, tar archives, files over 20 MB, and secret-shaped strings. A GitHub Actions copy of that check is not installed: pushing `.github/workflows/` needs a token with the `workflow` scope.
3. Commit only `docs/manifest.json`, `docs/cities/<slug>/…/pack.json`, and any small delta JSON.
4. From the pack root, run `release_assets.py` in the pipeline repo. Upload `<slug>-media.tar`, `<slug>-attribution.json`, and `SHA256SUMS` to the `packs` release. Do not `git add` those files.

Cloudflare R2 is not used.

## Licence

OpenStreetMap data is ODbL. Wikidata is CC0. GeoNames is CC BY 4.0. Each photo keeps the licence named in that city's attribution file. See [ATTRIBUTION.md](ATTRIBUTION.md).
