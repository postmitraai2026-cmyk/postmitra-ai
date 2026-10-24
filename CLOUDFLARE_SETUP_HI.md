# बिल्कुल नया PostMitra प्रोजेक्ट — सेटअप गाइड

## 1. नया GitHub Repository
1. GitHub में Sign in करें और **New repository** चुनें।
2. नाम रखें `postmitra-ai` (या उपलब्ध कोई नया नाम)।
3. Public/Private में अपनी पसंद चुनें; credentials कभी repository में न डालें।
4. इस ZIP की फाइलें extract करके repository root में upload करें।
5. `config.js.example` की copy बनाकर नाम `config.js` रखें। उसमें नए Supabase project की URL और publishable/anon key भरें। कोई secret key न डालें।

## 2. नया Supabase Project
1. Supabase Dashboard में **New project** बनाएं; नाम `postmitra-ai` रखें।
2. Project URL और publishable key प्राप्त करें और `config.js` में रखें।
3. SQL Editor में `supabase/schema.sql` की सामग्री run करें।
4. Authentication → URL Configuration में deployed Cloudflare Pages URL को Site URL और allowed redirect URLs में जोड़ें।
5. Authentication settings में email confirmation की पसंद तय करें।
6. दो अलग test accounts से जाँचें कि एक user दूसरे का data नहीं देख सकता।

## 3. नया Cloudflare Pages site
1. Cloudflare Dashboard → Workers & Pages → Create application → Pages → Connect to Git।
2. नया `postmitra-ai` GitHub repository चुनें।
3. Static HTML के लिए build command खाली रखें; build output directory repository root (`/`) या `.` जैसा dashboard स्वीकार करे, वही सेट करें।
4. Deploy करें; Cloudflare URL को Supabase Auth redirect allow-list में जोड़ें।
5. अगर `config.js` Git में नहीं रखना चाहते तो deployment design बदलकर runtime-safe public config injection इस्तेमाल करें। `config.js` में केवल public Supabase URL और publishable/anon key ही हो सकते हैं।

## 4. असली integrations
- AI: Supabase Edge Function + server-side AI key.
- Meta: Meta Developer App, Instagram Professional account/Facebook Page, permissions, OAuth and any required review.
- Google Business: Google Cloud project, Business Profile API access and OAuth.
- Scheduled publishing: secure Edge Function, job scheduler, retries and idempotency.
- Payments: Razorpay server-side subscription creation + signed webhook verification.
- Inbox replies: only platform-supported messaging surfaces and permissions; add human escalation for complaints/refunds.

ये integrations केवल SQL चलाने या वेबसाइट deploy करने से अपने-आप चालू नहीं होते। पहले staging/test accounts से पूरी जाँच करें।
