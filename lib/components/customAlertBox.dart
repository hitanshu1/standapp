




import 'package:flutter/material.dart';
import 'package:standapp/utils/textStyles.dart';

class CustomAlertBox extends StatefulWidget{

  List pickerData;
  
  String pickedItems ='';
  List<String> optionsFromInitValue = <String>[];

  CustomAlertBox({this.pickerData,this.optionsFromInitValue});

  @override
  CustomAlertBoxState createState() {
    return new CustomAlertBoxState();
  }
}

class CustomAlertBoxState extends State<CustomAlertBox> {
  List<bool> checkBoxValues = <bool>[];


  @override
  void initState() {
    print("widget.optionsFromInitValue => ${widget.optionsFromInitValue}");


    checkBoxValues.clear();


    for(int i =0; i< widget.pickerData[0]['options'].length;i++){
      checkBoxValues.add(false);
    }

    widget.pickerData[0]['options'].asMap().forEach((index,anOption){
      if( widget.optionsFromInitValue.isNotEmpty){
//      widget.optionsFromInitValue.forEach((initOption){

        if(widget.optionsFromInitValue.contains(anOption['label'])){
          checkBoxValues[index]=true;
        }
//      });
      }
    });

    print("checkBoxValues 0 => ${checkBoxValues}");


//    for(int i =0; i< widget.optionsFromInitValue.length;i++){
//
//      checkBoxValues[widget.pickerData[0]['options']];
//    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.pickerData.isNotEmpty) {
      return AlertDialog(
        title: Text(widget.pickerData[0]['label'],
          style: TextStyle(color: Colors.black54, fontSize: 18),),
        content: SingleChildScrollView(
          child: ListBody(
            children: List<Widget>.generate(
                widget.pickerData[0]['options'].length, (choice) =>
                ListTile(
                  title: Text(widget.pickerData[0]['options'][choice]['label'],
                    textAlign: TextAlign.start,),
                  contentPadding: EdgeInsets.all(2),
                  leading: Checkbox(
                    value: checkBoxValues.isNotEmpty?checkBoxValues[choice]:false,
                    onChanged: (bool value) {
                      print("checkBoxValues 1 => ${checkBoxValues}");

                      setState(() {
                        checkBoxValues[choice] = value;
                      });
                    },
                  ),

//            secondary: const Icon(Icons.hourglass_empty),
                )),
//                    <Widget>[
//                      Text('You will never be satisfied.'),
//                      Text('You\’re like me. I’m never satisfied.'),
//                    ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('CONFIRM'),
            onPressed: () {
              widget.pickedItems = '';
              checkBoxValues.asMap().forEach((index, aChoice) {
                if (aChoice) {
                  if (widget.pickedItems.isNotEmpty) {
                    widget.pickedItems +=
                    ",${widget.pickerData[0]['options'][index]['label']}";
                  } else {
                    widget.pickedItems +=
                    "${widget.pickerData[0]['options'][index]['label']}";
                  }
                }
              });
              print(widget.pickedItems);
              Navigator.of(context).pop(widget.pickedItems);
            },
          ),
        ],
      );
    }else{
      return Container(width: 0,height: 0,);
    }
  }
}