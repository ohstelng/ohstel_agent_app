import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/methods.dart';
import 'package:ohostel_hostel_agent_app/hostel_booking/model/hostel_model.dart';
import 'package:ohostel_hostel_agent_app/widgets/custom_button.dart';
import 'package:ohostel_hostel_agent_app/widgets/styles.dart' as Styles;

class EditHostelPage extends StatefulWidget {
  final HostelModel hostelModel;

  EditHostelPage({
    @required this.hostelModel,
  });

  @override
  _EditHostelPageState createState() => _EditHostelPageState();
}

class _EditHostelPageState extends State<EditHostelPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController hostelNameTextEditingController =
      TextEditingController();
  TextEditingController hostelPriceTextEditingController =
      TextEditingController();
  TextEditingController roommateNeededTextEditingController =
      TextEditingController();
  int _current = 0;
  String hostelName;
  String hostelPrice;
  bool roommateNeeded;
  bool loading;

  Future<void> save() async {
    //TODO: implement login in first
    //TODO: implement login in first
    //TODO: implement login in first

    if (formKey.currentState.validate() && roommateNeeded != null) {
      formKey.currentState.save();

      print(hostelName);
      print(hostelPrice);
      print(roommateNeeded);

      await HostelBookingMethods()
          .updateHostelDetails(
        id: widget.hostelModel.id,
        hostelName: hostelName,
        hostelPrice: int.parse(hostelPrice),
        roommateNeeded: roommateNeeded,
      )
          .whenComplete(() {
        Navigator.pop(context);
      });
    }
  }

  void delete() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Are Ypu Sure You Want To Delete This!!??'),
            title: Text('Warning!'),
            actions: [
              FlatButton(
                onPressed: () {
                  HostelBookingMethods()
                      .deleteHostelDetails(id: widget.hostelModel.id)
                      .whenComplete(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
                child: Text('Yes'),
                color: Styles.themePrimary,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
                color: Colors.grey,
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    hostelNameTextEditingController.text = widget.hostelModel.hostelName;
    hostelPriceTextEditingController.text = widget.hostelModel.price.toString();
    roommateNeeded = widget.hostelModel.isRoomMateNeeded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            body(),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              child: TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Hotel Name Can\'t Be Empty';
                  } else if (value.trim().length < 3) {
                    return 'Hotel Name Must Be More Than 2 Characters';
                  } else {
                    return null;
                  }
                },
                controller: hostelNameTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Hotel Name',
                ),
                onSaved: (value) => hostelName = value.trim(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            Container(
              child: TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Hotel Price Can\'t Be Empty';
                  } else if (value.trim().length < 3) {
                    return 'Hotel Price Must Be More Than 2 Characters';
                  } else {
                    return null;
                  }
                },
                controller: hostelPriceTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Hotel Price',
                ),
                onSaved: (value) => hostelPrice = value.trim(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Need RoomMate'),
                Checkbox(
                  value: roommateNeeded,
                  onChanged: (bool value) {
                    print(value);
                    setState(() {
                      switch ('Need RoomMate') {
                        case "Need RoomMate":
                          roommateNeeded = value;
//                  isRoomMateNeeded = value;
                          break;
//                    case "InSide Campus?":
//                      isSchoolHostel = value;
//                      break;
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 60),
            LongButton(
              color: Styles.themePrimary,
              label: 'Submit',
              onPressed: () {
                save();
              },
              labelColor: Colors.white,
            ),
            SizedBox(height: 20),
            LongButton(
              onPressed: () {
                delete();
              },
              label: 'Delete',
              color: Colors.red[700],
              border: true,
              borderColor: Styles.themePrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(children: [
            displayMultiPic(imageList: widget.hostelModel.imageUrl),
            Positioned(
                top: 0.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.grey[900].withOpacity(0.9),
                        Colors.grey[800].withOpacity(0.9),
                        Colors.grey[800].withOpacity(0.9),
                        Colors.grey[800].withOpacity(0.7),
                        Colors.grey[800].withOpacity(0.6),
                        Colors.grey[800].withOpacity(0.2),
                        Colors.transparent
                      ])),
                )),
            Container(
              padding: EdgeInsets.only(right: 10, top: 10, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Hostel Details',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            )
          ]),
          hostelDetails(),
          footer(),
        ],
      ),
    );
  }

  Widget hostelDetails() {
    TextStyle _titlestyle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    return DefaultTabController(
      length: 2,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.36,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '${widget.hostelModel.hostelName}',
                  style: _titlestyle,
                ),
                Spacer(),
                Text(
                  '₦${(widget.hostelModel.price)}',
                  style: _titlestyle,
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Text('${widget.hostelModel.hostelLocation}'),
                Spacer(),
                Text(widget.hostelModel.isSchoolHostel
                    ? 'Roommate Needed'
                    : 'Roomate not Needed')
              ],
            ),
            SizedBox(height: 8),
            Row(children: <Widget>[
              Icon(
                Icons.location_on,
                size: 16,
              ),
              Text(
                  '${widget.hostelModel.distanceFromSchoolInKm.toLowerCase().contains('km') ? widget.hostelModel.distanceFromSchoolInKm + ' from Unilorin' : widget.hostelModel.distanceFromSchoolInKm + 'KM from Unilorin'}'),
              Spacer(),
              Text("12/12/2020")
            ]),
            SizedBox(height: 16),
            Container(
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Details',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                      child: Text(
                    'Reviews',
                    style: TextStyle(color: Colors.black),
                  ))
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.13,
                child: TabBarView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Text('${widget.hostelModel.description}')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Text(
                              'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat')),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    List imgs = imageList.map(
      (images) {
        return Container(
          child: ExtendedImage.network(
            images,
            fit: BoxFit.fill,
            handleLoadingProgress: true,
            shape: BoxShape.rectangle,
            cache: false,
            enableMemoryCache: true,
          ),
        );
      },
    ).toList();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.474,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: CarouselSlider(
              items: imgs,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                height: 310.0,
                aspectRatio: 2.0,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          SizedBox(height: 8),
//          Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: map<Widget>(imageList, (index, url) {
//                return Container(
//                  width: 8.0,
//                  height: 8.0,
//                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                  decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: _current == index ? Colors.grey : Colors.black),
//                );
//              }).toList())
        ],
      ),
    );
  }
}
