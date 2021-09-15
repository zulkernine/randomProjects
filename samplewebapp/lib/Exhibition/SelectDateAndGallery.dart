import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class SelectDateAndGallery extends StatefulWidget {
  const SelectDateAndGallery({Key? key}) : super(key: key);

  @override
  _SelectDateAndGalleryState createState() => _SelectDateAndGalleryState();
}

class _SelectDateAndGalleryState extends State<SelectDateAndGallery> {
  List<int> galleries = [1, 2, 3, 4, 5]; // initialise from api call

  DateTime rangeStartDate = DateTime.now(), rangeEndDate = DateTime.now();
  int selectedGallery = -1;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      setState(() {
        rangeStartDate = args.value.startDate;
        rangeEndDate = args.value.endDate == null ? args.value.startDate : args.value.endDate;
      });
    } else if (args.value is DateTime) {
      print("only date picked");
      setState(() {
        rangeStartDate = args.value;
        rangeEndDate = args.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    bool mobileView = _size.width < 600,
        tabView = _size.width >= 600 && _size.width < 1100,
        desktopView = _size.width >= 1100;

    // if (mobileView)
    //   return Container(
    //     decoration: BoxDecoration(color: Color(0xFFFFF6FC)),
    //     child: Text("Mobile view"),
    //   );
    // else if(tabView)
    //   return Container(
    //     decoration: BoxDecoration(color: Color(0xFFFFF6FC)),
    //     child: Text("Tab view"),
    //   );
    // else
    return Container(
      decoration: BoxDecoration(color: Color(0xFFFFF6FC)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(40),
              margin: EdgeInsets.only(left: 70, top: 30, right: 37, bottom: 26),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: ResponsiveGridRow(
                  children: [
                    ResponsiveGridCol(
                      lg: 12,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Select Gallery",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    for (int i in galleries)
                      ResponsiveGridCol(
                        md: 6,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedGallery = i;
                            });
                          },
                          child: Container(
                            height: 190,
                            margin: EdgeInsets.all(14),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage( i==selectedGallery ? "" : "https://picsum.photos/id/155/400/400"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10)),
                              color: Color(0xFFBC7ACD),
                            ),
                            child: Center(
                                child: Text(
                              "Pegusus Galery",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(40),
              margin: EdgeInsets.only(top: 30, right: 37, bottom: 26),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Select Duration",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    cellBuilder: (BuildContext context,
                        DateRangePickerCellDetails cellDetails) {
                      return Container(
                        width: cellDetails.bounds.width,
                        height: cellDetails.bounds.height,
                        alignment: Alignment.center,
                        child: Text(cellDetails.date.day.toString()),
                      );
                    },
                    enableMultiView: true,
                    initialSelectedRange: PickerDateRange(
                        rangeStartDate,
                        rangeEndDate),
                  ),
                  Text(
                    "Your Chosen Gallery And Date",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Pegasus Gallery - ${DateFormat("E d MMM").format(rangeStartDate)} - ${DateFormat("E d MMM").format(rangeEndDate)}",
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
