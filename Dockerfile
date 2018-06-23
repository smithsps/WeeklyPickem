FROM debian:jessie as weekly-pickem-builder-jessie
MAINTAINER Simon Smith <smithsps@gmail.com>

# WGET for erlang, gcc for crypto argon2 library
RUN apt-get update && apt-get install -y wget gcc make

# Elixir uses/needs UTF8 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# Installing Erlang, then Elixir
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb 
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y esl-erlang elixir

# Copy needed project files
COPY rel ./rel
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY mix.exs .
COPY mix.lock .

# Install hex and rebar (I think rebar is needed for some library)
# Retrieve all other dependencies
# Build release with distillery.
RUN export MIX_ENV=prod && \
	mix local.hex --force && \
	mix local.rebar --force && \
	mix deps.get && \
	mix phx.digest && \
	mix release

# Combine our release into a tar for easy copying
RUN RELEASE_DIR=`ls -d _build/prod/rel/weekly_pickem/releases/*/` && \
	mkdir /weekly_pickem && \
	tar -xf "$RELEASE_DIR/weekly_pickem.tar.gz" -C /weekly_pickem && \
	cp -r /priv /weekly_pickem/lib/weekly_pickem-*/
	

