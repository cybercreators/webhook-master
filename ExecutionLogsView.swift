import SwiftUI

struct ExecutionLogsView: View {
    @ObservedObject var webhookManager: WebhookManager
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Execution Logs")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(webhookManager.logs) { log in
                            LogEntry(log: log)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }
}

struct LogEntry: View {
    let log: ExecutionLog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(log.webhookLabel)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text(log.timestamp.formatted(date: .abbreviated, time: .standard))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                Circle()
                    .fill(log.status.color)
                    .frame(width: 8, height: 8)
            }
            
            Text(log.message.prefix(100) + (log.message.count > 100 ? "..." : ""))
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .padding(12)
        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
        .cornerRadius(8)
    }
}
