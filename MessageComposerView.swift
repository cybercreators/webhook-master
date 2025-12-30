import SwiftUI

struct MessageComposerView: View {
    @ObservedObject var webhookManager: WebhookManager
    @State private var messageContent = ""
    @State private var selectedWebhook: WebhookItem?
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 16) {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Webhook")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Picker("Webhook", selection: $selectedWebhook) {
                                Text("Choose a webhook").tag(nil as WebhookItem?)
                                ForEach(webhookManager.webhooks) { webhook in
                                    Text(webhook.label).tag(webhook as WebhookItem?)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                            .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Message Content")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $messageContent)
                                .frame(height: 200)
                                .padding(12)
                                .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(16)
                }
                
                HStack(spacing: 12) {
                    Button(action: { messageContent = "" }) {
                        Text("Clear")
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.20))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if let webhook = selectedWebhook {
                            webhookManager.sendMessage(to: webhook, content: messageContent)
                            messageContent = ""
                        }
                    }) {
                        Text("Send")
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.4, blue: 0.8),
                                    Color(red: 0.6, green: 0.2, blue: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(selectedWebhook == nil || messageContent.isEmpty)
                }
                .padding(16)
            }
        }
    }
}
