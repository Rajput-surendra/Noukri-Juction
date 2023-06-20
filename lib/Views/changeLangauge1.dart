import 'package:flutter/material.dart';
import 'package:job_dekho_app/Views/signin_Screen.dart';
import '../Helper/session.dart';
import '../main.dart';

/*
Title:ChangeLanguageScreen
Purpose:ChangeLanguageScreen
Created By:Kalpesh Khandla
*/

class ChangeLanguage extends StatefulWidget {
  bool? back;
  ChangeLanguage({this.back});


  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {

  int? selectLan;

  @override
  void initState() {
    new Future.delayed(Duration.zero, () {
      languageList = [
        getTranslated(context, 'ENGLISH_LAN'),
        getTranslated(context, 'HINDI_LAN'),
      ];
    });
    super.initState();
    //  getProfile();
  }
  final GlobalKey<FormState> _changePwdKey = GlobalKey<FormState>();
  void openChangeLanguageBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHOOSE_LANGUAGE_LBL"),
                      StatefulBuilder(
                        builder:
                            (BuildContext context, StateSetter setModalState) {
                          return SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: getLngList(context, setModalState)),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(onPressed: (){
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>SignInScreen()));
                            },style: ElevatedButton.styleFrom(backgroundColor:Color(0xFF3700b3) ), child:Icon(Icons.arrow_forward))),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
  Widget getHeading(String title) {
    print("here is title value ${title}");
    return Text(
      getTranslated(context, title).toString(),
      style: Theme.of(context).textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black),
    );
  }
  Widget bottomSheetHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.black),
        height: 5,
        width: MediaQuery.of(context).size.width * 0.3,
      ),
    );
  }

  Widget bottomsheetLabel(String labelName) => Padding(
    padding: const EdgeInsets.only(top: 30.0, bottom: 20),
    child: getHeading(labelName),
  );
  List<String> langCode = ["en", "hi"];
  List<String?> languageList = [];
  List<Widget> getLngList(BuildContext ctx, StateSetter setModalState) {
    return languageList
        .asMap()
        .map(
          (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              if (mounted)
                setState(() {
                  selectLan = index;
                  _changeLan(langCode[index], ctx);
                });
              setModalState((){});
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 25.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectLan == index
                                ? Colors.grey
                                : Colors.white,
                            border: Border.all(color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: selectLan == index
                              ? Icon(
                            Icons.check,
                            size: 17.0,
                            color: Colors.black,
                          )
                              : Icon(
                              Icons.check_box_outline_blank,
                              size: 15.0,
                              color:Colors.white
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 15.0,
                          ),
                          child: Text(
                            languageList[index].toString(),
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                color: Colors.black),
                          ))
                    ],
                  ),

                  // index == languageList.length - 1
                  //     ? Container(
                  //         margin: EdgeInsetsDirectional.only(
                  //           bottom: 10,
                  //         ),
                  //       )
                  //     : Divider(
                  //         color: Theme.of(context).colorScheme.lightBlack,
                  //       ),
                ],
              ),
            ),
          )),
    )
        .values
        .toList();
  }

  void _changeLan(String language, BuildContext ctx) async {
    Locale _locale = await setLocale(language);

    MyApp.setLocale(ctx, _locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xFF3700b3),
      //   leading:Icon(Icons.arrow_forward_outlined,color:Color(0xFF3700b3)),
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.only(
      //           bottomLeft: Radius.circular(20),
      //           bottomRight: Radius.circular(20)
      //       )
      //   ),
      //   elevation: 2,
      //   centerTitle: true,
      //  actions: [
      //    Padding(
      //      padding: const EdgeInsets.all(12),
      //      child: RawMaterialButton(
      //        shape: CircleBorder(),
      //        padding: const EdgeInsets.all(0),
      //        fillColor: Colors.white,
      //        splashColor: Colors.grey[400],
      //        child: Icon(
      //          Icons.arrow_forward_outlined,
      //          size: 20,
      //          color: Colors.black,
      //        ),
      //        onPressed: () {
      //          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      //        },
      //      ),
      //    ),
      //  ],
      // ),

      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bacImage.png"),
                  fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>SignInScreen()));
                      },
                      child: Container(
                        height: 30,width: 55,
                        // decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            getTranslated(context, 'skip'),
                            // getTranslated(context, 'CHOOSE_LANGUAGE_LBL'),
                            style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/8.5),
                Text(
                  getTranslated(context, 'chooseLanguage',),
                  // getTranslated(context, 'CHOOSE_LANGUAGE_LBL'),
                  style: Theme.of(context).textTheme.caption!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/2.0),
                InkWell(
                  onTap: (){
                    Future.delayed(Duration(seconds: 0),(){
                      return openChangeLanguageBottomSheet();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 55,
                      child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                        // height: 50,
                        // alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //
                        // ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getTranslated(context, 'changeLanguage'),
                                // getTranslated(context, 'CHOOSE_LANGUAGE_LBL'),
                                style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                    color: Color(0xFF3700b3)
                                ),
                              ),
                              Icon(Icons.arrow_forward, color: Color(0xFF3700b3))
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                ),
              ],
            )
        )

      ),
    );
  }

// _createLanguageDropDown() {
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: Colors.black),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.only(left: 10, right: 10),
//       child: DropdownButton<LanguageModel>(
//         iconSize: 30,
//         underline: SizedBox(),
//         hint: Text(getTranslated(context, 'CHOOSE_LANGUAGE_LBL')),
//         onChanged: (LanguageModel? language) {
//           changeLanguage(context, language!.languageCode);
//         },
//         items: LanguageModel.languageList()
//             .map<DropdownMenuItem<LanguageModel>>(
//               (e) => DropdownMenuItem<LanguageModel>(
//             value: e,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 Text(
//                   e.flag,
//                   style: TextStyle(fontSize: 30),
//                 ),
//                 Text(e.name)
//               ],
//             ),
//           ),
//         )
//             .toList(),
//       ),
//     ),
//   );
// }
}