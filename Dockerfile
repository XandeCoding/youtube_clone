FROM elixir:latest

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y inotify-tools
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --force
RUN npm install --prefix ./assets
RUN npm rebuild node-sass
RUN mix do compile

CMD mix phx.server
