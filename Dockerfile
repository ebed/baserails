FROM ruby:3.0.0

ENV APP_HOME /app/
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

RUN rm -rf /var/lib/apt/lists/* &&\
      curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
      apt-get update -qq && apt-get install -y build-essential nodejs yarn

# Install standard Node modules
COPY package.json yarn.lock $APP_HOME
RUN yarn install --frozen-lockfile

COPY Gemfile* $APP_HOME
RUN bundle config --local without 'development test' && \
    bundle install -j4 --retry 3 && \
    # Remove unneeded gems
    bundle clean --force && \
    # Remove unneeded files from installed gems (cached *.gem, *.o, *.c)
    rm -rf /usr/local/bundle/cache/*.gem && \
    find /usr/local/bundle/gems/ -name "*.c" -delete && \
    find /usr/local/bundle/gems/ -name "*.o" -delete

# First we install dependencies and allow docker create cached image over it
# then we copy the application and precompile assets
COPY . $APP_HOME

# Compile assets with Webpacker or Sprockets
#
# Notes:
#   1. Executing "assets:precompile" runs "yarn:install" prior
#   2. Executing "assets:precompile" runs "webpacker:compile", too
#   3. For an app using encrypted credentials, Rails raises a `MissingKeyError`
#      if the master key is missing. Because on CI there is no master key,
#      we hide the credentials while compiling assets (by renaming them before and after)
#
RUN mv config/credentials.yml.enc config/credentials.yml.enc.bak 2>/dev/null || true
RUN RAILS_ENV=production \
      SECRET_KEY_BASE=dummy \
      RAILS_MASTER_KEY=dummy \
      bundle exec rails assets:precompile
RUN mv config/credentials.yml.enc.bak config/credentials.yml.enc 2>/dev/null || true

# Remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache vendor/bundle test spec

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
