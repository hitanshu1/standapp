import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/intermediateService.dart';

class SortModel extends Model {
  List<Scan> sortedByXList = <Scan>[];

  Map currentSortType = {"sortType": "name", "sortBy": "fullName","isAsc":true};

  Map<String, List<Scan>> genericMappedData =
      new Map<String, List<Scan>>();
  List<String> genericMapKeyList = <String>[];

  Map<String, List<Scan>> mappedListDataOfAllContacts =
      new Map<String, List<Scan>>();
  List<String> sortedMapKeyListOfAllContacts = <String>[];

  Map<String, List<Scan>> searchResultMappedData =
      new Map<String, List<Scan>>();
  List<String> searchSortedMapKeyList = <String>[];

  bool searchMode = false;
  bool searching = false;


  Map searchResultFound ={"found":false,"searchText":"","numResults":0};


  clear(){
    mappedListDataOfAllContacts.clear();
    genericMapKeyList.clear();
    genericMappedData.clear();
    currentSortType.clear();
    sortedByXList.clear();
    searchSortedMapKeyList.clear();
    searchResultMappedData.clear();
    sortedMapKeyListOfAllContacts.clear();

    searchMode = false;
    searching = false;

  }

  List<Map<String, dynamic>> sortList = [
    {
      "SortBy": "",
      "cards": [
        {
          "icon": "assets/icon_menu_filter_asc.svg",
          "title": "Sort Ascending",
          "selected": true,
        },
        {
          "icon": "assets/icon_menu_filter_des.svg",
          "title": "Sort Descending",
          "selected": false,
        },
      ],
    },
  ];
  List<Map<String, dynamic>> filterList = [
    {
      "SortBy": "NAME",
      "cards": [
        {
          "icon": "assets/icon_menu_filter_name.svg",
          "title": "First Name",
          "selected": true,
        },
        {
          "icon": "assets/icon_menu_filter_name.svg",
          "title": "Last Name",
          "selected": false,
        },
      ],
    },
    {
      "SortBy": "COMPANY",
      "cards": [
        {
          "icon": "assets/icon_menu_filter_post.svg",
          "title": "Present Post",
          "selected": false,
        },
        {
          "icon": "assets/icon_menu_filter_company.svg",
          "title": "Company Name",
          "selected": false,
        },
      ],
    },
    {
      "SortBy": "TIME",
      "cards": [
        {
          "icon": "assets/icon_menu_filter_date.svg",
          "title": "Date",
          "selected": false,
        },
        {
          "icon": "assets/icon_menu_filter_time.svg",
          "title": "Time",
          "selected": false,
        },
      ],
    },
  ];



  populateSortedList(Map currentSortType, listToSortFrom) {

    genericMapKeyList.clear();
    genericMappedData.clear();
    mappedListDataOfAllContacts.clear();
    sortedMapKeyListOfAllContacts.clear();

//    print("listToSortFrom => ${listToSortFrom}");
    this.currentSortType = currentSortType;
    print("currentSortType => ${currentSortType}");

    if (currentSortType["sortType"] == "name") {

//      if(currentSortType["sortBy"]=="firstName"||currentSortType["sortBy"]=="lastName"){
//        sortBy = "fullName";
//      }else{
//        sortBy = currentSortType["sortBy"];
//      }
      for (var element in listToSortFrom) {
        String sortBy = " ";
        Map mappedElement = element.toJson();

        if(currentSortType["sortBy"] == "firstName"){

          sortBy = mappedElement["_embed"]["visitor"]["fullName"].split(" ")[0];
        }else if(currentSortType["sortBy"] == "lastName"){
          sortBy = mappedElement["_embed"]["visitor"]["fullName"].split(" ")[1];
        }else if(currentSortType["sortBy"] == "jobTitle"){
          print(mappedElement["_embed"]["visitor"][currentSortType["sortBy"]]);
          sortBy = mappedElement["_embed"]["visitor"][currentSortType["sortBy"]]??"Job Title";
        }else if(currentSortType["sortBy"] == "company"){
          print(mappedElement["_embed"]["visitor"][currentSortType["sortBy"]]);
          sortBy = mappedElement["_embed"]["visitor"][currentSortType["sortBy"]]??"Company Name";
        }
        var list = mappedListDataOfAllContacts.putIfAbsent(
            sortBy[0].toUpperCase(),
            () => []);
        list.add(element);
      }
//      sortedMapKeyListOfAllContacts = mappedListDataOfAllContacts.keys.toList()
//        ..sort((a, b) => a.compareTo(b));
    }else {
      if (currentSortType["sortType"] == "time") {
        if (currentSortType["sortBy"] == "date") {
          for (var element in listToSortFrom) {
            Map mappedElement = element.toJson();
            DateTime date = DateTime.parse(mappedElement["conversationAt"]);
            print("date => ${ date.day}");
            var list = mappedListDataOfAllContacts.putIfAbsent(
                DateTime.utc(date.year, date.month, date.day).toString(),
                    () => []);
            list.add(element);
          }
        } else {
          for (var element in listToSortFrom) {
            Map mappedElement = element.toJson();
            DateTime date = DateTime.parse(mappedElement["conversationAt"]);
            print("date => ${ date.day}");
            var list = mappedListDataOfAllContacts.putIfAbsent(
                DateTime.utc(date.year, date.month, date.day).toString(),
                    () => []);
            list.add(element);
            list.sort((a, b) => a.conversationAt.compareTo(b.conversationAt));
            list = currentSortType["isAsc"] ? list : list.reversed.toList();
          }
        }
      }
    }
    sortedMapKeyListOfAllContacts =
    mappedListDataOfAllContacts.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    print("mappedListDataOfAllContacts => ${mappedListDataOfAllContacts}");

    genericMapKeyList.addAll(currentSortType["isAsc"]?sortedMapKeyListOfAllContacts:sortedMapKeyListOfAllContacts.reversed);
    genericMappedData.addAll(mappedListDataOfAllContacts);




    notifyListeners();
//    return {"sortedMapKeyListFromModel":sortedMapKeyListFromModel,"mappedListData":mappedListData};
  }

  switchToAllScans() {
    print("switchToAllScans");
    genericMapKeyList.clear();
    genericMappedData.clear();
    genericMapKeyList.addAll(currentSortType["isAsc"]?sortedMapKeyListOfAllContacts:sortedMapKeyListOfAllContacts.reversed);
    genericMappedData.addAll(mappedListDataOfAllContacts);
    searchMode = false;
    searching = false;
    notifyListeners();
  }

  switchToSearchScans() {
    print("switchToSearchScans");

//    setState(() {
    searching = true;
    searchMode = true;

//    });
    notifyListeners();
  }

  search(String searchText) {
    searchResultMappedData.clear();
    searchSortedMapKeyList.clear();
    List<Scan> firstAlphaList = <Scan>[];
    searchResultFound = {"found":false,"searchText":"","numResults":0};

    firstAlphaList
        .addAll(mappedListDataOfAllContacts[searchText[0].toUpperCase()]);

    //search based on first name & last name
    firstAlphaList.forEach((contact) {
      if (contact.eEmbed.visitor.fullName.split(" ")[0].toLowerCase().contains(searchText.toLowerCase()) ||
          contact.eEmbed.visitor.fullName.split(" ")[1].toLowerCase().contains(searchText.toLowerCase())) {
        searchResultMappedData.putIfAbsent(
            searchText[0].toUpperCase(), () => []);
        searchResultMappedData[searchText[0].toUpperCase()].add(contact);

//        print(
//            "searchResultFound => ${searchResultFound}");
        searchResultFound = {"found":true,"searchText":searchText,"numResults":1};
      }
    });
    print(
        "searchResultFound => ${searchResultFound}");
    if(searchResultFound["numResults"]!=0){
      searchResultFound["numResults"]=searchResultMappedData[searchText[0].toUpperCase()].length;
    }else{
      searchResultFound = {"found":false,"searchText":"","numResults":0};
    }


//    print("searchResultMappedData => ${searchResultMappedData}");

    //sort based on letter
    searchSortedMapKeyList = searchResultMappedData.keys.toList()
      ..sort((a, b) => a.compareTo(b));

//    print("searchSortedMapKeyList => ${searchSortedMapKeyList}");

    genericMapKeyList.clear();
    genericMappedData.clear();

//    setState(() {
    genericMapKeyList.addAll(currentSortType["isAsc"]?searchSortedMapKeyList:searchSortedMapKeyList.reversed);
    genericMappedData.addAll(searchResultMappedData);
    searchMode = false;
//    });
    notifyListeners();
  }

  clearList() {
    genericMappedData.clear();
    genericMapKeyList.clear();
    notifyListeners();
  }

  SortModel() {
    populateSortedList(
        {"sortType": "name", "sortBy": "firstName","isAsc":true}, scanModel.contactList);
  }



}

SortModel sortModel = new SortModel();
