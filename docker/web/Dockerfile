FROM ruby:2.5.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
ENV LANG C.UTF-8
WORKDIR /fodeli_online
# =========ローカルと本番切り替え===========
# ENV RAILS_ENV="production"
# ======================================
COPY Gemfile Gemfile.lock /fodeli_online/
RUN bundle install
COPY . .

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

RUN mkdir -p tmp/sockets

