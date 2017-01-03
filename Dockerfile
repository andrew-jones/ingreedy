FROM ruby:latest

COPY . /opt/app

RUN gem install bundler

WORKDIR /opt/app

RUN bundle install

CMD ["rspec", "spec"]
