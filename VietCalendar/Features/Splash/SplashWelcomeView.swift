import SwiftUI

public struct SplashWelcomeView: View {
    public let onFinished: () -> Void
    
    // Animation states
    @State private var pageNumber = 1
    @State private var flipAngle: Double = 0
    @State private var calendarScale: CGFloat = 0.8
    @State private var calendarOpacity: Double = 0.0
    @State private var titleOpacity: Double = 0.0
    @State private var authorOpacity: Double = 0.0
    @State private var progressWidth: CGFloat = 0.0
    
    // Sample flipping days
    private let flipDays = [
        (day: "26", lunar: "15/7", weekday: "THỨ HAI"),
        (day: "27", lunar: "16/7", weekday: "THỨ BA"),
        (day: "28", lunar: "17/7", weekday: "THỨ TƯ"),
        (day: "29", lunar: "18/7", weekday: "THỨ NĂM"),
        (day: "01", lunar: "MÙNG 1", weekday: "HÔM NAY")
    ]
    
    public init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
    }
    
    public var body: some View {
        ZStack {
            // Nền tối giản, sang trọng chuẩn Apple iOS (Deep Onyx / Slate)
            Color(hex: "#0F172A")
                .ignoresSafeArea()
            
            // Subtle ambient light
            RadialGradient(
                colors: [Color(hex: "#DC2626").opacity(0.2), Color.clear],
                center: .center,
                startRadius: 20,
                endRadius: 300
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                Spacer()
                
                // MARK: - 3D Flipping Calendar Bloc (Cuốn Lịch Lật Trang)
                ZStack {
                    // Bóng đổ phía dưới cuốn lịch
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.black.opacity(0.4))
                        .frame(width: 200, height: 230)
                        .offset(y: 12)
                        .blur(radius: 14)
                    
                    // Thân cuốn lịch (Lịch Bloc)
                    VStack(spacing: 0) {
                        // Đầu ghim bloc lịch màu đỏ mận viền vàng
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(hex: "#991B1B"), Color(hex: "#DC2626")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: 52)
                            
                            // 2 ghim khoen kim loại treo lịch
                            HStack(spacing: 70) {
                                Circle()
                                    .fill(Color(hex: "#FDE047"))
                                    .frame(width: 14, height: 14)
                                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 2))
                                Circle()
                                    .fill(Color(hex: "#FDE047"))
                                    .frame(width: 14, height: 14)
                                    .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 2))
                            }
                        }
                        
                        // Ruột tờ lịch trắng với số ngày lật trang
                        ZStack {
                            Rectangle()
                                .fill(Color(hex: "#F8FAFC"))
                            
                            VStack(spacing: 4) {
                                Text(currentDayData.weekday)
                                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(hex: "#DC2626"))
                                    .padding(.top, 12)
                                
                                Text(currentDayData.day)
                                    .font(.system(size: 68, weight: .heavy, design: .rounded))
                                    .foregroundColor(Color(hex: "#0F172A"))
                                    .lineLimit(1)
                                
                                Text("Âm lịch: \(currentDayData.lunar)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(hex: "#64748B"))
                                    .padding(.bottom, 12)
                            }
                        }
                        .frame(height: 160)
                    }
                    .frame(width: 200, height: 212)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1.5)
                    )
                    // Hiệu ứng lật trang 3D
                    .rotation3DEffect(
                        .degrees(flipAngle),
                        axis: (x: 1.0, y: 0.0, z: 0.0),
                        perspective: 0.5
                    )
                }
                .scaleEffect(calendarScale)
                .opacity(calendarOpacity)
                
                // MARK: - Typography (Tối giản, chuyên nghiệp)
                VStack(spacing: 8) {
                    Text("LỊCH VIỆT NAM")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(3)
                        .opacity(titleOpacity)
                    
                    Text("by trongtuandev")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(Color(hex: "#94A3B8"))
                        .opacity(authorOpacity)
                }
                
                Spacer()
                
                // Thanh progress chạy mượt đáy màn hình trong đúng 5s
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 3)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#DC2626"), Color(hex: "#F59E0B")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: progressWidth, height: 3)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 60)
                }
                .frame(height: 10)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            startAnimationSequence()
        }
    }
    
    private var currentDayData: (day: String, lunar: String, weekday: String) {
        let index = min(pageNumber - 1, flipDays.count - 1)
        return flipDays[max(0, index)]
    }
    
    private func startAnimationSequence() {
        // 1. Cuốn lịch xuất hiện mượt mà (0.0s -> 0.5s)
        withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
            calendarOpacity = 1.0
            calendarScale = 1.0
        }
        
        // 2. Chữ "LỊCH VIỆT NAM" hiện lên (0.4s)
        withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
            titleOpacity = 1.0
        }
        
        // 3. Chữ "by trongtuandev" hiện lên (0.8s)
        withAnimation(.easeOut(duration: 0.6).delay(0.8)) {
            authorOpacity = 1.0
        }
        
        // 4. Thanh progress chạy đầy trong đúng 5.0 giây
        withAnimation(.linear(duration: 4.8)) {
            progressWidth = UIScreen.main.bounds.width - 120
        }
        
        // 5. Hiệu ứng lật trang lịch chạy chạy liên tục (0.8s -> 4.2s)
        let flipIntervals: [Double] = [0.8, 1.5, 2.2, 2.9, 3.6]
        for (i, time) in flipIntervals.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                // Lật trang
                withAnimation(.easeInOut(duration: 0.25)) {
                    flipAngle = -20
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    pageNumber = i + 1
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                        flipAngle = 0
                    }
                }
            }
        }
        
        // 6. Đúng 5.0 giây: Tự động chuyển thẳng vào trang chủ không cần bấm nút
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                onFinished()
            }
        }
    }
}
