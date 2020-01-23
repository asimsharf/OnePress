import 'package:flutter/material.dart';
import 'package:onepress/Account/EditUserProfile.dart';
import 'package:onepress/Account/UserLoginRegister/utils/app_shared_preferences.dart';
import 'package:onepress/ui_widgets/SizedText.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  var firstName;
  var lastName;
  var userGender;
  var userPhone;
  var userBirth;
  var userEmail;
  var userAvatar;
  var userId;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (firstName == null ||
        lastName == null ||
        userGender == null ||
        userPhone == null ||
        userBirth == null ||
        userEmail == null ||
        userAvatar == null ||
        userId == null) {
      await initUserProfile();
    }
  }

  Future<void> initUserProfile() async {
    String firstNam = await AppSharedPreferences.getFromSession('firstName');
    String lastNam = await AppSharedPreferences.getFromSession('lastName');
    String userGende = await AppSharedPreferences.getFromSession('userGender');
    String userPhon = await AppSharedPreferences.getFromSession('userPhone');
    String userBirt = await AppSharedPreferences.getFromSession('userBirth');
    String userEmai = await AppSharedPreferences.getFromSession('userEmail');
    String userAvata = await AppSharedPreferences.getFromSession('userAvatar');
    String userI = await AppSharedPreferences.getFromSession('userId');
    setState(() {
      firstName = firstNam;
      lastName = lastNam;
      userGender = userGende;
      userPhone = userPhon;
      userBirth = userBirt;
      userEmail = userEmai;
      userAvatar = userAvata;
      userId = userI;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            title: Text(
              'profile',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'jazeera',
                  package: 'google_fonts_arabic',
                  color: Colors.white,
                  fontSize: EventSizedConstants.TextappBarSize,
                  shadows: <Shadow>[
                    new Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    new Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 8.0,
                      color: Color.fromARGB(125, 0, 0, 255),
                    ),
                  ]),
            ),
            centerTitle: true,
            pinned: true,
            floating: false,
            expandedHeight: 256,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/person.png',
                    image:
                        'https://healthitsecurity.com/images/site/article_headers/_normal/2017-11-08large-data-breach.jpg',
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: <Color>[Colors.black54, Color(0x00000000)],
                          stops: [0.0, 2.0],
                          begin: FractionalOffset.bottomCenter,
                          end: FractionalOffset.topCenter,
                          tileMode: TileMode.mirror),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new SliverList(
            delegate: SliverChildListDelegate(
              [
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('name',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'jazeera',
                              package: 'google_fonts_arabic',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37505D),
                              fontSize: 14.0)),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        firstName + ' ' + lastName,
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          package: 'google_fonts_arabic',
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('phone',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'jazeera',
                              package: 'google_fonts_arabic',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37505D),
                              fontSize: 14.0)),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        userPhone,
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          package: 'google_fonts_arabic',
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('dateOfBarth',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'jazeera',
                              package: 'google_fonts_arabic',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37505D),
                              fontSize: 14.0)),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        userBirth,
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          package: 'google_fonts_arabic',
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('email',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'jazeera',
                              package: 'google_fonts_arabic',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37505D),
                              fontSize: 14.0)),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          package: 'google_fonts_arabic',
                        ),
                      )
                    ],
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('gender',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: 'jazeera',
                              package: 'google_fonts_arabic',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF37505D),
                              fontSize: 14.0)),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        userGender,
                        style: TextStyle(
                          fontFamily: 'jazeera',
                          package: 'google_fonts_arabic',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: new FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUserProfile()));
                },
                color: Color(0xFF13A1C5),
                splashColor: Color(0xFF009AFF),
                textColor: Colors.black,
                //elevation: 0.2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    'edite_profile_user',
                    style: TextStyle(
                      fontFamily: 'jazeera',
                      package: 'google_fonts_arabic',
                      fontSize: EventSizedConstants.TextButtonFontSized,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: <Shadow>[
                        new Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        new Shadow(
                          offset: Offset(3.0, 3.0),
                          blurRadius: 8.0,
                          color: Color.fromARGB(125, 0, 0, 255),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
