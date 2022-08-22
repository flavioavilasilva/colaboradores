FROM ruby:3.1.0

RUN apt-get update -qq && apt-get install -y nodejs

RUN gem install bundler -v 2.3

WORKDIR /colaboradores

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 2 --retry 1

COPY . ./

