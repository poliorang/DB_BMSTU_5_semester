FROM postgres:11.3

RUN apt-get update && apt-get install -y postgresql-plpython3-11

RUN  apt-get clean && \
     rm -rf /var/cache/apt/* /var/lib/apt/lists/*

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]

