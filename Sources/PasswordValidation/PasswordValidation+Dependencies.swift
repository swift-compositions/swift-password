import Dependencies
import Translating
import Translating_Dependencies

private enum PasswordValidationKey {}

extension __DependencyValues {

    public var passwordValidation: PasswordValidation {
        get { self[PasswordValidationKey.self] }
        set { self[PasswordValidationKey.self] = newValue }
    }
}

extension PasswordValidationKey: Dependency.Key {

    static var testValue: PasswordValidation { .simple }

    static var liveValue: PasswordValidation { .default }
}
