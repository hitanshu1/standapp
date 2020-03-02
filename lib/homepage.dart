
//            onPressed: () async{
//
////              //check event key
//////              var res= await Api().getRequest(config["BASE_URL"]+"api/v2/register-stand-app","BBB8-DC21");
////
////            //get newToken for an owner
////              var res= await Api().postRequest(url:config["BASE_URL"]+"api/v2/register-stand-app", eventKey: "BBB8-DC21", body: utf8.encode(json.encode({"ownersName":"Roger Smith"})));
////
////              var ress=json.decode(res);
////              print("rres: ${ress["newToken"]}");
////
////
//////              //get contact details from barcode
//////              var contactDetails= await Api().postRequest(url:ress["conversationsLink"], eventKey:ress["newToken"], body: utf8.encode(json.encode([{"barCode":"107430744"}])));
//////              print("contactDetails: ${contactDetails}");
//
