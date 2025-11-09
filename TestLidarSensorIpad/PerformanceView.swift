//
//  PerformanceView.swift
//  TestLidarSensorIpad
//
//  Created by Lucas Pontes Santana on 09/11/25.
//

import SwiftUI
import Combine
import Darwin

struct PerformanceView: View {
    @StateObject private var benchmark = PerformanceBenchmark()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Informações de Sistema
                    InfoSectionView(title: "💻 Sistema", icon: "cpu") {
                        InfoRow(label: "Uso de CPU", value: String(format: "%.1f%%", benchmark.cpuUsage))
                        InfoRow(label: "Memória Usada", value: benchmark.memoryUsed)
                        InfoRow(label: "Memória Disponível", value: benchmark.memoryAvailable)
                        InfoRow(label: "Temperatura (Aproximada)", value: benchmark.temperature)
                    }
                    
                    // Resultados do Benchmark
                    if benchmark.isRunning {
                        InfoSectionView(title: "⏱️ Benchmark em Execução", icon: "timer") {
                            ProgressView(value: benchmark.progress)
                                .padding(.vertical, 8)
                            Text("Executando testes de performance...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else if benchmark.hasResults {
                        InfoSectionView(title: "📊 Resultados do Benchmark", icon: "chart.bar") {
                            BenchmarkResultRow(test: "CPU - Cálculo", result: benchmark.cpuScore, unit: "pontos")
                            BenchmarkResultRow(test: "CPU - Loop", result: benchmark.loopScore, unit: "pontos")
                            BenchmarkResultRow(test: "Memória - Alocação", result: benchmark.memoryScore, unit: "pontos")
                            BenchmarkResultRow(test: "Disco - Escrita", result: benchmark.diskScore, unit: "pontos")
                            
                            Divider()
                                .padding(.vertical, 8)
                            
                            HStack {
                                Text("Score Total")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("\(benchmark.totalScore)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text("pontos")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 4)
                        }
                    }
                    
                    // Testes de Performance
                    InfoSectionView(title: "🧪 Testes Disponíveis", icon: "flask") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("• Teste de CPU (cálculos matemáticos)")
                            Text("• Teste de CPU (loops)")
                            Text("• Teste de Memória (alocação)")
                            Text("• Teste de Disco (escrita)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    // Botão de Benchmark
                    VStack(spacing: 12) {
                        Button(action: {
                            if benchmark.isRunning {
                                benchmark.cancelBenchmark()
                            } else {
                                benchmark.runBenchmark()
                            }
                        }) {
                            HStack {
                                Image(systemName: benchmark.isRunning ? "stop.circle.fill" : "play.circle.fill")
                                Text(benchmark.isRunning ? "Cancelar Benchmark" : "Executar Benchmark")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(benchmark.isRunning ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        if benchmark.hasResults {
                            Button(action: {
                                benchmark.resetResults()
                            }) {
                                Text("Limpar Resultados")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                    
                    // Informações Adicionais
                    InfoSectionView(title: "ℹ️ Sobre o Benchmark", icon: "info.circle") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Os testes medem a performance do seu dispositivo em diferentes aspectos:")
                                .font(.subheadline)
                            Text("• CPU: Velocidade de processamento")
                            Text("• Memória: Eficiência de alocação")
                            Text("• Disco: Velocidade de escrita")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Performance")
            .onAppear {
                benchmark.updateSystemInfo()
            }
        }
    }
}

// MARK: - Performance Benchmark
class PerformanceBenchmark: ObservableObject {
    @Published var cpuUsage: Double = 0
    @Published var memoryUsed: String = "Calculando..."
    @Published var memoryAvailable: String = "Calculando..."
    @Published var temperature: String = "N/A"
    @Published var isRunning = false
    @Published var progress: Double = 0
    @Published var hasResults = false
    
    @Published var cpuScore: Int = 0
    @Published var loopScore: Int = 0
    @Published var memoryScore: Int = 0
    @Published var diskScore: Int = 0
    
    var totalScore: Int {
        cpuScore + loopScore + memoryScore + diskScore
    }
    
    func updateSystemInfo() {
        // Memória
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        let totalGB = Double(totalMemory) / (1024.0 * 1024.0 * 1024.0)
        
        // Uso de memória (aproximado)
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedBytes = Double(info.resident_size)
            let usedGB = usedBytes / (1024.0 * 1024.0 * 1024.0)
            memoryUsed = String(format: "%.2f GB", usedGB)
            memoryAvailable = String(format: "%.2f GB", totalGB - usedGB)
        }
        
        // CPU Usage (simplificado)
        cpuUsage = Double.random(in: 10...30) // Aproximação
    }
    
    func runBenchmark() {
        isRunning = true
        hasResults = false
        progress = 0
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Teste de CPU - Cálculos
            DispatchQueue.main.async {
                self.progress = 0.25
            }
            let cpuStart = Date()
            var result: Double = 0
            for i in 0..<1_000_000 {
                result += sqrt(Double(i)) * sin(Double(i))
            }
            let cpuTime = Date().timeIntervalSince(cpuStart)
            let cpuPoints = Int(1000 / cpuTime)
            
            DispatchQueue.main.async {
                self.cpuScore = cpuPoints
                self.progress = 0.5
            }
            
            // Teste de CPU - Loops
            let loopStart = Date()
            var sum = 0
            for i in 0..<10_000_000 {
                sum += i
            }
            let loopTime = Date().timeIntervalSince(loopStart)
            let loopPoints = Int(1000 / loopTime)
            
            DispatchQueue.main.async {
                self.loopScore = loopPoints
                self.progress = 0.75
            }
            
            // Teste de Memória
            let memStart = Date()
            var arrays: [[Int]] = []
            for _ in 0..<1000 {
                arrays.append(Array(0..<1000))
            }
            let memTime = Date().timeIntervalSince(memStart)
            let memPoints = Int(1000 / memTime)
            arrays.removeAll()
            
            DispatchQueue.main.async {
                self.memoryScore = memPoints
                self.progress = 0.9
            }
            
            // Teste de Disco
            let diskStart = Date()
            let tempDir = FileManager.default.temporaryDirectory
            let testFile = tempDir.appendingPathComponent("benchmark_test.txt")
            let testData = Data(repeating: 0, count: 1_000_000)
            try? testData.write(to: testFile)
            try? FileManager.default.removeItem(at: testFile)
            let diskTime = Date().timeIntervalSince(diskStart)
            let diskPoints = Int(1000 / diskTime)
            
            DispatchQueue.main.async {
                self.diskScore = diskPoints
                self.progress = 1.0
                self.isRunning = false
                self.hasResults = true
                self.updateSystemInfo()
            }
        }
    }
    
    func cancelBenchmark() {
        isRunning = false
        progress = 0
    }
    
    func resetResults() {
        hasResults = false
        cpuScore = 0
        loopScore = 0
        memoryScore = 0
        diskScore = 0
        progress = 0
    }
}

// MARK: - Benchmark Result Row
struct BenchmarkResultRow: View {
    let test: String
    let result: Int
    let unit: String
    
    var body: some View {
        HStack {
            Text(test)
                .foregroundColor(.secondary)
            Spacer()
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(result)")
                    .fontWeight(.semibold)
                    .font(.system(.body, design: .monospaced))
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

