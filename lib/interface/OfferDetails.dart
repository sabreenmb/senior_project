import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../model/offer_info.dart';
import '../theme.dart';

class OfferDetails extends StatelessWidget {
  OfferInfo offerInfo;
  OfferDetails(this.offerInfo, {super.key});
  String imageURL =
      "https://firebasestorage.googleapis.com/v0/b/senior-project-72daf.appspot.com/o/app_use%2FFITNESS-ZONE.png?alt=media&token=3e01d171-fd56-4ae5-a65e-5a4298b7ab53";
  @override
  Widget build(BuildContext context) {
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
                  decoration: BoxDecoration(
                    color: CustomColors.BackgroundColor,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.network(
                      '${imageURL}',
                      fit: BoxFit.cover,
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
                    margin: EdgeInsets.only(top: 250),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //start the colom
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
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
                          SizedBox(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      " خصم يصل الى : ",
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text4,
                                    ),
                                    Text(
                                      "صلاحية الخصم إلى: ",
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text4,
                                    ),
                                    Text(
                                      " tfhtfhfh خصم يصل الى : ",
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text4,
                                    ),
                                    Text(
                                      " خصم يصل الى : ",
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text4,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offerInfo.discount!,
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text2,
                                    ),
                                    Text(
                                      offerInfo.expDate!,
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text2,
                                    ),
                                    Text(
                                      offerInfo.targetUsers!,
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text2,
                                    ),
                                    Text(
                                      offerInfo.contact!,
                                      textAlign: TextAlign.right,
                                      style: TextStyles.text2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 50, bottom: 50),
                            width: 250,
                            height: 1,
                            color: CustomColors.lightGreyLowTrans,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(
                                      new ClipboardData(text: offerInfo.code!))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('${offerInfo.code} !')));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(175, 50),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(27),
                                ),
                                backgroundColor: CustomColors.lightBlue),
                            child:
                                Text("احصل على الخصم", style: TextStyles.text3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppBar(
                      systemOverlayStyle: const SystemUiOverlayStyle(
                        statusBarColor: CustomColors.darkGrey,
                        statusBarIconBrightness: Brightness.light,
                        statusBarBrightness: Brightness.light,
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: CustomColors.white),
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SearchScreen()));
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 80),
                      width: MediaQuery.of(context).size.width - 100,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0,
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
                                  : Image.network(
                                      '${offerInfo.logo}',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
                height: 170,
                padding: EdgeInsets.all(25),
                margin: EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
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
                        '======== Exception caught by widgets library =======================================================                        The following assertion was thrown while applying parent datacorrect use of ParentDataWidget.The ParentDataWidget Expanded(flex: 1) wants to apply ParentData of type FlexParentData to a RenderObject, which has been set up to accept ParentData of incompatible type BoxParentData.                  Usually,  means that the Expanded widget has the wrong ancestor RenderObjectWidget. Typically, Expanded widgets are placed directly inside Flex widgets.'
                        // ' ${offerInfo.details}',
                       , textAlign: TextAlign.right,
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
}
