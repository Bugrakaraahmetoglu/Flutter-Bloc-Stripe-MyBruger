import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:myburger/pages/cart/cubit/cart_cubit.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CardFieldInputDetails? _cardFieldInputDetails;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }
          return ListView.builder(
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              final burger = state.cartItems[index];
              return ListTile(
                leading: Image.asset(burger.imageUrl ?? ""),
                title: Text(burger.name ?? ""),
                subtitle: Text("\$${burger.price?.toStringAsFixed(2) ?? '0.00'}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => context.read<CartCubit>().removeFromCart(burger),
                    ),
                    Text("${burger.quantity ?? 1}"),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.read<CartCubit>().addToCart(burger, 1),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: \$${state.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: state.cartItems.isEmpty ? null : () => _showStripePaymentSheet(context, state.totalPrice),
                  child: const Text("Checkout"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showStripePaymentSheet(BuildContext context, double amount) async {
    setState(() => _loading = true);
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _buildPaymentSheet(context, amount),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildPaymentSheet(BuildContext context, double amount) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Payment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 20),
          const Text("Card Information", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          const SizedBox(height: 10),
          CardField(onCardChanged: (details) => setState(() => _cardFieldInputDetails = details)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _cardFieldInputDetails?.complete == true ? () => _processPayment(context, amount) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text("Pay \$${amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment(BuildContext context, double amount) async {
    final navContext = context;
    Navigator.of(navContext, rootNavigator: true).pop();
    _showProcessingDialog(navContext);

    try {
      if (_cardFieldInputDetails?.complete != true) throw Exception("Incomplete card details");

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
      );

      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      Navigator.of(navContext, rootNavigator: true).pop();
      await _showSimpleSuccessDialog(navContext);

      if (mounted) context.read<CartCubit>().clearCart();
    } catch (e) {
      if (mounted) Navigator.of(navContext, rootNavigator: true).pop();
      if (mounted) await _showSimpleErrorDialog(navContext, e.toString());
    }
  }

  void _showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Processing payment...'),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _showSimpleSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: const Text('Payment Successful!'),
        content: const Text('Your order has been placed successfully.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _showSimpleErrorDialog(BuildContext context, String errorMessage) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: const Text('Payment Error'),
        content: Text('An error occurred: $errorMessage'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }
}