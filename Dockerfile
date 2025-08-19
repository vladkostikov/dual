FROM ruby:2.7.8-alpine

ARG RAILS_ROOT=/task_manager
ARG PACKAGES="vim openssl-dev postgresql-dev build-base curl nodejs-current npm yarn less tzdata git postgresql-client bash screen gcompat libffi libffi-dev"

RUN apk add --no-cache $PACKAGES \
    && gem update --system 3.3.22 \
    && gem install bundler:2.4.22

RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock  ./
RUN bundle install --jobs 5 && bundle pristine ffi

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

ADD . $RAILS_ROOT
ENV PATH=$RAILS_ROOT/bin:${PATH}

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
