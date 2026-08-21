import Translating
import Translating_Dependencies

public struct PasswordValidation: Sendable {

    public var validate: @Sendable (_ password: String) throws(PasswordValidation.Error) -> Bool

    public init(
        validate: @Sendable @escaping (_: String) throws(PasswordValidation.Error) -> Bool
    ) {
        self.validate = validate
    }
}

extension PasswordValidation {
    public func callAsFunction(_ password: String) throws(PasswordValidation.Error) -> Bool {
        try self.validate(password)
    }
}

extension PasswordValidation {

    public static var `default`: Self {
        .init { (password: String) throws(PasswordValidation.Error) -> Bool in
            let minLength: Int = 8
            let maxLength: Int = 64

            let uppercasePattern: String = ".*[A-Z]+.*"
            let lowercasePattern: String = ".*[a-z]+.*"
            let digitPattern: String = ".*[0-9]+.*"

            let specialCharacterPattern: String = ".*[!&^%$#@()/ -]+.*"

            if password.count < minLength {
                throw PasswordValidation.Error.tooShort(minLength: minLength)
            }
            if password.count > maxLength {
                throw PasswordValidation.Error.tooLong(maxLength: maxLength)
            }

            if !matches(pattern: uppercasePattern, in: password) {
                throw PasswordValidation.Error.missingUppercase
            }
            if !matches(pattern: lowercasePattern, in: password) {
                throw PasswordValidation.Error.missingLowercase
            }
            if !matches(pattern: digitPattern, in: password) {
                throw PasswordValidation.Error.missingDigit
            }
            if !matches(pattern: specialCharacterPattern, in: password) {
                throw PasswordValidation.Error.missingSpecialCharacter
            }

            return true
        }
    }

    public static var simple: Self {
        .init { (password: String) throws(PasswordValidation.Error) -> Bool in
            guard password.count >= 4 else {
                throw PasswordValidation.Error.tooShort(minLength: 4)
            }
            return true
        }
    }
}

private func matches(pattern: String, in text: String) -> Bool {

    guard let regex = try? Regex(pattern) else { return false }
    return text.contains(regex)
}

extension PasswordValidation {

    public enum Error: Swift.Error, Equatable, CustomStringConvertible {

        case tooShort(minLength: Int)

        case tooLong(maxLength: Int)

        case missingUppercase

        case missingLowercase

        case missingDigit

        case missingSpecialCharacter
    }
}

extension PasswordValidation.Error {

    public var description: String {
        switch self {
        case .tooShort(let minLength):
            return TranslatedString(
                dutch: "Wachtwoord moet minstens \(minLength) tekens lang zijn.",
                english: "Password must be at least \(minLength) characters long."
            ).description

        case .tooLong(let maxLength):
            return TranslatedString(
                dutch: "Wachtwoord mag maximaal \(maxLength) tekens lang zijn.",
                english: "Password must be no more than \(maxLength) characters long."
            ).description

        case .missingUppercase:
            return TranslatedString(
                dutch: "Wachtwoord moet minstens één hoofdletter bevatten.",
                english: "Password must contain at least one uppercase letter."
            ).description

        case .missingLowercase:
            return TranslatedString(
                dutch: "Wachtwoord moet minstens één kleine letter bevatten.",
                english: "Password must contain at least one lowercase letter."
            ).description

        case .missingDigit:
            return TranslatedString(
                dutch: "Wachtwoord moet minstens één cijfer bevatten.",
                english: "Password must contain at least one digit."
            ).description

        case .missingSpecialCharacter:
            return TranslatedString(
                dutch: "Wachtwoord moet minstens één speciaal teken bevatten (bijv. !&^%$#@()/).",
                english: "Password must contain at least one special character (e.g., !&^%$#@()/)."
            ).description
        }
    }
}
