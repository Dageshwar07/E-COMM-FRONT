# Step 1: Build Stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Copy .env file (for environment variables)
COPY .env .env

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Set environment variable during build
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# Build the React app
RUN npm run build

# Step 2: Production Stage
FROM nginx:alpine

# Copy built files from builder stage to Nginx public directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
