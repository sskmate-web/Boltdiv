#!/bin/bash
# ===============================
# Bolt.diy WSL 안전 강화 올인원 스크립트
# ===============================

# 1️⃣ 디렉토리 이동
cd ~/bolt.diy-main || { echo "❌ 디렉토리 없음: ~/bolt.diy-main"; exit 1; }
echo "📁 이동 완료: $(pwd)"

# 2️⃣ SSH 인증 확인
echo "🔍 SSH 인증 확인 중..."
SSH_CHECK=$(ssh -T git@github.com 2>&1)

echo "$SSH_CHECK" | grep -qi "successfully authenticated"
if [[ $? -ne 0 ]]; then
    echo "⚠ SSH 인증 실패"
    exit 1
fi
echo "🔑 SSH 인증 완료"

# 3️⃣ Git 최신화 (원격 브랜치 확인 후 자동 pull/rebase)
CURRENT_BRANCH=$(git branch --show-current)
REMOTE_BRANCH="origin/$CURRENT_BRANCH"

echo "🌐 원격 브랜치 확인 및 최신화..."
git fetch origin
git rebase $REMOTE_BRANCH || {
    echo "⚠ Rebase 중 충돌 발생. 충돌 해결 후 수동 push 필요."
    exit 1
}

# 4️⃣ 의존성 설치
echo "📦 의존성 설치 중..."
npm install || { echo "❌ npm install 실패"; exit 1; }

# 5️⃣ 변경 사항 자동 커밋
if [[ -n $(git status --porcelain) ]]; then
    echo "💾 변경 사항 커밋"
    git add .
    git commit -m "Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"
else
    echo "✅ 변경 사항 없음, 커밋 생략"
fi

# 6️⃣ 안전하게 푸시
echo "🚀 원격으로 안전하게 푸시 중..."
git push origin $CURRENT_BRANCH || {
    echo "⚠ 푸시 실패. 원격 변경 사항을 확인 후 수동으로 처리 필요."
    exit 1
}

# 7️⃣ 개발 서버 실행
echo "🚀 개발 서버 실행 중..."
npm run dev
