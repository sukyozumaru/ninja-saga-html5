# Public historical-client test

This hosting source preserves the unchanged historical SWF and its original libraries. It replaces only authentication/storage and the AMF transport destination. The client still owns its original UI and gameplay code. Current verified scope: registration, login and original character selection. Character creation is blocked by the missing historical hair_10_1.swf. Unrestored services fail explicitly.

The original 4,731 SWF and Ruffle 0.7.1 are restored from preservation commit 32ecad6973472e24e40476441dc70735c1ab7079 using asset-lock.json. They are generated build inputs, not a second editable corpus. Run `node scripts/prepare-assets.mjs` before building; each file is verified by size and SHA-256. A sibling NinjaSaga preservation checkout is reused when available; otherwise the script downloads the pinned public archive.

Sites hosts the Worker, static assets and D1 database. The original SystemService.login response is retained; passwords now use salted PBKDF2-SHA256 (100,000 iterations), and only hashes of random session tokens are persisted. Sessions expire after 12 hours. Local accounts are not uploaded. No password or AMF argument logging is enabled. Registration/login are rate limited. Database changes are append-only migrations under drizzle/.

The AMF codec comes from shenjai47/NinjaSaga/server/amf.js; only its module export was adapted to ESM and its Buffer dependency imported explicitly. No community gameplay handlers are loaded.

Checks: `node --test lib/auth.test.mjs`. Generate schema changes with `npm run db:generate`; build and publish via the Sites workflow. Apply migrations through the deployment mechanism, not during requests.
