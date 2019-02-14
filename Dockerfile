FROM bitwalker/alpine-elixir-phoenix:1.8.0 AS build
WORKDIR /app
COPY . .
ENV MIX_ENV=prod
RUN ./build_prod.sh

FROM bitwalker/alpine-elixir-phoenix:1.8.0
WORKDIR /app
COPY --from=build /app/tlc_app.tar.gz .
RUN tar -zxf tlc_app.tar.gz && rm -f tlc_app.tar.gz && mkdir /app/logs && chmod 777 -R /app/logs
ENV MIX_ENV=prod

ENTRYPOINT ["bin/tlc_app"]
CMD ["foreground"]
