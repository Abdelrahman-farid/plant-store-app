import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/utilies/app_routes.dart';
import 'package:project1/view_models/add_new_card_cubid/payment_methods_cubit.dart';
import 'package:project1/view_models/auth_cubit/auth_cubit.dart';
import 'package:project1/view_models/choose_location_cubit/choose_location_cubit.dart';
import 'package:project1/view_models/favourite_cubit/favourite_cubit.dart';
import 'package:project1/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:project1/views/pages/add_new_card_page.dart';
import 'package:project1/views/pages/checkout_page.dart';
import 'package:project1/views/pages/choose_location_page.dart';
import 'package:project1/views/pages/custom_bottom_navbar_page.dart';
import 'package:project1/views/pages/login_page.dart';
import 'package:project1/views/pages/product_details_page.dart';
import 'package:project1/views/pages/register_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = FavoriteCubit();
              cubit.getFavoriteProducts();
              return cubit;
            },
            child: const CustomBottomNavbar(),
          ),
          settings: settings,
        );

      case AppRoutes.loginRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const LoginPage(),
          ),
          settings: settings,
        );

      case AppRoutes.registerRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const RegisterPage(),
          ),
          settings: settings,
        );

      case AppRoutes.checkoutRoute:
        return MaterialPageRoute(
          builder: (_) => const CheckoutPage(),
          settings: settings,
        );
      case AppRoutes.chooseLocation:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ChooseLocationCubit();
              cubit.fetchLocations();
              return cubit;
            },
            child: const ChooseLocationPage(),
          ),
          settings: settings,
        );
      case AppRoutes.addNewCardRoute:
        final paymentCubit = settings.arguments as PaymentMethodsCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: paymentCubit,
            child: const AddNewCardPage(),
          ),
          settings: settings,
        );
      case AppRoutes.productDetailsRoute:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ProductDetailsCubit();
              cubit.getProductDetails(productId);
              return cubit;
            },
            child: ProductDetailsPage(plantId: int.tryParse(productId) ?? 0),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
