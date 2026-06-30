#!/usr/bin/env bash
# DataForSEO Google Ads search volume → JSON (+ compact table via python3).
# Usage: DATAFORSEO_AUTH=<base64 login:password> ./dfs_search_volume.sh <location_code> <language_code> kw1 "kw 2" kw3 ...
# Writes raw JSON to ./dfs_resp.json and prints a table.
set -euo pipefail

: "${DATAFORSEO_AUTH:?Set DATAFORSEO_AUTH to the base64 of 'login:password' (DataForSEO Basic auth).}"
LOC="${1:?location_code, e.g. 2276 for Germany}"; shift
LANG="${1:?language_code, e.g. de}"; shift
[ "$#" -ge 1 ] || { echo "Pass at least one keyword."; exit 1; }

KW_JSON=$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1:]))' "$@")
PAYLOAD=$(python3 -c 'import json,sys; print(json.dumps([{"location_code":int(sys.argv[1]),"language_code":sys.argv[2],"keywords":json.loads(sys.argv[3])}]))' "$LOC" "$LANG" "$KW_JSON")

curl -s -X POST "https://api.dataforseo.com/v3/keywords_data/google_ads/search_volume/live" \
  -H "Authorization: Basic ${DATAFORSEO_AUTH}" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" -o dfs_resp.json

python3 - <<'PY'
import json
d=json.load(open('dfs_resp.json'))
print("status",d.get("status_code"),d.get("status_message"),"| cost $",d.get("cost"))
res=(d.get("tasks") or [{}])[0].get("result") or []
rows=[]
for r in res:
    ms=r.get("monthly_searches") or []
    latest=ms[0]["search_volume"] if ms else None
    yearago=ms[-1]["search_volume"] if ms else None
    trend=""
    if latest is not None and yearago not in (None,0):
        trend=f"{(latest-yearago)/yearago*100:+.0f}%"
    rows.append((r.get("keyword"),r.get("search_volume"),r.get("competition"),r.get("cpc"),trend))
rows.sort(key=lambda x:(x[1] or 0),reverse=True)
print(f"{'keyword':36}{'vol/mo':>9}{'comp':>9}{'cpc':>8}{'12mo':>7}")
for kw,sv,c,cpc,t in rows:
    print(f"{(kw or ''):36}{str(sv):>9}{str(c):>9}{str(cpc):>8}{t:>7}")
PY
