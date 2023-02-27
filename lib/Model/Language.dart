
class Language {
  static String? currentLanguage;
  static Map<String, String> language = currentLanguage == 'EN' ? EN : AR;

  static final Map<String, String> AR = {
    'title': 'أهداف',
    'days': 'الأيام',
    'goal': 'الهدف',
    'finish': 'أنتهى',
    'massageTitle': 'مجرد رسالة',
    'massageContent':
        'شكرا لك لأختيارك هذا التطبيق. \n\n إذا كان لديك اي شكوى أو أقتراح تواصل معي عبر البريد الخاص بي.\n',
    'massageButton': 'تواصل عبر البريد',
    'depositTitle': 'إيداع المال',
    'depositFiled': 'المبلغ',
    'ok': 'حسنًا',
    'cancel': 'إلغاء',
    'goalDetail': 'تفاصيل الهدف',
    'depositButton': 'إيداع',
    'history': 'سجل العمليات',
    'deleteTitle': 'حذف الهدف',
    'deleteContent':
        'هل أنت متأكد من حذف الهدف, إذا كنت متأكد من حذف الهدف قم بالضغط على حسنًا',
    'save': 'حفظ',
    'moneyGoal': 'هدف مالي',
    'date': 'التاريخ',
    'done': 'تهانينا لك, لقد اتمت هدفك المالي',
    'enterMoney': 'أدخل هدفك المالي',
    'newGoal': 'هدف جديد',
    'create': 'إنشاء',
    'language': 'اللغة',
    'darkMode': 'الوضع الليلي',
    'toastMassage':'يجب عليك اعادة تشغيل التطبيق لتفعيل الاعدادات الجديدة',
    'rate':'قيم التطبيق'
  };

  static final Map<String, String> EN = {
    'title': 'Goals',
    'days': 'Days',
    'goal': 'Goal',
    'finish': 'Finish',
    'massageTitle': 'Just a Massage',
    'massageContent':
        'Thank you for choosing my app.\n\n If you have any complaints or suggestions contact me on my email.\n',
    'massageButton': 'Contact me by email',
    'depositTitle': 'Deposit Money',
    'depositFiled': 'Amount',
    'ok': 'Ok',
    'cancel': 'Cancel',
    'goalDetail': 'Goal Detail',
    'depositButton': 'Deposit',
    'history': 'History',
    'deleteTitle': 'Delete Goal',
    'deleteContent':
        'Are you sure for delete goal. If you sure click ok, if not click cancel.',
    'save': 'Save',
    'moneyGoal': 'Money Goal',
    'date': 'Date',
    'done': 'Congratulations, your goal is done.',
    'enterMoney': 'Enter money goal',
    'newGoal': 'New Goal',
    'create': 'Create',
    'language': 'Language',
    'darkMode': 'Dark mode',
    'toastMassage':'You must restart the application to activate the new settings.',
    'rate':'Rate the application.'
  };
}
