import SwiftUI

struct TaskQueueView: View {
    @ObservedObject var webhookManager: WebhookManager
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Active Tasks")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                
                if webhookManager.tasks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No Active Tasks")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(webhookManager.tasks) { task in
                                TaskCard(task: task)
                            }
                        }
                        .padding(16)
                    }
                }
                
                Spacer()
            }
        }
    }
}
