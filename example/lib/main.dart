import 'package:flutter/material.dart';
import 'package:proportional_design/proportional_design.dart';

void main() {
  // Configurar o package para usar estratégia adaptativa por padrão
  ProportionalConfig.setDefaultStrategy(ScalingStrategy.adaptive);

  // Configurar logging (apenas em debug por padrão)
  ProportionalLogger.setDebugMode(true);
  ProportionalLogger.setVerboseMode(false);

  // Habilitar cache para melhor performance
  ProportionalCache.enable();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proportional Design - Improved',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proportional Design Examples'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do dispositivo
            _buildDeviceInfo(context),

            const SizedBox(height: 20),

            // Exemplo de Container Proporcional
            _buildProportionalContainerExample(context),

            const SizedBox(height: 20),

            // Exemplo de Texto Proporcional
            _buildProportionalTextExample(context),

            const SizedBox(height: 20),

            // Exemplo de Layout Adaptativo
            _buildAdaptiveLayoutExample(context),

            const SizedBox(height: 20),

            // Exemplo de Grid Responsivo
            _buildResponsiveGridExample(context),

            const SizedBox(height: 20),

            // Exemplo de Estatísticas do Cache
            _buildCacheStats(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(BuildContext context) {
    return ProportionalContainer(
      width: 360,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: context.getProportionalBorderRadiusAll(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProportionalText(
            'Informações do Dispositivo',
            fontSize: 20,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Tipo: ${context.deviceType.toString().split('.').last}'),
          Text('Breakpoint: ${context.breakpoint.toString().split('.').last}'),
          Text('Largura: ${context.screenWidth.toStringAsFixed(0)}px'),
          Text('Altura: ${context.screenHeight.toStringAsFixed(0)}px'),
          Text('Orientação: ${context.isLandscape ? "Landscape" : "Portrait"}'),
          Text('Status Bar: ${context.statusBarHeight.toStringAsFixed(0)}px'),
        ],
      ),
    );
  }

  Widget _buildProportionalContainerExample(BuildContext context) {
    return ProportionalPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProportionalText(
            'Containers Proporcionais',
            fontSize: 18,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ProportionalContainer(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: context.getProportionalBorderRadiusAll(8),
                ),
                child: Center(
                  child: ProportionalText(
                    '100x100',
                    fontSize: 14,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ProportionalContainer(
                width: 150,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: context.getProportionalBorderRadiusAll(8),
                ),
                child: Center(
                  child: ProportionalText(
                    '150x100',
                    fontSize: 14,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProportionalTextExample(BuildContext context) {
    return ProportionalPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProportionalText(
            'Textos Proporcionais',
            fontSize: 18,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ProportionalText('Fonte 12px', fontSize: 12),
          ProportionalText('Fonte 16px', fontSize: 16),
          ProportionalText('Fonte 20px', fontSize: 20),
          ProportionalText('Fonte 24px', fontSize: 24),
        ],
      ),
    );
  }

  Widget _buildAdaptiveLayoutExample(BuildContext context) {
    return ProportionalPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProportionalText(
            'Layout Adaptativo',
            fontSize: 18,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          AdaptiveLayout(
            phone: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade100,
              child: const Text('Layout para Phone (1 coluna)'),
            ),
            tablet: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.purple.shade100,
              child: const Text('Layout para Tablet (2 colunas)'),
            ),
            desktop: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.teal.shade100,
              child: const Text('Layout para Desktop (3 colunas)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveGridExample(BuildContext context) {
    return ProportionalPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProportionalText(
            'Grid Responsivo',
            fontSize: 18,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ResponsiveGrid(
              phoneColumns: 2,
              tabletColumns: 3,
              desktopColumns: 4,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                8,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.primaries[index % Colors.primaries.length],
                    borderRadius: context.getProportionalBorderRadiusAll(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheStats(BuildContext context) {
    final stats = ProportionalCache.statistics;

    return ProportionalPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProportionalText(
            'Estatísticas do Cache',
            fontSize: 18,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: context.getProportionalBorderRadiusAll(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Habilitado: ${stats['enabled']}'),
                Text('Tamanho: ${stats['size']} entradas'),
                Text(
                    'Taxa de Acerto: ${(stats['hitRate'] * 100).toStringAsFixed(1)}%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
