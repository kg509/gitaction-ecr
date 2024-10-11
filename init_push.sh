#!/bin/bash

# 0. 스크립트 파일이 있는 디렉토리에서 실행 중인지 확인
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
current_dir=$(pwd)

if [ "$script_dir" != "$current_dir" ]; then
  echo "Error: The script must be executed from its containing directory: $script_dir"
  exit 1
fi

# 1. 현재 경로에 있는 .git 폴더 삭제
if [ -d ".git" ]; then
  echo "Removing the existing .git directory from the current path."
  rm -rf .git
fi

# 2. config.txt 파일에서 경로와 repo 주소를 불러오기
source config.txt

# 3. 대상 경로와 repo 주소를 순서대로 처리
for i in "${!target_paths[@]}"; do
  target=${target_paths[$i]}
  repo=${repo_addr[$i]}

  echo "Processing target: $target with repository: $repo"

  # 대상 디렉토리로 이동
  cd "$target" || { echo "Failed to change directory to $target"; exit 1; }

  # git 초기화 및 원격 저장소 설정
  git init
  git remote add origin "$repo"

  # 첫 커밋 및 브랜치 설정
  git add .
  git commit -m "Initial commit for $target"
  git branch -M main

  # 원격 저장소로 푸시
  git push -u origin main

  # 원래 경로로 돌아오기
  cd - || exit
done

echo "All targets have been processed successfully!"
