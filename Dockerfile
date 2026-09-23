# --- Stage 1: Build the React Application ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# --- Stage 2: Serve the Static Files via Nginx ---
FROM nginx:stable-alpine
# Copy the compiled Vite build files from the builder stage over to Nginx
COPY --from=builder /app/dist /usr/share/nginx/html
# Copy a custom Nginx routing config file (created in the next step)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
