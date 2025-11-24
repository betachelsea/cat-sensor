#!/usr/bin/env bash
set -euo pipefail

PORT=4567

# 既存のngrokをkill
pkill -f "ngrok http $PORT" || true

# すでにngrokが動いているか確認
if ! pgrep -f "ngrok http $PORT" >/dev/null 2>&1; then
  # バックグラウンドでngrok起動
  # --log=stdout はお好み、デバッグ用
  ngrok http $PORT --log=stdout >/tmp/ngrok.log 2>&1 &
  NGROK_PID=$!

  # ngrokが起動してダッシュボードが立ち上がるまで待つ
  # 最大30秒ぐらいリトライ
  for i in $(seq 1 30); do
    if curl -s http://127.0.0.1:4040/api/tunnels >/dev/null 2>&1; then
      break
    fi
    sleep 1
  done
fi

# ダッシュボードAPIからpublic_urlを取る
URL=$(
  curl -s http://127.0.0.1:4040/api/tunnels \
    | ruby -rjson -e 'puts JSON.parse(STDIN.read)["tunnels"].find{|t| t["proto"]=="https"}["public_url"] rescue ""'
)

if [ -z "$URL" ]; then
  echo "ERROR: ngrok URL取得に失敗しました" >&2
  exit 1
fi

echo "$URL"
