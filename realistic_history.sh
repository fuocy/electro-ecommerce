#!/bin/bash

# === CONFIGURATION ===
START_DATE="2024-07-29T09:00:00"
END_DATE="2024-12-15T18:00:00"
PROJECT_DIR="D:/Learn/electro2"
AUTHOR_NAME="fuocy"
AUTHOR_EMAIL="fuocy.huynh@gmail.com"
MIN_FILES_PER_COMMIT=4
MAX_FILES_PER_COMMIT=10

cd "$PROJECT_DIR" || { echo "❌ Project directory not found"; exit 1; }

# === Realistic commit messages ===
MESSAGES=(
  "Initialize project"
  "Setup Docker config"
  "Add database models"
  "Implement login API"
  "Create registration page"
  "Build navigation bar"
  "Fix input validation"
  "Add toast notifications"
  "Improve layout responsiveness"
  "Refactor folder structure"
  "Add JWT token support"
  "Handle expired session"
  "Style login form"
  "Implement logout"
  "Secure admin routes"
  "Add environment config"
  "Connect MongoDB"
  "Implement user dashboard"
  "Fix typo in error message"
  "Improve loading states"
  "Optimize images"
  "Style buttons"
  "Fix 404 page"
  "Improve accessibility"
  "Add unit tests"
  "Implement dark mode"
  "Create user profile page"
  "Fix margin issues"
  "Build product card"
  "Refactor API layer"
  "Update README"
  "Style footer"
  "Add cart reducer"
  "Setup Redux"
  "Fix header z-index"
  "Refactor auth flow"
  "Add review section"
  "Create search bar"
  "Fix CSS variables"
  "Implement product filters"
  "Create user settings"
  "Handle server error"
  "Improve mobile menu"
  "Update ESLint rules"
  "Fix warning on console"
  "Add rate limiter"
  "Refactor middleware"
  "Implement category menu"
  "Fix modal close bug"
  "Polish final layout"
  "Cleanup unused code"
)

# === Get all trackable files (excluding ignored) ===
ALL_FILES=($(git ls-files --cached --others --exclude-standard))

if [ ${#ALL_FILES[@]} -eq 0 ]; then
  echo "❌ No files found to commit."
  exit 1
fi

# === Shuffle files for realism ===
SHUFFLED_FILES=($(printf "%s\n" "${ALL_FILES[@]}" | shuf))

# === Group files for commit batches ===
TOTAL_FILES=${#SHUFFLED_FILES[@]}
FILE_INDEX=0
COMMIT_GROUPS=()
while [ $FILE_INDEX -lt $TOTAL_FILES ]; do
  BATCH_SIZE=$((RANDOM % ($MAX_FILES_PER_COMMIT - $MIN_FILES_PER_COMMIT + 1) + $MIN_FILES_PER_COMMIT))
  GROUP=()
  for ((j=0; j<BATCH_SIZE && FILE_INDEX<TOTAL_FILES; j++)); do
    GROUP+=("${SHUFFLED_FILES[$FILE_INDEX]}")
    ((FILE_INDEX++))
  done
  COMMIT_GROUPS+=("$(printf "%s " "${GROUP[@]}")")
done

TOTAL_COMMITS=${#COMMIT_GROUPS[@]}
echo "📦 Total files: $TOTAL_FILES"
echo "🎯 Grouped into ~${TOTAL_COMMITS} commits"

# === Time stepping ===
START=$(date -d "$START_DATE" +%s)
END=$(date -d "$END_DATE" +%s)
INTERVAL=$(( (END - START) / TOTAL_COMMITS ))
COMMIT_TIME=$START

# === Commit loop ===
for GROUP in "${COMMIT_GROUPS[@]}"; do
  COMMIT_DATE=$(date -d "@$COMMIT_TIME" "+%Y-%m-%dT%H:%M:%S")
  COMMIT_MSG="${MESSAGES[$((RANDOM % ${#MESSAGES[@]}))]}"

  git add $GROUP 2>/dev/null

  if ! git diff --cached --quiet; then
    GIT_AUTHOR_NAME="$AUTHOR_NAME" \
    GIT_AUTHOR_EMAIL="$AUTHOR_EMAIL" \
    GIT_COMMITTER_NAME="$AUTHOR_NAME" \
    GIT_COMMITTER_EMAIL="$AUTHOR_EMAIL" \
    GIT_AUTHOR_DATE="$COMMIT_DATE" \
    GIT_COMMITTER_DATE="$COMMIT_DATE" \
    git commit -m "$COMMIT_MSG"

    echo "✅ [$COMMIT_DATE] $COMMIT_MSG"
  else
    echo "⚠️ Skipped (nothing to commit)"
  fi

  COMMIT_TIME=$((COMMIT_TIME + INTERVAL))
done

echo "🎉 Done! Total commits made: $TOTAL_COMMITS"
