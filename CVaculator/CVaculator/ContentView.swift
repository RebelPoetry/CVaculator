//
//  ContentView.swift
//  CVaculator
//
//  Created by Kazakh on 26.06.2022.
// https://dribbble.com/shots/8295078-004-Calculator
//
import SwiftUI

// MARK: - CalcButton

enum CalcButton {

    case digit(Character)
    case maximJopaTolstaya
    case percent, multiplication, clear, addition, division, power, equal, point
    
    var title: String {
        switch self {
        case .digit(let character):
            return String(character)
        case .maximJopaTolstaya:
            return "-"
        case .power:
            return "^"
        case .percent:
            return "%"
        case .division:
            return "/"
        case .multiplication:
            return "×"
        case .clear:
            return "C"
        case .addition:
            return "+"
        case .equal:
            return "="
        case .point:
            return "."
        }
    }
    var buttonColor: Color {
        switch self {
        case .clear, .percent, .multiplication, .maximJopaTolstaya, .addition, .division, .power:
            return Color.gray.opacity(0.38)
        case .equal:
            return Color.orange
        default:
            return Color.orange
        }
    }
    var buttonHeight: CGFloat {
        return ((UIScreen.main.bounds.width - 5 * PConstants.buttonSpacing) / 4)
    }
    var buttonWidth: CGFloat {
        switch self {
        case .equal:
            return ((UIScreen.main.bounds.width - 5 * PConstants.buttonSpacing) / 2) + 12
        default:
            return ((UIScreen.main.bounds.width - 5 * PConstants.buttonSpacing) / 4)
        }
    }
}

// MARK: - ContentView
struct ContentView: View {
    static let buttonSpacing: CGFloat = 12
    
    @State var calcDisplay = ""
    @State var expression = ""
    let buttons: [[CalcButton]] = [
        [.clear, .power, .percent, .division],
        [.digit("7"), .digit("8"), .digit("9"), .multiplication],
        [.digit("4"), .digit("5"), .digit("6"), .maximJopaTolstaya],
        [.digit("1"), .digit("2"), .digit("3"), .addition],
        [.digit("0"), .point, .equal]
    ]

    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text("\(calcDisplay)")
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.38)
                    
                }
                .padding()
                ForEach(buttons.indices, id: \.self) { index in
                    HStack(spacing: PConstants.buttonSpacing) {
                        ForEach(buttons[index], id: \.title) { item in
                            Button(action: {  // MARK: - Button actions
                                switch item {
                                case .equal:
                                    let a = calculateRPN(toRPN(parse(expression)))
                                    expression = "\(a)"
                                    if a.truncatingRemainder(dividingBy: 1) == 0 {
                                    calcDisplay = "\(Int(a))"
                                    } else { calcDisplay = "\(a)"}
                                case .clear:
                                    expression = ""
                                    calcDisplay = ""
                                case .percent:
                                    calcDisplay = "Введите полезную операцию! Для продолжения нажмите С или ="
                                case .digit:
                                    if calcDisplay != "Введите полезную операцию! Для продолжения нажмите С или =" {
                                    expression += item.title
                                    calcDisplay += item.title
                                    }
                                case .point:
                                    if let b = expression.last, b.isHexDigit{
                                    if !calcDisplay.isEmpty, calcDisplay != "Введите полезную операцию! Для продолжения нажмите С или ="{
                                    expression += item.title
                                    calcDisplay += item.title
                                    }}
                                default:
                                    if !calcDisplay.isEmpty, calcDisplay != "Введите полезную операцию! Для продолжения нажмите С или =" {
                                    expression += item.title
                                    calcDisplay += item.title
                                    }
                                }
                            }, label: {
                                Text(item.title) //MARK: - Button text
                                    .font(.system(size: 50))
                                    .frame(width: item.buttonWidth, height: item.buttonHeight)
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(item.buttonHeight/2)
                                    .minimumScaleFactor(0.38)
                            })
                        }
                    }
                }
            }
        }
    }
}
// MARK: - PConstants

private struct PConstants {
    static let buttonSpacing: CGFloat = 12
}

// MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
