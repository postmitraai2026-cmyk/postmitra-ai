# PostMitra AI — Fresh Project

This is a new, separate starter. It does not hardcode or reuse any previous Supabase project URL or GitHub repository.

## Included
- `index.html`: responsive orange/white interface, Supabase email signup/signin, business profile, saved drafts/scheduled posts, content calendar, plan pages, channel connection status.
- `config.js.example`: copy to `config.js` and configure your new Supabase project.
- `supabase/schema.sql`: database schema with RLS.
- `CLOUDFLARE_SETUP_HI.md`: Hindi setup checklist.
- `supabase/functions/*/README.md`: required secure backend work.

## Not yet live
The interface does not claim that AI image generation, real Meta/Google publishing, AI inbox replies, or payment processing are connected. Those require secure backend functions, provider credentials, permissions, and testing. Scheduled rows are stored as scheduled, but will not publish until the publisher function is implemented and deployed.

## Security
Use only Supabase publishable/anon key in `config.js`. Never commit service-role keys, OAuth secrets, AI API keys, or payment secrets. Never activate subscriptions from client-side state.
