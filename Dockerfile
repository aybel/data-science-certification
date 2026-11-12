FROM mysql:8.4

# Las credenciales NO se definen aquí. Se pasan al ejecutar el contenedor
# con --env-file (ver .env.example en la raíz del proyecto).
#   MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER, MYSQL_PASSWORD

# Los scripts .sql / .sh de esta carpeta se ejecutan una sola vez,
# la primera vez que se inicializa el volumen de datos.
COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 3306

HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=5 \
    CMD MYSQL_PWD="$MYSQL_ROOT_PASSWORD" mysqladmin ping -h 127.0.0.1 -u root --silent

CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]
