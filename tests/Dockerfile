ARG RUBY_TAG

FROM wodby/ruby:${RUBY_TAG}

RUN gem install rails

RUN echo 1

RUN rails new . --database=postgresql

RUN if rails version | grep -q "Rails 6."; then \
        sed -i '/Rails.application.configure do/a\  config.hosts << "nginx"' config/environments/development.rb; \
    fi

RUN bundle install

COPY database.yml config/database.yml
