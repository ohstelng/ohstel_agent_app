import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/fast_food_details_model.dart';
import 'package:ohostel_hostel_agent_app/food/pages/selected_fast_food_page.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FastFoodListPage extends StatefulWidget {
  @override
  _FastFoodListPageState createState() => _FastFoodListPageState();
}

class _FastFoodListPageState extends State<FastFoodListPage> {
  bool loading = false;

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      loading = true;
    });

    await Future.delayed(Duration(milliseconds: 200));

    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  void deleteFastFoodPopUP({@required String id}) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(
            'Are You Sure You Want To Delete This Fast Food?. \n This Action Can Not Be Undone...',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              color: Colors.red,
              onPressed: () async {
                await FoodMethods().deleteFastFood(documentId: id);
                Navigator.pop(context);
                refresh();
              },
            ),
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.grey,
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : PaginateFirestore(
                itemsPerPage: 5,
                bottomLoader: Center(child: CircularProgressIndicator()),
                itemBuilderType: PaginateBuilderType.listView,
                query: FoodMethods().foodCollectionRef.orderBy('fastFood'),
                itemBuilder: (_, context, DocumentSnapshot snap) {
                  FastFoodModel currentFastFood =
                      FastFoodModel.fromMap(snap.data);

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SelectedFastFoodPage(
                            foodModel: currentFastFood,
                            refresh: refresh,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      child: Card(
                        color: Color(0xFFF4F5F6),
                        elevation: 1,
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              height: 150,
                              width: 150,
                              child: currentFastFood.logoImageUrl != null
                                  ? ExtendedImage.network(
                                      currentFastFood.logoImageUrl,
                                      fit: BoxFit.fill,
                                      handleLoadingProgress: true,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      cache: false,
                                      enableMemoryCache: true,
                                    )
                                  : Center(child: Icon(Icons.image)),
                            ),
                            Expanded(
                              child: Container(
                                height: 120,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${currentFastFood.fastFoodName.trim()}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${currentFastFood.openTime.trim()}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.black45,
                                          size: 14,
                                        ),
                                        Text(
                                          '${currentFastFood.address.trim()}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    FlatButton(
                                      onPressed: () => deleteFastFoodPopUP(
                                        id: currentFastFood.fastFoodName,
                                      ),
                                      child: Text(
                                        'Delete FastFood',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
