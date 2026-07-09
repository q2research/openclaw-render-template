FROM node:22-slim

RUN apt-get update && apt-get install -y git curl procps python3 make g++ cron tini && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev --prefer-online && npm cache clean --force

ENV PATH="/app/node_modules/.bin:$PATH"
ENV ALPHACLAW_ROOT_DIR=/data

RUN mkdir -p /data

EXPOSE 3000

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/sh", "-lc", "echo '[boot] PATH='$PATH; echo '[boot] persisted PATH lines:'; grep -n '^PATH=' /data/.env || true; if [ -f /data/.env ]; then cp /data/.env /data/.env.before-path-fix; sed -i '/^PATH=/d' /data/.env; fi; echo '[boot] binaries:'; command -v curl || true; command -v openclaw || true; command -v alphaclaw || true; ls -l /usr/bin/curl /app/node_modules/.bin/openclaw /app/node_modules/.bin/alphaclaw 2>&1 || true; echo '[boot] starting alphaclaw'; exec /app/node_modules/.bin/alphaclaw start"]
