import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:project1/utilies/app_colors.dart';
import 'package:project1/view_models/user_profile_cubit/user_profile_cubit.dart';
import 'package:project1/view_models/user_profile_cubit/user_profile_state.dart';
import 'package:project1/views/pages/cart_page.dart';
import 'package:project1/views/pages/favourits_page.dart';
import 'package:project1/views/pages/home_page.dart';
import 'package:project1/views/pages/profile_page.dart';
import 'package:project1/models/product_item_model.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar({super.key});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  late final PersistentTabController _controller;
  late final List<Widget> _screens;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _screens = [const HomePage(), CartPage(addedToCartPlants: Plant.addedToCartPlants()), const FavoritesPage(), const ProfilePage()];
  }

  List<ItemConfig> _navBarsItems() {
    return [
      ItemConfig(
        icon: const Icon(CupertinoIcons.home),
        title: 'Home',
        activeForegroundColor: Theme.of(context).primaryColor,
        // activeColorPrimary: Theme.of(context).primaryColor,
        // inactiveColorPrimary: AppColors.grey,
      ),
      ItemConfig(
        icon: const Icon(CupertinoIcons.cart),
        title: 'Cart',
        activeForegroundColor: Theme.of(context).primaryColor,
        // activeColorPrimary: Theme.of(context).primaryColor,
        // inactiveColorPrimary: AppColors.grey,
      ),
      ItemConfig(
        icon: const Icon(CupertinoIcons.heart),
        title: 'Favorites',
        activeForegroundColor: Theme.of(context).primaryColor,
        // activeColorPrimary: Theme.of(context).primaryColor,
        // inactiveColorPrimary: AppColors.grey,
      ),
      ItemConfig(
        icon: const Icon(CupertinoIcons.person),
        title: 'Profile',
        activeForegroundColor: Theme.of(context).primaryColor,
        // activeColorPrimary: Theme.of(context).primaryColor,
        // inactiveColorPrimary: AppColors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                return CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: state.photoUrl != null
                      ? NetworkImage(state.photoUrl!)
                      : null,
                  child: state.photoUrl == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                );
              },
            ),
          ),
          title: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.name,
                      style: Theme.of(context).textTheme.labelLarge),
                  Text(
                    "Let's go shopping!",
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall!.copyWith(color: Colors.grey),
                  ),
                ],
              );
            },
          ),
          actions: [
            if (currentIndex == 0) ...[
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications)),
            ] else if (currentIndex == 1)
              IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag)),
          ],
        ),
        body: PersistentTabView(
          controller: _controller,
          tabs: [
            PersistentTabConfig(
                item: _navBarsItems()[0], screen: _screens[0]),
            PersistentTabConfig(
                item: _navBarsItems()[1], screen: _screens[1]),
            PersistentTabConfig(
                item: _navBarsItems()[2], screen: _screens[2]),
            PersistentTabConfig(
                item: _navBarsItems()[3], screen: _screens[3]),
          ],
          navBarBuilder: (navbarConfig) =>
              Style1BottomNavBar(navBarConfig: navbarConfig),
          onTabChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          backgroundColor: AppColors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement:
              true, // Keep tab state (prevents long reload when switching tabs).
        ),
      ),
    );
  }
}
