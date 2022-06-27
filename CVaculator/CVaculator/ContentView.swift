//
//  ContentView.swift
//  CVaculator
//
//  Created by Kazakh on 26.06.2022.
// https://dribbble.com/shots/8295078-004-Calculator

import SwiftUI

enum CalcButton: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case point = "."
    case division = "/"
    case addition = "+"
    case subtruction = "-"
    case multiplication = "X"
    case equal = "="
    case percent = "%"
    case clear = "C"
    case power = "^"
    
    var buttonColor: Color {
        switch self {
        case .clear, .percent, .multiplication, .subtruction, .addition, .division, .power:
            return Color.gray
        case .equal:
            return Color.orange
        default:
            return Color.black
        }
    }
    var buttonHeight: CGFloat {
        return ((UIScreen.main.bounds.width - 48) / 4)
    }
    var buttonWidth: CGFloat {
        switch self {
        case .equal:
            return ((UIScreen.main.bounds.width - 48) / 2) + 12
        default:
            return ((UIScreen.main.bounds.width - 48) / 4)
        }
    }
}



struct ContentView: View {
    @State var result = 0
    let buttons: [[CalcButton]] = [
        [.clear, .power, .percent, .division],
        [.seven, .eight, .nine, .multiplication],
        [.four, .five, .six, .subtruction],
        [.one, .two, .three, .addition],
        [.zero, .point, .equal]
    ]
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text("\(result)")
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                    
                }
                .padding()
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 50))
                                    .frame(width: item.buttonWidth, height: item.buttonHeight)
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(item.buttonHeight/2)
                            })
                        }
                    }
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
