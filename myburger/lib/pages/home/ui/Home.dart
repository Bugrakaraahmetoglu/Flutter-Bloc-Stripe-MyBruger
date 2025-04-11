import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myburger/pages/detail/ui/DetailPage.dart';
import 'package:myburger/pages/home/bloc/home_bloc.dart';
import 'package:myburger/pages/home/ui/ItemCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  final List<String> categories = [
    "All",
    "Combos",
    "Sliders",
    "Chicken",
    "Texas",
  ];
  final HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToDetailsState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(burgerModel: state.burgerModel),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          case HomeLoadedSuccessState:
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(),
                        const SizedBox(height: 12),
                        Text(
                          "Order your favourite food!",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        SearchBar(),
                        const SizedBox(height: 20),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                categories.map((category) {
                                  return Card(
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        category,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        GridView.builder(
                          physics:
                              NeverScrollableScrollPhysics(), // scroll'u yukarıdaki SingleChildScrollView yönetecek
                          shrinkWrap: true, // içerik kadar yer kaplasın
                          itemCount:
                              (state as HomeLoadedSuccessState).burgers.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: 0.8,
                              ),
                          itemBuilder: (context, index) {
                            final burger = state.burgers[index];
                            return ItemCard(
                              burgerModel: burger,
                              onTap: () {
                               homeBloc.add(HomeNavigateToDetailsEvent(burger));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );

          case HomeErrorState:
            return Scaffold(
              body: Center(
                child: Text(
                  "Error",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );

          default:
            return SizedBox();
        }
      },
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Foodgo', style: Theme.of(context).textTheme.headlineLarge),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "https://newprofilepic.photo-cdn.net//assets/images/article/profile.jpg?90af0c8b0d4a",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: Card(
            elevation: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).iconTheme.color,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(left: 10),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    );
  }
}
