const { loadNuxt } = require("nuxt");

async function start() {
  const nuxt = await loadNuxt("start");
  const port = process.env.PORT || process.env.NUXT_PORT || 3000;
  const host = process.env.HOST || process.env.NUXT_HOST || "0.0.0.0";

  console.log(`Starting Nuxt server programmatically at http://${host}:${port}`);
  await nuxt.listen(port, host);
}

start().catch((err) => {
  console.error("Failed to start Nuxt server:", err);
  process.exit(1);
});
