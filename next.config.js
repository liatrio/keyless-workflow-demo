/** @type {import('next').NextConfig} */
module.exports = {
  reactStrictMode: true,
  pageExtensions: ["page.tsx", "page.ts", "page.jsx", "page.js", "ts"],
  env: {
    KNOWLEDGE_SHARE_API: process.env["KNOWLEDGE_SHARE_API"],
  },
};
