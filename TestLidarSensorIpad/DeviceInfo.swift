//
//  DeviceInfo.swift
//  TestLidarSensorIpad
//
//  Created by Lucas Pontes Santana on 09/11/25.
//

import Foundation
import UIKit
import ARKit
import CoreMotion
import Darwin

struct DeviceInfo {
    // Informações Básicas
    var deviceName: String
    var deviceModel: String
    var deviceYear: String
    var systemVersion: String
    var systemName: String
    
    // Hardware
    var cpuName: String
    var cpuCores: String
    var physicalMemory: String
    var totalStorage: String
    var availableStorage: String
    
    // Display
    var screenSize: String
    var screenResolution: String
    var screenScale: String
    var displayType: String
    
    // Sensores
    var hasLiDAR: Bool
    var hasCamera: Bool
    var hasGyroscope: Bool
    var hasAccelerometer: Bool
    var hasMagnetometer: Bool
    var hasBarometer: Bool
    var hasProximitySensor: Bool
    var hasAmbientLightSensor: Bool
    
    // ARKit
    var arKitSupported: Bool
    var faceTrackingSupported: Bool
    var worldTrackingSupported: Bool
    var sceneReconstructionSupported: Bool
    
    static func collect() -> DeviceInfo {
        let device = UIDevice.current
        let screen = UIScreen.main
        let deviceIdentifier = getDeviceIdentifier()
        let deviceModel = getReadableDeviceModel(deviceIdentifier)
        
        // Criar uma única instância de CMMotionManager para evitar múltiplas inicializações
        let motionManager = CMMotionManager()
        
        return DeviceInfo(
            deviceName: device.name,
            deviceModel: deviceModel,
            deviceYear: getDeviceYear(identifier: deviceIdentifier, model: deviceModel),
            systemVersion: "\(device.systemName) \(device.systemVersion)",
            systemName: device.systemName,
            cpuName: getCPUName(identifier: deviceIdentifier),
            cpuCores: getCPUCores(),
            physicalMemory: getPhysicalMemory(),
            totalStorage: getTotalStorage(),
            availableStorage: getAvailableStorage(),
            screenSize: getScreenSize(),
            screenResolution: getScreenResolution(),
            screenScale: "\(Int(screen.scale))x",
            displayType: getDisplayType(),
            hasLiDAR: ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification),
            hasCamera: UIImagePickerController.isSourceTypeAvailable(.camera),
            hasGyroscope: motionManager.isGyroAvailable,
            hasAccelerometer: motionManager.isAccelerometerAvailable,
            hasMagnetometer: motionManager.isMagnetometerAvailable,
            hasBarometer: CMAltimeter.isRelativeAltitudeAvailable(),
            hasProximitySensor: device.isProximityMonitoringEnabled,
            hasAmbientLightSensor: true, // Assumido como sempre disponível em dispositivos modernos
            arKitSupported: ARWorldTrackingConfiguration.isSupported,
            faceTrackingSupported: ARFaceTrackingConfiguration.isSupported,
            worldTrackingSupported: ARWorldTrackingConfiguration.isSupported,
            sceneReconstructionSupported: ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification)
        )
    }
    
    private static func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0)
            }
        }
        return modelCode ?? UIDevice.current.model
    }
    
    // MARK: - Helper Functions
    
    private static func getReadableDeviceModel(_ identifier: String) -> String {
        let deviceModels: [String: String] = [
            // iPad Pro
            "iPad13,4": "iPad Pro 12.9\" (5ª geração)",
            "iPad13,5": "iPad Pro 12.9\" (5ª geração)",
            "iPad13,6": "iPad Pro 11\" (3ª geração)",
            "iPad13,7": "iPad Pro 11\" (3ª geração)",
            "iPad13,8": "iPad Pro 12.9\" (6ª geração)",
            "iPad13,9": "iPad Pro 12.9\" (6ª geração)",
            "iPad13,10": "iPad Pro 11\" (M4)",
            "iPad13,11": "iPad Pro 11\" (M4)",
            "iPad13,16": "iPad Pro 11\" (M4)",
            "iPad13,17": "iPad Pro 11\" (M4)",
            "iPad13,12": "iPad Pro 13\" (M4)",
            "iPad13,13": "iPad Pro 13\" (M4)",
            "iPad13,14": "iPad Pro 13\" (M4)",
            "iPad13,15": "iPad Pro 13\" (M4)",
            "iPad8,1": "iPad Pro 11\" (1ª geração)",
            "iPad8,2": "iPad Pro 11\" (1ª geração)",
            "iPad8,3": "iPad Pro 11\" (1ª geração)",
            "iPad8,4": "iPad Pro 11\" (1ª geração)",
            "iPad8,5": "iPad Pro 12.9\" (3ª geração)",
            "iPad8,6": "iPad Pro 12.9\" (3ª geração)",
            "iPad8,7": "iPad Pro 12.9\" (3ª geração)",
            "iPad8,8": "iPad Pro 12.9\" (3ª geração)",
            "iPad8,9": "iPad Pro 11\" (2ª geração)",
            "iPad8,10": "iPad Pro 11\" (2ª geração)",
            "iPad8,11": "iPad Pro 12.9\" (4ª geração)",
            "iPad8,12": "iPad Pro 12.9\" (4ª geração)",
            // iPad Air
            "iPad13,18": "iPad Air 13\" (M2)",
            "iPad13,19": "iPad Air 13\" (M2)",
            "iPad13,1": "iPad Air (4ª geração)",
            "iPad13,2": "iPad Air (4ª geração)",
            // iPhone
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone16,1": "iPhone 15 Pro",
            "iPhone16,2": "iPhone 15 Pro Max",
            "iPhone17,1": "iPhone 16 Pro",
            "iPhone17,2": "iPhone 16 Pro Max",
            "iPhone17,3": "iPhone 16 Pro Max"
        ]
        
        return deviceModels[identifier] ?? identifier
    }
    
    private static func getDeviceYear(identifier: String, model: String) -> String {
        // Anos baseados no identificador do dispositivo
        let yearMap: [String: String] = [
            // iPad Pro M4 (2024)
            "iPad13,10": "2024", "iPad13,11": "2024", "iPad13,12": "2024", "iPad13,13": "2024",
            "iPad13,14": "2024", "iPad13,15": "2024", "iPad13,16": "2024", "iPad13,17": "2024",
            // iPad Pro M2 (2022)
            "iPad13,6": "2022", "iPad13,7": "2022", "iPad13,8": "2022", "iPad13,9": "2022",
            // iPad Pro M1 (2021)
            "iPad13,4": "2021", "iPad13,5": "2021",
            // iPad Pro A12Z (2020)
            "iPad8,9": "2020", "iPad8,10": "2020", "iPad8,11": "2020", "iPad8,12": "2020",
            // iPad Pro A12X (2018)
            "iPad8,1": "2018", "iPad8,2": "2018", "iPad8,3": "2018", "iPad8,4": "2018",
            "iPad8,5": "2018", "iPad8,6": "2018", "iPad8,7": "2018", "iPad8,8": "2018",
            // iPad Air M2 (2024)
            "iPad13,18": "2024", "iPad13,19": "2024",
            // iPad Air (4ª geração) - 2020
            "iPad13,1": "2020", "iPad13,2": "2020",
            // iPhone com LIDAR
            "iPhone14,2": "2021", "iPhone14,3": "2021",
            "iPhone15,2": "2022", "iPhone15,3": "2022",
            "iPhone16,1": "2023", "iPhone16,2": "2023",
            "iPhone17,1": "2024", "iPhone17,2": "2024", "iPhone17,3": "2024"
        ]
        
        if let year = yearMap[identifier] {
            return year
        }
        
        // Fallback baseado no modelo
        if model.contains("M4") {
            return "2024"
        } else if model.contains("M2") {
            return "2022"
        } else if model.contains("M1") {
            return "2021"
        }
        
        return "Desconhecido"
    }
    
    private static func getCPUName(identifier: String) -> String {
        // Mapeamento de identificadores para CPUs
        let cpuMap: [String: String] = [
            // iPad Pro M4
            "iPad13,10": "Apple M4", "iPad13,11": "Apple M4", "iPad13,12": "Apple M4",
            "iPad13,13": "Apple M4", "iPad13,14": "Apple M4", "iPad13,15": "Apple M4",
            "iPad13,16": "Apple M4", "iPad13,17": "Apple M4",
            // iPad Pro M2
            "iPad13,6": "Apple M2", "iPad13,7": "Apple M2", "iPad13,8": "Apple M2", "iPad13,9": "Apple M2",
            // iPad Pro M1
            "iPad13,4": "Apple M1", "iPad13,5": "Apple M1",
            // iPad Pro A12Z
            "iPad8,9": "Apple A12Z", "iPad8,10": "Apple A12Z", "iPad8,11": "Apple A12Z", "iPad8,12": "Apple A12Z",
            // iPad Pro A12X
            "iPad8,1": "Apple A12X", "iPad8,2": "Apple A12X", "iPad8,3": "Apple A12X", "iPad8,4": "Apple A12X",
            "iPad8,5": "Apple A12X", "iPad8,6": "Apple A12X", "iPad8,7": "Apple A12X", "iPad8,8": "Apple A12X",
            // iPad Air M2
            "iPad13,18": "Apple M2", "iPad13,19": "Apple M2",
            // iPad Air (4ª geração) - A14 Bionic
            "iPad13,1": "Apple A14 Bionic", "iPad13,2": "Apple A14 Bionic",
            // iPhone
            "iPhone14,2": "Apple A15 Bionic", "iPhone14,3": "Apple A15 Bionic",
            "iPhone15,2": "Apple A16 Bionic", "iPhone15,3": "Apple A16 Bionic",
            "iPhone16,1": "Apple A17 Pro", "iPhone16,2": "Apple A17 Pro",
            "iPhone17,1": "Apple A18 Pro", "iPhone17,2": "Apple A18 Pro", "iPhone17,3": "Apple A18 Pro"
        ]
        
        if let cpu = cpuMap[identifier] {
            return cpu
        }
        
        // Tentar detectar pelo identificador
        if identifier.contains("iPad13") {
            if identifier.contains("iPad13,10") || identifier.contains("iPad13,12") {
                return "Apple M4"
            } else if identifier.contains("iPad13,6") || identifier.contains("iPad13,8") {
                return "Apple M2"
            } else {
                return "Apple M1"
            }
        } else if identifier.contains("iPad8") {
            return "Apple A12Z / A12X"
        }
        
        return "Apple Silicon"
    }
    
    private static func getCPUCores() -> String {
        var cores: Int32 = 0
        var size = MemoryLayout<Int32>.size
        sysctlbyname("hw.ncpu", &cores, &size, nil, 0)
        return "\(cores) cores"
    }
    
    private static func getPhysicalMemory() -> String {
        let totalBytes = ProcessInfo.processInfo.physicalMemory
        let totalGB = Double(totalBytes) / (1024.0 * 1024.0 * 1024.0)
        return String(format: "%.1f GB", totalGB)
    }
    
    private static func getTotalStorage() -> String {
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let totalSize = attributes[.systemSize] as? NSNumber {
            let totalGB = Double(totalSize.int64Value) / (1024.0 * 1024.0 * 1024.0)
            return String(format: "%.1f GB", totalGB)
        }
        return "N/A"
    }
    
    private static func getAvailableStorage() -> String {
        if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let freeSize = attributes[.systemFreeSize] as? NSNumber {
            let freeGB = Double(freeSize.int64Value) / (1024.0 * 1024.0 * 1024.0)
            return String(format: "%.1f GB", freeGB)
        }
        return "N/A"
    }
    
    private static func getScreenSize() -> String {
        let screen = UIScreen.main
        let width = screen.bounds.width
        let height = screen.bounds.height
        let diagonal = sqrt(width * width + height * height) / 72.0 // 72 points per inch (aproximado)
        return String(format: "%.1f\"", diagonal)
    }
    
    private static func getScreenResolution() -> String {
        let screen = UIScreen.main
        let nativeBounds = screen.nativeBounds
        return "\(Int(nativeBounds.width)) × \(Int(nativeBounds.height))"
    }
    
    private static func getDisplayType() -> String {
        let screen = UIScreen.main
        if #available(iOS 16.0, *) {
            if screen.maximumFramesPerSecond >= 120 {
                return "ProMotion (até 120Hz)"
            }
        }
        return "Liquid Retina"
    }
}

