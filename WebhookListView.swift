import SwiftUI

struct WebhookListView: View {
    @ObservedObject var webhookManager: WebhookManager
    @State private var showAddSheet = false
    @State private var newLabel = ""
    @State private var newURL = ""
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 16) {
                if webhookManager.webhooks.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "link.badge.plus")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No Webhooks")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Add your first Discord webhook to get started")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(webhookManager.webhooks) { webhook in
                                WebhookCard(webhook: webhook, onDelete: {
                                    webhookManager.deleteWebhook(id: webhook.id)
                                })
                            }
                        }
                        .padding(16)
                    }
                }
                
                Button(action: { showAddSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Webhook")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(14)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 1.0, green: 0.4, blue: 0.8),
                            Color(red: 0.6, green: 0.2, blue: 1.0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(16)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddWebhookSheet(isPresented: $showAddSheet, onAdd: { label, url in
                webhookManager.addWebhook(label: label, url: url)
            })
        }
    }
}

struct WebhookCard: View {
    let webhook: WebhookItem
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(webhook.label)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text(webhook.url.prefix(50) + "...")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: webhook.isActive ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(webhook.isActive ? .green : .gray)
            }
            
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Test")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color(red: 0.2, green: 0.3, blue: 0.5))
                        .cornerRadius(6)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color(red: 0.3, green: 0.1, blue: 0.1))
                        .cornerRadius(6)
                }
            }
        }
        .padding(14)
        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
        .cornerRadius(10)
    }
}

struct AddWebhookSheet: View {
    @Binding var isPresented: Bool
    let onAdd: (String, String) -> Void
    @State private var label = ""
    @State private var url = ""
    
    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Add Webhook")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 12) {
                    TextField("Label", text: $label)
                        .padding(12)
                        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    
                    TextField("Webhook URL", text: $url)
                        .padding(12)
                        .background(Color(red: 0.10, green: 0.12, blue: 0.18))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 12) {
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.20))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        onAdd(label, url)
                        isPresented = false
                    }) {
                        Text("Add")
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
                }
                
                Spacer()
            }
            .padding(20)
        }
    }
}
