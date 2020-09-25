import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohostel_hostel_agent_app/hive_methods/hive_class.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/edit_hostel_details_page.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/methods.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;


class HostelSearchPage extends StatefulWidget {
  @override
  _HostelSearchPageState createState() => _HostelSearchPageState();
}

class _HostelSearchPageState extends State<HostelSearchPage> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<HostelModel> searchList = [];
  String query = '';
  bool isStillLoadingData = false;
  bool moreHostelAvailable = true;
  bool gettingMoreHostels = false;
  bool searchStarted = false;
  HostelModel lastHostel;
  String uniName;

  Future<void> getUniName() async {
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;
  }

  void startSearch({@required String value}) {
    setState(() {
      searchStarted = true;
      isStillLoadingData = true;
    });
    try {
      print(value);
      HostelBookingMethods()
          .fetchHostelByKeyWord(
        keyWord: value,
        uniName: uniName,
      )
          .then((List<HostelModel> list) {
        setState(() {
          if (list.isNotEmpty) {
            if (list.length < 3) {
              moreHostelAvailable = false;
            }
            searchList = list;
            lastHostel = searchList[searchList.length - 1];
            isStillLoadingData = false;
//            searchStarted = false;
          } else {
            searchList = list;
            isStillLoadingData = false;
          }
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      setState(() {
        isStillLoadingData = false;
      });
    }
  }

  void moreSearchOption() {
    print('getting more');
    if (moreHostelAvailable == false) {
      return;
    }

    if (gettingMoreHostels == true) {
      return;
    }

    try {
      gettingMoreHostels = true;
      print('getting more Hostel now');
      HostelBookingMethods()
          .fetchHostelByKeyWordWithPagination(
        keyWord: query,
        lastHostel: lastHostel,
        uniName: uniName,
      )
          .then((List<HostelModel> list) {
        print(list);
        print(list.length);
        setState(() {
          if (list.length < 3) {
            moreHostelAvailable = false;
          }

          searchList.addAll(list);
          lastHostel = searchList[searchList.length - 1];

          gettingMoreHostels = false;
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
    }
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      moreSearchOption();
    }
  }

  @override
  void initState() {
    getUniName();
    scrollController.addListener(() {
      _scrollListener();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            searchBar(),
//            autoSuggest(),
            searchStarted
                ? Expanded(
                    child: isStillLoadingData == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: resultList(),
                          ),
                  )
                : greetingWidget(),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: Styles.boxDec,
      margin: EdgeInsets.all(20.0),
      child: TextField(
        onChanged: (val) {
          query = val;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              startSearch(value: query);
            },
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget notFound() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.local_hotel,
                  color: Colors.grey,
                  size: 85.0,
                ),
                Text(
                  'Sorry No Hostel Was Found With This Location :(',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget resultList() {
    if (searchList.isEmpty || searchList == null) {
      return notFound();
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: searchList.length,
        controller: scrollController,
        itemBuilder: ((context, index) {
          HostelModel currentHostelModel = searchList[index];
          return Card(
            elevation: 2.5,
            child: InkWell(
              onTap: () {
                print(currentHostelModel.id);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditHostelPage(hostelModel: currentHostelModel),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    displayMultiPic(imageList: currentHostelModel.imageUrl),
                    hostelDetails(hostel: currentHostelModel),
                    index == (searchList.length - 1)
                        ? Container(
                            height: 100,
                            child: Center(
                              child: moreHostelAvailable == false
                                  ? Text('No More Hostel Available!!')
                                  : CircularProgressIndicator(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    }
  }

  Widget hostelDetails({@required HostelModel hostel}) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${hostel.hostelName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${hostel.hostelLocation}',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  '#${hostel.price}K',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${hostel.distanceFromSchoolInKm}KM',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300,
        maxWidth: MediaQuery.of(context).size.width * .95,
      ),
      child: Carousel(
        images: imageList.map(
          (images) {
            return Container(
              child: ExtendedImage.network(
                images,
                fit: BoxFit.fill,
                handleLoadingProgress: true,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                cache: false,
                enableMemoryCache: true,
              ),
            );
          },
        ).toList(),
        autoplay: true,
        indicatorBgPadding: 0.0,
        dotPosition: DotPosition.bottomCenter,
        dotSpacing: 15.0,
        dotSize: 4,
        dotIncreaseSize: 2.5,
        dotIncreasedColor: Colors.deepOrange,
        dotBgColor: Colors.transparent,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }

  Widget greetingWidget() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.hotel,
              color: Colors.grey,
              size: 85.0,
            ),
            Text(
              'Search For Hostel By Name',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
