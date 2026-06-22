#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Hayaa — سكربت تنصيب تلقائي على Ubuntu
# يثبّت كل المتطلبات (Flutter + Android SDK deps) ويجهّز المشروع.
#
# الاستخدام:
#   chmod +x setup_ubuntu.sh
#   ./setup_ubuntu.sh
# ─────────────────────────────────────────────────────────────
set -e

# ألوان للطباعة
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}==>${NC} $1"; }
warn()  { echo -e "${YELLOW}!!${NC} $1"; }
error() { echo -e "${RED}xx${NC} $1"; }

FLUTTER_DIR="$HOME/flutter"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1) حزم النظام الأساسية ─────────────────────────────────────
info "تحديث النظام وتثبيت الحزم الأساسية..."
sudo apt-get update -y
sudo apt-get install -y \
  curl git unzip xz-utils zip libglu1-mesa \
  clang cmake ninja-build pkg-config libgtk-3-dev \
  android-tools-adb

# 2) Java (مطلوب لبناء أندرويد) ──────────────────────────────
if ! command -v java >/dev/null 2>&1; then
  info "تثبيت OpenJDK 17..."
  sudo apt-get install -y openjdk-17-jdk
else
  info "Java مثبّت بالفعل: $(java -version 2>&1 | head -1)"
fi

# 3) Flutter SDK ────────────────────────────────────────────
if [ ! -d "$FLUTTER_DIR" ]; then
  info "تنزيل Flutter SDK (الإصدار المستقر)..."
  git clone https://github.com/flutter/flutter.git -b stable "$FLUTTER_DIR"
else
  info "Flutter موجود في $FLUTTER_DIR — تحديث..."
  git -C "$FLUTTER_DIR" pull || warn "تعذّر التحديث، سنكمل بالنسخة الحالية."
fi

# إضافة Flutter إلى PATH للجلسة الحالية
export PATH="$FLUTTER_DIR/bin:$PATH"

# جعل المسار دائماً في bashrc
if ! grep -q "flutter/bin" "$HOME/.bashrc"; then
  echo "export PATH=\"\$HOME/flutter/bin:\$PATH\"" >> "$HOME/.bashrc"
  info "أُضيف مسار Flutter إلى ~/.bashrc"
fi

# 4) موافقة تراخيص أندرويد ───────────────────────────────────
info "قبول تراخيص Android (قد يُطلب الضغط y)..."
yes | flutter doctor --android-licenses || warn "تخطّ التراخيص إن لم يكن Android SDK مثبّتاً بعد."

# 5) تجهيز المشروع ──────────────────────────────────────────
info "تثبيت حزم المشروع..."
cd "$PROJECT_DIR"
flutter pub get

# 6) فحص نهائي ──────────────────────────────────────────────
info "تشغيل flutter doctor للتأكد من البيئة:"
flutter doctor || true

echo ""
info "اكتمل التنصيب! ✅"
echo ""
echo "الخطوات التالية:"
echo "  1) أعد فتح الطرفية أو نفّذ:  source ~/.bashrc"
echo "  2) وصّل جوالك عبر USB وفعّل تصحيح USB"
echo "  3) تحقق من رؤية الجهاز:       flutter devices"
echo "  4) شغّل المشروع:              flutter run"
echo ""
warn "ملاحظة: إن لم يكن Android SDK مثبّتاً، ثبّت Android Studio من:"
echo "        https://developer.android.com/studio"
echo "        ثم افتحه مرة واحدة لتنزيل SDK، وأعد تشغيل هذا السكربت."
