#!/bin/bash

echo "🌐 서버 준비 대기 중..."
cd /home/sohn5772/bolt.diy-main || exit
echo "📁 이동 완료: $(pwd)"

echo "🔍 SSH 인증 확인 중..."
ssh-add -l >/dev/null 2>&1 || echo "⚠️ SSH 키 없음, 무시됨"
echo "🔑 SSH 인증 완료"

echo "🌐 Git 최신화..."
git pull origin main
echo "✅ 최신화 완료"

echo "📦 npm 설치 중..."
npm install
echo "✅ 의존성 설치 완료"

if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Auto commit: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "💾 변경 사항 커밋 및 푸시 완료"
else
    echo "💾 변경 사항 없음, 커밋 생략"
fi

echo "🚀 Vite 서버 실행 중 (모든 인터페이스 허용)..."
npm run dev -- --host 0.0.0.0
