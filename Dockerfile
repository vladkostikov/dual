FROM ruby:3.2.9-alpine

ARG RAILS_ROOT=/task_manager
ARG PACKAGES="vim openssl-dev postgresql-dev build-base curl nodejs-current npm yarn less tzdata git postgresql-client bash screen gcompat libffi libffi-dev imagemagick imagemagick-dev jpeg-dev"

RUN apk add --no-cache $PACKAGES

RUN gem update --system 3.4.19 \
    && gem install bundler:2.4.22

RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock  ./

ENV BUNDLE_PATH=/bundle_cache \
    GEM_HOME=/bundle_cache \
    GEM_PATH=/bundle_cache \
    BUNDLE_JOBS=5 \
    BUNDLE_RETRY=3

RUN bundle install
RUN bundle pristine ffi

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

ADD . $RAILS_ROOT
ENV PATH=$RAILS_ROOT/bin:${PATH}

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
