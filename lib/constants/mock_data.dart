class MockData {
  // Learning Tracks Data
  static final List<Map<String, dynamic>> learningTracks = [
    // Accessible Tracks
    {
      'id': 'pre_programming',
      'title': 'ما قبل البرمجة - "رحلة الاستكشاف"',
      'icon': '🎯',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 8,
      'description': 'تعرف على عالم البرمجة قبل البدء',
      'image': '/placeholder.svg?height=200&width=300&text=Pre-Programming',
    },
    {
      'id': 'logical_thinking',
      'title': 'التفكير المنطقي - "عقل المبرمج"',
      'icon': '🧩',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 12,
      'description': 'طور مهارات التفكير المنطقي',
      'image': '/placeholder.svg?height=200&width=300&text=Logical Thinking',
    },
    {
      'id': 'computer_science_intro',
      'title': 'مقدمة في علوم الحاسوب - "عالم التقنية"',
      'icon': '💡',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 15,
      'description': 'أساسيات علوم الحاسوب',
      'image': '/placeholder.svg?height=200&width=300&text=Computer Science',
    },
    {
      'id': 'programmer_roadmap',
      'title': 'خريطة المبرمج - "اختر طريقك"',
      'icon': '🗺️',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 6,
      'description': 'اختر مسارك في البرمجة',
      'image': '/placeholder.svg?height=200&width=300&text=Roadmap',
    },
    {
      'id': 'career_guidance',
      'title': 'التوجيه المهني - "مستقبلك التقني"',
      'icon': '🎓',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 10,
      'description': 'خطط لمستقبلك المهني',
      'image': '/placeholder.svg?height=200&width=300&text=Career Guidance',
    },
    {
      'id': 'python',
      'title': 'Python - "الثعبان الودود"',
      'icon': '🐍',
      'isAccessible': true,
      'progress': 0.15,
      'lessonsCount': 20,
      'description': 'تعلم لغة البايثون من الصفر',
      'image': '/placeholder.svg?height=200&width=300&text=Python',
    },
    {
      'id': 'html',
      'title': 'HTML - "هيكل الويب"',
      'icon': '🌐',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 14,
      'description': 'أساسيات بناء صفحات الويب',
      'image': '/placeholder.svg?height=200&width=300&text=HTML',
    },
    {
      'id': 'css',
      'title': 'CSS - "جمال الويب"',
      'icon': '🎨',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 18,
      'description': 'تصميم وتنسيق صفحات الويب',
      'image': '/placeholder.svg?height=200&width=300&text=CSS',
    },
    {
      'id': 'programming_basics',
      'title': 'أساسيات البرمجة - "البداية الصحيحة"',
      'icon': '📋',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 16,
      'description': 'المفاهيم الأساسية في البرمجة',
      'image': '/placeholder.svg?height=200&width=300&text=Programming Basics',
    },
    {
      'id': 'scratch',
      'title': 'Scratch - "البرمجة بالمكعبات"',
      'icon': '📝',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 12,
      'description': 'تعلم البرمجة بطريقة بصرية',
      'image': '/placeholder.svg?height=200&width=300&text=Scratch',
    },
    {
      'id': 'alice',
      'title': 'Alice - "البرمجة ثلاثية الأبعاد"',
      'icon': '🎮',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 10,
      'description': 'برمجة ثلاثية الأبعاد للمبتدئين',
      'image': '/placeholder.svg?height=200&width=300&text=Alice 3D',
    },
    {
      'id': 'mit_app_inventor',
      'title': 'MIT App Inventor - "صانع التطبيقات"',
      'icon': '🤖',
      'isAccessible': true,
      'progress': 0.0,
      'lessonsCount': 14,
      'description': 'إنشاء تطبيقات الهاتف بسهولة',
      'image': '/placeholder.svg?height=200&width=300&text=MIT App Inventor',
    },
    // Locked Tracks
    {
      'id': 'java',
      'title': 'Java - "قهوة المبرمجين"',
      'icon': '☕',
      'isAccessible': false,
      'progress': 0.0,
      'lessonsCount': 25,
      'description': 'لغة البرمجة الشائعة',
      'image': '/placeholder.svg?height=200&width=300&text=Java',
    },
    {
      'id': 'cpp',
      'title': 'C++ - "قوة السرعة"',
      'icon': '⚡',
      'isAccessible': false,
      'progress': 0.0,
      'lessonsCount': 30,
      'description': 'لغة البرمجة عالية الأداء',
      'image': '/placeholder.svg?height=200&width=300&text=C++',
    },
    {
      'id': 'javascript',
      'title': 'JavaScript - "روح الويب"',
      'icon': '⚡',
      'isAccessible': false,
      'progress': 0.0,
      'lessonsCount': 22,
      'description': 'لغة برمجة الويب التفاعلي',
      'image': '/placeholder.svg?height=200&width=300&text=JavaScript',
    },
  ];

  // Demo Python Lesson Data
  static const Map<String, dynamic> pythonDemoLesson = {
    'id': 'python_hello',
    'title': 'مرحباً بايثون',
    'trackId': 'python',
    'slides': [
      {
        'title': 'ما هي لغة البايثون؟',
        'content': 'البايثون هي لغة برمجة سهلة التعلم وقوية في نفس الوقت. تستخدم في تطوير المواقع، الذكاء الاصطناعي، وتحليل البيانات.',
        'code': 'print("مرحباً بالعالم!")',
        'hasCode': true,
      },
      {
        'title': 'لماذا نتعلم البايثون؟',
        'content': 'البايثون مناسبة للمبتدئين لأنها سهلة القراءة والفهم. كما أنها تستخدم في شركات كبيرة مثل جوجل ونتفليكس.',
        'code': 'name = "أحمد"\nprint(f"مرحباً {name}!")',
        'hasCode': true,
      },
      {
        'title': 'ملخص الدرس',
        'content': 'تعلمنا في هذا الدرس:\n• ما هي لغة البايثون\n• لماذا هي مهمة\n• كيفية كتابة أول برنامج',
        'code': '',
        'hasCode': false,
      },
    ],
  };

  // Sample Quiz Data
  static final List<Map<String, dynamic>> quizQuestions = [
    {
      'id': 'q1',
      'type': 'multiple_choice',
      'question': 'ما هي الدالة المستخدمة لطباعة النص في البايثون؟',
      'options': ['print()', 'show()', 'display()', 'output()'],
      'correctAnswer': 0,
      'explanation': 'دالة `print()` هي الدالة الأساسية لطباعة النصوص في البايثون',
      'points': 10,
    },
    {
      'id': 'q2',
      'type': 'fill_blank',
      'question': 'أكمل الكود التالي لطباعة "مرحباً بالعالم":',
      'code': '___("مرحباً بالعالم")',
      'correctAnswer': 'print',
      'explanation': 'نستخدم `print` لطباعة النصوص',
      'points': 15,
    },
    {
      'id': 'q3',
      'type': 'code_arrangement',
      'question': 'رتب الأسطر التالية لإنشاء برنامج صحيح:',
      'codeBlocks': ['name = "سارة"', 'print(f"مرحباً {name}")'],
      'correctOrder': [0, 1],
      'explanation': 'يجب تعريف المتغير أولاً ثم استخدامه',
      'points': 20,
    },
  ];

  // Achievements Data
  static final List<Map<String, dynamic>> achievements = [
    {
      'id': 'first_lesson',
      'title': 'الدرس الأول',
      'description': 'أكمل أول درس لك',
      'icon': '🎯',
      'isUnlocked': true,
    },
    {
      'id': 'quiz_master',
      'title': 'خبير الاختبارات',
      'description': 'احصل على 100% في 5 اختبارات',
      'icon': '🏆',
      'isUnlocked': false,
    },
    {
      'id': 'week_streak',
      'title': 'أسبوع متواصل',
      'description': 'تعلم لمدة 7 أيام متتالية',
      'icon': '🔥',
      'isUnlocked': false,
    },
    {
      'id': 'python_beginner',
      'title': 'مبتدئ البايثون',
      'description': 'أكمل 5 دروس في البايثون',
      'icon': '🐍',
      'isUnlocked': true,
    },
  ];

  // Store Items Data
  static final List<Map<String, dynamic>> storeItems = [
    // Coins Section
    {
      'id': 'coins_100',
      'category': 'coins',
      'title': '100 عملة',
      'price': '4.99',
      'currency': 'SAR',
      'icon': '🪙',
      'description': 'حزمة العملات الأساسية',
    },
    {
      'id': 'coins_500',
      'category': 'coins',
      'title': '500 عملة',
      'price': '19.99',
      'currency': 'SAR',
      'icon': '💰',
      'description': 'حزمة العملات المتوسطة',
      'isPopular': true,
    },
    {
      'id': 'coins_1000',
      'category': 'coins',
      'title': '1000 عملة',
      'price': '34.99',
      'currency': 'SAR',
      'icon': '💎',
      'description': 'حزمة العملات الكبيرة',
    },
    // Content Section
    {
      'id': 'advanced_python',
      'category': 'content',
      'title': 'البايثون المتقدم',
      'price': '150',
      'currency': 'coins',
      'icon': '🐍',
      'description': 'دروس متقدمة في البايثون',
    },
    {
      'id': 'web_development',
      'category': 'content',
      'title': 'تطوير المواقع',
      'price': '200',
      'currency': 'coins',
      'icon': '🌐',
      'description': 'مسار كامل لتطوير المواقع',
    },
    // Customization Section
    {
      'id': 'avatar_robot',
      'category': 'customization',
      'title': 'أفاتار الروبوت',
      'price': '50',
      'currency': 'coins',
      'icon': '🤖',
      'description': 'شكل أفاتار جديد',
    },
    {
      'id': 'vip_badge',
      'category': 'customization',
      'title': 'شارة VIP',
      'price': '100',
      'currency': 'coins',
      'icon': '👑',
      'description': 'شارة مميزة للملف الشخصي',
    },
  ];

  static final List<Map<String, dynamic>> lessons = [
    {
      'id': 'lesson_1',
      'title': 'مقدمة في البايثون',
      'description': 'تعرف على أساسيات لغة البايثون',
      'duration': '15 دقيقة',
      'isUnlocked': true,
      'isCompleted': false,
      'type': 'introduction',
      'trackId': 'python',
    },
    {
      'id': 'lesson_2',
      'title': 'المتغيرات والأنواع',
      'description': 'تعلم كيفية استخدام المتغيرات',
      'duration': '20 دقيقة',
      'isUnlocked': true,
      'isCompleted': false,
      'type': 'concept',
      'trackId': 'python',
    },
    {
      'id': 'lesson_3',
      'title': 'العمليات الحسابية',
      'description': 'العمليات الأساسية في البايثون',
      'duration': '18 دقيقة',
      'isUnlocked': false,
      'isCompleted': false,
      'type': 'practice',
      'trackId': 'python',
    },
    {
      'id': 'lesson_4',
      'title': 'الشروط والحلقات',
      'description': 'التحكم في تدفق البرنامج',
      'duration': '25 دقيقة',
      'isUnlocked': false,
      'isCompleted': false,
      'type': 'concept',
      'trackId': 'python',
    },
    {
      'id': 'lesson_5',
      'title': 'الدوال',
      'description': 'إنشاء واستخدام الدوال',
      'duration': '22 دقيقة',
      'isUnlocked': false,
      'isCompleted': false,
      'type': 'practice',
      'trackId': 'python',
    },
    {
      'id': 'html_intro',
      'title': 'مقدمة في HTML',
      'track': 'HTML - هيكل الويب',
      'completedDate': 'منذ 3 أيام',
      'score': 92,
      'coins': 60,
      'difficulty': 'مبتدئ',
      'timeSpent': '20 دقيقة',
      'isUnlocked': true,
      'isCompleted': true,
      'type': 'introduction',
      'trackId': 'html',
    },
    {
      'id': 'logic_basics',
      'title': 'أساسيات المنطق',
      'track': 'التفكير المنطقي',
      'completedDate': 'منذ أسبوع',
      'score': 78,
      'coins': 40,
      'difficulty': 'متوسط',
      'timeSpent': '25 دقيقة',
      'isUnlocked': true,
      'isCompleted': true,
      'type': 'concept',
      'trackId': 'logical_thinking',
    },
  ];
}
