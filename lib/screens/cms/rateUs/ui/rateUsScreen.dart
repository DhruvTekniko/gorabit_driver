import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_appBar.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/custom_app_button.dart';
import 'package:gorabbit_driver/Utils/custom_widgets/screenSizeHelper.dart';


class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  var ratingValue = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Rate Us"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            SizedBox(height: 60,),
            RatingBar.builder(
              initialRating: ratingValue,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                ratingValue = rating;
                print(">>>>>>>>>>>>>>>>>>>>>rating is${rating}");
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                height: context.screenHeight * 0.25,
                width: context.screenWidth,
                decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(20),
                    border: Border.all(
                        width: 1.5, color: Colors.grey.withOpacity(0.6))),
                child: TextFormField(
                  maxLines: 100,
                  decoration: InputDecoration(
                      hintText: "Massage", border: InputBorder.none),
                )),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: CustomAppButton(title: "Submit", onPressed: (){}),
      ),
    );
  }
}
