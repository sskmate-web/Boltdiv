#!/bin/bash
# ==========================================
# Bolt DIY 원클릭 런처 (WSL)
# ==========================================

PROJECT_DIR="/home/sohn5772/bolt.diy-main"
LOG_FILE="$PROJECT_DIR/boltdiy_launcher.log"
URL="http://localhost:5173"

echo "==== $(date) ====" >> "$LOG_FILE"

# 1️⃣ SSH 인증
eval "$(ssh-agent -s)" >> "$LOG_FILE" 2>&1
ssh-add ~/.ssh/id_ed25519 >> "$LOG_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "⚠ SSH 인증 실패. 종료" >> "$LOG_FILE"
    exit 1
fi
echo "✅ SSH 인증 성공" >> "$LOG_FILE"

# 2️⃣ 프로젝트 경로 이동
cd "$PROJECT_DIR" || { echo "❌ 프로젝트 디렉토리 없음!"; exit 1; }
echo "📁 이동 완료: $(pwd)" >> "$LOG_FILE"

# 3️⃣ Bolt DIY 안전 실행
nohup ./run_boltdiy_safe.sh >> "$LOG_FILE" 2>&1 &

sleep 3  # 서버 시작 대기

# 4️⃣ 브라우저 자동 열기
xdg-open "$URL" >> "$LOG_FILE" 2>&1
echo "🌐 브라우저 열기: $URL" >> "$LOG_FILE"

# 5️⃣ 알림
notify-send "Bolt DIY" "서버 실행 완료! 브라우저 열기: $URL"
echo "✅ Bolt DIY 런처 완료" >> "$LOG_FILE"
