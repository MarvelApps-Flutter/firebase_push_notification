import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_push_notifications_app/services/local_notifications_services.dart';
import 'package:flutter_push_notifications_app/transactions_screen.dart';
import 'package:flutter_push_notifications_app/utils/text_styles.dart';
import 'color/material_color.dart';
import 'data/list_item.dart';
import 'data/transaction_item.dart';
import 'data/user_profile_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Size? size;
  List<ListItem> list = [
    ListItem(
        colors: createMaterialColor(Color(0xFF4f51fe)),
        icons: Icon(
          Icons.send,
          color: Colors.black,
        ),
        text: "Send"),
    ListItem(
        colors: createMaterialColor(Color(0xFFfb7b70)),
        icons: Icon(
          Icons.download,
          color: Colors.black,
        ),
        text: "Request"),
    ListItem(
        colors: createMaterialColor(Color(0xFF91b3fa)),
        icons: Icon(
          Icons.widgets,
          color: Colors.black,
        ),
        text: "More"),
  ];

  List<UserProfileItem> userProfile = [
    UserProfileItem(image: "assets/images/user_profile1.png", name: "Anna"),
    UserProfileItem(image: "assets/images/user_profile2.png", name: "Alex"),
    UserProfileItem(image: "assets/images/user_profile3.png", name: "Devid"),
    UserProfileItem(image: "assets/images/user_profile4.png", name: "Kenne"),
    UserProfileItem(image: "assets/images/user_profile5.png", name: "Lana"),
  ];

  List<TransactionItem> transactionList = [
    TransactionItem(
        icon: "assets/images/user_profile1.png",
        name: "Anna",
        amount: "Rs.67",
        time: "22:10"),
    TransactionItem(
        icon: "assets/images/user_profile2.png",
        name: "Alex",
        amount: "Rs.89",
        time: "17:10"),
    TransactionItem(
        icon: "assets/images/user_profile3.png",
        name: "Devid",
        amount: "Rs.110",
        time: "08:09"),
    TransactionItem(
        icon: "assets/images/user_profile4.png",
        name: "Kenne",
        amount: "Rs.99",
        time: "21:10"),
    TransactionItem(
        icon: "assets/images/user_profile5.png",
        name: "Lana",
        amount: "Rs.88",
        time: "19:20"),
  ];



  @override
  void initState() {
    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message != null){
        final routeFromMessage = message.data["route"];
        print("routeFromMessage is $routeFromMessage");
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });



    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification != null){
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffececec),
      body: body(),
    );
  }

  Widget body() {
    return CustomScrollView(
      //physics: ScrollPhysics(),
      slivers: <Widget>[
        buildSliverAppBar(),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                buildBalanceCard(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverToBoxAdapter(
              child: Container(
            height: 130,
            child: ListView.separated(
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 8);
                },
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return buildItem(index, list);
                }),
          )),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Send Again",
                      style:
                      AppTextStyles.boldTextStyle,
                    )),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverToBoxAdapter(
              child: Container(
            height: 90,
            child: ListView.separated(
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 20);
                },
                itemCount: userProfile.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: buildSearchItem(),
                        ),
                        Container(
                            margin: const EdgeInsets.only(right: 15),
                            child: buildUserProfile(index, userProfile))
                      ],
                    );
                  } else {
                    return Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: buildUserProfile(index, userProfile));
                  }
                }),
          )),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                //const SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Transactions",
                          style: AppTextStyles.boldTextStyle,
                        ),
                        Expanded(
                            child: InkWell(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "View All",
                                    style: AppTextStyles.lightTextStyle,
                                  )),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> TransactionsScreen()));
                              },
                            )),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                        ),
                      ],
                    )),
                //const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return buildTransactionItem(index, transactionList);
                }),
          ),
        ),
      ],
    );
  }

  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      snap: true,
      floating: true,
      elevation: 10,
      backgroundColor: Colors.white,
      expandedHeight: 90,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(40)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage:
                      AssetImage("assets/images/user_profile5.png"),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello User",style: AppTextStyles.lightTextStyle,),
                          Text(
                            "Welcome Back",
                            style: AppTextStyles.boldTextStyle,
                          )
                        ],
                      ),
                      CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.notifications,
                                color: Colors.black,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(int index, List<ListItem> list) {
    return Container(
      height: MediaQuery.of(context).size.height * 45,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Card(
        //elevation: 10,
        semanticContainer: true,
        color: list[index].colors,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: list[index].icons,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                list[index].text!,
                style: AppTextStyles.boldWhiteTextStyle
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchItem() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text("Search",style: AppTextStyles.lightTextStyle,)
      ],
    );
  }

  Widget buildUserProfile(index, List<UserProfileItem> userProfile) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(userProfile[index].image!),
        ),
        SizedBox(
          height: 8,
        ),
        Text(userProfile[index].name!,style: AppTextStyles.lightTextStyle,)
      ],
    );
  }

  Widget buildBalanceCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          child: Card(
            elevation: 10,
            //semanticContainer: true,
            //color: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Your Balance",
                        style: AppTextStyles.lightTextStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Rs.30,000",
                        style: AppTextStyles.boldTextStyle,
                      ),
                    ],
                  ),
                ),
                Image(
                    image: AssetImage("assets/images/bank_balance.jpg"),
                    //height: 120,
                    width: 120)
              ],
            ),
          ),
        ),
        Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all()),
                child: Icon(Icons.add)))
      ],
    );
  }

  Widget buildTransactionItem(
      int index, List<TransactionItem> transactionList) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black87.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundImage: AssetImage(transactionList[index].icon!),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 20),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                              child: Text(transactionList[index].name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.boldTextStyle,))),
                      SizedBox(width: 5),
                      Container(
                          child: Text(transactionList[index].amount!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.boldTextStyle,))
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          child: Text(transactionList[index].time!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:AppTextStyles.lightTextStyle
                                  )),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
}
