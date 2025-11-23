#!/bin/bash

# ========================================
# BoltDIY WSL2 최적화 자동 실행 스크립트
# ========================================

echo "🌐 서버 준비 대기 중..."
cd /home/sohn5772/bolt.diy-main || exit
echo "📁 이동 완료: $(pwd)"

# SSH 인증 확인
echo "🔍 SSH 인증 확인 중..."
ssh-add -l >/dev/null 2>&1 || eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa
echo "🔑 SSH 인증 완료"

# Git 최신화
echo "🌐 원격 브랜치 확인 및 최신화..."
git pull origin main
echo "✅ 최신화 완료"

# npm 의존성 설치
echo "📦 의존성 설치 중..."
npm install
echo "✅ 의존성 설치 완료"

# 자동 커밋 및 푸시
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Auto commit: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "💾 변경 사항 커밋 및 원격 푸시 완료"
else
    echo "💾 변경 사항 없음, 커밋 생략"
fi

# Vite 개발 서버 실행 (Windows에서 접속 가능)
echo "🚀 개발 서버 실행 중..."
npm run dev -- --host
