import SwiftUI

struct GameView: View {
    var selectedTheme: String
    var selectedDifficulty: Int
    var selectedCardBackground: String
    
    @State private var emojis: [String] = []
    @State private var cardPairs: [Card] = []
    @State private var flippedCards: [Card] = []
    @State private var score = 0               // Счет для текущей игры
    @State private var totalScore = 0           // Общий счет, который будет суммироваться
    @State private var isMusicOn = true
    @State private var showingSettings = false
    @State private var showingConfirmation = false
    @State private var gameFinished = false
    @State private var isCardFlipping = false
    @State private var isCardInteractionEnabled = true
    @State private var hintCount = 1 // Количество подсказок
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Устанавливаем фон на основе выбранного значения
            BackgroundView(selectedBackground: selectedCardBackground) // Добавление анимированного фона
            
            VStack {
                // Панель с кнопками всегда сверху
                HStack {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                            .font(.title)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        showingConfirmation = true
                    }) {
                        Text("Вернуться")
                            .font(.title2)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        shuffleCards()
                    }) {
                        Image(systemName: "arrow.2.circlepath")
                            .font(.title)
                            .padding()
                    }
                    Spacer()
                    
                    // Кнопка с подсказкой (HintView)
                    HintView(cards: $cardPairs, hintCount: $hintCount)
                }
                .background(Color.white.opacity(0.8))
                .shadow(radius: 5)
                .padding(.horizontal)
                .padding(.top, 5)
                
                // Текстовые элементы
                VStack(spacing: 10) {
                    Text("Выбранная тема: \(selectedTheme)")
                        .font(.largeTitle)
                        .padding(.top, 20)
                    
                    Text("Текущий счет: \(score)")       // Показываем счет текущей игры
                        .font(.title)
                        .padding(.bottom, 5)
                    
                    Text("Общий счет: \(totalScore)")    // Показываем общий накопленный счет
                        .font(.title)
                        .padding(.bottom, 5)
                }
                
                // Создание карточек
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                    ForEach(cardPairs) { card in
                        CardView(card: card) {
                            if isCardInteractionEnabled {
                                onCardTapped(card)
                            }
                        }
                    }
                }
                .padding()
                .onAppear {
                    generateCards()
                    if isMusicOn {
                        SoundPlayerMainGame.playMusic()
                    }
                }
                
                Spacer()
                
                // Проверка на завершение игры
                if gameFinished {
                    VStack {
                        Text("Поздравляем! Вы победили!")
                            .font(.largeTitle)
                            .padding()
                        
                        HStack {
                            Button("Вернуться в главное меню") {
                                SoundPlayerMainGame.stopMusic()
                                presentationMode.wrappedValue.dismiss()
                            }
                            .padding()
                            
                            Button("Продолжить игру") {
                                resetGame()
                            }
                            .padding()
                        }
                    }
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
            }
            .navigationTitle("Игра на память")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingSettings) {
                GameSettingsView(isMusicOn: $isMusicOn)
            }
            .alert(isPresented: $showingConfirmation) {
                Alert(
                    title: Text("Подтверждение"),
                    message: Text("Вы уверены, что хотите вернуться в главное меню?"),
                    primaryButton: .destructive(Text("Да")) {
                        SoundPlayerMainGame.stopMusic()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func onCardTapped(_ tappedCard: Card) {
        guard !isCardFlipping, flippedCards.count < 2, !tappedCard.isFaceUp, !tappedCard.isTransparent else { return }
        
        var updatedCard = tappedCard
        updatedCard.isFaceUp = true
        
        if let index = cardPairs.firstIndex(where: { $0.id == updatedCard.id }) {
            cardPairs[index] = updatedCard
        }
        
        flippedCards.append(updatedCard)
        
        if flippedCards.count == 2 {
            isCardFlipping = true
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        let firstCard = flippedCards[0]
        let secondCard = flippedCards[1]
        
        if firstCard.emoji == secondCard.emoji {
            withAnimation {
                //Совпадение
                score += 1
                removeMatchedCards(firstCard: firstCard, secondCard: secondCard)
            }
        } else {
            //Ошибка
            score -= 2  // Вычитаем 2 очка за ошибку
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                hideUnmatchedCards(firstCard: firstCard, secondCard: secondCard)
            }
        }
        flippedCards.removeAll()
    }
    
    private func removeMatchedCards(firstCard: Card, secondCard: Card) {
        if let index1 = cardPairs.firstIndex(where: { $0.id == firstCard.id }),
           let index2 = cardPairs.firstIndex(where: { $0.id == secondCard.id }) {
            withAnimation {
                // Перемещение карточек за пределы экрана с анимацией
                cardPairs[index1].offset = CGSize(width: 1000, height: 0)
                cardPairs[index2].offset = CGSize(width: 1000, height: 0)
                
                // Начинаем делать карточки прозрачными во время анимации
                withAnimation(.easeInOut(duration: 0.5)) {
                    cardPairs[index1].opacity = 0
                    cardPairs[index2].opacity = 0
                }
                
                // Проверка на завершение игры
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Увеличенный таймер перед исчезновением
                    cardPairs[index1].isTransparent = true
                    cardPairs[index2].isTransparent = true
                    cardPairs[index1].offset = .zero
                    cardPairs[index2].offset = .zero
                    isCardFlipping = false
                    
                    // Проверяем, завершена ли игра
                    if cardPairs.allSatisfy({ $0.isTransparent }) {
                        gameFinished = true
                    }
                }
            }
        }
    }
    
    private func hideUnmatchedCards(firstCard: Card, secondCard: Card) {
        if let index1 = cardPairs.firstIndex(where: { $0.id == firstCard.id }),
           let index2 = cardPairs.firstIndex(where: { $0.id == secondCard.id }) {
            withAnimation {
                cardPairs[index1].isFaceUp = false
                cardPairs[index2].isFaceUp = false
                isCardFlipping = false
            }
        }
    }
    
    private func generateCards() {
        switch selectedTheme {
        case "Тема 1":
            emojis = ["🍎", "🍌", "🍇", "🍊", "🍉", "🍓", "🍈", "🍒", "🍑", "🍍", "🥭", "🥝"]
        case "Тема 2":
            emojis = ["🐶", "🐱", "🐰", "🦊", "🐻", "🦁", "🐮", "🐷", "🐸", "🦓", "🐢", "🐘"]
        case "Тема 3":
            emojis = ["🎃", "👻", "🕷️", "🍬", "🍭", "🎉", "🎈", "🎁", "🎀", "🧙‍♀️", "🧙‍♂️", "👑"]
        case "Рандом":
            let allEmojis = ["🍎", "🍌", "🍇", "🍊", "🍉", "🍓", "🍈", "🍒", "🍑", "🍍", "🥭", "🥝", "🐶", "🐱", "🐰", "🦊", "🐻", "🦁", "🐮", "🐷", "🐸", "🦓", "🐢", "🐘", "🎃", "👻", "🕷️", "🍬", "🍭", "🎉", "🎈", "🎁", "🎀", "🧙‍♀️", "🧙‍♂️", "👑"]
            emojis = Array(allEmojis.shuffled().prefix(12))
        default:
            emojis = []
        }
        
        let numberOfPairs = selectedDifficulty / 2
        cardPairs = Array(emojis.prefix(numberOfPairs)).flatMap { [$0, $0] }.shuffled().map { Card(emoji: $0, isFaceUp: false) }
    }
    
    private func shuffleCards() {
        // Добавляем анимацию перемешивания
        let originalCards = cardPairs
        
        // Меняем состояние карточек на видимые, чтобы их можно было перемещать
        for index in originalCards.indices {
            cardPairs[index].offset = CGSize(width: 0, height: 0)
            cardPairs[index].opacity = 1.0
        }
        
        withAnimation(.spring()) {
            // Перемешиваем карточки с анимацией
            cardPairs.shuffle()
            
            // Сбрасываем смещения после перемешивания
            for index in cardPairs.indices {
                cardPairs[index].offset = CGSize(width: 0, height: 0)
            }
        }
    }
    
    
    private func resetGame() {
        totalScore += score  // Добавляем текущий счет к общему перед сбросом
        score = 0            // Сбрасываем счет текущей игры
        hintCount = 1        // Сбрасываем количество подсказок
        isCardInteractionEnabled = true
        flippedCards.removeAll()
        generateCards()
        gameFinished = false
    }
}
