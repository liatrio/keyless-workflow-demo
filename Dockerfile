FROM node:16-alpine AS builder

ENV NEXT_TELEMETRY_DISABLED 1
WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY src/ src/
COPY public/ public/
COPY tsconfig.json ./
COPY next-env.d.ts ./
COPY next.config.js ./
COPY .eslintrc.js ./

RUN npm run validateBuild

RUN npm prune --production

FROM node:16-alpine AS runner

WORKDIR /app
ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup -g 1001 -S nodejs && \
  adduser -S nextjs -u 1001

COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/next.config.js ./
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json

USER nextjs
EXPOSE 3000

CMD ["npm", "start"]
