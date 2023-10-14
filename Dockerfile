FROM ruby:3.3.0-preview2-alpine3.17 AS base

RUN apk add --no-cache \
    build-base \
    curl \
    git \
    libpq \
    postgresql-dev  \
    tzdata \
    && rm -rf /var/cache/apk/*

FROM base AS dev

ENTRYPOINT ["/app/docker-entrypoint.sh"]

FROM base AS build

# Rails app lives here
WORKDIR /app

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

FROM base AS release

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

ENTRYPOINT ["/app/docker-entrypoint.sh"]
