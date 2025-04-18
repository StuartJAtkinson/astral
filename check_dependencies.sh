#!/bin/bash

# Ensure we're in the correct directory (repo)
REPO_DIR=$(pwd)

# Output log file for large results
LOG_FILE="dependency_check.log"
echo "Starting dependency check in repository: $REPO_DIR" > $LOG_FILE

# 1. Checking Composer (PHP) dependencies - Look for framework-based packages
echo "Checking Composer dependencies..." >> $LOG_FILE
if [[ -f "composer.json" ]]; then
  echo "Found composer.json. Scanning for PHP frameworks..." >> $LOG_FILE
  # This checks for frameworks like Laravel, Symfony, or any other common PHP frameworks
  jq '.require | keys' composer.json >> $LOG_FILE
  jq '.require-dev | keys' composer.json >> $LOG_FILE
else
  echo "composer.json not found in this repo. Skipping Composer dependency check." >> $LOG_FILE
fi

# 2. Checking Node (JavaScript) dependencies - Look for JavaScript frameworks
echo "Checking Node.js dependencies..." >> $LOG_FILE
if [[ -f "package.json" ]]; then
  echo "Found package.json. Scanning for JavaScript frameworks..." >> $LOG_FILE
  # Look for common JavaScript frameworks like React, Vue, Angular, etc.
  jq '.dependencies | keys' package.json >> $LOG_FILE
  jq '.devDependencies | keys' package.json >> $LOG_FILE
else
  echo "package.json not found in this repo. Skipping Node.js dependency check." >> $LOG_FILE
fi

# 3. Checking for Dockerfiles - Verify dependencies mentioned in the Dockerfile
echo "Checking Dockerfile for declared dependencies..." >> $LOG_FILE
if [[ -f "Dockerfile" ]]; then
  echo "Found Dockerfile. Checking for framework-specific instructions..." >> $LOG_FILE
  # Example: Check for framework-based dependencies in Dockerfile
  grep -i "composer install" Dockerfile >> $LOG_FILE
  grep -i "yarn install" Dockerfile >> $LOG_FILE
  grep -i "npm install" Dockerfile >> $LOG_FILE
else
  echo "Dockerfile not found in this repo. Skipping Dockerfile check." >> $LOG_FILE
fi

# 4. Verifying Dockerfile Framework Compatibility - Check for PHP and Node versions
echo "Verifying Dockerfile framework compatibility..." >> $LOG_FILE
php_version=$(grep -i "FROM php" Dockerfile | head -n 1 | awk '{print $3}')
node_version=$(grep -i "FROM node" Dockerfile | head -n 1 | awk '{print $3}')

echo "PHP version declared in Dockerfile: $php_version" >> $LOG_FILE
echo "Node.js version declared in Dockerfile: $node_version" >> $LOG_FILE

# LLM Check Placeholder - Here you could integrate a tool that uses LLMs to check dependencies
# For now, we'll simulate it with a simple check for commonly used frameworks
echo "Simulating LLM check for dependencies..." >> $LOG_FILE
common_php_frameworks=("laravel" "symfony" "zend" "codeigniter")
common_js_frameworks=("react" "vue" "angular" "svelte")

echo "Checking for common PHP frameworks..." >> $LOG_FILE
for framework in "${common_php_frameworks[@]}"; do
  grep -i "$framework" composer.json >> $LOG_FILE
done

echo "Checking for common JavaScript frameworks..." >> $LOG_FILE
for framework in "${common_js_frameworks[@]}"; do
  grep -i "$framework" package.json >> $LOG_FILE
done

# Final message
echo "Dependency check completed. Review the log file at $LOG_FILE"
