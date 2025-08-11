# تعليمات البناء والتوقيع - Instagram Login App

## المتطلبات الأساسية

### 1. البرامج المطلوبة
- **macOS** (مطلوب لبناء تطبيقات iOS)
- **Xcode** (أحدث إصدار من App Store)
- **Node.js** (الإصدار 18 أو أحدث)
- **CocoaPods** (لإدارة تبعيات iOS)

### 2. حساب Apple Developer
- حساب Apple Developer (مجاني للاختبار، مدفوع للنشر)
- شهادة تطوير iOS
- Provisioning Profile

## خطوات الإعداد

### 1. تثبيت التبعيات
```bash
# الانتقال إلى مجلد المشروع
cd InstagramLoginApp

# تثبيت تبعيات Node.js
npm install

# تثبيت تبعيات iOS
cd ios
pod install
cd ..
```

### 2. إعداد Xcode

#### فتح المشروع
```bash
open ios/InstagramLoginApp.xcworkspace
```

#### إعداد التوقيع
1. اختر مشروع `InstagramLoginApp` من الشريط الجانبي
2. اختر Target `InstagramLoginApp`
3. انتقل إلى تبويب `Signing & Capabilities`
4. فعل `Automatically manage signing`
5. اختر `Team` (حساب Apple Developer الخاص بك)
6. غير `Bundle Identifier` إلى معرف فريد (مثل: `com.yourname.instagramlogin`)

## البناء للاختبار

### 1. الاختبار على Simulator
```bash
# تشغيل على iOS Simulator
npx react-native run-ios

# أو اختيار simulator محدد
npx react-native run-ios --simulator="iPhone 15 Pro"
```

### 2. الاختبار على جهاز حقيقي
1. وصل جهاز iOS بالكمبيوتر
2. ثق بالكمبيوتر على الجهاز
3. في Xcode، اختر جهازك من قائمة الأجهزة
4. اضغط على زر Run (▶️)

## البناء للإنتاج

### 1. إعداد Release Build
1. في Xcode، اختر `Product` > `Scheme` > `Edit Scheme`
2. اختر `Run` من الشريط الجانبي
3. غير `Build Configuration` إلى `Release`
4. احفظ التغييرات

### 2. إنشاء Archive
1. اختر `Generic iOS Device` من قائمة الأجهزة
2. اختر `Product` > `Archive`
3. انتظر حتى اكتمال البناء
4. سيفتح `Organizer` تلقائياً

### 3. التوزيع

#### للاختبار (TestFlight/Ad Hoc)
1. في `Organizer`, اختر Archive الذي تم إنشاؤه
2. اضغط على `Distribute App`
3. اختر `Ad Hoc` أو `App Store Connect`
4. اتبع الخطوات لرفع التطبيق

#### للنشر في App Store
1. اختر `App Store Connect` في خطوات التوزيع
2. ارفع التطبيق إلى App Store Connect
3. أكمل معلومات التطبيق في App Store Connect
4. قدم للمراجعة

## إعدادات مهمة

### 1. Bundle Identifier
تأكد من أن Bundle Identifier فريد:
```
com.yourcompany.instagramlogin
```

### 2. App Icons
أضف أيقونات التطبيق في:
```
ios/InstagramLoginApp/Images.xcassets/AppIcon.appiconset/
```

### 3. Launch Screen
عدل شاشة البداية في:
```
ios/InstagramLoginApp/LaunchScreen.storyboard
```

## استكشاف الأخطاء

### مشاكل شائعة وحلولها

#### 1. خطأ في التوقيع
```
Code signing error: No matching provisioning profile found
```
**الحل:**
- تأكد من تسجيل الدخول بحساب Apple Developer
- تحقق من Bundle Identifier
- جدد Provisioning Profiles

#### 2. خطأ في البناء
```
Build failed with error: Command failed
```
**الحل:**
```bash
# نظف البناء
cd ios
xcodebuild clean
cd ..

# أعد تثبيت pods
cd ios
pod deintegrate
pod install
cd ..
```

#### 3. مشاكل Metro
```bash
# إعادة تشغيل Metro
npx react-native start --reset-cache
```

## ملفات مهمة للتوقيع

### 1. Info.plist
يحتوي على إعدادات التطبيق والأذونات:
```
ios/InstagramLoginApp/Info.plist
```

### 2. Entitlements
إذا كنت تحتاج أذونات خاصة:
```
ios/InstagramLoginApp/InstagramLoginApp.entitlements
```

## نصائح للنجاح

1. **استخدم Bundle Identifier فريد** لتجنب تضارب التطبيقات
2. **اختبر على أجهزة حقيقية** قبل النشر
3. **احتفظ بنسخة احتياطية** من شهادات التوقيع
4. **اقرأ إرشادات App Store** قبل النشر
5. **اختبر جميع الوظائف** في وضع Release

## الدعم

إذا واجهت مشاكل:
1. تحقق من سجلات Xcode للأخطاء التفصيلية
2. تأكد من تحديث جميع الأدوات
3. راجع وثائق React Native الرسمية
4. تحقق من منتديات Apple Developer

---

**ملاحظة:** هذا التطبيق مخصص للاستخدام الشخصي والتعليمي. تأكد من الامتثال لشروط خدمة Instagram وإرشادات App Store.

