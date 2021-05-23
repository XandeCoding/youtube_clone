FROM elixir:latest as phoenix_multistage

COPY . /app
WORKDIR /app
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y inotify-tools \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get --force \
  && npm install --prefix ./assets \
  && npm rebuild node-sass \
  && mix do compile

CMD mix phx.server
