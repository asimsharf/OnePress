import 'package:flutter/material.dart';

class aboutApps extends StatefulWidget {
  @override
  _aboutAppsState createState() => _aboutAppsState();
}

class _aboutAppsState extends State<aboutApps> {
  @override
  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'jazeera',
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "حول التطبيق",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15.0,
            color: Colors.white,
            fontFamily: 'jazeera',
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 15.0),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/logo.png",
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "One Press",
                            style: _txtCustomSub.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "تطبيق One Press اﻹخباري",
                            style: _txtCustomSub,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Divider(
                  height: 0.5,
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "تأسست شركة ون بريس المحدودة:"
                  "لتقدم تصميم جديد برؤية مختفة مواكبة ذات محتوي فني وإذاعي و تلفزيوني عبر الوسائط المختلفة ، "
                  "كما تقوم بأعمال الدعاية والإعلان والتسويق والترويج والإنتاج الفني والإعلامي والتصوير والجرافيك والخدمات الإعلامية."
                  " وإنتاج وتحرير الأخبار  والتقارير والمواد الصحافية وتسويقها عبر الوسائط الإعلامية المتعددة وتنشئ المراكز الصحافية والاعلامية ومعلوماتية والعمل كوكيل أو مراسل صحفي أو  إعلامي وإقامة "
                  "المعارض بعد موافقة الجهات المختصة\n\n\n"
                  "تأسست شركة ون بريس المحدودة:\nوهي تعمل الان في المجال الإعلامي المرئي والمكتوب والمسموع والإلكتروني حيث أنشأت وكالات One Press الاعلامية وهي التي حصلت علي التصديق من المجاس القومي للصحافة والمطبوعات والاعلام الخارجي كمراسل متعدد لعدد من القنوات الخارجية وفقاً للتصديق رقم (م ق ص/أ ع/36/ب/أ) الصادر بتاريخ 23/10/2019.\n\n\n"
                  "تأسست شركة ون بريس المحدودة:\nوهي تعمل في مجال السياحة وتشييد الفنادق والنوادي الرياضية والمنتزهات الترفيهية والقيام بالنقل السياحي وتأجير الليموزين والسيارات والشاحنات وإنشاء وكالات السفر السفر والسياحة وتجهيز وإدارة المطاعم والكفتريات السياحية الثابتة والمتحركة وإنشاء المنتزهات وقاعات الحفلات والأفراح الثابتة والمتنقلة وإستقدام وإستخدام وإستجلاب الأيدي العاملة .\n\n\n"
                  "تأسست شركة ون بريس المحدودة:\n وهي تعمل في مجال صيانة وتسويق المعدات والأجهزة الإلكترونية والكهربائية وأجهزة الانتاج التلفزيوني والصوتيات والاضاءة وصيانتها وتسويق كافة المعدات المتعلقة بالانتاج التلفزيوني.تأسست شركة ون بريس المحدودة:وهي تعمل في مجال بناء الاستديوهات الافتراضية بتقنيات 3D Max وتنقنيات أخري كما تقوم ببناء أستديوهات الشاشة الخضراء بكامل تجيهزاتها.\n\n\n"
                  "Email: info@sudagoras.com\n OR \nsudagoras@gmail.com \nWebsite: https://www.sudagoras.com",
                  style: _txtCustomSub,
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
