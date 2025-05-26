import SwiftUI

struct Question26: View {
    @State private var isDropped = false
    @State private var skipCount = 0
    @State private var offset = CGSize.zero
    @State private var pageNumber: String = "٢٦"
    var onNext: () -> Void = {}

    var body: some View {
       
                    if !isDropped {
                        Image("PAGENUMBER")
                            .resizable()
                            .frame(width: 42, height: 42)
                            .overlay(
                                Text("٢٦")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .offset(offset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        self.offset = value.translation
                                    }
                                    .onEnded { value in
                                        // تحقق إذا تم الإسقاط فوق الرقم ٣٣ (حسب إحداثيات الشاشة)
                                        if value.translation.height > 100 && value.translation.height < 300 &&
                                            value.translation.width > 80 && value.translation.width < 200 {
                                            isDropped = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                onNext()
                                            }
                                        } else {
                                            offset = .zero
                                        }
                                    }
                            )
                    } else {
                        // عنصر شفاف بنفس حجم الدائرة ليحافظ على مكان النصوص
                        Color.clear
                            .frame(width: 42, height: 42)
                    }
            
            VStack(spacing: 32) {
                Spacer().frame(height: 40)

                // نص السؤال
                Text("كيف بتحل هذي المعادلة؟")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)

                // المعادلة مع الرقم القابل للإسقاط
                HStack {
                    Spacer()
                    Text("١٠٠٠ +")
                        .font(.custom("BalooBhaijaan2-Medium", size: 32))
                        .foregroundColor(.black)
                    // الرقم ٣٣ القابل للإسقاط عليه
                    Text(isDropped ? "٢٦٣٣" : "٣٣")
                        .font(.custom("BalooBhaijaan2-Medium", size: 32))
                        .foregroundColor(.black)
                        .padding(8)
                    Text("= ١٢٦٣٣")
                        .font(.custom("BalooBhaijaan2-Medium", size: 32))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top, 40)

                Spacer()
            }
        }
    }

#Preview {
    Question26(onNext: {})
}
