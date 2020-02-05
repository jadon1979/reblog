FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y software-properties-common curl && \
  apt-add-repository ppa:brightbox/ruby-ng && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | bash apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \  
  apt-get update -y && \
  apt-get install -y build-essential vim git python ruby2.3 ruby2.3-dev unzip && \
  apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \
  libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs nginx-extras yarn && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/* && \
  mkdir -p /opt/apps/reblog && \
  gem install bundler && \
  echo 'gem: --no-document' >> ~/.gemrc

RUN groupadd -g 1000 deploy && \
  useradd deploy -m -u 1000 -s /bin/bash -c "Deploy" -g 1000 -G www-data,sudo

WORKDIR /opt/apps/reblog

COPY . /opt/apps/reblog

WORKDIR /opt/apps/reblog/app

EXPOSE 80
EXPOSE 3000

CMD ["../script/environment"]