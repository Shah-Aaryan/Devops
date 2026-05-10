# Stage 1: Build
FROM node:20-slim AS backend-builder

# Setup the working dir
WORKDIR /app

# Copy package.json and package-lock.json first (for better caching)
COPY package*.json ./

# Install packages
RUN npm ci

# Copy the rest of the code
COPY . .

# Run tests to ensure everything is working before we build the production image
#RUN npm run test

# Stage 2: Production Image
FROM node:20-slim
ENV NODE_ENV=production

# Setup the working dir
WORKDIR /app

# Copy only the necessary files from the builder stage to keep the image lean
COPY --from=backend-builder /app .

# Remove dev dependencies to keep the image smaller
RUN npm prune --omit=dev

# Expose the port the app runs on
EXPOSE 8000 

# Start the application
CMD ["npm", "start"]
