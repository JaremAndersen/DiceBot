FROM  elixir:1.11-alpine as img


COPY ./lib ./app/lib
COPY ./config ./app/config
COPY ./mix.exs ./app

WORKDIR ./app


RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
CMD mix run --no-halt
