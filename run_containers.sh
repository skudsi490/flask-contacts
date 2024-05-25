#!/bin/bash

# Remove any existing containers
docker rm -f contacts-web contacts-db

# Run the PostgreSQL container
docker run -d --name contacts-db -e POSTGRES_DB=contacts_db -e POSTGRES_USER=contacts_user -e POSTGRES_PASSWORD=contacts_pass skudsi/contacts-db

# Check if the contacts-db container is running
if [ "$(docker inspect -f '{{.State.Running}}' contacts-db)" != "true" ]; then
    echo "contacts-db container failed to start. Logs:"
    docker logs contacts-db
    exit 1
fi

# Run the Flask web app container and link it to the database container
docker run -d --name contacts-web --link contacts-db:db -p 5000:5000 skudsi/contacts-web

# Check if the contacts-web container is running
if [ "$(docker inspect -f '{{.State.Running}}' contacts-web)" != "true" ]; then
    echo "contacts-web container failed to start. Logs:"
    docker logs contacts-web
    exit 1
fi

# Wait for the database to be ready
echo "Waiting for database to be ready..."
sleep 10  

# Drop the existing contacts table if it exists
docker exec contacts-db psql -U contacts_user -d contacts_db -c "DROP TABLE IF EXISTS contacts;"

# Ensure the FLASK_APP environment variable is set and run database migrations
docker exec contacts-web sh -c "export FLASK_APP=app.py && flask db upgrade"

# Run the migrations script to populate the database with fake contacts
docker exec contacts-web sh -c "export FLASK_APP=app.py && python migrations.py"

echo "Containers started and migrations applied."
