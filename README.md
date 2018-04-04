Ciber Squash
============

A simple site for registration who is going to play squash.

# Development locally

Run a Docker container with postgres:
```bash
docker run --name postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=cibersquash -p 5432:5432 -d postgres:latest
```

If you already have a container running, you can add a new database with the following command:
```bash
docker exec -it postgres psql -U postgres -c "CREATE DATABASE cibersquash"
```

Then install `Ruby-2.5.1` and install Gem's with `bundle install'.

Start the app with `foreman start`.