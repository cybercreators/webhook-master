import SwiftUI

@main
struct DiscordSenderApp: App {
    @StateObject private var webhookManager = WebhookManager()
    @State private var selectedTab: TabSelection = .webhooks
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.06, green: 0.08, blue: 0.12),
                        Color(red: 0.08, green: 0.10, blue: 0.16)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Discord Sender")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Webhook Management & Automation")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    // Tab Navigation
                    HStack(spacing: 0) {
                        ForEach(TabSelection.allCases, id: \.self) { tab in
                            VStack(spacing: 8) {
                                Text(tab.label)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(selectedTab == tab ? .white : .gray)
                                
                                if selectedTab == tab {
                                    Capsule()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 1.0, green: 0.4, blue: 0.8),
                                                Color(red: 0.6, green: 0.2, blue: 1.0)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        .frame(height: 3)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = tab
                                }
                            }
                        }
                    }
                    .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    
                    // Content
                    TabView(selection: $selectedTab) {
                        WebhookListView(webhookManager: webhookManager)
                            .tag(TabSelection.webhooks)
                        
                        MessageComposerView(webhookManager: webhookManager)
                            .tag(TabSelection.composer)
                        
                        SchedulerView(webhookManager: webhookManager)
                            .tag(TabSelection.scheduler)
                        
                        TaskQueueView(webhookManager: webhookManager)
                            .tag(TabSelection.tasks)
                        
                        ExecutionLogsView(webhookManager: webhookManager)
                            .tag(TabSelection.logs)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .environmentObject(webhookManager)
        }
    }
}

enum TabSelection: CaseIterable {
    case webhooks
    case composer
    case scheduler
    case tasks
    case logs
    
    var label: String {
        switch self {
        case .webhooks: return "Webhooks"
        case .composer: return "Compose"
        case .scheduler: return "Schedule"
        case .tasks: return "Tasks"
        case .logs: return "Logs"
        }
    }
}

// MARK: - Webhook Manager
class WebhookManager: ObservableObject {
    @Published var webhooks: [WebhookItem] = []
    @Published var messages: [MessageTemplate] = []
    @Published var tasks: [ScheduledTask] = []
    @Published var logs: [ExecutionLog] = []
    
    func addWebhook(label: String, url: String) {
        let webhook = WebhookItem(id: UUID(), label: label, url: url, isActive: true)
        webhooks.append(webhook)
    }
    
    func deleteWebhook(id: UUID) {
        webhooks.removeAll { $0.id == id }
    }
    
    func sendMessage(to webhook: WebhookItem, content: String) {
        let log = ExecutionLog(
            id: UUID(),
            timestamp: Date(),
            status: .pending,
            message: content,
            webhookLabel: webhook.label
        )
        logs.insert(log, at: 0)
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let index = self.logs.firstIndex(where: { $0.id == log.id }) {
                self.logs[index].status = .success
            }
        }
    }
}

// MARK: - Models
struct WebhookItem: Identifiable {
    let id: UUID
    var label: String
    var url: String
    var isActive: Bool
    var lastUsed: Date?
}

struct MessageTemplate: Identifiable {
    let id: UUID
    var name: String
    var content: String
}

struct ScheduledTask: Identifiable {
    let id: UUID
    var name: String
    var webhookId: UUID
    var messageContent: String
    var intervalSeconds: Int
    var isRunning: Bool = false
}

struct ExecutionLog: Identifiable {
    let id: UUID
    let timestamp: Date
    var status: ExecutionStatus
    let message: String
    let webhookLabel: String
}

enum ExecutionStatus {
    case pending
    case success
    case failed
    case rateLimited
    
    var color: Color {
        switch self {
        case .pending: return .yellow
        case .success: return .green
        case .failed: return .red
        case .rateLimited: return .orange
        }
    }
}
