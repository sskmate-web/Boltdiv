#!/bin/bash
# 기존 run_boltdiy_safe.sh 내용 실행
./run_boltdiy_safe.sh &

# 서버가 5173 포트 열릴 때까지 최대 60초 대기
echo "🌐 서버 준비 대기 중..."
for i in {1..60}; do
  if ss -tln | grep -q ':5173'; then
    echo "🔥 서버 실행 완료! 브라우저 열기..."
    powershell.exe start http://localhost:5173 > /dev/null 2>&1
    break
  fi
  sleep 1
done

echo "✅ 준비 완료. 로그는 이 창에서 확인 가능합니다."
exec bash
