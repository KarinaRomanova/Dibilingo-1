//
//  PossibleWordsView.swift
//  Dibilingo-iOS
//
//  Created by Vlad Vrublevsky on 28.10.2020.
//

import SwiftUI

struct PossibleWordsView: View {
    let uuid = UUID().uuidString
    var height: CGFloat
    var onEnded: ((DragGesture.Value, UUID, String) -> Bool)
    var words: [identifiable_word]

    // sorted words little-big-little
    /*
    var words_paired: [String] {
        //var words_sorted = words.sorted(by: { $0 < $1 })
        
        //var words = [String]()
        /*
        while words_sorted.count != 0 {
            let w1 = words_sorted.removeFirst()
            words.append(w1)
            guard words_sorted.count > 0 else {
                break
            }
            let w2 = words_sorted.removeLast()
            words.append(w2)
            /*
            guard words_sorted.count > 0 else {
                break
            }
            let w3 = words_sorted.removeFirst()
            words.append(w3) */
        } */
        
        
        
        return words //.shuffled()
    }
    */
    
    @State private var usedWords = [String]()
    @State private var checkedWord = String()
    
    var body: some View {
        
            GeometryReader { geo in
                let columns = [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]
                LazyVGrid(columns: columns) {
                    ForEach(words, id: \.id) { word in
                        if usedWords.contains(word.text) == false {
                            FishView(word: word, onEnded: onEnded)
                        }
                    }
                }
            }
            .padding([.top, .bottom])
                
        .frame(height: height, alignment: .center)
    }
    
}

struct PossibleWordsView_Previews: PreviewProvider {
    static var previews: some View {
        PossibleWordsView(height: 300, onEnded: { _,_,_   in return false}, words: [identifiable_word("begin")]) //, words_for_verbs(id: 1, text: "begun"), words_for_verbs(id: 2, text: "began"), words_for_verbs(id: 3, text: "begin") ])
    }
}
