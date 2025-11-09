//
//  ContentView.swift
//  TestLidarSensorIpad
//
//  Created by Lucas Pontes Santana on 09/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DeviceInfoView()
                .tabItem {
                    Label("Informações", systemImage: "info.circle")
                }
            
            SensorsView()
                .tabItem {
                    Label("Sensores", systemImage: "sensor.tag.radiowaves.forward")
                }
            
            PerformanceView()
                .tabItem {
                    Label("Performance", systemImage: "speedometer")
                }
        }
    }
}

// MARK: - Header View
struct LIDARHeaderView: View {
    let hasLiDAR: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: hasLiDAR ? "cube.transparent.fill" : "cube.fill")
                .font(.system(size: 70))
                .foregroundStyle(hasLiDAR ? .green : .red)
            
            Text(hasLiDAR ? "LIDAR Detectado ✓" : "LIDAR Não Detectado ✗")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(hasLiDAR ? .green : .red)
            
            Text(hasLiDAR ? "Seu dispositivo possui sensor LIDAR" : "Seu dispositivo não possui sensor LIDAR")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(hasLiDAR ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
        )
    }
}

// MARK: - Info Section View
struct InfoSectionView<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .padding(.bottom, 4)
            
            VStack(spacing: 8) {
                content
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Sensor Row
struct SensorRow: View {
    let name: String
    let available: Bool
    var description: String? = nil
    
    var body: some View {
        HStack {
            Image(systemName: available ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(available ? .green : .red)
                .font(.system(size: 16))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .fontWeight(.medium)
                if let desc = description {
                    Text(desc)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(available ? "Disponível" : "Indisponível")
                .font(.caption)
                .foregroundColor(available ? .green : .red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill((available ? Color.green : Color.red).opacity(0.15))
                )
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    ContentView()
}
