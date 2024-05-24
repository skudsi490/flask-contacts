#!/bin/bash

# Remove any existing containers
docker rm -f contacts-web contacts-db

# Run the PostgreSQL container
docker run -d --name contacts-db -e POSTGRES_DB=contacts_db -e POSTGRES_USER=contacts_user -e POSTGRES_PASSWORD=contacts_pass skudsi/contacts-db

# Run the Flask web app container and link it to the database container
docker run -d --name contacts-web --link contacts-db:db -p 5000:5000 skudsi/contacts-web

# Wait for the database to be ready
echo "Waiting for database to be ready..."
sleep 10  

# Drop the existing contacts table if it exists
docker exec contacts-db psql -U contacts_user -d contacts_db -c "DROP TABLE IF EXISTS contacts;"

# Ensure the FLASK_APP environment variable is set and run database migrations
docker exec contacts-web sh -c "export FLASK_APP=app.py && flask db upgrade"

echo "Containers started and migrations applied."
