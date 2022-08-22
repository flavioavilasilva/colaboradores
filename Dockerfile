FROM ruby:3.1.0

ENV BUNDLER_VERSION=2.0.2

RUN apt-get update -qq && apt-get install -y nodejs

RUN gem install bundler -v 2.0.2

WORKDIR /colaboradores

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY . ./

