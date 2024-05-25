#!/bin/bash


docker rm -f contacts-web contacts-db


docker run -d --name contacts-db -e POSTGRES_DB=contacts_db -e POSTGRES_USER=contacts_user -e POSTGRES_PASSWORD=contacts_pass skudsi/contacts-db


if [ "$(docker inspect -f '{{.State.Running}}' contacts-db)" != "true" ]; then
    echo "contacts-db container failed to start. Logs:"
    docker logs contacts-db
    exit 1
fi


docker run -d --name contacts-web --link contacts-db:db -p 5000:5000 skudsi/contacts-web


if [ "$(docker inspect -f '{{.State.Running}}' contacts-web)" != "true" ]; then
    echo "contacts-web container failed to start. Logs:"
    docker logs contacts-web
    exit 1
fi


echo "Waiting for database to be ready..."
sleep 10  


docker exec contacts-db psql -U contacts_user -d contacts_db -c "DROP TABLE IF EXISTS contacts;"


docker exec contacts-web sh -c "export FLASK_APP=app.py && flask db upgrade"


docker exec contacts-web sh -c "export FLASK_APP=app.py && python migrations.py"

echo "Containers started and migrations applied."
