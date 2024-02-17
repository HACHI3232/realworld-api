# Rubyのバージョンを指定
FROM ruby:3.3.0

# 必要なパッケージをインストール
RUN apt-get update -qq \
    && apt-get install -y nodejs default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリを設定
WORKDIR /app


# 作業ディレクトリを設定
WORKDIR /app

# 現在のディレクトリのGemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Gemをインストール
RUN bundle install

# 現在のディレクトリの残りのファイルをコピー
COPY . /app
RUN chmod +x /app/entrypoint.sh

# コンテナがリッスンするポート番号を指定
EXPOSE 3000

# データベースの設定とRailsサーバーの起動
CMD ["./entrypoint.sh"]
