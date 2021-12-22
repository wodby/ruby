ARG RUBY_TAG

FROM wodby/ruby:${RUBY_TAG}

RUN if [[ "${RUBY_VERSION}" =~ ^2.6. ]]; then \
      gem install rails -v 6;  \
    else  \
      gem install rails;  \
    fi

RUN rails new . --database=postgresql

RUN sed -i '/Rails.application.configure do/a\  config.hosts << "nginx"' config/environments/development.rb

RUN bundle install

COPY database.yml config/database.yml
