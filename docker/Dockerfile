# Step 1: Specify the base image
# Use the official Node.js image (version 18) as the base image
FROM node:18

# Step 2: Set the working directory inside the container
# This creates and sets /usr/src/app as the working directory where all application files will reside
WORKDIR /usr/src/app

# Step 3: Copy package.json and package-lock.json files
# Copy only package.json and package-lock.json to the working directory
# This helps leverage Docker's layer caching for dependency installation
COPY package*.json ./

# Step 4: Install dependencies
# Run npm install to install all dependencies specified in package.json
RUN npm install

# Step 5: Copy the rest of the application code
# Copy all remaining application files from the host machine to the working directory
COPY . .

# Step 6: Expose the application port
# Expose port 3000 so the application can listen for incoming HTTP requests on this port
EXPOSE 3000

# Step 7: Specify the command to run the application
# Start the application using Node.js and execute the server.js file
CMD ["node", "server.js"]
