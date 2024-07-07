//
//  GIDSignIn+concurency.swift
//  LearnWords
//
//  Created by sergemi on 24.06.2024.
//

//import Foundation
import GoogleSignIn

// Remove when Google add native support

extension GIDSignIn {
    func signIn(withPresenting presentingViewController: UIViewController) async throws -> GIDGoogleUser {
        return try await withCheckedThrowingContinuation { continuation in
            self.signIn(withPresenting: presentingViewController) { signInResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = signInResult?.user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: "GIDSignInErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"]))
                }
            }
        }
    }
}
