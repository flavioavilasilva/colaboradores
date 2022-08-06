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
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Inicia o processo principal
CMD ["rails", "server", "-b", "0.0.0.0"]

