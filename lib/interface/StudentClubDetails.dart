import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/SClubInfo.dart';
import '../theme.dart';

class ClubDetails extends StatefulWidget {
  SClubInfo clubDetails;
  ClubDetails(this.clubDetails, {super.key});
  @override
  State<ClubDetails> createState() => _ClubDetailsState();
}

class _ClubDetailsState extends State<ClubDetails> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    SClubInfo clubDetails = widget.clubDetails;
    // TODO: implement build
    return Scaffold(
      backgroundColor: CustomColors.BackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
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
                            clubDetails.name!,
                            textAlign: TextAlign.right,
                            style: TextStyles.heading1D,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          // _buildInfoColumn(
                          //     "خصم يصل الى : ", offerInfo.discount!),
                          // _buildInfoColumn(
                          //     "صلاحية الخصم إلى: ", offerInfo.expDate!),
                          // _buildInfoColumn("الفئة المستهدفة : ",
                          //     offerInfo.targetUsers!),
                          // _buildInfoColumn(
                          //     "وسيلة التواصل : ", offerInfo.contact!),

                          // if (isClicked)
                          //   Padding(
                          //     padding: const EdgeInsets.all(5.0),
                          //     child: Text(offerInfo.code!,
                          //         style: TextStyles.heading3B),
                          //   )
                        ],
                      ),
                    ),
                  ),
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //
                //   ],
                // ),
                Positioned(
                  top: 180,
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
                      child:Padding(padding: const EdgeInsets.all(8),
                      child: clubDetails.logo == "empty"
                          ? const Image(image: AssetImage('assets/images/mug.png'))
                          : Image.network(
                        '${clubDetails.logo}',
                        fit: BoxFit.contain,
                      ),)
                      // child: details['icon'] == "empty"
                      //     ? const Image(
                      //         image: AssetImage('assets/images/mug.png'))
                      //     : Image(
                      //         image: AssetImage('${details['icon']}'),
                      //       ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("led");
                      print(clubDetails.membersLink);
                      if (!isClicked) {
                        setState(() {
                          isClicked = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(170, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      backgroundColor: CustomColors.lightBlue,
                    ),
                    child: Text("انضم للأعضاء", style: TextStyles.text3),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!isClicked) {
                        setState(() {
                          isClicked = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(170, 50),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      backgroundColor: CustomColors.lightBlue,
                    ),
                    child: Text("انضم للإدارة", style: TextStyles.text3),
                  ),
                ],
              ),
            ),
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
        padding: EdgeInsets.symmetric(horizontal: width),
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
