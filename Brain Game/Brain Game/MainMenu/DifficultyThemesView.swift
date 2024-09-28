import SwiftUI

struct DifficultyThemesView: View {
    @Binding var selectedTheme: String
    @Binding var selectedDifficulty: Int
    @Binding var selectedCardBackground: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Выбор темы")) {
                    Picker("Выберите тему", selection: $selectedTheme) {
                        Text("Тема 1").tag("Тема 1")
                        Text("Тема 2").tag("Тема 2")
                        Text("Тема 3").tag("Тема 3")
                        Text("Случайная тема").tag("Рандом")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Выбор сложности")) {
                    Picker("Количество пар карт", selection: $selectedDifficulty) {
                        Text("8 пар").tag(8)
                        Text("12 пар").tag(12)
                        Text("24 пары").tag(24)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Выбор фона")) {
                    Picker("Выберите фон", selection: $selectedCardBackground) {
                        Text("Фон 1").tag("Фон 1")
                        Text("Фон 2").tag("Фон 2")
                        Text("Фон 3").tag("Фон 3")
                        Text("Эко").tag("Фон 0")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Button("Применить настройки") {
                    // Действие при нажатии на кнопку "Применить настройки"
                    print("Выбранная тема: \(selectedTheme), Сложность: \(selectedDifficulty), Фон: \(selectedCardBackground)")
                }
            }
            .navigationTitle("Сложность и Темы")
        }
    }
}

#Preview {
    DifficultyThemesView(selectedTheme: .constant("Тема 1"), selectedDifficulty: .constant(8), selectedCardBackground: .constant("Фон 1"))
}
