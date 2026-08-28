# Ứng Dụng Lịch Việt Nam (VietCalendar) - iOS Swift / SwiftUI

Ứng dụng Lịch Vạn Niên & Âm Dương Lịch Việt Nam hoàn chỉnh cho iOS (iOS 17+), viết hoàn toàn bằng **Swift & SwiftUI** hiện đại.

---

## 🌟 Tính Năng Nổi Bật

1. **Thuật toán Âm Lịch Thiên Văn Học (Hồ Ngọc Đức)**:
   - Tính toán chính xác ngày Âm lịch, Can Chi ngày/tháng/năm (Giáp Thìn, Ất Tỵ...), tháng nhuận cho múi giờ Việt Nam (GMT+7).
   - Chuyển đổi hai chiều Dương Lịch ↔ Âm Lịch.
2. **24 Tiết Khí**:
   - Tự động tính vị trí kinh độ Mặt Trời (Xuân Phân, Thanh Minh, Lập Hạ, Đông Chí, v.v.).
3. **Giờ Hoàng Đạo / Hắc Đạo**:
   - Phân tích 12 canh giờ theo Chi của ngày (Tý, Sửu, Dần, Mão...).
4. **Bộ Dữ Liệu Ngày Lễ Việt Nam Toàn Diện**:
   - Ngày lễ Quốc gia (Tết Nguyên Đán, Giỗ Tổ Hùng Vương, 30/4, 2/9...).
   - Ngày lễ Dân gian & Tôn giáo (Táo Quân, Rằm tháng Giêng, Tết Hàn Thực, Đoan Ngọ, Vu Lan, Trung Thu...).
   - Đánh dấu ngày nghỉ lễ chính thức.
5. **Quản Lý Sự Kiện & Ngày Giỗ Gia Tiên**:
   - Hỗ trợ sự kiện lặp lại theo **Âm lịch hàng năm** (rất tiện để nhớ ngày giỗ).
   - Tích hợp thông báo nhắc nhở qua `UserNotifications`.
6. **Giao Diện SwiftUI Hiện Đại**:
   - Lưới lịch tháng 7 cột trực quan (hiển thị ngày dương to, ngày âm nhỏ).
   - Tự động highlight hôm nay, ngày rằm, mùng 1, ngày lễ, ngày nghỉ.
   - Sheet xem chi tiết ngày và Tab đổi ngày nhanh.

---

## 📁 Cấu Trúc Thư Mục

```
viet_calendar/
├── Package.swift                       # Swift Package Manager manifest
├── VietCalendar/
│   ├── App/
│   │   ├── VietCalendarApp.swift       # Entry point (@main)
│   │   └── ContentView.swift           # TabView điều hướng
│   ├── Core/
│   │   ├── LunarCalendar/
│   │   │   ├── LunarDate.swift         # Data model Âm Lịch & Can Chi
│   │   │   ├── LunarCalendarConverter.swift # Engine thiên văn Hồ Ngọc Đức
│   │   │   ├── SolarTermCalculator.swift    # 24 Tiết Khí
│   │   │   └── AuspiciousHourCalculator.swift # Giờ Hoàng Đạo
│   │   ├── Models/
│   │   │   ├── CalendarDay.swift       # Model ngày trong lịch
│   │   │   ├── Holiday.swift           # Model ngày lễ & phân loại
│   │   │   └── UserEvent.swift         # Model sự kiện / ngày giỗ
│   │   └── Services/
│   │       ├── HolidayService.swift    # Cơ sở dữ liệu ngày lễ VN
│   │       ├── EventService.swift      # Quản lý & lưu trữ sự kiện
│   │       └── NotificationService.swift # Quản lý thông báo iOS
│   ├── Features/
│   │   ├── Calendar/
│   │   │   ├── CalendarView.swift      # Màn hình Lịch Tháng
│   │   │   ├── CalendarViewModel.swift # Logic tính toán lưới 42 ngày
│   │   │   └── DayCellView.swift       # Ô hiển thị từng ngày
│   │   ├── DayDetail/
│   │   │   └── DayDetailView.swift     # Modal xem chi tiết ngày
│   │   ├── Events/
│   │   │   ├── EventListView.swift     # Danh sách sự kiện & ngày giỗ
│   │   │   └── AddEventView.swift      # Form tạo sự kiện
│   │   ├── ConvertDate/
│   │   │   └── ConvertDateView.swift   # Công cụ đổi Âm ↔ Dương lịch
│   │   └── Settings/
│   │       └── SettingsView.swift      # Màn hình cài đặt
│   └── Utils/
│       └── Extensions/
│           ├── Date+Extensions.swift
│           └── Color+Extensions.swift
└── Tests/
    └── VietCalendarTests/
        └── LunarCalendarTests.swift    # Unit test chuyển đổi ngày & tiết khí
```

---

## 🚀 Hướng Dẫn Mở & Chạy Dự Án

### Cách 1: Mở Trực Tiếp Bằng Xcode
1. Mở thư mục `C:\Users\ADMIN\.gemini\antigravity\scratch\viet_calendar` trên máy Mac hoặc kéo toàn bộ thư mục vào Xcode.
2. Xcode sẽ tự động nhận diện `Package.swift` và load toàn bộ dependencies/targets.
3. Chọn Simulator (ví dụ: iPhone 16 Pro) và nhấn **Run (Cmd + R)**.

### Cách 2: Tích Hợp Vào Dự Án iOS Mới
1. Tạo một dự án **iOS App (SwiftUI)** mới trong Xcode.
2. Copy toàn bộ thư mục `VietCalendar` vào source tree của project.
3. Đặt `ContentView()` làm view khởi đầu trong `WindowGroup`.
