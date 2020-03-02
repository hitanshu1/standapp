import 'package:flutter/material.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/filterCard.dart';
import 'package:standapp/data/scoped_model_filter.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class Filter extends StatefulWidget {
  @override
  FilterState createState() {
    return new FilterState();
  }
}

class FilterState extends State<Filter> {
  List<Map<String, dynamic>> combinedList = <Map<String, dynamic>>[];
//  Map currentSortType = {
////    "sortType": "name",
////    "sortBy": "firstName",
////    "isAsc": true
//  };

//  List<Map<String, dynamic>> sortList = [
//    {
//      "SortBy": "",
//      "cards": [
//        {
//          "icon": "assets/icon_menu_filter_asc.svg",
//          "title": "Sort Ascending",
//          "selected": true,
//        },
//        {
//          "icon": "assets/icon_menu_filter_des.svg",
//          "title": "Sort Descending",
//          "selected": false,
//        },
//      ],
//    },
//  ];
//  List<Map<String, dynamic>> filterList = [
//    {
//      "SortBy": "NAME",
//      "cards": [
//        {
//          "icon": "assets/icon_menu_filter_name.svg",
//          "title": "First Name",
//          "selected": true,
//        },
//        {
//          "icon": "assets/icon_menu_filter_name.svg",
//          "title": "Last Name",
//          "selected": false,
//        },
//      ],
//    },
//    {
//      "SortBy": "COMPANY",
//      "cards": [
//        {
//          "icon": "assets/icon_menu_filter_post.svg",
//          "title": "Present Post",
//          "selected": false,
//        },
//        {
//          "icon": "assets/icon_menu_filter_company.svg",
//          "title": "Company Name",
//          "selected": false,
//        },
//      ],
//    },
//    {
//      "SortBy": "TIME",
//      "cards": [
//        {
//          "icon": "assets/icon_menu_filter_date.svg",
//          "title": "Date",
//          "selected": false,
//        },
//        {
//          "icon": "assets/icon_menu_filter_time.svg",
//          "title": "Time",
//          "selected": false,
//        },
//      ],
//    },
//  ];

  @override
  initState() {
    super.initState();
  }

  _buildFilterSection(index) {
    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 48 * ScreenRatio.heightRatio,
        ),

        sortModel.filterList[index]["SortBy"] != ""
            ? Align(
                child: _buildSortText(index),
                alignment: Alignment.centerLeft,
              )
            : Container(
                width: 0,
                height: 0,
              ),
        _buildFilterCards(sortModel.filterList[index]["cards"], index),

//        SizedBox(
//          height: 12,
//        ),
      ],
    );
  }

  _buildSortText(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, left: 32),
      child: Text(
        "SORT BY " + sortModel.filterList[index]["SortBy"],
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 16 * ScreenRatio.heightRatio,
            color: Color.fromRGBO(144, 142, 144, 1)),
      ),
    );
  }

  _buildFilterCards(List<Map> cards, var sectionIndex) {
    return Column(

      children: cards.map((Map card) {
        return GestureDetector(
          onTap: () {
//            print(sectionIndex);
            sortModel.filterList[sectionIndex]["cards"]
                    [sortModel.filterList[sectionIndex]["cards"].indexOf(card)]
                ["selected"] = true;

            decideSortBy(sectionIndex, card);

            sortModel.filterList.forEach((section) {
              section["cards"].forEach((acard) {
                if (acard["title"] !=
                    sortModel.filterList[sectionIndex]["cards"][sortModel
                        .filterList[sectionIndex]["cards"]
                        .indexOf(card)]["title"]) {
                  acard["selected"] = false;
                }
              });
            });

//            print(filterList);
            setState(() {});
          },
          child: FilterCard(
            selected: card["selected"],
            iconName: card["icon"],
            names: card["title"],
          ),
        );
      }).toList(),
    );
  }

  decideSortBy(sectionIndex, card) {
    switch (sortModel.filterList[sectionIndex]["cards"]
        [sortModel.filterList[sectionIndex]["cards"].indexOf(card)]["title"]) {
      case "First Name":
        {
          sortModel.currentSortType["sortType"] = "name";
          sortModel.currentSortType["sortBy"] = "firstName";
        }
        break;
      case "Last Name":
        {
          sortModel.currentSortType["sortType"] = "name";
          sortModel.currentSortType["sortBy"] = "lastName";
        }
        break;
      case "Present Post":
        {
          sortModel.currentSortType["sortType"] = "name";
          sortModel.currentSortType["sortBy"] = "jobTitle";
        }
        break;
      case "Company Name":
        {
          sortModel.currentSortType["sortType"] = "name";
          sortModel.currentSortType["sortBy"] = "company";
        }
        break;

      case "Date":
        {
          sortModel.currentSortType["sortType"] = "time";
          sortModel.currentSortType["sortBy"] = "date";
        }
        break;
      case "Time":
        {
          sortModel.currentSortType["sortType"] = "time";
          sortModel.currentSortType["sortBy"] = "time";
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        floatingActionButton: CircularButton(
//                          heroTag: "3",
          onPressed: () async {
            print(sortModel.currentSortType);
            await sortModel.populateSortedList(
                sortModel.currentSortType, scanModel.contactList);
            Navigator.of(context).pop();
          },
          backgroundColor: Colors.white,
          icon: 'assets/icon_footer_close.svg',
        ),
        backgroundColor: ColorConstants.backgroundColors,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
//                print(index);
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 42 * ScreenRatio.heightRatio,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text(
                            "Filter",
                            style: TextStyles.textStyle32Primary,
                            maxLines: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: GestureDetector(
                            child: FilterCard(
                              selected: sortModel.sortList[0]["cards"][0]
                                  ["selected"],
                              iconName: sortModel.sortList[0]["cards"][0]
                                  ["icon"],
                              names: sortModel.sortList[0]["cards"][0]["title"],
                            ),
                            onTap: () {
                              sortModel.sortList[0]["cards"][0]["selected"] =
                                  true;
                              sortModel.sortList[0]["cards"][1]["selected"] =
                                  false;
                              sortModel.currentSortType["isAsc"] = true;
                              setState(() {});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: GestureDetector(
                            onTap: () {
                              sortModel.sortList[0]["cards"][0]["selected"] =
                                  false;
                              sortModel.sortList[0]["cards"][1]["selected"] =
                                  true;
                              sortModel.currentSortType["isAsc"] = false;

                              setState(() {});
                            },
                            child: FilterCard(
                              selected: sortModel.sortList[0]["cards"][1]
                                  ["selected"],
                              iconName: sortModel.sortList[0]["cards"][1]
                                  ["icon"],
                              names: sortModel.sortList[0]["cards"][1]["title"],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return _buildFilterSection(index - 1);
                  }
                },
                childCount: sortModel.filterList.length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
