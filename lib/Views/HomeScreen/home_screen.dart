import 'package:flutter/material.dart';
import 'package:newspapers/Utils/AppIcon/app_icon.dart';
import 'package:newspapers/Utils/AppImage/app_image.dart';
import 'package:newspapers/Views/Base/AppText/appText.dart';
import 'package:newspapers/Views/Base/CustomTextfield/CustomTextfield.dart';
import 'package:newspapers/utils/AppColor/app_colors.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  TextEditingController searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray0,
      appBar: AppBar(
        backgroundColor: AppColors.gray0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImage.app_logo,height: 50,width: 50,),
            AppText("Newspapers",fontSize: 16,fontWeight: FontWeight.w600,),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [

            CustomTextField(
              borderRadius: 18,
              controller: searchcontroller,
              hintText: "search news",
              borderColor: AppColors.gray500,
              prefixIcon: AppIcons.search,
            ),
          ],
        ),
      ),
    );
  }
}
