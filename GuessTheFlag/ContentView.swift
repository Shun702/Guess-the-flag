//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Shun Le Yi Mon on 02/07/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var correctScore = 0
    @State private var gameNum = 0
    @State private var endgame = false
    
    @State private var animationAmount = 0.0
    @State private var correctflag = false
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue:0.26), location: 0.3),], center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag").font(.largeTitle.weight(.bold)).foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of").foregroundStyle(.secondary).font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) {
                        number in Button (action: {
                            flagTapped(number)
                            withAnimation{
                                animationAmount = 360.0
                            }
                        }) {
                            if correctflag{
                                if number == correctAnswer{
                                    withAnimation{
                                        Image(countries[number]).renderingMode(.original)
                                            .something()
                                            .rotation3DEffect(Angle(degrees: animationAmount), axis: (x: 0, y: 1, z: 0))
                                    }
                                }else {
                                    Image(self.countries[number])
                                        .renderingMode(.original)
                                        .something()
                                        .opacity(0.75)
                                }
                            } else {
                                Image(self.countries[number])
                                    .renderingMode(.original)
                                    .something()
                            }
                            
                        }
                    }
                    
                }
                    Spacer()
                    Spacer()
                    HStack {
                        Text("Socre: ").foregroundColor(.white).font(.title.bold())
                        Text(correctScore, format: .number).foregroundColor(.white).font(.title.bold())
                    }
                    Spacer()
                }.padding()
                    .alert(scoreTitle, isPresented: $showingScore) {
                        Button("Continue", action: askQuestion)
                    } message: {
                        Text("Your score is \(correctScore)")
                    }.alert(scoreTitle, isPresented: $endgame) {
                        Button("New Game", action: createNewGame)
                    } message: {
                        Text("End of the game. You got \(correctScore) / 8.")
                    }
            }
        }
            
            func flagTapped(_ number: Int) {
                if number == correctAnswer {
                    addScore()
                    scoreTitle = "Correct"
                    correctflag = true
                    
                }else {
                    scoreTitle = "Wrong! That is \(countries[number])."
                }
                
                showingScore = true
                
                numOfGame()
            }
            
            func askQuestion() {
                countries.shuffle()
                correctAnswer = Int.random(in: 0...2)
                correctflag = false
                animationAmount = 0.0
            }
            func addScore() {
                correctScore = correctScore + 1
            }
            
            //adds 1 after each number of game and checks if the number reaches 8
            func numOfGame() {
                gameNum = gameNum + 1
                if gameNum >= 8 {
                    endgame = true
                }
            }
            
            func createNewGame(){
                gameNum = 0
                correctScore = 0
                endgame = false
                askQuestion()
            }
        }
    
struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 5)
        
    }
}

extension View {
    func something() -> some View{
        self.modifier(FlagImage())
    }
}
    
struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
