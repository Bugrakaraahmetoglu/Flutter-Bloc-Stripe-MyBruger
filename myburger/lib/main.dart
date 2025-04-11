import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myburger/Theme/AppTheme';
import 'package:myburger/navigation/bloc/navigation_bloc.dart';
import 'package:myburger/pages/bottomNavBar/CustomBottomNavBarState.dart';
import 'package:myburger/pages/cart/cubit/cart_cubit.dart';
import 'package:myburger/pages/home/bloc/home_bloc.dart';

void main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Stripe - use your own publishable key
    Stripe.publishableKey = 'pk_test_51RC3NzQDSbpUHciqUMOQ3CErtZBOzaeGwThHvUhOYC434SXkZqLNde2nkh49HyLotm91z0zNtH2ouLsb1eEAQ6a400QTKvmOI6';
    await Stripe.instance.applySettings();
    print("Stripe initialized successfully");
  } catch (e) {
    print("Failed to initialize Stripe: $e");
    // Continue without Stripe
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc()..add(NavigateToHomeEvent()),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(),
        ),
        BlocProvider<CartCubit>(
          create: (_) => CartCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyBurger',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const FancyNavBar(),
      ),
    );
  }
}