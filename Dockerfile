FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    texlive-full \
    texlive-xetex \
    texlive-lang-arabic \
    texlive-lang-other \
    fonts-freefont-otf \
    fonts-freefont-ttf \
    fonts-dejavu \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    latexmk \
    wget unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# نصب فونت‌های فارسی
RUN mkdir -p /usr/share/fonts/truetype/farsi && \
    cd /usr/share/fonts/truetype/farsi && \
    # Vazirmatn
    wget https://github.com/rastikerdar/vazirmatn/releases/download/v33.003/vazirmatn-v33.003.zip && \
    unzip -o vazirmatn-v33.003.zip && \
    # Samim
    wget https://github.com/rastikerdar/samim-font/releases/download/v4.0.5/samim-font-v4.0.5.zip && \
    unzip -o samim-font-v4.0.5.zip && \
    # Shabnam
    wget https://github.com/rastikerdar/shabnam-font/releases/download/v5.0.1/shabnam-font-v5.0.1.zip && \
    unzip -o shabnam-font-v5.0.1.zip && \
    # Sahel
    wget https://github.com/rastikerdar/sahel-font/releases/download/v3.4.0/sahel-font-v3.4.0.zip && \
    unzip -o sahel-font-v3.4.0.zip && \
    # Parastoo
    wget https://github.com/rastikerdar/parastoo-font/releases/download/v2.0.1/parastoo-font-v2.0.1.zip && \
    unzip -o parastoo-font-v2.0.1.zip && \
    # Tanha
    wget https://github.com/rastikerdar/tanha-font/releases/download/v0.10/tanha-font-v0.10.zip && \
    unzip -o tanha-font-v0.10.zip && \
    # # Gandom
    wget https://github.com/rastikerdar/gandom-font/releases/download/v0.8/gandom-font-v0.8.zip && \
    unzip -o gandom-font-v0.8.zip && \
    # پاک‌سازی فایل‌های zip
    rm -f *.zip && \
    # به‌روزرسانی کش فونت‌ها
    fc-cache -fv



WORKDIR /work
CMD ["bash"]
