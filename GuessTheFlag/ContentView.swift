//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Doce on 17.10.23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Brazil", "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var correctAnswer = 0
    @State private var score = 0
    @State private var round = 0
    @State private var keepPlaying = false
    
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var isScoreOpen = false
    @State private var isRestartOpen = false
    @State private var isGameOver = false
    
    let rounds = 9
    
    var body: some View {
        VStack {
            VStack {
                Text("Guess The Flag")
                    .font(.title.bold())
                Text(keepPlaying ? "Score: \(score)" : "Score: \(score)/\(rounds + 1)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(spacing: 24) {
                VStack {
                    Text("Tap the flag of **\(countries[correctAnswer])** 👇")
                        .font(.title2)
                }
                ForEach(0..<3) { i in
                    Button {
                        guessFlag(i)
                    } label: {
                        Image(countries[i])
                            .clipShape(.buttonBorder)
                            .shadow(radius: 4)
                    }
                }
            }
            Spacer()
            Button("Restart", systemImage: "arrow.clockwise", role: .destructive) {
                isRestartOpen = true
            }
            .alert("Restart game", isPresented: $isRestartOpen) {
                Button("Restart", role: .destructive, action: restartGame)
            } message: {
                Text("Are you sure you want to restart the game? Your current score will be lost.")
            }
        }
        .padding()
        .alert(scoreTitle, isPresented: $isScoreOpen) {
            Button("Continue", action: startRound)
        } message: {
            Text(scoreMessage)
        }
        .alert("Final score: \(score)/\(rounds + 1) 🎉", isPresented: $isGameOver) {
            Button("Keep playing", role: .cancel, action: resumeGame)
            Button("New game", role: .destructive, action: restartGame)
        } message: {
            Text("\(scoreMessage)\n\nDo you want to keep playing or start a new game?")
        }
        .onAppear() {
            restartGame()
        }
    }
    
    func guessFlag(_ guess: Int) {
        if (guess == correctAnswer) {
            score += 1
            scoreTitle = "Correct!"
            scoreMessage = "You guessed the flag of \(countries[guess]) correctly, well done! 👌"
        } else {
            if (keepPlaying && score > 0) {
                score -= 1
            }
            scoreTitle = "Wrong!"
            scoreMessage = "You tapped the flag of \(countries[guess]) instead of \(countries[correctAnswer])... 😥"
        }
        
        if (!keepPlaying && round >= rounds) {
            isGameOver = true
            return
        }
        
        isScoreOpen = true
    }
    
    func startRound() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        round += 1
    }
    
    func restartGame() {
        score = 0
        round = -1
        keepPlaying = false
        startRound()
    }
    
    func resumeGame() {
        keepPlaying = true
        startRound()
    }
}

#Preview {
    ContentView()
}
