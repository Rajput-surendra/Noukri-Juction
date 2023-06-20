import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:job_dekho_app/Model/AddJobDataModel.dart';
import 'package:job_dekho_app/Services/api_path.dart';
import 'package:job_dekho_app/Services/globle.dart';
import 'package:job_dekho_app/Services/tokenString.dart';
import 'package:job_dekho_app/Utils/CustomWidgets/customButton.dart';
import 'package:job_dekho_app/Views/Recruiter/recruiterdrawer_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utils/style.dart';

class AddJob extends StatefulWidget {
  const AddJob({Key? key}) : super(key: key);

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {

  String? jobType,selectedDesignation,qualification,passingYear,experience,jobRoles,minSalary,maxSalary,vaccancy,specialization,location;

   TextEditingController minController  =  TextEditingController();
   TextEditingController maxController = TextEditingController();
  TextEditingController jobRoleController = TextEditingController();
  TextEditingController descriptionController  = TextEditingController();
 // TextEditingController vaccancyNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? lastDateApply;
  int selectedIndex = 1;

    AddJobDataModel? addJobDataModel;
  addJobDataFunction()async{
    var headers = {
      'Cookie': 'ci_session=b54ea4dc21bb9562023ebd8c74e28340f129a573'
    };
    var request = http.Request('GET', Uri.parse('${ApiPath.baseUrl}job_post_lists'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = AddJobDataModel.fromJson(json.decode(finalResponse));
      setState(() {
        addJobDataModel = jsonResponse;
      });
      print("final data here ${addJobDataModel!.data!.jobRoles![0].name}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  List<String> hiringList = [];


  postJob()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    String hiringData = hiringList.join(",");

    var headers = {
      'Cookie': 'ci_session=c5efed1303ab938120bcaa43daf60f005db47cbb'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}add_job'));
    request.fields.addAll({
      'user_id': '$userid',
      'job_type': '$jobType',
      'designation': '$selectedDesignation',
      'qualification': '$qualification',
      'passing_year': '$passingYear',
      'experience': '$experience',
      'salary_range':  selectedIndex == 1 ? 'monthly' :'yearly',
      'min': minController.text,
      'max': maxController.text,
      'no_of_vaccancies': '${vaccancy.toString()}',
      'job_role': '$jobRoles',
      'end_date': '$lastDateApply',
      'hiring_process': '$hiringData',
      'specialization': '$specialization',
      'location': location.toString(),
      'description': descriptionController.text
    });
    print("paras are here ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("final response here ${jsonResponse}");
      if(jsonResponse['status'] == "true"){
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        Navigator.pop(context,true);
      }
      setState(() {
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }



  List<String> minSalaryListMonthly = [
    "10",
    "15",
    "20",
    "25",
    "35",
    "40"
  ];
  List<String> maxSalaryListMonthly = [
    "15",
    "20",
    "25",
    "30",
    "40",
  ];
  List locationList = [];
  List<String> maxSalaryListYearLy = [
    "2",
    "5",
    "10",
    "15",
    "20"
  ];
  List<String> minSalaryListYearLy = [
    "2",
    "5",
    "10",
    "15",
    "20"
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      return addJobDataFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
             // Get.to(DrawerScreen());
            },
            child:  Icon(Icons.arrow_back_ios, color: whiteColor, size: 20),
          ),
          elevation: 0,
          backgroundColor: primaryColor,
          title: Text("${getTranslated(context, 'Post_job')}"),
          centerTitle: true,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(90)),
                color: Colors.white
            ),
            alignment: Alignment.center,
            width: size.width,
            height: size.height,
            child: addJobDataModel == null ? Center(
              child: CircularProgressIndicator(color: primaryColor,),
            ) : ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                /// job type
                Text("Job Type",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: jobType,
                  hint: Text("Job Type"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.jobTypes!.map((items) {
                    return DropdownMenuItem(
                      value: items.name.toString(),
                      child: Text(items.name.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      jobType = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10,),
                /// designation type
                Text("Designation",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: selectedDesignation,
                  hint: Text("Designation"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.designations!.map(( items) {
                    return DropdownMenuItem(
                      value: items.name.toString(),
                      child: Text(items.name.toString()),
                    );
                  }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDesignation = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10,),
                /// Qualification
                Text("Qualification",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: qualification,
                  hint: Text("Qualification"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.qualifications!.map((items) {
                    return DropdownMenuItem(
                      value: items.name.toString(),
                      child: Text(items.name.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      qualification = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10,),
                /// Location
                Text("Location",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: location,
                  hint: Text("Location"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.locations!.map((items) {
                    return DropdownMenuItem(
                      value: items.name.toString(),
                      child: Text(items.name.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      location = newValue!;
                    });
                  },
                ),
                // TextFormField(
                //   controller: addressController ,
                //   decoration: InputDecoration(
                //       hintText: "Location",
                //       border: UnderlineInputBorder(
                //         borderSide: BorderSide(color: greyColor1)
                //       )
                //   ),
                // ),
                SizedBox(height: 20,),
                /// passing year
                Text("Passing Year",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: passingYear,
                  hint: Text("Passing year"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.years!.map((items) {
                    return DropdownMenuItem(
                      value: items.toString(),
                      child: Text(items.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      passingYear = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10,),

                /// Experience section
                Text("Experience",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: experience,
                  hint: Text("Experience"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.experiences!.map(( items) {
                    return DropdownMenuItem(
                      value: items.name
                      .toString(),
                      child: Text(items.name.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      experience = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10,),
                Text("Specialization",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: specialization,
                  hint: Text("Specialization"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.specializations!.map(( items) {
                    return DropdownMenuItem(
                      value: items.name
                          .toString(),
                      child: Text(items.name.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      specialization = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10,),
                /// salary type
                Text("Salary Type",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                SizedBox(height: 20,),

                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          child:
                          Row(
                            children: [
                              Container(
                                height:20,
                                width: 20,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: selectedIndex == 1 ? primaryColor : greyColor1,width: 2)
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: selectedIndex == 1 ? primaryColor : Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text("Monthly",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        child: Container(
                          child:
                          Row(
                            children: [
                              Container(
                                height:20,
                                width: 20,
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(color: selectedIndex == 2 ? primaryColor : greyColor1,width: 2)
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: selectedIndex == 2 ? primaryColor : Colors.transparent,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text("Yearly",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                /// Salary range
                Text("Salary Range",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: minController ,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Min Salary",
                            border: OutlineInputBorder(

                                borderSide: BorderSide(color: greyColor1)
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextFormField(
                        controller: maxController ,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Max Salary",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: greyColor1)
                            )
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child:  selectedIndex == 1 ?   DropdownButton(
                    //     isExpanded: true,
                    //     // Initial Value
                    //     value: minSalary,
                    //     hint: Text("Min Salary"),
                    //     // Down Arrow Icon
                    //     icon: const Icon(Icons.keyboard_arrow_down),
                    //
                    //     // Array list of items
                    //     items: minSalaryListMonthly.map(( items) {
                    //       return DropdownMenuItem(
                    //         value: items
                    //             .toString(),
                    //         child: Text(items.toString()),
                    //       );
                    //     }).toList(),
                    //     // After selecting the desired option,it will
                    //     // change button value to selected value
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         minSalary = newValue!;
                    //       });
                    //     },
                    //   ): DropdownButton(
                    //     isExpanded: true,
                    //     // Initial Value
                    //     value: maxSalary,
                    //     hint: Text("Max Salary"),
                    //     // Down Arrow Icon
                    //     icon: const Icon(Icons.keyboard_arrow_down),
                    //
                    //     // Array list of items
                    //     items:minSalaryListYearLy.map(( items) {
                    //       return DropdownMenuItem(
                    //         value: items
                    //             .toString(),
                    //         child: Text(items.toString()),
                    //       );
                    //     }).toList(),
                    //     // After selecting the desired option,it will
                    //     // change button value to selected value
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         maxSalary = newValue!;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // SizedBox(width: 10,),
                    // Expanded(
                    //   child:   selectedIndex == 2 ? DropdownButton(
                    //     isExpanded: true,
                    //     // Initial Value
                    //     value: minSalary,
                    //     hint: Text("Min Salary"),
                    //     // Down Arrow Icon
                    //     icon: const Icon(Icons.keyboard_arrow_down),
                    //
                    //     // Array list of items
                    //     items: maxSalaryListYearLy.map(( items) {
                    //       return DropdownMenuItem(
                    //         value: items
                    //             .toString(),
                    //         child: Text(items.toString()),
                    //       );
                    //     }).toList(),
                    //     // After selecting the desired option,it will
                    //     // change button value to selected value
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         minSalary = newValue!;
                    //       });
                    //     },
                    //   ) : DropdownButton(
                    //     isExpanded: true,
                    //     // Initial Value
                    //     value: maxSalary,
                    //     hint: Text("Max Salary"),
                    //     // Down Arrow Icon
                    //     icon: const Icon(Icons.keyboard_arrow_down),
                    //
                    //     // Array list of items
                    //     items: maxSalaryListMonthly.map(( items) {
                    //       return DropdownMenuItem(
                    //         value: items
                    //             .toString(),
                    //         child: Text(items.toString()),
                    //       );
                    //     }).toList(),
                    //     // After selecting the desired option,it will
                    //     // change button value to selected value
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         maxSalary = newValue!;
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),

                SizedBox(height: 20,),
                /// No of vaccancies
                Text("No of vacancies",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                // TextFormField(
                //   controller: vaccancyNoController ,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //       hintText: "No of vacancies",
                //       border: UnderlineInputBorder(
                //           borderSide: BorderSide(color: greyColor1)
                //       )
                //   ),
                // ),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: vaccancy,
                  hint: Text("No of vaccancies"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: ['1','2','3','4','5','6','7','8','9','10'].map(( items) {
                    return DropdownMenuItem(
                      value: items
                          .toString(),
                      child: Text(items.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      vaccancy = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20,),
                /// job Role
                Text("Job Role",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                DropdownButton(
                  isExpanded: true,
                  // Initial Value
                  value: jobRoles,
                  hint: Text("Job Role"),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: addJobDataModel!.data!.jobRoles!.map((items) {
                    return DropdownMenuItem(
                      value: items.name.toString(),
                      child: Text(items.name.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      jobRoles = newValue!;
                    });
                  },
                ),
                SizedBox(height: 10,),
                Text("Last date of application",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                SizedBox(height: 15,),
                InkWell(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2100),
                        builder: (context,child){
                          return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(
                            primary: primaryColor,
                          )), child: child!);
                        }
                    );

                    if (pickedDate != null) {
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                      //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        lastDateApply =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: greyColor1))
                    ),
                    child: lastDateApply == null ? Text("Last date",style: TextStyle(color: greyColor1),) : Text("${lastDateApply}",),
                  ),
                ),
                SizedBox(height: 20,),
                /// Hiring Process
                Text("Hiring Process",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              child:
                         InkWell(
                           onTap:(){
                             if(hiringList.contains('Face to Face')){
                               hiringList.remove('Face to Face');
                             }
                             else{
                               hiringList.add('Face to Face');
                             }
                          setState(() {
          
                          });
                           },
                           child:Container(
                             child:
                             Row(
                               children: [
                                 Container(
                                   height:20,
                                   width: 20,
                                   padding: EdgeInsets.all(3),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(100),
                                       border: Border.all(color: hiringList.contains('Face to Face') ? primaryColor : greyColor1,width: 2)
                                   ),
                                   child: Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(100),
                                       color: hiringList.contains('Face to Face') ? primaryColor : Colors.transparent,
                                     ),
                                   ),
                                 ),
                                 SizedBox(width: 10,),
                                 Text("Face to Face",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                               ],
                             ),
                           ),
                           // Row(
                           //     children: [
                           //       Container(
                           //         height: 20,
                           //         width: 20,
                           //         //padding: EdgeInsets.all(3),
                           //         alignment: Alignment.center,
                           //         decoration: BoxDecoration(
                           //             border: Border.all(color: primaryColor)
                           //         ),
                           //         child: hiringList.contains('Face to Face') ? Icon(Icons.check,size: 16,) : SizedBox.shrink(),
                           //       ),
                           //       SizedBox(width: 10,),
                           //       Text("Face to Face"),
                           //     ],
                           // ),
                         ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                if(hiringList.contains('Written-test')){
                                  hiringList.remove('Written-test');
                                }
                                else{
                                  hiringList.add('Written-test');
                                }
                                setState(() {

                                });
                              },
                              child: Container(
                                child:Row(
                                  children: [
                                    Container(
                                      height:20,
                                      width: 20,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          border: Border.all(color: hiringList.contains('Written-test') ? primaryColor : greyColor1,width: 2)
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: hiringList.contains('Written-test') ? primaryColor : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text("Written-test",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Container(
                                //       height: 20,
                                //       width: 20,
                                //     //  padding: EdgeInsets.all(3),
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           border: Border.all(color: primaryColor)
                                //       ),
                                //       child:hiringList.contains('Written-test')  ? Icon(Icons.check,size: 16,) : SizedBox.shrink(),
                                //     ),
                                //     SizedBox(width: 10,),
                                //     Text("Written-test"),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap:(){
                                if(hiringList.contains('HR Round')){
                                  hiringList.remove('HR Round');
                                }
                                else{
                                  hiringList.add('HR Round');
                                }
                                setState(() {
                                });
                              },
                              child: Container(
                                child:Row(
                                  children: [
                                    Container(
                                      height:20,
                                      width: 20,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          border: Border.all(color: hiringList.contains('HR Round') ? primaryColor : greyColor1,width: 2)
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: hiringList.contains('HR Round') ? primaryColor : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text("HR Round",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Container(
                                //       height: 20,
                                //       width: 20,
                                //      // padding: EdgeInsets.all(3),
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           border: Border.all(color: primaryColor)
                                //       ),
                                //       child:hiringList.contains('HR Round') ?  Icon(Icons.check,size: 16,) : SizedBox.shrink(),
                                //     ),
                                //     SizedBox(width: 10,),
                                //     Text("HR Round"),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                if(hiringList.contains('Group Discussion')){
                                  hiringList.remove('Group Discussion');
                                }
                                else{
                                  hiringList.add('Group Discussion');
                                }
                                setState(() {

                                });
                              },
                              child: Container(
                                child:Row(
                                  children: [
                                    Container(
                                      height:20,
                                      width: 20,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          border: Border.all(color: hiringList.contains('Group Discussion') ? primaryColor : greyColor1,width: 2)
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: hiringList.contains('Group Discussion') ? primaryColor : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text("Group Discussion",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Container(
                                //       height: 20,
                                //       width: 20,
                                //      // padding: EdgeInsets.all(3),
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           border: Border.all(color: primaryColor)
                                //       ),
                                //       child: hiringList.contains('Group Discussion') ? Icon(Icons.check,size: 16,) : SizedBox.shrink(),
                                //     ),
                                //     SizedBox(width: 10,),
                                //     Text("Group Discussion"),
                                //   ],
                                // ),
                              ),
                            ),
                          ),
                        ], 
                      ),  
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                /// Job description
                Text("Job Description",style: TextStyle(color: greyColor1,fontSize: 14,fontWeight: FontWeight.w500),),
                SizedBox(height: 10,),
                TextFormField(
                  controller: descriptionController ,
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: "Job description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      )
                  ),
                ),
            SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    postJob();
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                        BorderRadius.circular(6)
                    ),
                    child: Text("${getTranslated(context, 'Post_job')}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 14),),
                  ),
                ),
                SizedBox(height: 20,),

              ],
            )
        ),
      ),
    );
  }
}
