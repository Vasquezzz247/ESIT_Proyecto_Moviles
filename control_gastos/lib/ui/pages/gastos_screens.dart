import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/gastos_provider.dart';
import '../widgets/gasto_card.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/custom_fab.dart';

class GastosPage extends StatelessWidget {
  const GastosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GastosProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            flexibleSpace:
                const FlexibleSpaceBar(title: Text('MOVIMIENTOS')),
          ),
          if (provider.gastos.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No hay gastos registrados')),
            )
          else
            SliverList.separated(
              itemCount: provider.gastos.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                child: GastoCard(
                  gasto: provider.gastos[i],
                  onTap: () async {
                    final updated = await Navigator.pushNamed(
                      context,
                      '/detalle',
                      arguments: provider.gastos[i],
                    );
                    if (updated == true) provider.init();
                  },
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 4),
            ),
        ],
      ),

      floatingActionButton: CustomFAB(onSaved: provider.init),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
      ),
    );
  }
}
