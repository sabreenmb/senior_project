import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/offer_info.dart';
import '../theme.dart';

class OfferDetails extends StatefulWidget {
  OfferInfo offerInfo;

  OfferDetails(this.offerInfo, {super.key});
  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  String imageURL =
      "https://firebasestorage.googleapis.com/v0/b/senior-project-72daf.appspot.com/o/app_use%2Ftile_background.png?alt=media&token=db53f43f-268e-4877-a5b2-be156851f822";
  // "https://firebasestorage.googleapis.com/v0/b/senior-project-72daf.appspot.com/o/app_use%2FFITNESS-ZONE.png?alt=media&token=3e01d171-fd56-4ae5-a65e-5a4298b7ab53";
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    OfferInfo offerInfo = widget.offerInfo;
    // TODO: implement build
    return Scaffold(
      backgroundColor: CustomColors.BackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: CustomColors.darkGrey,
                  ),
                ),
                Positioned(
                  child: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                      statusBarBrightness: Brightness.light,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: CustomColors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SearchScreen()));
                      },
                    ),
                  ),
                ),

                SizedBox(
                  height: 700,
                  width: MediaQuery.of(context).size.width - 50,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    margin: const EdgeInsets.only(top: 250),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            offerInfo.name!,
                            textAlign: TextAlign.right,
                            style: TextStyles.heading1D,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          _buildInfoColumn(
                              "خصم يصل الى : ", offerInfo.discount!),
                          _buildInfoColumn(
                              "صلاحية الخصم إلى: ", offerInfo.expDate!),
                          _buildInfoColumn("الفئة المستهدفة : ",
                              offerInfo.targetUsers!),
                          _buildInfoColumn(
                              "وسيلة التواصل : ", offerInfo.contact!),
                          Container(
                            margin: const EdgeInsets.only(top: 25, bottom: 25),
                            width: 250,
                            height: 1,
                            color: CustomColors.lightGreyLowTrans,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (!isClicked) {
                                setState(() {
                                  // searchList = getValidCertificates();
                                  isClicked = true;
                                });
                              }

                              // Clipboard.setData(
                              //         new ClipboardData(text: offerInfo.code!))
                              //     .then((_) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       SnackBar(
                              //           content: Text('${offerInfo.code} !')));
                              // });
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(170, 40),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27),
                                ),
                                backgroundColor: CustomColors.lightBlue),
                            child: Text("احصل على الخصم",
                                style: TextStyles.text3),
                          ),
                          if (isClicked)
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(offerInfo.code!,
                                  style: TextStyles.heading3B),
                            )
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top:180,
                  child:  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0,
                              3), // changes the position of the shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: offerInfo.logo == "empty"
                            ? const Image(
                            image:
                            AssetImage('assets/images/mug.png'))
                            :Image.network(
                        '${offerInfo.logo}',
                          fit: BoxFit.cover,
                        ),
                    ),
                  ),

                )

              ],
            ),
            Container(
                height: 170,
                padding: const EdgeInsets.all(25),
                margin: const EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          width: 2, color: CustomColors.lightGreyLowTrans)),
                  color: Colors.white,
                ),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    children: [
                      Text(
                        'تفاصيل الخصم :  \n',
                        textAlign: TextAlign.right,
                        style: TextStyles.heading3B,
                      ),
                      Text(
                        ' ${offerInfo.details}',
                        textAlign: TextAlign.right,
                        style: TextStyles.text2,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    double width = MediaQuery.of(context).size.width / 10;
print(width);
    return Expanded(

      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyles.text2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyles.text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
