//
//  DeviceInfoView.swift
//  TestLidarSensorIpad
//
//  Created by Lucas Pontes Santana on 09/11/25.
//

import SwiftUI
import ARKit

struct DeviceInfoView: View {
    @State private var deviceInfo: DeviceInfo?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let info = deviceInfo {
                        // Header com LIDAR
                        LIDARHeaderView(hasLiDAR: info.hasLiDAR)
                            .padding(.top)
                        
                        // Layout em duas colunas para iPad
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 20) {
                                // Coluna 1
                                VStack(spacing: 20) {
                                    // Informações do Dispositivo
                                    InfoSectionView(title: "📱 Dispositivo", icon: "ipad") {
                                        InfoRow(label: "Nome", value: info.deviceName)
                                        InfoRow(label: "Modelo", value: info.deviceModel)
                                        InfoRow(label: "Ano", value: info.deviceYear)
                                        InfoRow(label: "Sistema", value: info.systemVersion)
                                    }
                                    
                                    // Hardware
                                    InfoSectionView(title: "⚙️ Hardware", icon: "cpu") {
                                        InfoRow(label: "Processador", value: info.cpuName)
                                        InfoRow(label: "Núcleos", value: info.cpuCores)
                                        InfoRow(label: "Memória RAM", value: info.physicalMemory)
                                        InfoRow(label: "Armazenamento Total", value: info.totalStorage)
                                        InfoRow(label: "Armazenamento Disponível", value: info.availableStorage)
                                    }
                                }
                                
                                // Coluna 2
                                VStack(spacing: 20) {
                                    // Display
                                    InfoSectionView(title: "🖥️ Display", icon: "display") {
                                        InfoRow(label: "Tamanho", value: info.screenSize)
                                        InfoRow(label: "Resolução", value: info.screenResolution)
                                        InfoRow(label: "Escala", value: info.screenScale)
                                        InfoRow(label: "Tipo", value: info.displayType)
                                    }
                                    
                                    // Sensores
                                    InfoSectionView(title: "📡 Sensores", icon: "sensor.tag.radiowaves.forward") {
                                        SensorRow(name: "LIDAR", available: info.hasLiDAR, description: "Scanner a laser para realidade aumentada")
                                        SensorRow(name: "Câmera", available: info.hasCamera)
                                        SensorRow(name: "Giroscópio", available: info.hasGyroscope)
                                        SensorRow(name: "Acelerômetro", available: info.hasAccelerometer)
                                        SensorRow(name: "Magnetômetro", available: info.hasMagnetometer)
                                        SensorRow(name: "Barômetro", available: info.hasBarometer)
                                        SensorRow(name: "Sensor de Proximidade", available: info.hasProximitySensor)
                                        SensorRow(name: "Sensor de Luz Ambiente", available: info.hasAmbientLightSensor)
                                    }
                                }
                            }
                            
                            // ARKit (largura total)
                            InfoSectionView(title: "🥽 ARKit", icon: "arkit") {
                                SensorRow(name: "ARKit Suportado", available: info.arKitSupported)
                                SensorRow(name: "Face Tracking", available: info.faceTrackingSupported)
                                SensorRow(name: "World Tracking", available: info.worldTrackingSupported)
                                SensorRow(name: "Scene Reconstruction", available: info.sceneReconstructionSupported, description: "Reconstrução 3D de cenas")
                            }
                        } else {
                            // Layout para iPhone (coluna única)
                            // Informações do Dispositivo
                            InfoSectionView(title: "📱 Dispositivo", icon: "ipad") {
                                InfoRow(label: "Nome", value: info.deviceName)
                                InfoRow(label: "Modelo", value: info.deviceModel)
                                InfoRow(label: "Ano", value: info.deviceYear)
                                InfoRow(label: "Sistema", value: info.systemVersion)
                            }
                            
                            // Hardware
                            InfoSectionView(title: "⚙️ Hardware", icon: "cpu") {
                                InfoRow(label: "Processador", value: info.cpuName)
                                InfoRow(label: "Núcleos", value: info.cpuCores)
                                InfoRow(label: "Memória RAM", value: info.physicalMemory)
                                InfoRow(label: "Armazenamento Total", value: info.totalStorage)
                                InfoRow(label: "Armazenamento Disponível", value: info.availableStorage)
                            }
                            
                            // Display
                            InfoSectionView(title: "🖥️ Display", icon: "display") {
                                InfoRow(label: "Tamanho", value: info.screenSize)
                                InfoRow(label: "Resolução", value: info.screenResolution)
                                InfoRow(label: "Escala", value: info.screenScale)
                                InfoRow(label: "Tipo", value: info.displayType)
                            }
                            
                            // Sensores
                            InfoSectionView(title: "📡 Sensores", icon: "sensor.tag.radiowaves.forward") {
                                SensorRow(name: "LIDAR", available: info.hasLiDAR, description: "Scanner a laser para realidade aumentada")
                                SensorRow(name: "Câmera", available: info.hasCamera)
                                SensorRow(name: "Giroscópio", available: info.hasGyroscope)
                                SensorRow(name: "Acelerômetro", available: info.hasAccelerometer)
                                SensorRow(name: "Magnetômetro", available: info.hasMagnetometer)
                                SensorRow(name: "Barômetro", available: info.hasBarometer)
                                SensorRow(name: "Sensor de Proximidade", available: info.hasProximitySensor)
                                SensorRow(name: "Sensor de Luz Ambiente", available: info.hasAmbientLightSensor)
                            }
                            
                            // ARKit
                            InfoSectionView(title: "🥽 ARKit", icon: "arkit") {
                                SensorRow(name: "ARKit Suportado", available: info.arKitSupported)
                                SensorRow(name: "Face Tracking", available: info.faceTrackingSupported)
                                SensorRow(name: "World Tracking", available: info.worldTrackingSupported)
                                SensorRow(name: "Scene Reconstruction", available: info.sceneReconstructionSupported, description: "Reconstrução 3D de cenas")
                            }
                        }
                    } else {
                        ProgressView("Carregando informações...")
                            .padding()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Informações")
            .onAppear {
                loadDeviceInfo()
            }
        }
    }
    
    private func loadDeviceInfo() {
        deviceInfo = DeviceInfo.collect()
    }
}

