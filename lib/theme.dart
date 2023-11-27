import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
  static const Color lightBlue = Color(0xff83CCEA);
  static const Color darkGrey = Color(0xff535D74);
  static const Color pink = Color(0xffF2D1BE);
  static const Color lightGrey = Color(0xffABABAB);
  static const Color BackgroundColor=Color(0xFFF1EFF1);
  static const Color white=Colors.white;



}
class TextStyles{
  static  TextStyle heading1 = GoogleFonts.getFont("Almarai",color: CustomColors.darkGrey,fontWeight: FontWeight.w400,fontSize: 30);
  static  TextStyle heading2 = GoogleFonts.getFont("Almarai",color: CustomColors.darkGrey,fontWeight: FontWeight.w400,fontSize: 16);
  static  TextStyle heading3G = GoogleFonts.getFont("Almarai",color: CustomColors.darkGrey,fontWeight: FontWeight.w400,fontSize: 14);
  static  TextStyle text = GoogleFonts.getFont("Almarai",color: CustomColors.lightGrey,fontWeight: FontWeight.w400,fontSize: 12);
  static  TextStyle heading3B = GoogleFonts.getFont("Almarai",color: CustomColors.lightBlue,fontWeight: FontWeight.bold,fontSize: 14);
  static  TextStyle text2 = GoogleFonts.getFont("Almarai",color: CustomColors.darkGrey,fontWeight: FontWeight.w400,fontSize: 12);


}