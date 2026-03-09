import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project1/utilies/constants.dart';
import 'package:project1/models/product_item_model.dart';
import 'package:project1/views/pages/product_details_page.dart';

class FavoritePage extends StatefulWidget {
  final List<Plant> favoritedPlants;
  const FavoritePage({Key? key, required this.favoritedPlants})
    : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Plant> _favorites = [];

  @override
  void initState() {
    super.initState();
    _favorites = Plant.getFavoritedPlants();
  }

  @override
  void didUpdateWidget(covariant FavoritePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _favorites = Plant.getFavoritedPlants();
  }

  void _refreshFavorites() {
    setState(() {
      _favorites = Plant.getFavoritedPlants();
    });
  }

  void _removeFavorite(Plant plant) {
    setState(() {
      plant.isFavorated = false;
      _favorites = Plant.getFavoritedPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _favorites.isEmpty
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    child: Image.asset('assets/images/favorited.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your favorited Plants',
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              height: size.height * .5,
              child: ListView.builder(
                itemCount: _favorites.length,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final plant = _favorites[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: DetailPage(plantId: plant.plantId),
                          type: PageTransitionType.bottomToTop,
                        ),
                      ).then((_) => _refreshFavorites());
                    },
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Constants.primaryColor.withOpacity(.15),
                      backgroundImage: AssetImage(plant.imageURL),
                    ),
                    title: Text(
                      plant.plantName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(plant.category),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${plant.price}',
                          style: TextStyle(
                            color: Constants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _removeFavorite(plant),
                          tooltip: 'Remove from favorites',
                          icon: const Icon(Icons.favorite, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
