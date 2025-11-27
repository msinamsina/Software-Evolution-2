#!/bin/bash

# اسکریپت کامپایل گزارش فارسی

set -e

# رنگ‌ها
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

IMAGE_NAME="persian-latex"
MAIN_FILE="main.tex"

echo -e "${BLUE}[INFO]${NC} شروع کامپایل گزارش..."

# بررسی وجود Docker image
if ! docker image inspect $IMAGE_NAME >/dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} Docker image یافت نشد!"
    echo -e "${BLUE}[INFO]${NC} لطفاً ابتدا image را بسازید:"
    echo "  cd .. && ./build.sh build"
    exit 1
fi

# کامپایل اول
echo -e "${BLUE}[INFO]${NC} کامپایل اول..."
docker run --rm -v "$(pwd):/work" $IMAGE_NAME xelatex -interaction=nonstopmode $MAIN_FILE

# اجرای bibtex
echo -e "${BLUE}[INFO]${NC} پردازش مراجع..."
docker run --rm -v "$(pwd):/work" $IMAGE_NAME bibtex main || true

# کامپایل دوم
echo -e "${BLUE}[INFO]${NC} کامپایل دوم..."
docker run --rm -v "$(pwd):/work" $IMAGE_NAME xelatex -interaction=nonstopmode $MAIN_FILE

# کامپایل سوم
echo -e "${BLUE}[INFO]${NC} کامپایل سوم (نهایی)..."
docker run --rm -v "$(pwd):/work" $IMAGE_NAME xelatex -interaction=nonstopmode $MAIN_FILE

# پاک‌سازی فایل‌های موقت
echo -e "${BLUE}[INFO]${NC} پاک‌سازی فایل‌های موقت..."
rm -f *.aux *.log *.out *.toc *.bbl *.blg *.nav *.snm *.vrb

echo -e "${GREEN}[SUCCESS]${NC} کامپایل با موفقیت انجام شد!"
echo -e "${GREEN}[SUCCESS]${NC} فایل PDF: main.pdf"

