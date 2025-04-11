import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myburger/pages/cart/ui/CartPage.dart';
import 'package:myburger/pages/favorite/ui/FavoritePage.dart';
import 'package:myburger/pages/home/ui/Home.dart';
import 'package:myburger/pages/messages/ui/MessagesPage.dart';
import 'package:myburger/pages/profile/ui/ProfilePage.dart';
import '../../navigation/bloc/navigation_bloc.dart';

class FancyNavBar extends StatefulWidget {
  const FancyNavBar({super.key});

  @override
  State<FancyNavBar> createState() => _FancyNavBarState();
}

class _FancyNavBarState extends State<FancyNavBar> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc()..add(NavigateToHomeEvent()),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          Widget currentPage;
          if (state is NavigationHomeState) {
            currentPage = const HomePage();
          } else if (state is NavigationProfileState) {
            currentPage = const ProfilePage();
          } else if (state is NavigationCartState) {
            currentPage =  CartPage();
          } else if (state is NavigationMessagesState) {
            currentPage = const MessagesPage();
          } else if (state is NavigationFavoriteState) {
            currentPage = const FavoritePage();
          } else {
            currentPage = const HomePage(); // fallback
          }

          return Scaffold(
            body: currentPage,
            floatingActionButton: SizedBox(
              width: 70, // FAB genişliği
              height: 70, // FAB yüksekliği
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  context.read<NavigationBloc>().add(NavigateToCartEvent());
                },
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 40,
                ), // İkon boyutunu 40'a ayarladık
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).primaryColor,
              shape: const CircularNotchedRectangle(),
              notchMargin: 12,
              elevation: 8,
              child: Container(
                height: 40, // Burada BottomAppBar'ın yüksekliğini ayarlıyoruz
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed:
                            () => context.read<NavigationBloc>().add(
                              NavigateToHomeEvent(),
                            ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed:
                            () => context.read<NavigationBloc>().add(
                              NavigateToProfileEvent(),
                            ),
                      ),
                      const SizedBox(width: 40), // FAB boşluğu
                      IconButton(
                        icon: const Icon(
                          Icons.chat,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed:
                            () => context.read<NavigationBloc>().add(
                              NavigateToMessagesEvent(),
                            ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed:
                            () => context.read<NavigationBloc>().add(
                              NavigateToFavoriteEvent(),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
