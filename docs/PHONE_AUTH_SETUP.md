# إعداد تسجيل الدخول برقم الهاتف (SMS OTP)

واجهة تسجيل الدخول في `index.html` تستخدم Supabase Auth عبر `signInWithOtp` و`verifyOtp`.

## 1) إعداد Supabase Auth
1. افتح لوحة مشروع Supabase ثم **Authentication → Providers → Phone**.
2. فعّل Phone provider.
3. أضف مزود SMS مدعوماً في إعدادات المشروع، وأدخل بياناته من لوحة Supabase فقط.
4. اضبط قالب الرسالة ليحتوي رمز التحقق الذي يمرره Supabase.
5. اختبر وصول الرسائل إلى أرقام عراقية (+964) مع مزودك قبل الإطلاق. توفر الرسائل وتكلفتها يعتمدان على مزود SMS وتغطيته للعراق.

## 2) إعداد واجهة الموقع
في أعلى كتلة JavaScript داخل `index.html` استبدل:
- `https://YOUR_PROJECT_REF.supabase.co` برابط Project URL.
- `YOUR_SUPABASE_ANON_OR_PUBLISHABLE_KEY` بمفتاح anon / publishable الخاص بالمشروع.

هذه مفاتيح عميل عامة مصممة للاستخدام في المتصفح مع RLS. **لا تضع service_role أو أي مفتاح سري في HTML أو GitHub.**

## 3) إنشاء ملف المستخدم تلقائياً
شغّل محتوى `supabase/migrations/202611130001_phone_auth_profile.sql` مرة واحدة في SQL Editor. ينشئ trigger ملف profile بدور customer بعد إنشاء حساب Auth.

## 4) اختبار
- جرّب رقم هاتف بصيغة +9647XXXXXXXXX.
- اطلب رمزاً، ثم أدخله خلال مدة صلاحيته.
- تحقق من ظهور المستخدم في Authentication → Users ومن وجود صف مقابل في public.profiles.
- تحقق من أن الدور customer وليس merchant أو admin.

## ملاحظات إنتاجية
- لا تسمح للمتصفح بتغيير role.
- إعدادات مزود SMS وتكاليفه وحدود الإرسال يجب اختبارها قبل الإعلان عن الخدمة.
- أضف CAPTCHA / rate limits وسياسة خصوصية وموافقة المستخدم قبل فتح التسجيل العام.
