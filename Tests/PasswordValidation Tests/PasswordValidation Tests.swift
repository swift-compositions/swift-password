import Dependencies
import Dependencies_Test_Support
import Testing

@testable import PasswordValidation

@Suite(
    "PasswordValidation Tests",
    .dependency(\.language, .english),
    .dependency(\.passwordValidation, .default)
)
struct PasswordValidationTests {

    @Suite
    struct ValidPasswords {

        @Test("Valid password with all requirements")
        func validWithAllRequirements() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let validPassword: String = "Password123!"
            #expect(try isValidPassword(validPassword) == true)
        }

        @Test("Valid password with minimum length")
        func validWithMinimumLength() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let validPassword: String = "Pass123!"
            #expect(try isValidPassword(validPassword) == true)
        }

        @Test("Valid password with multiple special characters")
        func validWithMultipleSpecialCharacters() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let validPassword: String = "Password123!@#$%^&*()"
            #expect(try isValidPassword(validPassword) == true)
        }

        @Test("Valid password with maximum allowed length")
        func validWithMaximumAllowedLength() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let validPassword: String = String(repeating: "Aa1!", count: 16)
            #expect(try isValidPassword(validPassword) == true)
        }
    }

    @Suite("Hyphen and space special characters")
    struct HyphenAndSpaceSpecialCharacters {

        @Test("Safari-format hyphenated password passes validation")
        func safariHyphenatedPasswordPasses() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool

            let safariPassword: String = "Xokwaq-9kotbe-ruwmoq"
            #expect(try isValidPassword(safariPassword) == true)
        }

        @Test("Password whose only special character is a space passes validation")
        func spaceOnlySpecialCharacterPasses() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let spacePassword: String = "Pass word12"
            #expect(try isValidPassword(spacePassword) == true)
        }

        @Test("Password with no special character at all still fails")
        func noSpecialCharacterStillFails() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool

            let noSpecial: String = "Xokwaq9kotberuwmoq"
            #expect(throws: PasswordValidation.Error.missingSpecialCharacter) {
                try isValidPassword(noSpecial)
            }
        }
    }

    @Suite("Invalid Passwords - Length")
    struct InvalidPasswordsLength {

        @Test("Password too short throws tooShort error")
        func tooShortThrows() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let shortPassword: String = "Pass1!"

            #expect(throws: PasswordValidation.Error.tooShort(minLength: 8)) {
                try isValidPassword(shortPassword)
            }
        }

        @Test("Password too long throws tooLong error")
        func tooLongThrows() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let longPassword: String = String(repeating: "Aa1!", count: 17)
            #expect(throws: PasswordValidation.Error.tooLong(maxLength: 64)) {
                try isValidPassword(longPassword)
            }
        }
    }

    @Suite("Invalid Passwords - Missing Character Types")
    struct InvalidPasswordsMissingCharacterTypes {

        @Test("Password missing uppercase throws missingUppercase error")
        func missingUppercaseThrows() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let password: String = "password123!"
            #expect(throws: PasswordValidation.Error.missingUppercase) {
                try isValidPassword(password)
            }
        }

        @Test("Password missing lowercase throws missingLowercase error")
        func missingLowercaseThrows() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let password: String = "PASSWORD123!"

            #expect(throws: PasswordValidation.Error.missingLowercase) {
                try isValidPassword(password)
            }
        }

        @Test("Password missing digit throws missingDigit error")
        func missingDigitThrows() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let password: String = "Password!"

            #expect(throws: PasswordValidation.Error.missingDigit) {
                try isValidPassword(password)
            }
        }

        @Test("Password missing special character throws missingSpecialCharacter error")
        func missingSpecialCharacterThrows() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let password: String = "Password123"

            #expect(throws: PasswordValidation.Error.missingSpecialCharacter) {
                try isValidPassword(password)
            }
        }
    }

    @Suite("PasswordValidation.Error Tests")
    struct ErrorTests {

        @Test("TooShort error has correct description")
        func tooShortDescription() {
            let error: PasswordValidation.Error = PasswordValidation.Error.tooShort(minLength: 8)
            #expect(error.description.contains("at least 8 characters"))
        }

        @Test("TooLong error has correct description")
        func tooLongDescription() {
            let error: PasswordValidation.Error = PasswordValidation.Error.tooLong(maxLength: 64)
            #expect(error.description.contains("no more than 64 characters"))
        }

        @Test("MissingUppercase error has correct description")
        func missingUppercaseDescription() {
            let error: PasswordValidation.Error = PasswordValidation.Error.missingUppercase
            #expect(error.description.contains("uppercase letter"))
        }

        @Test("MissingLowercase error has correct description")
        func missingLowercaseDescription() {
            let error: PasswordValidation.Error = PasswordValidation.Error.missingLowercase
            #expect(error.description.contains("lowercase letter"))
        }

        @Test("MissingDigit error has correct description")
        func missingDigitDescription() {
            let error: PasswordValidation.Error = PasswordValidation.Error.missingDigit
            #expect(error.description.contains("digit"))
        }

        @Test("MissingSpecialCharacter error has correct description")
        func missingSpecialCharacterDescription() {
            let error: PasswordValidation.Error = PasswordValidation.Error.missingSpecialCharacter
            #expect(error.description.contains("special character"))
        }
    }

    @Suite
    struct EdgeCases {

        @Test("Empty password throws tooShort error")
        func emptyPasswordThrowsTooShort() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let emptyPassword: String = ""

            #expect(throws: PasswordValidation.Error.tooShort(minLength: 8)) {
                try isValidPassword(emptyPassword)
            }
        }

        @Test("Password with Unicode characters")
        func unicodeCharacters() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let unicodePassword: String = "Pássword123!"
            #expect(try isValidPassword(unicodePassword) == true)
        }

        @Test("Password with all allowed special characters")
        func allAllowedSpecialCharacters() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let password: String = "Password123!&^%$#@()/"
            #expect(try isValidPassword(password) == true)
        }

        @Test("Password with spaces")
        func passwordWithSpaces() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword:
                @Sendable (String) throws(PasswordValidation.Error) -> Bool
            let password: String = "Pass word123!"
            #expect(try isValidPassword(password) == true)
        }
    }
}
