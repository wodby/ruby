ARG RUBY_IMAGE

FROM $RUBY_IMAGE

RUN gem install rails

RUN rails new . --database=postgresql

RUN sed -i '/Rails.application.configure do/a\  config.hosts << "nginx"' config/environments/development.rb

RUN bundle install

COPY database.yml config/database.yml
