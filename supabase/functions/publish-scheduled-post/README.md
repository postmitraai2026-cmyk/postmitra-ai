# publish-scheduled-post
Implement a protected server-side job that atomically claims due scheduled posts, checks connected account permissions and subscription status, publishes via supported provider APIs, stores provider post IDs, retries transient errors idempotently, and records failures. Do not mark posts published unless the provider confirms success. Use a scheduler/cron to invoke it.
