import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/gastos_provider.dart';
import '../widgets/custom_bottom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final total = context.watch<GastosProvider>().total;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('ESTADO DE GASTOS'),
              centerTitle: false,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('TOTAL GASTADO', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Text('\$${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pushReplacementNamed(context, '/gastos');
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab',
        onPressed: () => Navigator.pushNamed(context, '/gastos'),
        child: const Icon(Icons.list),
      ),
    );
  }
}