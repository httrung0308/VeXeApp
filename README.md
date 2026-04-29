# VeXe - Bus Ticket Booking App

> Ứng dụng đặt vé xe khách cao cấp, viết bằng Flutter. Một dự án portfolio hoàn chỉnh thể hiện kỹ năng Mobile Development.

![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?style=flat-square&logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-34A853?style=flat-square)

## 📱 Giới thiệu

**VeXe** là ứng dụng đặt vé xe khách cao cấp, mang đến trải nghiệm đặt vé xe bus dễ dàng và thuận tiện. Dự án được xây dựng với mục tiêu:

- Giao diện người dùng hiện đại, thân thiện
- Kiến trúc code sạch, dễ bảo trì và mở rộng
- State management rõ ràng với Riverpod
- Navigation logic chặt chẽ với GoRouter

## 🛠 Công nghệ sử dụng

| Công nghệ | Phiên bản | Mô tả |
|-----------|-----------|-------|
| Flutter | 3.10.7 | Cross-platform UI framework |
| Dart | 3.10.7 | Programming language |
| flutter_riverpod | 2.6.1 | State management |
| go_router | 14.8.1 | Declarative navigation |
| google_fonts | 6.2.1 | Typography (Lexend) |
| phosphor_flutter | 2.1.0 | Icon library |
| qr_flutter | 4.1.0 | QR code generation |
| shared_preferences | 2.3.5 | Local storage |
| intl | 0.20.1 | Date/number formatting |

## 🏗 Kiến trúc dự án

```
lib/
├── main.dart                    # App entry point
├── core/                       # Shared utilities & base components
│   ├── constants/              # AppColors, AppSpacing, AppTypography
│   ├── data/                  # Mock data (trips, cities)
│   ├── domain/                # Entities (Trip, Seat, Booking, Passenger)
│   ├── theme/                 # AppTheme (Material 3)
│   └── widgets/               # Reusable UI components
│       ├── vex_buttons.dart   # Primary, Secondary, Text buttons
│       ├── vex_cards.dart     # Trip card, Seat card
│       ├── vex_inputs.dart    # Location field, Date field
│       ├── vex_loading.dart   # Loading indicators
│       └── vex_seat_widgets.dart # Seat grid, Seat item
├── features/                   # Feature modules (Clean Architecture)
│   ├── home/                  # Home screen + Search
│   ├── search/                # Search results
│   ├── booking/               # Seat selection
│   ├── payment/               # Payment screen
│   └── confirmation/           # Booking confirmation + QR
└── shared/                    # Cross-feature shared code
```

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│          Presentation               │  Screens, Widgets, Providers
├─────────────────────────────────────┤
             (Business Logic)           │  Providers (Riverpod)
├─────────────────────────────────────┤
              Domain                   │  Entities, Business Rules
├─────────────────────────────────────┤
               Data                    │  Mock data, Repositories
└─────────────────────────────────────┘
```

## ✨ Tính năng chính

### 1. Trang chủ (Home Screen)
- Header với gradient background và pattern decoration
- Search card với:
  - Input điểm đi / điểm đến (có nút swap)
  - Date picker để chọn ngày đi
  - Passenger selector (1-10 hành khách)
- Horizontal scrollable popular routes
- Promotions banner

### 2. Tìm kiếm chuyến xe (Search Results)
- Danh sách các chuyến xe phù hợp
- Thông tin chi tiết: nhà xe, giờ khởi hành/đến, thời gian di chuyển
- Giá vé, số ghế trống, rating
- Filter amenities

### 3. Chọn ghế (Seat Selection)
- Bus layout visualization (2 tầng)
- Ghế Standard (trắng) và VIP (xanh lá)
- Ghế đã chọn, ghế trống, ghế đã bán
- Floor selector (tầng 1 / tầng 2)
- Real-time price calculation

### 4. Thông tin hành khách (Passenger Info)
- Form nhập thông tin cho từng ghế đã chọn
- Validation: Họ tên, Số điện thoại, Email, Ghi chú

### 5. Thanh toán (Payment)
- Tổng quan đơn hàng
- Chọn phương thức thanh toán
- Confirmation flow

### 6. Xác nhận (Confirmation)
- Booking code (format: `VX********`)
- QR Code vé
- Chi tiết chuyến xe
- Animation success

## 🎨 Design System

### Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Primary | `#1A237E` | Deep Navy - Brand |
| Secondary | `#2ECC71` | Mint Green - Accent |
| Accent | `#F59E0B` | Amber - Warnings |
| Background | `#F8FAFC` | Light Gray |
| Surface | `#FFFFFF` | Cards |
| Error | `#EF4444` | Error states |
| Success | `#2ECC71` | Success states |

### Typography
- **Font Family**: Lexend (Google Fonts)
- **Display**: 32px / Bold
- **H1-H4**: Headings
- **Body**: 16px / Regular
- **Caption**: 12px

### Spacing System (4px base unit)
- `xxs`: 4px, `xs`: 8px, `sm`: 12px, `md`: 16px
- `lg`: 24px, `xl`: 32px, `xxl`: 48px, `xxxl`: 64px

## 📦 Entities

### TripEntity
```dart
- id, operatorId, operatorName, operatorLogo
- fromCity, toCity
- departureTime, arrivalTime
- busType, availableSeats, price
- rating, amenities
```

### SeatEntity
```dart
- seatNumber, floor
- type: SeatType (standard, vip)
- price
```

### BookingEntity
```dart
- id, trip, seats[], passengers[]
- totalPrice, status, createdAt
- bookingCode: "VX********"
```

### BookingStatus
`pending` → `confirmed` → `completed` | `cancelled`

## 🚀 Chạy dự án

### Yêu cầu
- Flutter SDK 3.10.7+
- Dart SDK 3.10.7+
- Android Studio / VS Code + Flutter extension

### Các bước

```bash
# Clone repository
git clone https://github.com/your-username/vexe_app.git
cd vexe_app

# Install dependencies
flutter pub get

# Run on Android
flutter run

# Run on iOS (macOS only)
flutter run -d ios
```

### Build APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 📁 Cấu trúc GitHub Repository

```
vexe_app/
├── README.md
├── pubspec.yaml
├── pubspec.lock
├── .gitignore
├── analysis_options.yaml
├── metadata/
├── assets/
│   ├── images/
│   └── icons/
├── lib/
│   ├── main.dart
│   ├── core/
│   └── features/
├── test/
├── android/
├── ios/
└── build/
```

## 🎯 Kiến thức thể hiện trong CV

### Đã sử dụng
- ✅ **Flutter Development** - Cross-platform mobile
- ✅ **State Management** - Riverpod (ConsumerWidget, StateNotifier)
- ✅ **Navigation** - GoRouter / Navigator 1.0 hybrid
- ✅ **Clean Architecture** - Separation of concerns
- ✅ **Material Design 3** - Custom theme system
- ✅ **Reusable Widgets** - Component-based design
- ✅ **UI Customization** - Google Fonts, Phosphor Icons
- ✅ **Form Validation** - Passenger info collection
- ✅ **QR Code Generation** - Ticket verification

### Có thể mở rộng
- [ ] API Integration (REST/GraphQL)
- [ ] Authentication (Firebase/Auth)
- [ ] Payment Gateway Integration
- [ ] Push Notifications
- [ ] Unit & Widget Tests
- [ ] Dark Mode support

## 📝 Ghi chú

- Dự án sử dụng **mock data** để simulate API responses
- Assets hiện chỉ chứa placeholder `.gitkeep`
- App có 4 tab bottom navigation: Trang chủ, Chuyến xe, Khuyến mãi, Cá nhân
- Một số màn hình placeholder cần hoàn thiện (My Trips, Promotions, Profile)

## 📄 License

MIT License - feel free to use for portfolio/cv purposes.

---

**Made with ❤️ for internship application**
