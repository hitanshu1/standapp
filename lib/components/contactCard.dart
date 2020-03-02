import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/main.dart';
import 'package:standapp/utils/allContactsDetails.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';


class ContactCard extends StatefulWidget {
  String name;
  String jobTitle;
  String company;

  bool disabled;


  ContactCard({this.name="", this.disabled = false,this.uploaded = true,this.jobTitle="Job Title",this.company='Konduko'});


  bool uploaded;

  @override
  ContactCardState createState() {
    return new ContactCardState();
  }
}

class ContactCardState extends State<ContactCard>  with SingleTickerProviderStateMixin {
  Animation<double> animation;

  AnimationController animationController;

  @override
  void initState() {

    animationController = new AnimationController(vsync: this,
        duration: new Duration(seconds: 6));

    !widget.uploaded?animationController.repeat():animationController.reset();

    super.initState();
  }

  @override
  void dispose() {
    animationController.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    widget.uploaded?animationController.reset():null;

    return Container(
        //width: 200.0,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.grey[200], blurRadius: 4.0, spreadRadius: 2)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        // height: MediaQuery.of(context).size.height / 2,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RotationTransition(
                  turns: animationController,
                  child:
//                  !prefs.getBool("guest")?
                  new SvgPicture.asset(
                  widget.uploaded?ImageConstants.statusDone:ImageConstants.statusSync,
                    width: 20 * ScreenRatio.widthRatio,
                    height: 20 * ScreenRatio.heightRatio,
          ),
//                      :Container(width: 20 * ScreenRatio.widthRatio,height: 20 * ScreenRatio.heightRatio,),
                ),
              ],
            ),
              Text(widget.name ?? "name",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 18 * ScreenRatio.heightRatio,
                      fontWeight: FontWeight.bold,
                      color: widget.disabled
                          ? ColorConstants.primaryTextColor
                              .withOpacity(0.5)
                          : ColorConstants.primaryTextColor),
                  overflow: TextOverflow.ellipsis),
              SizedBox(
                height: 10,
              ),
              Text(
//                "asdaxczxczqwewqeqweqweqweqweqwewqe",
                widget.jobTitle.isEmpty?"Job Title":widget.jobTitle,
//                maxLines: 2,
                style: TextStyle(
                    fontSize: 12 * ScreenRatio.heightRatio ,
                    color: widget.disabled
                        ? ColorConstants.secondaryTextColor
                            .withOpacity(0.2)
                        : ColorConstants.secondaryTextColor),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
              Expanded(
                child: Text(
//                  "asdasdasdassadasdsadasdasasddasdadasd",
                    widget.company.isEmpty?"Company Name":widget.company,
//                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16 * ScreenRatio.heightRatio ,
                        fontWeight: FontWeight.bold,
                        color: widget.disabled
                            ? ColorConstants.touchableCardTextColor
                                .withOpacity(0.2)
                            : ColorConstants.touchableCardTextColor)),
              )
            ],
          ),
        ));
  }
}


//"{\"alternateEmail\":\"\",\"phoneNumber\":\"\",\"Level of interest?\":\"\",\"Purchasing time frame?\":\"\",\"Purchasing authority\":\"\",\"Assigned budget\":\"\",\"Notes\":\"\",\"What are your favourite cars?\":\"\"}"