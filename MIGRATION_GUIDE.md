# Guia de Migração v1.0 → v2.0

## 🎉 Boa Notícia: Sem Breaking Changes!

A versão 2.0 é **100% compatível** com código v1.0. Você pode atualizar sem medo e adotar as melhorias gradualmente.

---

## 📦 Atualização do Package

### 1. Atualizar pubspec.yaml

```yaml
dependencies:
  proportional_design: ^2.0.0 # era ^1.0.0
```

### 2. Instalar

```bash
flutter pub get
```

### 3. Pronto!

Seu código continuará funcionando exatamente como antes.

---

## 🚀 Melhorias Opcionais

### Configuração Inicial (Recomendado)

Adicione no seu `main.dart`:

```dart
import 'package:proportional_design/proportional_design.dart';

void main() {
  // Configurar estratégia adaptativa (recomendado para melhor suporte a tablets)
  ProportionalConfig.setDefaultStrategy(ScalingStrategy.adaptive);

  // Configurar logging (opcional - já vem configurado)
  ProportionalLogger.setDebugMode(true);
  ProportionalLogger.setVerboseMode(false);

  // Habilitar cache (opcional - já vem habilitado)
  ProportionalCache.enable();

  runApp(MyApp());
}
```

---

## 📱 Migração da Detecção de Dispositivos

### Antes (v1.0)

```dart
if (context.isTablet) {
  return TabletLayout();
}

if (context.isPhone) {
  return PhoneLayout();
}
```

### Depois (v2.0 - Recomendado)

```dart
// Opção 1: Usar enum DeviceType
if (context.deviceType == DeviceType.tablet) {
  return TabletLayout();
}

// Opção 2: Usar extension helpers
if (context.isTabletDevice) {
  return TabletLayout();
}

// Opção 3: Usar breakpoints Material Design 3
if (context.breakpoint == MaterialBreakpoint.medium) {
  return TabletLayout();
}
```

### Compatibilidade

```dart
// v1.0 - AINDA FUNCIONA mas não recomendado
context.isTablet  // baseado apenas em largura >= 600

// v2.0 - MELHOR detecção
context.isTabletDevice  // detecção inteligente usando shortestSide e longestSide
```

---

## 🎨 Migração para Widgets Proporcionais

### Container

**Antes (v1.0):**

```dart
Container(
  width: context.getProportionalWidth(200),
  height: context.getProportionalHeight(100),
  padding: EdgeInsets.all(context.getProportionalPadding(16)),
  margin: EdgeInsets.all(context.getProportionalMargin(8)),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: context.getProportionalBorderRadiusAll(12),
  ),
  child: Text(
    'Hello',
    style: TextStyle(
      fontSize: context.getProportionalFontSize(16),
    ),
  ),
)
```

**Depois (v2.0):**

```dart
ProportionalContainer(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: context.getProportionalBorderRadiusAll(12),
  ),
  child: ProportionalText(
    'Hello',
    fontSize: 16,
  ),
)
```

### Text

**Antes (v1.0):**

```dart
Text(
  'Título',
  style: TextStyle(
    fontSize: context.getProportionalFontSize(24),
    fontWeight: FontWeight.bold,
  ),
)
```

**Depois (v2.0):**

```dart
ProportionalText(
  'Título',
  fontSize: 24,
  style: TextStyle(fontWeight: FontWeight.bold),
)
```

### Padding

**Antes (v1.0):**

```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: context.getProportionalPadding(16),
    vertical: context.getProportionalPadding(8),
  ),
  child: MyWidget(),
)
```

**Depois (v2.0):**

```dart
ProportionalPadding.symmetric(
  horizontal: 16,
  vertical: 8,
  child: MyWidget(),
)
```

---

## 📐 Migração de Layouts

### Layout Adaptativo

**Antes (v1.0):**

```dart
Widget build(BuildContext context) {
  if (context.isSmallScreen) {
    return PhoneLayout();
  } else if (context.isMediumScreen) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

**Depois (v2.0):**

```dart
Widget build(BuildContext context) {
  return AdaptiveLayout(
    phone: PhoneLayout(),
    tablet: TabletLayout(),
    desktop: DesktopLayout(),
  );
}
```

### Grid Responsivo

**Antes (v1.0):**

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: context.responsiveColumns,
    crossAxisSpacing: context.getProportionalSpacing(8),
    mainAxisSpacing: context.getProportionalSpacing(8),
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => items[index],
)
```

**Depois (v2.0):**

```dart
ResponsiveGrid(
  phoneColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  spacing: 8,
  runSpacing: 8,
  children: items,
)
```

---

## ⚙️ Configuração Avançada

### Dimensões Base Customizadas

**Novo em v2.0:**

```dart
// Configurar dimensões base globais
ProportionalConfig.setBaseSize(Size(375, 812));

// Ou configurar por tipo de dispositivo
ProportionalConfig.setBaseSizeForDevice(
  DeviceType.tablet,
  Size(768, 1024),
);
```

### Fatores de Escala Customizados

**Novo em v2.0:**

```dart
// Configurar fator de escala para tablets
ProportionalConfig.setScaleFactor(DeviceType.tablet, 1.2);

// Tablets terão elementos 20% maiores
```

### Estratégias de Escala

**Novo em v2.0:**

```dart
// Configurar estratégia padrão
ProportionalConfig.setDefaultStrategy(ScalingStrategy.adaptive);

// Ou usar estratégia específica por cálculo
final width = context.getProportionalSizeAdaptive(
  100,
  isWidth: true,
  strategy: ScalingStrategy.material,
);
```

---

## 🔍 Breakpoints

### Antes (v1.0)

```dart
bool get isSmallScreen => screenWidth < 400;
bool get isMediumScreen => screenWidth >= 400 && screenWidth < 800;
bool get isLargeScreen => screenWidth >= 800;
```

### Depois (v2.0)

```dart
// Material Design 3 breakpoints
MaterialBreakpoint.compact    // < 600dp
MaterialBreakpoint.medium     // 600dp - 840dp
MaterialBreakpoint.expanded   // > 840dp

// Uso
if (context.breakpoint == MaterialBreakpoint.medium) {
  // Layout para tablets
}

// Ou usar propriedades (ainda funcionam)
if (context.isSmallScreen) {  // agora usa MaterialBreakpoint.compact
  // Layout compacto
}
```

---

## 📊 Performance

### Monitorar Cache

**Novo em v2.0:**

```dart
// Ver estatísticas do cache
final stats = ProportionalCache.statistics;
print('Hit rate: ${stats['hitRate']}');
print('Cache size: ${stats['size']}');

// Limpar cache se necessário
ProportionalCache.clear();
```

### Controlar Logging

**Novo em v2.0:**

```dart
// Em desenvolvimento
ProportionalLogger.setDebugMode(true);
ProportionalLogger.setVerboseMode(true);

// Em produção (automático)
// Logs são removidos automaticamente em release builds
```

---

## ✅ Checklist de Migração

### Obrigatório

- [x] Atualizar `pubspec.yaml` para v2.0
- [x] Executar `flutter pub get`
- [x] Testar app (deve funcionar sem mudanças)

### Recomendado

- [ ] Adicionar configuração inicial no `main.dart`
- [ ] Trocar `context.isTablet` por `context.deviceType`
- [ ] Migrar para widgets proporcionais (gradualmente)
- [ ] Usar breakpoints Material Design 3

### Opcional

- [ ] Configurar dimensões base customizadas
- [ ] Configurar fatores de escala
- [ ] Implementar layouts adaptativos
- [ ] Usar grids responsivos

---

## 🐛 Problemas Comuns

### 1. "Não vejo diferença após atualizar"

**Solução:** A v2.0 é compatível com v1.0. Para usar novos recursos:

```dart
// Configurar estratégia adaptativa
ProportionalConfig.setDefaultStrategy(ScalingStrategy.adaptive);
```

### 2. "Elementos ainda pequenos em tablets"

**Solução:** Usar estratégia adaptativa e/ou configurar fator de escala:

```dart
ProportionalConfig.setScaleFactor(DeviceType.tablet, 1.2);
```

### 3. "Muitos logs no console"

**Solução:** Desabilitar verbose mode:

```dart
ProportionalLogger.setVerboseMode(false);
```

---

## 📚 Recursos Adicionais

- [README v2.0](README_V2.md) - Documentação completa
- [CHANGELOG](CHANGELOG.md) - Lista de mudanças
- [IMPROVEMENTS_CHANGELOG](IMPROVEMENTS_CHANGELOG.md) - Changelog detalhado
- [Exemplo Completo](example/lib/main.dart) - App demonstrativo

---

## 💡 Dicas

1. **Migre Gradualmente**: Não precisa mudar tudo de uma vez
2. **Teste em Tablets**: Use a nova detecção para melhor UX
3. **Use Widgets**: Código mais limpo e menos verboso
4. **Configure no Início**: Defina estratégias no `main.dart`
5. **Monitore Performance**: Use estatísticas do cache

---

## 🎓 Exemplo Completo de Migração

### Antes (v1.0)

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.getProportionalWidth(300),
        height: context.getProportionalHeight(200),
        padding: EdgeInsets.all(context.getProportionalPadding(16)),
        child: Column(
          children: [
            Text(
              'Título',
              style: TextStyle(
                fontSize: context.getProportionalFontSize(24),
              ),
            ),
            if (context.isTablet)
              TabletView()
            else
              PhoneView(),
          ],
        ),
      ),
    );
  }
}
```

### Depois (v2.0)

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProportionalContainer(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ProportionalText(
              'Título',
              fontSize: 24,
            ),
            AdaptiveLayout(
              phone: PhoneView(),
              tablet: TabletView(),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

**Pronto! Você está preparado para migrar para v2.0! 🚀**
