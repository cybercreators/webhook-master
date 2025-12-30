import SwiftUI

struct SchedulerView: View {
    @ObservedObject var webhookManager: WebhookManager
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Interval Scheduler")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(webhookManager.tasks) { task in
                            TaskCard(task: task)
                        }
                    }
                    .padding(16)
                }
                
                Spacer()
            }
        }
    }
}

struct TaskCard: View {
    let task: ScheduledTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: task.isRunning ? "play.circle.fill" : "pause.circle")
                    .foregroundColor(task.isRunning ? .green : .gray)
            }
            Text("Every \(task.intervalSeconds)s")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
        .cornerRadius(8)
    }
}
