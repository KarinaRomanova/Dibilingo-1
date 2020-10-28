//
//  PossibleWordsView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct PossibleWordsView: View {
    var height: CGFloat
    var words: [String]
    
    var words_paired: [String] {
        var words_sorted = words.sorted()
        print(words_sorted)
        
        //var words_paired = [[String]]()
        var words = [String]()
        while words_sorted.count != 0 {
            let w1 = words_sorted.removeFirst()
            words.append(w1)
            guard words_sorted.count > 0 else {
                //words_paired.append([w1])
                
                break
            }
            let w2 = words_sorted.removeLast()
            words.append(w2)
            guard words_sorted.count > 0 else {
                //words_paired.append([w1, w2])
                break
            }
            let w3 = words_sorted.removeFirst()
            words.append(w3)
            //words_paired.append([w1, w2, w3])
        }
        
        return words
    }
    
    @State private var usedWords = [String]()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(.yellow)
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundColor(.white)
                    .padding(5)
                GeometryReader { geo in
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    LazyVGrid(columns: columns) {
                        ForEach(words_paired, id: \.self) { word in
                            if usedWords.contains(word) == false {
                                WordView(text: word)
                                    .onTapGesture(count: 2, perform: {
                                        withAnimation {
                                            usedWords.append(word)
                                        }
                                    })
                                }
                        }
                    }
                    //.padding([.trailing, .leading])
                }
                .padding(.top)
                
            }
            
        }
        .frame(height: height, alignment: .center)
    }
    
 
}

struct PossibleWordsView_Previews: PreviewProvider {
    static var previews: some View {
        PossibleWordsView(height: 300, words: ["begin", "begun", "began", "adsd", "forgot", "forgotten", "adaa", "dsaadsda", "aa" ])
    }
}
