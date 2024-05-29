docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d -p 5432:5432 -v my_pgdata:/var/lib/postgresql/data postgres
