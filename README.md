# Proportional Design v2.0

[![pub package](https://img.shields.io/pub/v/proportional_design.svg)](https://pub.dev/packages/proportional_design)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Um pacote Flutter avançado que fornece utilidades de design responsivo e dimensionamento proporcional com **estratégias adaptativas inteligentes**, seguindo os padrões do **Material Design 3**.

## ✨ Novidades da v2.0

### 🎯 Destaques

- ✅ **5 Estratégias de Escala** diferentes (linear, adaptive, aspectRatio, density, material)
- ✅ **Breakpoints Material Design 3** (compact, medium, expanded)
- ✅ **Detecção Inteligente de Dispositivos** (phone, tablet, desktop, foldable)
- ✅ **Sistema de Cache** com ~70% redução em cálculos repetitivos
- ✅ **Logging Condicional** (zero logs em produção)
- ✅ **Validação Robusta** com fallbacks automáticos
- ✅ **Widgets Proporcionais Prontos** para uso
- ✅ **100% Compatível** com código v1.0

## 🚀 Instalação

```yaml
dependencies:
  proportional_design: ^2.0.0
```

```bash
flutter pub get
```

## 📖 Uso Básico

### Configuração Inicial (Opcional)

```dart
import 'package:proportional_design/proportional_design.dart';

void main() {
  // Configurar estratégia de escala (padrão: adaptive)
  ProportionalConfig.setDefaultStrategy(ScalingStrategy.adaptive);

  // Configurar logging (apenas debug por padrão)
  ProportionalLogger.setDebugMode(true);

  // Habilitar cache (já habilitado por padrão)
  ProportionalCache.enable();

  runApp(MyApp());
}
```

### Detecção de Dispositivos

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Novo sistema de detecção
    final deviceType = context.deviceType; // DeviceType.tablet
    final breakpoint = context.breakpoint; // MaterialBreakpoint.medium

    // Ou usar verificações diretas
    if (context.isTabletDevice) {
      return TabletLayout();
    }

    return PhoneLayout();
  }
}
```

### Widgets Proporcionais (Recomendado)

```dart
// Antes (ainda funciona)
Container(
  width: context.getProportionalWidth(200),
  height: context.getProportionalHeight(100),
  padding: EdgeInsets.all(context.getProportionalPadding(16)),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: context.getProportionalFontSize(16)),
  ),
)

// Depois (mais simples)
ProportionalContainer(
  width: 200,
  height: 100,
  padding: EdgeInsets.all(16),
  child: ProportionalText('Hello', fontSize: 16),
)
```

## 🎨 Recursos Principais

### 1. Layout Adaptativo

```dart
AdaptiveLayout(
  phone: PhoneView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)
```

### 2. Grid Responsivo

```dart
ResponsiveGrid(
  phoneColumns: 1,
  tabletColumns: 2,
  desktopColumns: 3,
  spacing: 8,
  children: [
    Card(child: Text('Item 1')),
    Card(child: Text('Item 2')),
    Card(child: Text('Item 3')),
  ],
)
```

### 3. Layout por Orientação

```dart
OrientationAwareLayout(
  portrait: PortraitView(),
  landscape: LandscapeView(),
)
```

### 4. Estratégias de Escala

```dart
// Escala linear (comportamento original)
final size = context.getProportionalSizeAdaptive(
  100,
  strategy: ScalingStrategy.linear,
);

// Escala adaptativa por dispositivo (recomendado)
final size = context.getProportionalSizeAdaptive(
  100,
  strategy: ScalingStrategy.adaptive,
);

// Escala baseada em aspect ratio
final size = context.getProportionalSizeAdaptive(
  100,
  strategy: ScalingStrategy.aspectRatio,
);

// Escala Material Design
final size = context.getProportionalSizeAdaptive(
  100,
  strategy: ScalingStrategy.material,
);
```

### 5. Configuração Avançada

```dart
// Configurar dimensões base
ProportionalConfig.setBaseSize(Size(375, 812));

// Configurar por tipo de dispositivo
ProportionalConfig.setBaseSizeForDevice(
  DeviceType.tablet,
  Size(768, 1024),
);

// Configurar fator de escala
ProportionalConfig.setScaleFactor(DeviceType.tablet, 1.2);
```

## 📚 Widgets Disponíveis

| Widget                   | Descrição                           |
| ------------------------ | ----------------------------------- |
| `ProportionalContainer`  | Container com dimensões automáticas |
| `ProportionalText`       | Text com fontSize proporcional      |
| `ProportionalSizedBox`   | SizedBox proporcional               |
| `ProportionalPadding`    | Padding proporcional                |
| `ProportionalIcon`       | Icon com tamanho proporcional       |
| `AdaptiveLayout`         | Layout por tipo de dispositivo      |
| `OrientationAwareLayout` | Layout por orientação               |
| `ResponsiveGrid`         | Grid com colunas adaptativas        |

## 🔧 API Completa

### Detecção de Dispositivos

```dart
context.deviceType          // DeviceType enum
context.breakpoint          // MaterialBreakpoint enum
context.isTabletDevice      // bool
context.isPhoneDevice       // bool
context.isDesktopDevice     // bool
context.deviceInfo          // Map com informações detalhadas
```

### Dimensionamento

```dart
context.getProportionalWidth(200)
context.getProportionalHeight(100)
context.getProportionalSize(150, isWidth: true)
context.getWidthPercentage(0.5)  // 50% da largura
context.getHeightPercentage(0.3) // 30% da altura
```

### Tipografia

```dart
context.getProportionalFontSize(16)
context.getFontSizePercentage(0.02)
context.getResponsiveFontSizeByBreakpoint(
  small: 14,
  medium: 16,
  large: 18,
)
```

### Espaçamento

```dart
context.getProportionalSpacing(16)
context.getProportionalPadding(12)
context.getProportionalMargin(8)
context.getProportionalEdgeInsets(all: 16)
context.getProportionalEdgeInsetsSymmetric(
  horizontal: 16,
  vertical: 8,
)
```

### Estilização

```dart
context.getProportionalBorderRadius(8)
context.getProportionalBorderRadiusAll(12)
context.getProportionalIconSize(24)
context.getProportionalBoxShadow(
  dx: 0,
  dy: 2,
  blurRadius: 4,
  color: Colors.black26,
)
```

## 📊 Performance

### Sistema de Cache

```dart
// Ver estatísticas
final stats = ProportionalCache.statistics;
print('Hit rate: ${stats['hitRate']}');
print('Cache size: ${stats['size']}');

// Limpar cache se necessário
ProportionalCache.clear();

// Desabilitar cache temporariamente
ProportionalCache.disable();
```

### Logging

```dart
// Configurar níveis de log
ProportionalLogger.setDebugMode(true);
ProportionalLogger.setVerboseMode(true);

// Logs são automaticamente removidos em release builds
```

## 🎯 Breakpoints Material Design 3

| Breakpoint | Range         | Dispositivos                |
| ---------- | ------------- | --------------------------- |
| Compact    | < 600dp       | Phones                      |
| Medium     | 600dp - 840dp | Tablets pequenos, Foldables |
| Expanded   | > 840dp       | Tablets grandes, Desktops   |

## 💡 Melhores Práticas

1. **Use estratégia adaptativa** para melhor suporte a tablets
2. **Prefira widgets proporcionais** para código mais limpo
3. **Configure na inicialização** para comportamento consistente
4. **Teste em diferentes dispositivos** e orientações
5. **Use breakpoints Material Design 3** ao invés de valores hardcoded

## 🔄 Migração da v1.0

### Sem Breaking Changes!

Todo código v1.0 continua funcionando perfeitamente:

```dart
// v1.0 - continua funcionando
context.getProportionalWidth(200);
context.isTablet; // ainda funciona, mas use context.deviceType

// v2.0 - nova API recomendada
ProportionalContainer(width: 200, child: ...);
context.deviceType == DeviceType.tablet;
```

### Melhorias Opcionais

```dart
// Configurar estratégia (opcional)
void main() {
  ProportionalConfig.setDefaultStrategy(ScalingStrategy.adaptive);
  runApp(MyApp());
}
```

## 📱 Exemplo Completo

Veja o [exemplo completo](example/lib/main.dart) no diretório `example/` para um app demonstrando todos os recursos.

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o repositório
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- Flutter team pelo framework incrível
- Material Design team pelos guidelines
- Comunidade Flutter pelos feedbacks e contribuições

---

**Made with ❤️ for the Flutter community**

### 📞 Suporte

- [Issues](https://github.com/matheusperez/proportional-widget/issues)
- [Discussions](https://github.com/matheusperez/proportional-widget/discussions)
- [Documentation](https://pub.dev/documentation/proportional_design/latest/)
