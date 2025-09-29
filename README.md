# Proportional Design

[![pub package](https://img.shields.io/pub/v/proportional_design.svg)](https://pub.dev/packages/proportional_design)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter package that provides responsive design utilities and proportional sizing based on your design dimensions. Perfect for creating consistent layouts across different screen sizes.

## ✨ Features

- 📱 **Proportional Sizing**: Automatically scale dimensions based on your design specifications
- 📐 **Screen Utilities**: Easy access to screen dimensions, safe areas, and device information
- 🎯 **Design-Based Layout**: Configure your base design dimensions for consistent scaling
- 📱 **Responsive Typography**: Scale text sizes proportionally
- 🛡️ **Safe Area Handling**: Built-in support for status bars, navigation bars, and notches
- 🔧 **Flexible Configuration**: Override system values for testing and specific use cases
- 📊 **Screen Breakpoint Detection**: Identify device types and orientations
- 🎨 **Material Design Ready**: Works seamlessly with Flutter's Material Design

## 🚀 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  proportional_design: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 📖 Usage

### Basic Setup

```dart
import 'package:proportional_design/proportional_design.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getProportionalWidth(200),  // Scales based on screen width
      height: context.getProportionalHeight(100), // Scales based on screen height
      child: Text(
        'Responsive Text',
        style: TextStyle(
          fontSize: context.getProportionalFontSize(16), // Proportional font size
        ),
      ),
    );
  }
}
```

### Screen Information

```dart
class ScreenInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Screen Width: ${context.screenWidth}'),
        Text('Screen Height: ${context.screenHeight}'),
        Text('Status Bar Height: ${context.statusBarHeight}'),
        Text('Bottom Padding: ${context.bottomPadding}'),
        Text('Available Height: ${context.getAvailableHeight()}'),
        Text('Is Tablet: ${context.isTablet}'),
        Text('Is Landscape: ${context.isLandscape}'),
      ],
    );
  }
}
```

### Safe Area Handling

```dart
class SafeAreaExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Get available height excluding safe areas
        height: context.getAvailableHeight(
          useSafeAreaTop: true,
          useSafeAreaBottom: true,
        ),
        child: YourContent(),
      ),
    );
  }
}
```

### Responsive Layouts

```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Responsive container
        Container(
          width: context.getProportionalWidth(300),
          height: context.getProportionalHeight(200),
          margin: EdgeInsets.all(context.getProportionalWidth(16)),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(context.getProportionalWidth(8)),
          ),
          child: Center(
            child: Text(
              'Responsive Container',
              style: TextStyle(
                fontSize: context.getProportionalFontSize(18),
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Responsive spacing
        SizedBox(height: context.getProportionalHeight(20)),

        // Responsive button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: context.getProportionalWidth(24),
              vertical: context.getProportionalHeight(12),
            ),
          ),
          child: Text(
            'Responsive Button',
            style: TextStyle(fontSize: context.getProportionalFontSize(16)),
          ),
        ),
      ],
    );
  }
}
```

## 🔧 Configuration

### Base Design Dimensions

The package uses a base design of 402x874 pixels by default. You can configure this for your specific design:

```dart
// In your main.dart or app initialization
void main() {
  // Configure base design dimensions
  ScreenConfig.setBaseDimensions(
    width: 375,  // Your design width
    height: 812, // Your design height
  );

  runApp(MyApp());
}
```

### Override System Values

For testing or specific use cases, you can override system values:

```dart
// Override status bar height for testing
ScreenConfig.forcedStatusBarHeight = 44.0;

// Override bottom padding for testing
ScreenConfig.forcedBottomPadding = 34.0;
```

## 📚 API Reference

### Screen Dimensions

| Method                         | Description                               |
| ------------------------------ | ----------------------------------------- |
| `context.screenWidth`          | Get total screen width                    |
| `context.screenHeight`         | Get total screen height                   |
| `context.statusBarHeight`      | Get status bar height                     |
| `context.bottomPadding`        | Get bottom safe area padding              |
| `context.getAvailableHeight()` | Get available height excluding safe areas |

### Proportional Sizing

| Method                                    | Description                        |
| ----------------------------------------- | ---------------------------------- |
| `context.getProportionalWidth(double)`    | Scale width based on screen ratio  |
| `context.getProportionalHeight(double)`   | Scale height based on screen ratio |
| `context.getProportionalFontSize(double)` | Scale font size proportionally     |
| `context.getProportionalSize(double)`     | Scale any dimension proportionally |

### Device Detection

| Property              | Description                          |
| --------------------- | ------------------------------------ |
| `context.isTablet`    | Check if device is a tablet          |
| `context.isPhone`     | Check if device is a phone           |
| `context.isLandscape` | Check if device is in landscape mode |
| `context.isPortrait`  | Check if device is in portrait mode  |

### Safe Area Utilities

| Method                           | Description                                 |
| -------------------------------- | ------------------------------------------- |
| `context.isStatusBarVisible`     | Check if status bar is visible              |
| `context.isNavigationBarVisible` | Check if navigation bar is visible          |
| `context.getAvailableHeight()`   | Get available height with safe area options |

## 🎯 Best Practices

1. **Design Consistency**: Use the same base design dimensions across your app
2. **Proportional Scaling**: Always use proportional methods for dimensions that should scale
3. **Safe Areas**: Consider safe areas when designing for different devices
4. **Testing**: Test on different screen sizes to ensure proper scaling
5. **Performance**: The package is optimized for performance with minimal overhead

## 📱 Example

Check out the complete example in the `example/` directory to see the package in action.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design principles
- Community contributors and users

## 📞 Support

If you encounter any issues or have questions, please:

1. Check the [Issues](https://github.com/matheusperez/proportional-widget/issues) page
2. Create a new issue with detailed information
3. For quick questions, you can also reach out through the discussions

---

Made with ❤️ for the Flutter community
