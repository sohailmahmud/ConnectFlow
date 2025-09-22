# ConnectFlow - BLE Device Manager

> Flutter BLE app with clean architecture, BLoC pattern, real-time data streaming, and OTA firmware updates

[![Dart](https://img.shields.io/badge/Dart-3.9.0+-00579C.svg?style=flat&logo=dart&logoColor=white)](https://dart.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-3.35.0+-02569B.svg?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-lightgrey.svg?style=flat)](https://flutter.dev/)
[![Coverage Status](https://coveralls.io/repos/github/sohailmahmud/ConnectFlow/badge.svg?branch=main)](https://coveralls.io/github/sohailmahmud/ConnectFlow?branch=main)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg?style=flat)](https://github.com/sohailmahmud/ConnectFlow)

A professional-grade Flutter application for managing Bluetooth Low Energy (BLE) devices with real-time sensor monitoring, over-the-air firmware updates, and comprehensive device control capabilities.

## ✨ Features

### 🔍 **Device Management**
- **Smart Scanning**: Automatic BLE device discovery with RSSI indication
- **Secure Pairing**: Robust device connection with timeout handling
- **Connection Management**: Real-time connection status monitoring

### 📊 **Real-time Data Streaming**
- **Live Sensor Data**: Temperature, humidity, pressure, and battery monitoring
- **Data Visualization**: Real-time charts and historical data tracking
- **Configurable Buffering**: Adjustable data history with memory management

### 🔄 **OTA Firmware Updates**
- **Wireless Updates**: Over-the-air firmware deployment
- **Progress Tracking**: Real-time update progress with status indicators
- **Error Handling**: Robust error recovery and retry mechanisms

### 🏗️ **Architecture & Design**
- **Clean Architecture**: Separation of concerns with layered design
- **SOLID Principles**: Maintainable and extensible codebase
- **BLoC Pattern**: Reactive state management with event-driven architecture
- **Dependency Injection**: Modular design with GetIt

## 🏛️ Architecture Overview

```
├── 📱 Presentation Layer
│   ├── BLoC (State Management)
│   ├── Pages (UI Screens)
│   └── Widgets (Reusable Components)
│
├── 🧠 Domain Layer
│   ├── Entities (Business Models)
│   ├── Use Cases (Business Logic)
│   └── Repository Interfaces
│
└── 💾 Data Layer
    ├── Data Sources (BLE Implementation)
    ├── Models (Data Transfer Objects)
    └── Repository Implementation
```

### 🎯 SOLID Principles Implementation

- **Single Responsibility**: Each class has one clear purpose
- **Open/Closed**: Easy to extend without modifying existing code
- **Liskov Substitution**: Interfaces are properly abstracted
- **Interface Segregation**: Small, focused interfaces
- **Dependency Inversion**: High-level modules independent of low-level details

## 🚀 Getting Started

### Prerequisites

- Flutter 3.0 or higher
- Android SDK 21+ or iOS 12+
- Physical device (BLE not supported on simulators)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sohailmahmud/ConnectFlow.git
   cd connectflow
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if using build_runner)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### 📱 Platform Setup

#### Android Configuration
Add these permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

#### iOS Configuration
Add to `ios/Runner/Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth access to connect to BLE devices</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app needs Bluetooth access to connect to BLE devices</string>
```

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter_blue_plus: ^1.14.3      # Modern BLE library
  flutter_bloc: ^8.1.3            # State management
  equatable: ^2.0.5               # Value equality
  injectable: ^2.3.2              # Dependency injection annotations
  get_it: ^7.6.4                  # Service locator
  permission_handler: ^11.0.1     # Runtime permissions
  rxdart: ^0.27.7                 # Reactive extensions
  dartz: ^0.10.1                  # Functional programming

dev_dependencies:
  build_runner: ^2.4.7            # Code generation
  freezed: ^2.4.6                 # Immutable classes
  injectable_generator: ^2.4.1    # DI code generation
  json_serializable: ^6.7.1       # JSON serialization
```

## 🎮 Usage

### Basic Workflow

1. **Scan for Devices**
   ```dart
   context.read<BleBloc>().add(StartScanningEvent());
   ```

2. **Connect to Device**
   ```dart
   context.read<BleBloc>().add(ConnectToDeviceEvent(deviceId));
   ```

3. **Start Data Streaming**
   ```dart
   context.read<BleBloc>().add(StartDataStreamEvent(deviceId));
   ```

4. **Firmware Update**
   ```dart
   context.read<BleBloc>().add(
     StartFirmwareUpdateEvent(deviceId, firmwareData)
   );
   ```

### State Management Example

```dart
BlocBuilder<BleBloc, BleState>(
  builder: (context, state) {
    if (state is BleDataStreaming) {
      return DataVisualizationWidget(
        device: state.device,
        dataHistory: state.dataHistory,
      );
    }
    return CircularProgressIndicator();
  },
)
```

## 🧪 Testing

### Running Tests
```bash
# Domain layer tests
flutter test test/domain/

# Data layer tests  
flutter test test/data/

# Presentation layer tests
flutter test test/presentation/

# All unit tests
flutter test

# Integration tests
flutter test integration_test/

# With coverage
flutter test --coverage
```

### Test Structure
```
test/
├── core/
│   └── errors/failures_test.dart
├── domain/
│   ├── entities/
│   ├── usecases/
├── data/
│   ├── models/
│   └── repositories/
├── presentation/
│   ├── bloc/
│   └── widgets/
├── mocks/
├── test_helpers/
└── integration_test/
```

## 🔧 Configuration

### BLE Service UUIDs
Update these constants in `ble_datasource.dart`:

```dart
static const String serviceUuid = "12345678-1234-1234-1234-123456789abc";
static const String dataCharacteristicUuid = "87654321-4321-4321-4321-cba987654321";
static const String otaCharacteristicUuid = "11111111-2222-3333-4444-555555555555";
```

### Data Parsing
Customize sensor data parsing in `_parseFloat()` method based on your device's data format.

## 📊 Performance

- **Memory Management**: Automatic cleanup of streams and subscriptions
- **Battery Optimization**: Efficient BLE scanning with timeouts
- **Data Buffering**: Configurable history size to prevent memory leaks
- **Connection Pooling**: Proper device connection lifecycle management

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the existing code style and architecture patterns
4. Write tests for new functionality
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add documentation for public APIs
- Maintain separation of concerns

## 🐛 Troubleshooting

### Common Issues

**BLE Not Working on Emulator**
- BLE requires physical device - emulators don't support Bluetooth hardware

**Permission Denied Errors**
- Ensure all required permissions are added to platform-specific files
- Check that location services are enabled (required for BLE scanning)

**Connection Timeouts**
- Verify device is in pairing mode
- Check signal strength (RSSI)
- Ensure device is not connected to another app

**OTA Update Failures**
- Verify firmware file format
- Check MTU size limitations
- Ensure stable connection during update

## � CI/CD & DevOps

This project includes comprehensive GitHub Actions workflows for automated testing, building, and deployment:

### 🔄 Continuous Integration (`.github/workflows/ci.yml`)
- **Automated Testing**: Runs on every push and pull request
- **Multi-platform Support**: Tests on Ubuntu, macOS, and Windows
- **Comprehensive Coverage**: Unit, widget, and integration tests
- **Code Quality**: Static analysis, formatting checks, and security scanning
- **Coverage Reporting**: Automatic test coverage analysis

### 🛠️ Maintenance Workflow (`.github/workflows/maintenance.yml`)
- **Weekly Dependency Updates**: Automated dependency management
- **Security Audits**: Regular vulnerability scanning
- **Automated PRs**: Creates pull requests for updates

### 📦 Release Workflow (`.github/workflows/release.yml`)
- **Production Builds**: Automated APK and App Bundle generation
- **GitHub Releases**: Automatic release creation with changelogs
- **Artifact Management**: Binary distribution and versioning
- **Multi-format Support**: Both stable and pre-release versions

### Workflow Badges
Add these badges to track your CI/CD status:

```markdown
[![CI](https://github.com/yourusername/connectflow/workflows/CI/badge.svg)](https://github.com/yourusername/connectflow/actions/workflows/ci.yml)
[![Maintenance](https://github.com/yourusername/connectflow/workflows/Maintenance/badge.svg)](https://github.com/yourusername/connectflow/actions/workflows/maintenance.yml)
[![Release](https://github.com/yourusername/connectflow/workflows/Release/badge.svg)](https://github.com/yourusername/connectflow/actions/workflows/release.yml)
```

## �📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter Blue Plus](https://pub.dev/packages/flutter_blue_plus) - Excellent BLE library
- [BLoC Library](https://bloclibrary.dev/) - Reactive state management
- [GetIt](https://pub.dev/packages/get_it) - Dependency injection
- Clean Architecture principles by Robert C. Martin

## 📞 Support

- 📧 **Email**: sohailmahmud@yahoo.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/sohailmahmud/ConnectFlow/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/sohailmahmud/ConnectFlow/discussions)

---

<p align="center">
  Made with ❤️ using Flutter
</p>