.PHONY: all build clean help

IMAGE_NAME = persian-latex
MAIN_FILE = main

help:
	@echo "دستورات Makefile برای گزارش فارسی:"
	@echo ""
	@echo "  make build-image - ساخت Docker image"
	@echo "  make all         - کامپایل کامل گزارش"
	@echo "  make build       - کامپایل سریع (یک‌بار)"
	@echo "  make clean       - پاک‌سازی فایل‌های موقت"
	@echo "  make clean-all   - پاک‌سازی همه فایل‌ها (شامل PDF)"
	@echo "  make shell       - ورود به shell تعاملی"
	@echo ""

build-image:
	@echo "در حال ساخت Docker image..."
	docker build -t $(IMAGE_NAME) .
	@echo "✓ ساخت با موفقیت انجام شد!"

all: build-image
	@echo "کامپایل کامل با مراجع..."
	docker run --rm -v "$$(pwd):/work" $(IMAGE_NAME) xelatex -interaction=nonstopmode $(MAIN_FILE).tex
	docker run --rm -v "$$(pwd):/work" $(IMAGE_NAME) biber $(MAIN_FILE) || true
	docker run --rm -v "$$(pwd):/work" $(IMAGE_NAME) xelatex -interaction=nonstopmode $(MAIN_FILE).tex
	docker run --rm -v "$$(pwd):/work" $(IMAGE_NAME) xelatex -interaction=nonstopmode $(MAIN_FILE).tex
	@echo "✓ کامپایل با موفقیت انجام شد!"

build:
	@echo "کامپایل سریع..."
	docker run --rm -v "$$(pwd):/work" $(IMAGE_NAME) xelatex -interaction=nonstopmode $(MAIN_FILE).tex
	@echo "✓ کامپایل سریع انجام شد!"

clean:
	@echo "پاک‌سازی فایل‌های موقت..."
	rm -f *.aux *.log *.out *.toc *.lof *.lot *.bbl *.blg *.nav *.snm *.vrb *.synctex.gz *.fls *.fdb_latexmk *.xdv
	@echo "✓ پاک‌سازی انجام شد!"

clean-all: clean
	@echo "پاک‌سازی فایل PDF..."
	rm -f *.pdf
	@echo "✓ تمام فایل‌ها پاک شدند!"

shell:
	docker run -it --rm -v "$$(pwd):/work" $(IMAGE_NAME) bash

