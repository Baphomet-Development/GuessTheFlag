//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jason on 2/19/23.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

extension View {
    func flagStyle() -> some View {
        modifier(FlagImage())
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var scoreTotal = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var turn = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
        
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<5) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .flagStyle()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius:  20))
                
                Spacer()
                Spacer()
                
                HStack {
                    Text("Score: \(scoreTotal)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .padding()
                    
                    Text("Turns: \(turn)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                }
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(scoreTotal)")
            }
        .alert(scoreTitle, isPresented: $gameOver) {
            Button("Restart", action: askQuestion)
            } message: {
                Text("Your score: \n\(scoreTotal)")
        }
        
    
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreTotal = scoreTotal + 1
        } else {
            scoreTitle = "Wrong,that's the flag of \(countries[number])"
            scoreTotal = scoreTotal - 2
        }
        
        turn -= 1
        showingScore = true
        
        if turn == 0 {
            showingScore = false
            scoreTitle = "Game Over!"
            gameOver = true
        }
    }
    
    func reset() {
        gameOver = false
        turn = 8
        scoreTotal = 0
    }
    
    func askQuestion() {
        if turn == 0 { reset() }
        else {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
