#!/bin/bash
exec > /var/log/user-data.log 2>&1

echo "STARTING USER DATA"

# Update system
yum update -y

# Install Docker
yum install -y docker

# Start & enable Docker
systemctl start docker
systemctl enable docker

# Install docker-compose (latest)
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Wait for Docker to be ready
echo "Waiting for Docker..."
for i in {1..30}; do
  if docker info > /dev/null 2>&1; then
    echo "Docker is ready"
    break
  fi
  sleep 5
done

# Debug
docker info || echo "Docker failed"

echo "USER DATA COMPLETED"