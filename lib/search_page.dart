import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_application_project/dummy_data.dart';
import 'package:mobile_application_project/home_page.dart';
import 'package:mobile_application_project/places_widget.dart';
import 'package:mobile_application_project/theme_provider.dart';
import 'package:provider/provider.dart';
import 'colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  AnimationController? animationController;
  List<PlacesWidget> places = [];
  List<PlaceListData> hotelList = [];
  List<PlaceListData> filteredHotelList = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fetchData();
  }

  Future<void> _fetchData() async {
    hotelList = await PlaceListData.fetchHotels();
    filteredHotelList = hotelList;
    _updatePlacesWidgets();
  }

  void _updatePlacesWidgets() {
    places.clear();
    int count = filteredHotelList.length;
    for (int i = 0; i < count; i++) {
      var item = filteredHotelList[i];
      final Animation<double> animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animationController!,
          curve: Interval((1 / count) * i, 1, curve: Curves.fastOutSlowIn),
        ),
      );

      PlacesWidget widget = PlacesWidget(
        animation: animation,
        animationController: animationController,
        item: item,
      );
      places.add(widget);
      widget.animationController?.forward();
    }
    setState(() {});
  }

  void _searchHotels(String query) {
    filteredHotelList = hotelList
        .where((hotel) => hotel.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    _updatePlacesWidgets();
  }

  @override
  Widget build(BuildContext context) {
    final themeSettings = Provider.of<ThemeSettings>(context);
    return Scaffold(
      backgroundColor: themeSettings.currentTheme.primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()), // Navigate to your bookings page
            );
          },
        ),
        title: Text('Explore'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    ((context, index) {
                      return Column(
                        children: [
                          _buildSearchUI(context)
                        ],
                      );
                    }),
                    childCount: 1,
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: FilterTabHeader(
                    _buildFilterUI(context),
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

  Widget _buildContent() {
    final themeSettings = Provider.of<ThemeSettings>(context);
    return Container(
      color: themeSettings.isDarkModeEnabled ? Colors.black : Colors.white,
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: ((context, index) {
          return places[index];
        }),
      ),
    );
  }

  Widget _buildFilterUI(BuildContext context) {
    final themeSettings = Provider.of<ThemeSettings>(context);
    return Stack(
      children: [
        Container(
          color: themeSettings.isDarkModeEnabled ? Colors.black : Colors.white,
          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "${filteredHotelList.length} Places Found",
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.sort, color: accentColor),
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

  Widget _buildSearchUI(BuildContext context) {
    final themeSettings = Provider.of<ThemeSettings>(context);
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      color: themeSettings.isDarkModeEnabled ? primaryColor : primaryColor,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: themeSettings.isDarkModeEnabled ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  )
                ],
              ),
              margin: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                child: TextField(
                  onChanged: (value) {
                    _searchHotels(value);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Where are you going?",
                  ),
                ),
              ),
            ),
          ),
          // Creating Search Button
          Container(
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 20,
                   // color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class FilterTabHeader extends SliverPersistentHeaderDelegate {
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
