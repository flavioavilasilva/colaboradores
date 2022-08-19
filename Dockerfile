FROM ruby:3.1.0
RUN apt-get update -qq && apt-get install -y nodejs
RUN mkdir /colaboradores
WORKDIR /colaboradores
COPY Gemfile* ./
RUN gem uninstall nokogiri && gem install bundler && bundle install --jobs=3 --retry=3 
COPY . /colaboradores

# Script que será executado toda vez que o container iniciar
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
EXPOSE 3000

