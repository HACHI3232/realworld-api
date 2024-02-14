# Rubyのベースイメージを使用
FROM ruby:2.7.4

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs

# アプリケーションディレクトリを作成
RUN mkdir /app

# 作業ディレクトリを設定
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Bundlerをインストール
RUN gem install bundler -v 2.4.22


# Bundlerの設定を更新
RUN bundle config set --local without 'test development'

# Bundle installを実行
RUN bundle install

# アプリケーションのソースコードをコピー
ADD . /app

# コンテナがリッスンするポートを指定
EXPOSE 3000

# コンテナ起動時に実行されるコマンド
CMD ["/bin/sh", "-c", "bundle exec rails db:create && bundle exec rails db:migrate && bundle exec unicorn -p 3000 -c /app/config/unicorn.rb -E production"]
