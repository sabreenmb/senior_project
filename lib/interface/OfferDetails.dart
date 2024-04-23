import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../model/offer_info.dart';
import '../common/theme.dart';

class OfferDetails extends StatefulWidget {
  OfferInfo offerInfo;

  OfferDetails(this.offerInfo, {super.key});
  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    OfferInfo offerInfo = widget.offerInfo;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
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
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 670,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      margin: const EdgeInsets.only(top: 200),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
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
                              textAlign: TextAlign.center,
                              style: TextStyles.heading1D,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _buildInfoColumn("خصم يصل الى :",
                                '  ' + offerInfo.discount! + '%'),
                            _buildInfoColumn("صلاحية الخصم إلى  :",
                                '  ' + offerInfo.expDate!),
                            _buildInfoColumn("الفئة المستهدفة  :",
                                ' ' + offerInfo.targetUsers!),
                            _buildInfoColumn(
                                "وسيلة التواصل  :", ' ' + offerInfo.contact!),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      width: 200,
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
                                            borderRadius:
                                                BorderRadius.circular(27),
                                          ),
                                          backgroundColor:
                                              CustomColors.lightBlue),
                                      child: Text("احصل على الخصم",
                                          style: TextStyles.btnText),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                          isClicked ? offerInfo.code! : ' ',
                                          style: TextStyles.heading3B),
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes the position of the shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 95,
                          height: 130,
                          child: offerInfo.logo == "empty"
                              ? Image(
                                  image:
                                      AssetImage('assets/images/logo-icon.png'))
                              : FutureBuilder<void>(
                                  future: precacheImage(
                                    CachedNetworkImageProvider(offerInfo.logo!),
                                    context,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.white,
                                        highlightColor: Colors.grey[300]!,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'Error loading image'); // Handle error loading image
                                    } else {
                                      return CachedNetworkImage(
                                        imageUrl: offerInfo.logo!,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  },
                                ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                  height: 170,
                  padding: const EdgeInsets.all(25),
                  margin: const EdgeInsets.only(top: 40),
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
                          style: TextStyles.text1D,
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    double width = MediaQuery.of(context).size.width / 20;
    print(width);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.text1D,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyles.text1L,
              maxLines: 5,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
