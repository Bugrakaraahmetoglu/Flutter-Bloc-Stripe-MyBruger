import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myburger/model/BurgerModel.dart';
import 'package:myburger/pages/cart/cubit/cart_cubit.dart';
import 'package:myburger/pages/detail/cubit/quantity_cubit.dart';
import 'package:myburger/pages/detail/cubit/quantity_state.dart';

class DetailPage extends StatefulWidget {
  final BurgerModel burgerModel;

  const DetailPage({super.key, required this.burgerModel});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    // Create the QuantityCubit here and pass it down
    return BlocProvider(
      create: (_) => QuantityCubit(widget.burgerModel.price!),
      child: _DetailPageContent(burgerModel: widget.burgerModel),
    );
  }
}

// Separate widget for the content that can access the QuantityCubit
class _DetailPageContent extends StatelessWidget {
  final BurgerModel burgerModel;

  const _DetailPageContent({required this.burgerModel});

  @override
  Widget build(BuildContext context) {
    // Now this context has access to the QuantityCubit
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image.asset(
                    burgerModel.imageUrl!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      burgerModel.name! + " " + burgerModel.shop!,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          burgerModel.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 5),
                        Text(" - "),
                        const SizedBox(width: 5),
                        Text(
                          burgerModel.deliveryTime!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      burgerModel.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Portion",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        BlocBuilder<QuantityCubit, QuantityState>(
                          builder: (context, state) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.read<QuantityCubit>().decrement(),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child: Icon(Icons.remove)),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  state.quantity.toString(),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () => context.read<QuantityCubit>().increment(),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child: Icon(Icons.add)),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: BlocBuilder<QuantityCubit, QuantityState>(
                  builder: (context, state) {
                    return Text(
                      "\$${state.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 230,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  final currentQuantity = context.read<QuantityCubit>().state.quantity;
                  context.read<CartCubit>().addToCart(
                    burgerModel,
                    currentQuantity,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child:  Text(
                  "Add to Cart",
                  style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}