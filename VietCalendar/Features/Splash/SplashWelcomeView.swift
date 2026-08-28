import SwiftUI

public struct SplashWelcomeView: View {
    public let onFinished: () -> Void
    
    @State private var isAnimating = false
    @State private var textOpacity = 0.0
    @State private var badgeScale = 0.0
    @State private var rotationAngle = 0.0
    
    public init(onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
    }
    
    public var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color(hex: "#990D0A"), Color(hex: "#DC2626"), Color(hex: "#7F1D1D")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Decorative background glowing circles
            Circle()
                .fill(Color(hex: "#F59E0B").opacity(0.12))
                .frame(width: 420, height: 420)
                .scaleEffect(isAnimating ? 1.15 : 0.85)
                .blur(radius: 20)
            
            VStack(spacing: 24) {
                Spacer()
                
                // Animated Icon Emblem
                ZStack {
                    Circle()
                        .stroke(Color(hex: "#FDE047").opacity(0.6), lineWidth: 4)
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(Color(hex: "#B91C1C"))
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#FEF08A"), Color(hex: "#F59E0B")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .scaleEffect(isAnimating ? 1.05 : 0.95)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.4)
                
                // Welcome Text
                VStack(spacing: 8) {
                    Text("LỊCH VIỆT NAM")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "#FEF08A"))
                        .tracking(2)
                    
                    Text("Âm Dương • Vạn Niên • Giờ Hoàng Đạo")
                        .font(.subheadline.bold())
                        .foregroundColor(.white.opacity(0.9))
                }
                .opacity(textOpacity)
                
                // Greeting Blessing Card
                VStack(spacing: 6) {
                    Text("🌸 Chào Mừng Bạn Đến Với Lịch Việt 🌸")
                        .font(.caption.bold())
                        .foregroundColor(Color(hex: "#FEF08A"))
                    
                    Text("Kính chúc bạn và gia đình\nVạn Sự Như Ý • An Khang Thịnh Vượng")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.95))
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.black.opacity(0.2))
                .cornerRadius(16)
                .opacity(textOpacity)
                
                Spacer()
                
                // Creator Credit Badge (@dev trongtuan)
                HStack(spacing: 6) {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .foregroundColor(Color(hex: "#FDE047"))
                    Text("Phát triển bởi:")
                        .foregroundColor(.white.opacity(0.8))
                    Text("@dev trongtuan")
                        .bold()
                        .foregroundColor(Color(hex: "#FDE047"))
                }
                .font(.footnote)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.25))
                .cornerRadius(20)
                .scaleEffect(badgeScale)
                
                // Enter App Button
                Button(action: onFinished) {
                    HStack {
                        Text("Vào Ứng Dụng")
                            .font(.headline.bold())
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                    }
                    .foregroundColor(Color(hex: "#7F1D1D"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#FEF08A"), Color(hex: "#F59E0B")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
                .opacity(textOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                isAnimating = true
            }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            withAnimation(.easeIn(duration: 0.8).delay(0.3)) {
                textOpacity = 1.0
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.5)) {
                badgeScale = 1.0
            }
            
            // Auto dismiss after 3 seconds if not tapped
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    onFinished()
                }
            }
        }
    }
}
