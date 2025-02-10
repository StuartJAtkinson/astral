#!/bin/bash

# Path to the Astral project directory (replace with your actual path)
PROJECT_DIR="/mnt/l/Repos/astral"

# Check for Composer (PHP)
if [ -f "$PROJECT_DIR/composer.json" ]; then
    echo "Composer detected: $PROJECT_DIR/composer.json"
fi

# Check for NPM/Yarn (Node.js)
if [ -f "$PROJECT_DIR/package.json" ]; then
    echo "Node.js detected (NPM/Yarn): $PROJECT_DIR/package.json"
fi

# Check for Laravel configuration (artisan)
if [ -f "$PROJECT_DIR/artisan" ]; then
    echo "Laravel detected: $PROJECT_DIR/artisan"
fi

# Check for Docker
if [ -f "$PROJECT_DIR/Dockerfile" ]; then
    echo "Docker detected: $PROJECT_DIR/Dockerfile"
elif [ -f "$PROJECT_DIR/docker-compose.yml" ]; then
    echo "Docker Compose detected: $PROJECT_DIR/docker-compose.yml"
fi

# Check for .env (environment variables for the project)
if [ -f "$PROJECT_DIR/.env" ]; then
    echo ".env file detected: $PROJECT_DIR/.env"
fi

# Check for Vue or frontend setup
if [ -f "$PROJECT_DIR/package.json" ]; then
    FRONTEND_DEPS=$(grep -i "vue" "$PROJECT_DIR/package.json" || echo "No Vue detected")
    echo "$FRONTEND_DEPS"
fi

# Check for Laravel Mix configuration
if [ -f "$PROJECT_DIR/webpack.mix.js" ]; then
    echo "Laravel Mix detected: $PROJECT_DIR/webpack.mix.js"
fi
