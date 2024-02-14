# アプリケーションの基本パスを設定
app_path = File.expand_path('..', __dir__)

# ワーカープロセスの数
worker_processes 1

# Unicornの作業ディレクトリ
working_directory app_path

# リッスンするポート番号
listen 3000

# PIDファイルのパス
pid "#{app_path}/tmp/pids/unicorn.pid"

# 標準エラーログのパス
stderr_path "#{app_path}/log/unicorn.stderr.log"

# 標準出力ログのパス
stdout_path "#{app_path}/log/unicorn.stdout.log"

# タイムアウト設定
timeout 600

# アプリケーションのプリロード
preload_app true
# GCの設定（コピーオンライトフレンドリー）
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

# クライアント接続チェック
check_client_connection false

# フォーク前の一度だけ実行するフラグ
run_once = true

# フォーク前の処理
before_fork do |server, worker|
  # ActiveRecordの接続を切断
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  # 一度だけ実行する処理
  if run_once
    run_once = false
  end

  # 古いPIDファイルがあればプロセスを終了
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
end

# フォーク後の処理
after_fork do |_server, _worker|
  # ActiveRecordの接続を確立
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
