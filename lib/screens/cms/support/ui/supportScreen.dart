
import 'package:flutter/material.dart';
import 'package:gorabbit_driver/Utils/app_colors.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/screenSizeHelper.dart';


class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {


  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        "question": "How do I contact customer support?",
        "answer":
        "You can contact customer support through the chat feature in our app.",
      },
      {
        "question": "Where can I submit feedback about the app?",
        "answer":
        "You can submit feedback through the app settings or by emailing support.",
      },
      {
        "question": "How do I rate the app on the App Store or Google Play?",
        "answer":
        "You can rate the app by visiting the App Store or Google Play and leaving a review.",
      },
      {
        "question": "Is there a community forum for users?",
        "answer":
        "Yes, we have a community forum available in the app where users can discuss issues.",
      },
      {
        "question": "Why am I not receiving notifications?",
        "answer":
        "Make sure notifications are enabled in your phone's settings and in the app.",
      },
    ];

    return Scaffold(
      backgroundColor: ColorResource.whiteColor,
      appBar: CustomAppBar(title: "Support"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 14),
        child: Column(
          children: [
            Text('Tell us how we can help',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
            SizedBox(height:10,),
            Text('Our experts of superheroes are standing by for services & support!',textAlign: TextAlign.center,style: TextStyle(color: ColorResource.greyColor),),
            SizedBox(height:10,), Container(
              width: context.screenWidth ,
              height: 45,
             // padding: EdgeInsets.symmetric(horizontal: 12),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: ColorResource.whiteColor,
                shadows: [
                  BoxShadow(
                    color: Color(0x7F95AF28),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: TextFormField(
                cursorColor: ColorResource.primaryColor,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: faqList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildFAQTile(
                 index:    index + 1,
               question:  faqList[index]["question"]!,
                answer:     faqList[index]["answer"]!,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFAQTile({
  required  int index,required String question, required String answer
}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          "$index. $question",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
