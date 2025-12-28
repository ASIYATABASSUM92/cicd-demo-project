# Use official Node.js LTS version as base image
# Why: LTS (Long Term Support) versions are stable and secure
FROM node:18-alpine

# Set working directory inside container
# Why: Organizes files and makes paths predictable
WORKDIR /app

# Copy package files first
# Why: Docker caches layers - if package.json hasn't changed, 
# npm install won't run again (faster builds)
COPY package*.json ./

# Install dependencies
# Why: --production flag skips devDependencies, making image smaller
RUN npm ci --production

# Copy application code
# Why: Done after npm install to leverage Docker cache
COPY . .

# Expose port 3000
# Why: Documents which port the app uses (doesn't actually publish it)
EXPOSE 3000

# Set NODE_ENV to production
# Why: Optimizes Node.js performance and security
ENV NODE_ENV=production

# Create non-root user for security
# Why: Running as root is a security risk
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
USER nodejs

# Health check
# Why: Allows Docker/K8s to know if container is healthy
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))"

# Start the application
# Why: CMD is the default command when container starts
CMD ["node", "app.js"]
