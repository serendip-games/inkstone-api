# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN yarn install

COPY . .
RUN yarn run build


# ---------- Stage 2: Run ----------
FROM node:20-alpine

WORKDIR /app

# Build ARG (optional)
ARG NODE_ENV

# Conditionally set NODE_ENV if provided
# Note: This will only set NODE_ENV if the build arg was passed
# Otherwise, NODE_ENV will remain undefined at runtime
ENV NODE_ENV=${NODE_ENV}

# Make sure the app is always serving on port 3000
ENV PORT=3000

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# Always expose port 3000
EXPOSE 3000

CMD ["node", "dist/main"]
