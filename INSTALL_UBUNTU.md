# تنصيب وتشغيل Hayaa على Ubuntu

دليل سريع لتجهيز المشروع وتشغيله على جوال أندرويد عبر USB.

## الطريقة السريعة (سكربت تلقائي)

```bash
chmod +x setup_ubuntu.sh
./setup_ubuntu.sh
```

السكربت يقوم بـ:
- تثبيت حزم النظام (git, curl, unzip, clang, ninja…)
- تثبيت OpenJDK 17
- تنزيل Flutter SDK في `~/flutter` وإضافته للـ PATH
- قبول تراخيص أندرويد
- تشغيل `flutter pub get`
- تشغيل `flutter doctor`

بعد انتهائه:
```bash
source ~/.bashrc      # لتفعيل مسار flutter
flutter devices       # تأكد من ظهور جوالك
flutter run           # تشغيل التطبيق
```

## Android SDK

السكربت لا يثبّت Android SDK كاملاً. أسهل طريقة:

1. حمّل **Android Studio**: https://developer.android.com/studio
2. افتحه مرة واحدة → سيُنزّل الـ SDK تلقائياً
3. أعد تشغيل `./setup_ubuntu.sh` أو نفّذ `flutter doctor` للتأكد

## التشغيل على الجوال عبر USB

1. على الجوال: الإعدادات → حول الهاتف → اضغط **رقم الإصدار** 7 مرات
2. خيارات المطوّر → فعّل **تصحيح USB**
3. وصّل الجوال واضغط **سماح** عند ظهور رسالة الإذن
4. `flutter devices` ثم `flutter run`

## متطلبات المشروع

- Dart SDK: `>=3.2.3 <4.0.0`
- minSdkVersion: 23 (Android 6.0+)
- ملف `android/app/google-services.json` موجود (Firebase)
- صلاحيات الميكروفون مطلوبة للغرف الصوتية (ZEGOCLOUD)

## حل المشاكل الشائعة

| المشكلة | الحل |
|---|---|
| `flutter: command not found` | `source ~/.bashrc` أو أعد فتح الطرفية |
| الجوال لا يظهر | جرّب كيبل بيانات آخر، أو `adb devices` |
| فشل بناء أندرويد | تأكد من تثبيت Android SDK + قبول التراخيص |
| أخطاء حزم | `flutter clean && flutter pub get` |
