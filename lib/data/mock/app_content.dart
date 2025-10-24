class AppContent {
  static const trendingSearches = [
    'Rawabi skyline',
    'Beachfront villas',
    'Smart homes',
    'Downtown lofts',
    'Mountain cabins',
    'Pet friendly rentals',
    'Furnished studios',
    'Homes with solar',
  ];

  static const marketStats = [
    {'label': 'Avg Listing', 'value': '\$325K', 'trend': '1.8'},
    {'label': 'New Supply', 'value': '48', 'trend': '-0.8'},
    {'label': 'Rental Yield', 'value': '6.2%', 'trend': '0.4'},
  ];

  static const marketInsights = [
    {
      'title': 'Mortgage rates eased this week',
      'body': 'Fixed 15-year programs dropped 0.3% giving buyers more leverage.',
    },
    {
      'title': 'Family villas stay on market for 12 days',
      'body': 'Demand for 4+ bedroom homes around schools remains strong.',
    },
    {
      'title': 'Investors seek flexible rentals',
      'body': 'Serviced apartments with 3-month leases are trending across city centers.',
    },
  ];

  static const virtualTours = [
    {
      'title': 'Skyline Penthouse Tour',
      'image': 'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6',
      'duration': '4:32',
    },
    {
      'title': 'Mountain Retreat Walkthrough',
      'image': 'https://images.unsplash.com/photo-1501183638710-841dd1904471',
      'duration': '3:12',
    },
    {
      'title': 'Coastal Villa Sunset',
      'image': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6',
      'duration': '5:21',
    },
  ];

  static const neighborhoodSpotlights = [
    {
      'title': 'Rawabi Heights',
      'subtitle': 'Cafés, co-working hubs, and weekend markets with skyline views.',
    },
    {
      'title': 'Jericho Oasis',
      'subtitle': 'Palm-lined streets with luxury spas and tranquil resort living.',
    },
    {
      'title': 'Bethlehem Creative District',
      'subtitle': 'Artisan studios surrounded by boutique loft conversions.',
    },
  ];

  static const financePrograms = [
    {
      'title': 'First Home Advantage',
      'subtitle': '1.99% fixed for 12 months + appraisal rebate.',
    },
    {
      'title': 'Green Energy Upgrade',
      'subtitle': 'Finance solar additions with flexible amortization.',
    },
    {
      'title': 'Investor Bridge',
      'subtitle': 'Bridge-to-rent with interest-only payments for 18 months.',
    },
  ];

  static const serviceDirectory = [
    {
      'title': 'Interior Styling',
      'subtitle': 'Curated staging packages for quick resale.',
      'icon': 'wand-magic-sparkles',
    },
    {
      'title': 'Smart Home Setup',
      'subtitle': 'Integrate sensors, climate control, and security suites.',
      'icon': 'house-signal',
    },
    {
      'title': 'Relocation Concierge',
      'subtitle': 'Paperwork, moving logistics, and school enrollment help.',
      'icon': 'truck-fast',
    },
  ];

  static const communityEvents = [
    {
      'title': 'Investors Breakfast',
      'date': '27 Oct',
      'location': 'Rawabi Innovation Hub',
    },
    {
      'title': 'Sustainability Expo',
      'date': '31 Oct',
      'location': 'Jerusalem Design Center',
    },
    {
      'title': 'Waterfront Sunset Open House',
      'date': '04 Nov',
      'location': 'Gaza Azure Walk',
    },
  ];

  static const investmentTips = [
    {
      'title': 'Track absorption rate',
      'body': 'Listings under 10 days indicate opportunity to reprice upwards.',
    },
    {
      'title': 'Blend rental mixes',
      'body': 'Combine long-term leases with executive stays to protect cashflow.',
    },
    {
      'title': 'Audit operating costs',
      'body': 'Smart thermostats trim 12% from seasonal energy bills on average.',
    },
    {
      'title': 'Bundle amenities',
      'body': 'Fitness memberships and coworking tie-ins add \$120/month in value.',
    },
  ];

  static const sustainabilityHighlights = [
    {
      'title': 'Solar ready rooftops',
      'body': 'Eligible homes get municipal credit covering 25% of installation.',
    },
    {
      'title': 'Grey water reuse',
      'body': 'Filtered recovery systems save 38% on landscaping water.',
    },
    {
      'title': 'Passive cooling layouts',
      'body': 'Cross-ventilation floorplans keep interiors 3°C cooler naturally.',
    },
  ];

  static const safetyReminders = [
    {
      'title': 'Smart lock audits',
      'body': 'Schedule quarterly code refresh for rental turnovers.',
    },
    {
      'title': 'Emergency packs',
      'body': 'Each listing includes QR-coded evacuation guides and contacts.',
    },
    {
      'title': 'Inspections calendar',
      'body': 'Auto-reminders ensure fire extinguishers and alarms stay certified.',
    },
  ];

  static const lifestylePresets = [
    {
      'id': 'family',
      'title': {'en': 'Family Focus', 'ar': 'مناسب للعائلات'},
      'status': 'for_sale',
      'types': ['villas'],
      'minBeds': 4,
      'sort': 'Newest',
    },
    {
      'id': 'city',
      'title': {'en': 'City Living', 'ar': 'سكن حضري'},
      'status': 'for_rent',
      'types': ['apartments'],
      'city': 'Rawabi',
      'sort': 'Price ↑',
    },
    {
      'id': 'eco',
      'title': {'en': 'Eco Smart', 'ar': 'ذكي وصديق للبيئة'},
      'types': ['apartments', 'villas'],
      'sort': 'Newest',
    },
    {
      'id': 'holiday',
      'title': {'en': 'Holiday Homes', 'ar': 'منازل العطل'},
      'types': ['cabins'],
      'status': 'for_rent',
      'sort': 'Price ↓',
    },
  ];

  static const homeQuickActions = [
    {
      'icon': 'plus',
      'route': 'property.submit',
      'label': {'en': 'List Property', 'ar': 'أضف عقاراً'},
    },
    {
      'icon': 'heart',
      'route': 'saved',
      'label': {'en': 'View Favorites', 'ar': 'المحفوظات'},
    },
    {
      'icon': 'scale-balanced',
      'route': 'compare',
      'label': {'en': 'Compare', 'ar': 'المقارنة'},
    },
    {
      'icon': 'calendar-check',
      'route': 'booking.sheet',
      'label': {'en': 'Plan Visit', 'ar': 'حجز زيارة'},
    },
  ];

  static const budgetAdvisories = [
    {
      'title': {'en': 'Smart saving plan', 'ar': 'خطة ادخار ذكية'},
      'body': {
        'en': 'Allocate 25% of income toward mortgage and 5% for maintenance.',
        'ar': 'خصص 25% من الدخل للقرض و5% للصيانة الشهرية.',
      },
    },
    {
      'title': {'en': 'Upgrade buffer', 'ar': 'احتياطي الترقية'},
      'body': {
        'en': 'Keep $8k aside for furnishing and smart upgrades.',
        'ar': 'احتفظ بمبلغ 8000 دولار للأثاث والترقيات الذكية.',
      },
    },
    {
      'title': {'en': 'Finance coaching', 'ar': 'استشارة تمويل'},
      'body': {
        'en': 'Schedule a session with our finance partner for tailored plans.',
        'ar': 'احجز جلسة مع شريك التمويل للحصول على خطة مخصصة.',
      },
    },
  ];

  static const travelTimes = [
    {
      'title': {'en': 'City Center', 'ar': 'وسط المدينة'},
      'car': 18,
      'transit': 26,
      'bike': 35,
    },
    {
      'title': {'en': 'Tech Park', 'ar': 'منتزه التكنولوجيا'},
      'car': 14,
      'transit': 21,
      'bike': 28,
    },
    {
      'title': {'en': 'Seaside', 'ar': 'الواجهة البحرية'},
      'car': 32,
      'transit': 44,
      'bike': 0,
    },
  ];

  static const renovationChecklist = [
    {
      'title': {'en': 'Energy audit', 'ar': 'تدقيق الطاقة'},
      'detail': {
        'en': 'Check insulation, glazing, and HVAC efficiency.',
        'ar': 'تحقق من العزل والزجاج وكفاءة التكييف.',
      },
    },
    {
      'title': {'en': 'Smart lock upgrade', 'ar': 'ترقية الأقفال الذكية'},
      'detail': {
        'en': 'Install biometric entry with guest pass management.',
        'ar': 'ركّب دخولاً حيوياً مع إدارة تصاريح الضيوف.',
      },
    },
    {
      'title': {'en': 'Outdoor lighting', 'ar': 'إضاءة خارجية'},
      'detail': {
        'en': 'Solar walkway fixtures improve curb appeal.',
        'ar': 'مصابيح الممرات الشمسية تعزز جاذبية المدخل.',
      },
    },
  ];

  static const successStories = [
    {
      'title': {'en': 'The Khalil family', 'ar': 'عائلة خليل'},
      'body': {
        'en': 'Found a school-side villa and closed in 9 days.',
        'ar': 'وجدوا فيلا قرب المدرسة وأتموا الشراء خلال 9 أيام.',
      },
    },
    {
      'title': {'en': 'Remote investor', 'ar': 'المستثمر البعيد'},
      'body': {
        'en': 'Automated tours and financing secured a high-yield loft.',
        'ar': 'الجولات الافتراضية والتمويل أمّنا شقة عالية العائد.',
      },
    },
    {
      'title': {'en': 'Designer duo', 'ar': 'الثنائي المصمم'},
      'body': {
        'en': 'Upgraded a heritage cabin with green tech support.',
        'ar': 'طوّرا كوخاً تراثياً بدعم تقنيات خضراء.',
      },
    },
  ];

  static const insuranceOptions = [
    {
      'title': {'en': 'Premium shield', 'ar': 'درع مميز'},
      'body': {
        'en': 'All-risk cover with rent protection add-on.',
        'ar': 'تغطية شاملة مع حماية الإيجار الإضافية.',
      },
    },
    {
      'title': {'en': 'Eco saver', 'ar': 'توفير بيئي'},
      'body': {
        'en': 'Discounted for solar powered homes and EV garages.',
        'ar': 'خصم للمنازل المزودة بالطاقة الشمسية ومساحات السيارات الكهربائية.',
      },
    },
    {
      'title': {'en': 'Tenant care', 'ar': 'رعاية المستأجر'},
      'body': {
        'en': 'Covers furnished rentals with guest turnover services.',
        'ar': 'يشمل إيجارات مفروشة مع خدمات تبديل الضيوف.',
      },
    },
  ];

  static const maintenanceReminders = [
    {
      'title': {'en': 'Filter swap', 'ar': 'استبدال الفلاتر'},
      'schedule': 'Monthly',
    },
    {
      'title': {'en': 'Roof inspection', 'ar': 'فحص السقف'},
      'schedule': 'Seasonal',
    },
    {
      'title': {'en': 'Pool balancing', 'ar': 'معايرة المسبح'},
      'schedule': 'Bi-weekly',
    },
  ];

  static const guaranteeBadges = [
    {
      'title': {'en': '14-day resale assist', 'ar': 'دعم إعادة البيع خلال 14 يوماً'},
      'body': {
        'en': 'We relist and cover marketing if you change your mind.',
        'ar': 'نعيد إدراج العقار ونتكفل بالتسويق عند تغيير القرار.',
      },
    },
    {
      'title': {'en': 'Smart home warranty', 'ar': 'ضمان المنزل الذكي'},
      'body': {
        'en': '24-month coverage for IoT devices and automation.',
        'ar': 'ضمان لمدة 24 شهراً لأجهزة إنترنت الأشياء والأتمتة.',
      },
    },
    {
      'title': {'en': 'Green compliance', 'ar': 'التزام بيئي'},
      'body': {
        'en': 'Certified energy auditors support sustainability upgrades.',
        'ar': 'مدققو الطاقة المعتمدون يدعمون الترقيات البيئية.',
      },
    },
  ];

  static const topAgents = [
    {
      'name': {'en': 'Maya Khalil', 'ar': 'مايا خليل'},
      'city': {'en': 'Rawabi', 'ar': 'روابي'},
      'rating': 4.9,
      'photo': 'https://i.pravatar.cc/150?img=47',
    },
    {
      'name': {'en': 'Omar Haddad', 'ar': 'عمر حداد'},
      'city': {'en': 'Jericho', 'ar': 'أريحا'},
      'rating': 4.7,
      'photo': 'https://i.pravatar.cc/150?img=22',
    },
  ];

  static const marketHeatmap = [
    {
      'title': {'en': 'Rawabi skyline', 'ar': 'أفق روابي'},
      'trend': 2.8,
    },
    {
      'title': {'en': 'Jericho oasis', 'ar': 'واحة أريحا'},
      'trend': 1.3,
    },
    {
      'title': {'en': 'Bethlehem creatives', 'ar': 'مبدعو بيت لحم'},
      'trend': -0.6,
    },
  ];

  static const exploreAlerts = [
    {
      'title': {'en': 'New villas weekly', 'ar': 'فلل جديدة أسبوعياً'},
      'body': {
        'en': 'Get curated villa drops every Monday morning.',
        'ar': 'استلم أحدث عروض الفلل كل صباح اثنين.',
      },
    },
    {
      'title': {'en': 'Rental price watch', 'ar': 'مراقبة أسعار الإيجار'},
      'body': {
        'en': 'Alerts when rents dip 5% in your saved cities.',
        'ar': 'تنبيهات عند انخفاض الإيجارات بنسبة 5% في مدنك المفضلة.',
      },
    },
  ];

  static const commuteProfiles = [
    {
      'title': {'en': 'Metro rider', 'ar': 'راكب المترو'},
      'body': {
        'en': 'Show homes within 10 minutes of transit stations.',
        'ar': 'عرض المنازل على بُعد 10 دقائق من محطات النقل.',
      },
    },
    {
      'title': {'en': 'Remote work hub', 'ar': 'مركز العمل عن بُعد'},
      'body': {
        'en': 'Filter properties with dedicated office and fiber.',
        'ar': 'فرز العقارات ذات المكاتب المخصصة والإنترنت السريع.',
      },
    },
    {
      'title': {'en': 'Weekend escapes', 'ar': 'عطلات نهاية الأسبوع'},
      'body': {
        'en': 'Highlight cabins within 90 minutes drive.',
        'ar': 'تسليط الضوء على الأكواخ على بُعد 90 دقيقة بالسيارة.',
      },
    },
  ];

  static const savedCollections = [
    {
      'title': {'en': 'Investment picks', 'ar': 'اختيارات الاستثمار'},
      'body': {
        'en': 'High yield homes you tagged for rentals.',
        'ar': 'منازل عالية العائد حفظتها للإيجار.',
      },
    },
    {
      'title': {'en': 'Family shortlist', 'ar': 'قائمة العائلة'},
      'body': {
        'en': 'Large kitchens, gardens, and schools nearby.',
        'ar': 'مطابخ كبيرة وحدائق ومدارس قريبة.',
      },
    },
    {
      'title': {'en': 'Design gems', 'ar': 'روائع التصميم'},
      'body': {
        'en': 'Lofts with premium finishes and views.',
        'ar': 'شقق بلمسات فاخرة وإطلالات مميزة.',
      },
    },
  ];

  static const advisorContacts = [
    {
      'title': {'en': 'Mortgage advisor', 'ar': 'مستشار التمويل'},
      'phone': '+970-555-903',
    },
    {
      'title': {'en': 'Interior consultant', 'ar': 'استشاري التصميم الداخلي'},
      'phone': '+970-555-812',
    },
  ];

  static const propertyDocuments = [
    {
      'title': {'en': 'Floor plan', 'ar': 'مخطط الطابق'},
      'icon': 'file-lines',
    },
    {
      'title': {'en': 'Energy certificate', 'ar': 'شهادة الطاقة'},
      'icon': 'file-shield',
    },
    {
      'title': {'en': 'Neighborhood guide', 'ar': 'دليل الحي'},
      'icon': 'book',
    },
  ];

  static const nearbyServices = [
    {
      'title': {'en': 'Organic market', 'ar': 'سوق عضوي'},
      'distance': '0.8 km',
    },
    {
      'title': {'en': 'Fitness club', 'ar': 'نادي رياضي'},
      'distance': '1.2 km',
    },
    {
      'title': {'en': 'International school', 'ar': 'مدرسة دولية'},
      'distance': '1.5 km',
    },
  ];

  static const investmentHighlights = [
    {
      'title': {'en': 'Projected ROI', 'ar': 'العائد المتوقع'},
      'body': {
        'en': '7.8% gross yield with furnished rental strategy.',
        'ar': 'عائد إجمالي 7.8% مع استراتيجية الإيجار المفروش.',
      },
    },
    {
      'title': {'en': 'Occupancy trend', 'ar': 'نسبة الإشغال'},
      'body': {
        'en': '94% occupancy in the last 12 months.',
        'ar': '94% نسبة إشغال خلال 12 شهراً.',
      },
    },
    {
      'title': {'en': 'Upgrade potential', 'ar': 'إمكانات الترقية'},
      'body': {
        'en': 'Solar roof upgrade adds $220 monthly savings.',
        'ar': 'ترقية السقف الشمسي توفر 220 دولاراً شهرياً.',
      },
    },
  ];

  static const propertyBadges = [
    {'title': {'en': 'Verified photos', 'ar': 'صور موثوقة'}},
    {'title': {'en': '360° tour', 'ar': 'جولة 360°'}},
    {'title': {'en': 'Move-in ready', 'ar': 'جاهز للسكن'}},
  ];

  static String localizedText(Map<String, String> values, String languageCode) {
    return values[languageCode] ?? values['en'] ?? values.values.first;
  }
}
