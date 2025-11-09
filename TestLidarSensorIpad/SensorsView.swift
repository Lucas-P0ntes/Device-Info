//
//  SensorsView.swift
//  TestLidarSensorIpad
//
//  Created by Lucas Pontes Santana on 09/11/25.
//

import SwiftUI
import Combine
import CoreMotion

struct SensorsView: View {
    @StateObject private var motionManager = MotionSensorManager()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Status dos Sensores
                    InfoSectionView(title: "📡 Status dos Sensores", icon: "sensor.tag.radiowaves.forward") {
                        SensorStatusRow(name: "Acelerômetro", isActive: motionManager.isAccelerometerActive, available: motionManager.isAccelerometerAvailable)
                        SensorStatusRow(name: "Giroscópio", isActive: motionManager.isGyroActive, available: motionManager.isGyroAvailable)
                        SensorStatusRow(name: "Magnetômetro", isActive: motionManager.isMagnetometerActive, available: motionManager.isMagnetometerAvailable)
                    }
                    
                    // Dados do Acelerômetro
                    if motionManager.isAccelerometerAvailable {
                        InfoSectionView(title: "📊 Acelerômetro", icon: "arrow.up.and.down") {
                            SensorDataRow(label: "X", value: String(format: "%.3f", motionManager.acceleration.x), unit: "g")
                            SensorDataRow(label: "Y", value: String(format: "%.3f", motionManager.acceleration.y), unit: "g")
                            SensorDataRow(label: "Z", value: String(format: "%.3f", motionManager.acceleration.z), unit: "g")
                            SensorDataRow(label: "Magnitude", value: String(format: "%.3f", motionManager.accelerationMagnitude), unit: "g")
                        }
                    }
                    
                    // Dados do Giroscópio
                    if motionManager.isGyroAvailable {
                        InfoSectionView(title: "🌀 Giroscópio", icon: "arrow.triangle.2.circlepath") {
                            SensorDataRow(label: "X", value: String(format: "%.3f", motionManager.rotationRate.x), unit: "rad/s")
                            SensorDataRow(label: "Y", value: String(format: "%.3f", motionManager.rotationRate.y), unit: "rad/s")
                            SensorDataRow(label: "Z", value: String(format: "%.3f", motionManager.rotationRate.z), unit: "rad/s")
                            SensorDataRow(label: "Magnitude", value: String(format: "%.3f", motionManager.rotationMagnitude), unit: "rad/s")
                        }
                    }
                    
                    // Dados do Magnetômetro
                    if motionManager.isMagnetometerAvailable {
                        InfoSectionView(title: "🧲 Magnetômetro", icon: "location.north") {
                            SensorDataRow(label: "X", value: String(format: "%.3f", motionManager.magneticField.x), unit: "μT")
                            SensorDataRow(label: "Y", value: String(format: "%.3f", motionManager.magneticField.y), unit: "μT")
                            SensorDataRow(label: "Z", value: String(format: "%.3f", motionManager.magneticField.z), unit: "μT")
                            SensorDataRow(label: "Magnitude", value: String(format: "%.3f", motionManager.magneticMagnitude), unit: "μT")
                        }
                    }
                    
                    // Atitude do Dispositivo
                    if motionManager.isDeviceMotionAvailable {
                        InfoSectionView(title: "📐 Atitude", icon: "move.3d") {
                            SensorDataRow(label: "Roll", value: String(format: "%.2f°", motionManager.attitudeRoll * 180 / .pi), unit: "")
                            SensorDataRow(label: "Pitch", value: String(format: "%.2f°", motionManager.attitudePitch * 180 / .pi), unit: "")
                            SensorDataRow(label: "Yaw", value: String(format: "%.2f°", motionManager.attitudeYaw * 180 / .pi), unit: "")
                        }
                    }
                    
                    // Controles
                    VStack(spacing: 12) {
                        Button(action: {
                            if motionManager.isMonitoring {
                                motionManager.stopMonitoring()
                            } else {
                                motionManager.startMonitoring()
                            }
                        }) {
                            HStack {
                                Image(systemName: motionManager.isMonitoring ? "stop.circle.fill" : "play.circle.fill")
                                Text(motionManager.isMonitoring ? "Parar Monitoramento" : "Iniciar Monitoramento")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(motionManager.isMonitoring ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        if motionManager.isMonitoring {
                            Text("Atualizando em tempo real...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Sensores")
        }
    }
}

// MARK: - Motion Sensor Manager
class MotionSensorManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
    @Published var isAccelerometerActive = false
    @Published var isGyroActive = false
    @Published var isMagnetometerActive = false
    @Published var isMonitoring = false
    
    @Published var acceleration = CMAcceleration(x: 0, y: 0, z: 0)
    @Published var rotationRate = CMRotationRate(x: 0, y: 0, z: 0)
    @Published var magneticField = CMMagneticField(x: 0, y: 0, z: 0)
    
    // Atitude como valores separados para evitar problemas de inicialização
    @Published var attitudeRoll: Double = 0
    @Published var attitudePitch: Double = 0
    @Published var attitudeYaw: Double = 0
    
    var isAccelerometerAvailable: Bool { motionManager.isAccelerometerAvailable }
    var isGyroAvailable: Bool { motionManager.isGyroAvailable }
    var isMagnetometerAvailable: Bool { motionManager.isMagnetometerAvailable }
    var isDeviceMotionAvailable: Bool { motionManager.isDeviceMotionAvailable }
    
    var accelerationMagnitude: Double {
        sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
    }
    
    var rotationMagnitude: Double {
        sqrt(rotationRate.x * rotationRate.x + rotationRate.y * rotationRate.y + rotationRate.z * rotationRate.z)
    }
    
    var magneticMagnitude: Double {
        sqrt(magneticField.x * magneticField.x + magneticField.y * magneticField.y + magneticField.z * magneticField.z)
    }
    
    func startMonitoring() {
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.gyroUpdateInterval = 0.1
        motionManager.magnetometerUpdateInterval = 0.1
        motionManager.deviceMotionUpdateInterval = 0.1
        
        // Acelerômetro
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
                guard let data = data else { return }
                self?.acceleration = data.acceleration
                self?.isAccelerometerActive = true
            }
        }
        
        // Giroscópio
        if motionManager.isGyroAvailable {
            motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
                guard let data = data else { return }
                self?.rotationRate = data.rotationRate
                self?.isGyroActive = true
            }
        }
        
        // Magnetômetro
        if motionManager.isMagnetometerAvailable {
            motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
                guard let data = data else { return }
                self?.magneticField = data.magneticField
                self?.isMagnetometerActive = true
            }
        }
        
        // Device Motion (Atitude)
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
                guard let data = data else { return }
                self?.attitudeRoll = data.attitude.roll
                self?.attitudePitch = data.attitude.pitch
                self?.attitudeYaw = data.attitude.yaw
            }
        }
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        
        isAccelerometerActive = false
        isGyroActive = false
        isMagnetometerActive = false
        isMonitoring = false
        
        // Resetar valores de atitude
        attitudeRoll = 0
        attitudePitch = 0
        attitudeYaw = 0
    }
}

// MARK: - Sensor Status Row
struct SensorStatusRow: View {
    let name: String
    let isActive: Bool
    let available: Bool
    
    var body: some View {
        HStack {
            Image(systemName: available ? (isActive ? "checkmark.circle.fill" : "circle") : "xmark.circle.fill")
                .foregroundColor(available ? (isActive ? .green : .orange) : .red)
            
            Text(name)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(available ? (isActive ? "Ativo" : "Disponível") : "Indisponível")
                .font(.caption)
                .foregroundColor(available ? (isActive ? .green : .orange) : .red)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill((available ? (isActive ? Color.green : Color.orange) : Color.red).opacity(0.15))
                )
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Sensor Data Row
struct SensorDataRow: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .fontWeight(.semibold)
                    .font(.system(.body, design: .monospaced))
                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

