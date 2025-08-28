# Use the official nginx image as the base
FROM nginx:alpine

# Copy the static HTML site to the nginx html directory
COPY report/report.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
