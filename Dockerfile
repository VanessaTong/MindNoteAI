# Use official nginx image as base
FROM nginx:alpine

# Copy your nginx config (optional; you can use default)
COPY nginx.template.conf /etc/nginx/conf.d/default.conf

# Remove default content and copy Flutter build
RUN rm -rf /usr/share/nginx/html/*
COPY build/web /usr/share/nginx/html

# Expose port (Cloud Run listens on 8080 internally by default)
EXPOSE 8080

# Ensure nginx runs in foreground
CMD ["nginx", "-g", "daemon off;"]