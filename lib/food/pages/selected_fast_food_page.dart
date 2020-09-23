import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ohostel_hostel_agent_app/food/food_methods.dart';
import 'package:ohostel_hostel_agent_app/food/models/fast_food_details_model.dart';
import 'package:ohostel_hostel_agent_app/food/models/food_details_model.dart';

class SelectedFastFoodPage extends StatefulWidget {
  final FastFoodModel foodModel;

  SelectedFastFoodPage({Key key, @required this.foodModel});

  @override
  _SelectedFastFoodPageState createState() => _SelectedFastFoodPageState();
}

class _SelectedFastFoodPageState extends State<SelectedFastFoodPage> {
  Future<void> deleteItemDetails({@required int index}) async {
    print(index);

    List<Map> _itemDetails = [];

    print(widget.foodModel.itemDetails.length);
    for (var i = 0; i < widget.foodModel.itemDetails.length; i++) {
//      print(widget.foodModel.itemDetails[i]);
      Map updateData = widget.foodModel.itemDetails[i];

      if (i == index) {
        continue;
      }

      _itemDetails.add(updateData);
    }

    print(_itemDetails);
    print(_itemDetails.length);

    await FoodMethods()
        .updateItemDetails(
          itemDetails: _itemDetails,
          fastFoodName: widget.foodModel.fastFoodName,
        )
        .whenComplete(() => Navigator.pop(context));
  }

  void deletePopUp({@required int index}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Text('Are You Sure You Want To Proceed'),
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                deleteItemDetails(index: index);
              },
              child: Text('Yes'),
              color: Colors.green,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  void editFoodItem(
      {@required String itemName,
      @required int price,
      @required int index,
      @required ItemDetails item}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: EditFoodItemPage(
              itemLists: widget.foodModel.itemDetails,
              index: index,
              fastFoodName: widget.foodModel.fastFoodName,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.foodModel.itemDetails.length,
          itemBuilder: (context, index) {
            ItemDetails currentItemDetails =
                ItemDetails.formMap(widget.foodModel.itemDetails[index]);

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              child: Card(
                color: Color(0xFFF4F5F6),
                elevation: 1,
                child: Row(
                  children: <Widget>[
                    currentItemDetails.imageUrl != null
                        ? Container(
                            padding: EdgeInsets.all(8.0),
                            height: 150,
                            width: 150,
                            child: ExtendedImage.network(
                              currentItemDetails.imageUrl,
                              fit: BoxFit.fill,
                              handleLoadingProgress: true,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              cache: false,
                              enableMemoryCache: true,
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(8.0),
                            height: 150,
                            width: 150,
                            child: Center(child: Icon(Icons.image)),
                          ),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${currentItemDetails.itemName.trim()}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'price: ${currentItemDetails.price}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  'itemCategory: ${currentItemDetails.itemCategory}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  padding: EdgeInsets.all(5.0),
                                  color: Colors.green,
                                  child: InkWell(
                                    onTap: () {
                                      editFoodItem(
                                        item: currentItemDetails,
                                        index: index,
                                        itemName: currentItemDetails.itemName,
                                        price: currentItemDetails.price,
                                      );
                                    },
                                    child: Text('Edit'),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  margin: EdgeInsets.all(8.0),
                                  color: Colors.red,
                                  child: InkWell(
                                    onTap: () async {
                                      deletePopUp(index: index);
                                    },
                                    child: Text('Delete'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditFoodItemPage extends StatefulWidget {
  final List itemLists;
  final String fastFoodName;
  final int index;

  EditFoodItemPage({
    @required this.itemLists,
    @required this.fastFoodName,
    @required this.index,
  });

  @override
  _EditFoodItemPageState createState() => _EditFoodItemPageState();
}

class _EditFoodItemPageState extends State<EditFoodItemPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController itemNameTextEditingController = TextEditingController();
  TextEditingController itemPriceTextEditingController =
      TextEditingController();
  String itemName;
  String itemPrice;

  List<Map> getUpdatedItemDetails() {
    print(widget.index);

    List<Map> _itemDetails = [];

    for (var i = 0; i < widget.itemLists.length; i++) {
      print(widget.itemLists[i]);
      Map updateData = widget.itemLists[i];

      if (i == widget.index) {
        updateData['price'] = int.parse(itemPrice);
        updateData['itemName'] = itemName;
      }

      _itemDetails.add(updateData);
    }

    print(_itemDetails);
    return _itemDetails;
  }

  void save() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Text('Are You Sure You Want To Proceed'),
          ),
          actions: [
            FlatButton(
              onPressed: () async {
                await FoodMethods()
                    .updateItemDetails(
                      itemDetails: getUpdatedItemDetails(),
                      fastFoodName: widget.fastFoodName,
                    )
                    .whenComplete(() => Navigator.pop(context));
              },
              child: Text('Yes'),
              color: Colors.green,
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    itemNameTextEditingController.text =
        widget.itemLists[widget.index]['itemName'];
    itemPriceTextEditingController.text =
        widget.itemLists[widget.index]['price'].toString();
//    getCurrentItemDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Item Name Can\'t Be Empty';
                  } else if (value.trim().length < 3) {
                    return 'Item Name Must Be More Than 2 Characters';
                  } else {
                    return null;
                  }
                },
                controller: itemNameTextEditingController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                ),
                onSaved: (value) => itemName = value.trim(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            Container(
              child: TextFormField(
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'Item Price Can\'t Be Empty';
                  } else if (value.trim().length < 3) {
                    return 'Item Price Must Be More Than 2 Characters';
                  } else {
                    return null;
                  }
                },
                controller: itemPriceTextEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Item Price',
                ),
                onSaved: (value) => itemPrice = value.trim(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      formKey.currentState.save();
                      print(itemName);
                      print(itemPrice);
                      save();
                    }
                  },
                  child: Text('Submit'),
                  color: Colors.green,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
