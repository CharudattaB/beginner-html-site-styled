# Use an official Nginx runtime as a parent image
# 'alpine' is a lightweight version of Linux, making our image smaller.
FROM nginx:alpine

# Set the working directory inside the container.
# All subsequent commands will run from this directory.
WORKDIR /usr/share/nginx/html

# Copy all files from the current directory (of the repository)
# into the working directory inside the container.
COPY . .

# Inform Docker that the container listens on port 80 at runtime.
# This is for documentation; the port is actually opened by the -p flag in `docker run`.
EXPOSE 80

# The command to run when the container starts.
# This starts the Nginx server in the foreground.
CMD ["nginx", "-g", "daemon off;"]
