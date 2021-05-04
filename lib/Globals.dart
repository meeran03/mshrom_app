import 'dart:core';

class Globals {
  static bool arabic = false;

  static putWord(String word) {
    if (!arabic) {
      return word;
    } else {
      return translations[word];
    }
  }

  static Map translations = {
    'Home': 'الصفحة الرئيسية',
    'Categories': 'فئات',
    'Wishlist': 'قائمة الرغبات',
    'Confirm Password': 'تأكيد كلمة المرور',
    'Current Password': 'كلمة المرور الحالي',
    'New Password': 'كلمة السر الجديدة',
    'Phone Number': 'رقم التليفون',
    'Enter Name': 'أدخل الاسم',
    'Update Profile': 'تحديث الملف',
    'Address': 'تبوك',
    'My Carts': 'عرباتي',
    'Dashboard': 'لوحة القيادة',
    'Log out': 'تسجيل خروج',
    'District required': 'المنطقة المطلوبة',
    "Fill form correctly": 'املأ النموذج بشكل صحيح',
    'Special notes for delivery': 'ملاحظات خاصة للتسليم',
    'Search By Product Name': 'البحث عن طريق اسم المنتج',
    'Orders': 'الطلب',
    'Edit Personal Info': 'تحرير المعلومات الشخصية',
    'Welcome Back': 'مرحبا بعودتك',
    'Sign in to continue': 'تسجيل الدخول للمتابعة',
    'Enter Email': 'أدخل البريد الإلكتروني',
    'Password': 'كلمة المرور',
    'Address is required': 'العنوان مطلوب',
    'Phone Number  is required': 'رقم الهاتف مطلوب',
    'Invalid email address': 'عنوان البريد الإلكتروني غير صالح',
    'Forget Password?': 'نسيت كلمة المرور؟',
    'Sign In': ' تسجيل الدخول ',
    'Sign up to continue': 'اشترك للمتابعة',
    'Processing....': 'معالجة....',
    'Select State': 'اختر ولايه',
    'Select City': 'اختر مدينة',
    'City is required': 'المدينة مطلوبة',
    'Logistic required': 'اللوجيستية المطلوبة',
    'Logistic': 'جمارك',
    'Create New Account!': ' انشاء حساب جديد! ',
    'Register': ' يسجل ',
    'Change Password': 'تغيير كلمة المرور',
    'Already have an account?': ' هل لديك حساب؟ '
  };
}
