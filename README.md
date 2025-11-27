# راهنمای سریع شروع کار

## کامپایل گزارش

### روش ۱: استفاده از اسکریپت (پیشنهادی)

```bash
./compile.sh
```

### روش ۲: استفاده از Makefile

```bash
# کامپایل کامل با مراجع
make all

# کامپایل سریع (بدون مراجع)
make build

# پاک‌سازی فایل‌های موقت
make clean
```

### روش ۳: دستی

```bash
cd persian-report

# کامپایل اول
docker run --rm -v "$(pwd):/work" persian-latex xelatex main.tex

# پردازش مراجع
docker run --rm -v "$(pwd):/work" persian-latex bibtex main

# کامپایل نهایی (دو بار)
docker run --rm -v "$(pwd):/work" persian-latex xelatex main.tex
docker run --rm -v "$(pwd):/work" persian-latex xelatex main.tex
```

## ویرایش محتوا

### ۱. تغییر اطلاعات صفحه عنوان

فایل: `frontmatter/title.tex`

```latex
{\Large \textbf{نام دانشگاه شما}}\\[0.5cm]
{\large نام دانشکده}\\[2cm]

{\Huge \textbf{عنوان گزارش خود}}\\[1cm]
```

### ۲. نوشتن چکیده

فایل: `frontmatter/abstract.tex`

### ۳. افزودن محتوا به فصل‌ها

- فصل اول: `chapters/chapter1/section*.tex`
- فصل دوم: `chapters/chapter2/section*.tex`
- فصل سوم: `chapters/chapter3/section*.tex`

### ۴. اضافه کردن فصل جدید

```bash
# ایجاد پوشه
mkdir chapters/chapter4

# ایجاد فایل‌ها
touch chapters/chapter4/main.tex
touch chapters/chapter4/section1.tex
touch chapters/chapter4/section2.tex
```

سپس در `main.tex` اضافه کنید:

```latex
\input{chapters/chapter4/main}
```

### ۵. اضافه کردن تصویر

۱. تصویر را در پوشه `images/` قرار دهید
۲. در فایل tex خود:

```latex
\begin{figure}[h]
\centering
\includegraphics[width=0.8\textwidth]{image-name.png}
\caption{توضیحات تصویر}
\label{fig:my-image}
\end{figure}
```

ارجاع به تصویر:

```latex
همانطور که در \figref{fig:my-image} مشاهده می‌شود...
```

### ۶. اضافه کردن جدول

```latex
\begin{table}[h]
\centering
\caption{عنوان جدول}
\label{tab:my-table}
\begin{tabular}{|c|c|c|}
\hline
ستون ۱ & ستون ۲ & ستون ۳ \\
\hline
سلول ۱ & سلول ۲ & سلول ۳ \\
\hline
\end{tabular}
\end{table}
```

### ۷. اضافه کردن مرجع

۱. در `backmatter/references.bib`:

```bibtex
@article{my-key,
    title={عنوان مقاله},
    author={نویسنده},
    journal={مجله},
    year={۱۴۰۲}
}
```

۲. در متن:

```latex
طبق تحقیقات \cite{my-key} مشخص شده است...
```

## دستورات سفارشی

```latex
% نوشتن متن انگلیسی
\en{English Text}

% کد درون‌خطی
\code{variable_name}

% نقل قول فارسی
\pquote{متن نقل شده}

% ارجاع به عناصر
\figref{fig:label}     % شکل
\tabref{tab:label}     % جدول
\chapref{ch:label}     % فصل
\secref{sec:label}     # بخش
```

## تغییر فونت

در `config/settings.tex`:

```latex
% استفاده از فونت Shabnam
\settextfont[
    Path=/usr/share/fonts/truetype/farsi/shabnam-font-v5.0.1/,
    Extension=.ttf,
    UprightFont=*-Regular,
    BoldFont=*-Bold
]{Shabnam}
```

## نکات مهم

1. **همیشه ۴ بار کامپایل کنید** (xelatex، bibtex، xelatex، xelatex) برای مراجع صحیح
2. **از لیبل منحصربفرد** برای شکل‌ها، جداول و فصل‌ها استفاده کنید
3. **تصاویر با کیفیت بالا** در فرمت PNG یا PDF استفاده کنید
4. **پس از هر تغییر مهم** یک کامپایل کامل انجام دهید

## حل مشکلات

### خطای فونت

```
! Package xepersian Error: The font "Vazirmatn" cannot be found.
```

**راه‌حل:** مطمئن شوید Docker image ساخته شده است:

```bash
cd .. && ./build.sh build
```

### مراجع نمایش داده نمی‌شوند

**راه‌حل:** کامپایل کامل انجام دهید:

```bash
make all
```

### تصویر نمایش داده نمی‌شود

**راه‌حل:**

1. مطمئن شوید تصویر در پوشه `images/` است
2. نام فایل را بدون مسیر بنویسید
3. پسوند فایل را حتماً ذکر کنید

## پشتیبانی

برای سوالات و مشکلات می‌توانید به فایل `README.md` مراجعه کنید.

موفق باشید! 🎓
