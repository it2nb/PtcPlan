module.exports = {
  apps: [
    {
      name: "ptcplan",
      exec_mode: "cluster",
      instances: "max",
      script: "./start.js",
      env: {
        NODE_ENV: "production",
        NUXT_HOST: "0.0.0.0",
        NUXT_PORT: 3000
      }
    }
  ]
};
