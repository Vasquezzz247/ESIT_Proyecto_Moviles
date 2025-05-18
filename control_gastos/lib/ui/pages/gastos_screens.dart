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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceVariant, // Fondo gris (igual que HomePage)
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: colors.surface, // Usa el mismo color que HomePage
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  title: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'MOVIMIENTOS',
                      style: TextStyle(
                        fontSize: 20,
                        color: colors.onSurface, // Color de texto consistente
                      ),
                    ),
                  ),
                  background: Container(color: colors.surface), // Fondo consistente
                );
              },
            ),
          ),
          if (provider.gastos.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Card(
                  elevation: 0,
                  color: colors.surfaceVariant,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No hay gastos registrados',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            SliverList.separated(
              itemCount: provider.gastos.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
              separatorBuilder: (_, __) => const SizedBox(height: 8),
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