//
//  CardDataTextFormatter.swift
//  SDKForms
//
// 
//

import Foundation

final class CardDataTextFormatter {
    
    private let SPACE = " "
    private let SLASH = "/"
    
    func modify(
        _ text: String,
        forPattern pattern: CardDataTextFieldStringPattern
    ) -> String {
        switch pattern {
        case .cardNumber:
            modifyCardNumberString(text)
        case .cardExpiry:
            modifyCardExpiryString(text)
        case .cardCVC, .mandatoryField, .phoneNumber, .email, .plain:
            text
        case .cardHolder:
            modifyCardHolderString(text)
        }
    }
    
    private func modifyCardNumberString(_ creditCardString: String) -> String {
        let trimmedString = creditCardString.digitsOnly()

        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""

        if arrOfCharacters.count > 0 {
            for i in 0...arrOfCharacters.count - 1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                
                if (i + 1) % 4 == 0 && i + 1 != arrOfCharacters.count {
                    modifiedCreditCardString.append(SPACE)
                }
            }
        }
       
        return modifiedCreditCardString
    }
    
    private func modifyCardExpiryString(_ cardExpiryString: String) -> String {
        let trimmedString = cardExpiryString.digitsOnly()
        
        let arrOfChars = Array(trimmedString)
        var modifiedString = ""
        
        if arrOfChars.count > 0 {
            for i in 0...arrOfChars.count - 1 {
                if i == 0, "23456789".contains(where: { $0 == arrOfChars[i] }) {
                    modifiedString.append("0")
                }
                
                if i == 1,
                    !"012".contains(where: { $0 == arrOfChars[i] }),
                    arrOfChars.count <= 2,
                    arrOfChars[0] != "0" {
                    break
                }

                modifiedString.append(arrOfChars[i])
                
                if (i + 1) % 2 == 0 && i + 1 != arrOfChars.count {
                    modifiedString.append(SLASH)
                }
            }
        }
        
        return modifiedString
    }
    
    private func modifyCardHolderString(_ cardHolderString: String) -> String {
        cardHolderString.uppercased()
    }
}
