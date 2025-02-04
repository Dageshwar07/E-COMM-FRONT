# Stage 1: Build Stage
FROM node:18-alpine AS build

# Set working directory inside the container
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the frontend source code
COPY . .

# Set the environment variable (this will be used by Create React App to build with the given API URL)
ARG REACT_APP_API_DEV_URL
ENV REACT_APP_API_DEV_URL=${REACT_APP_API_DEV_URL}

# Build the React app for production
RUN npm run build

# Stage 2: Serve Stage (using a lightweight web server)
FROM nginx:alpine

# Copy the build files from the first stage to the Nginx server directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port the app will be served on
EXPOSE 3000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
