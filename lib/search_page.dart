import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_application_project/dummy_data.dart';
import 'package:mobile_application_project/places_widget.dart';


import 'colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<PlacesWidget> places = [];

  int index = 0;

  _fetchData() {
    int count = PlaceListData.list.length;
    for (var item in PlaceListData.list) {
      final Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animationController!, curve: Interval( (1 / count) * index, 1, curve: Curves.fastOutSlowIn ))
      );

      PlacesWidget widget = PlacesWidget(
        animation: animation,
        animationController: animationController,
        item: item,
      );
      places.add(widget);
      widget.animationController?.forward();

      setState(() {
        index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return Column(
      children: [
        _buildAppbar(context),
        Expanded(
          child:
          NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context,bool innerBoxIsScrolled){
              return<Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      ((context,index){
                        return Column(
                          children: [
                            _buildSerchUI(context)
                          ],
                        );
                      }),childCount: 1
                  ),
                ),
                SliverPersistentHeader(
                  pinned:true,
                  floating: true,
                  delegate: FilterTabHeader(
                      _buildFilterUI(context)
                  ),
                ),
              ];
            },
            body: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(){
    return Container(
      color: white,
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: ((context, index){
          return places[index];
        }),),
    );
  }

  Widget _buildFilterUI(BuildContext context){
    return Stack(
      children: [
        Container(
          color: white,
          padding: EdgeInsets.only(left: 16, right: 16,top: 8, bottom: 8),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "400 Places Found",
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,

                      ),
                    ),
                  )
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.sort, color: purple,),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSerchUI(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: purple.withOpacity(0.2),
                        offset: Offset(0,2),
                        blurRadius: 8
                    )
                  ]
              ),
              margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                child: TextField(
                  onChanged: (value){},
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Where are you going?"
                  ),
                ),
              ),
            ),
          ),
          // Creating Search Button
          Container(
            decoration: BoxDecoration(
                color: Colors.purpleAccent.shade100,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: Offset(0,2),
                      blurRadius: 8
                  )
                ]
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: (){},
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Icon(FontAwesomeIcons.magnifyingGlass,
                    size: 20,
                    color: Colors.purple.shade100,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAppbar(BuildContext context){
    return Container(
      decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
                color: purple,
                blurRadius: 0.8,
                spreadRadius: 0.0,
                blurStyle: BlurStyle.normal),
          ]
      ),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 8, right: 8
      ),
      child: Row(
        children: [
          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new),
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                'Explore',
                style: TextStyle(
                    fontSize: 22,fontWeight: FontWeight.w800
                ),
              ),
            ),
          ),

          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){

                    },
                    borderRadius: BorderRadius.circular(32),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.favorite_border),
                    ),
                  ),
                ),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){

                    },
                    borderRadius: BorderRadius.circular(32),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(FontAwesomeIcons.locationDot),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _fetchData();
    super.initState();
  }
}



class FilterTabHeader extends SliverPersistentHeaderDelegate{
  final Widget filterUI;
  FilterTabHeader(this.filterUI);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return filterUI;
  }

  @override
  double get maxExtent => 55;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }


}