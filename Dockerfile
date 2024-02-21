FROM ruby:3.3.0

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# ワーキングディレクトリの設定
WORKDIR /app

# GemfileとGemfile.lockをコピーしてGemのインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリケーションのファイルをコピー
COPY . .

# ポートのエクスポート
EXPOSE 3000

# Railsサーバーの起動
CMD ["rails", "server", "-b", "0.0.0.0"]
