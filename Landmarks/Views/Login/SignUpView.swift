//
//  SignUpView.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/27/23.
//

import SwiftUI
import Firebase


struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {

            Spacer() // Use all available space above the TextField
            Text("Welcome")
            Text("Sign up Here:")
            TextField("Username",
                      text: $username,
                      prompt: Text("Username").foregroundColor(.blue))
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)

            SecureField("Password",
                        text: $password,
                        prompt: Text("Password").foregroundColor(.blue))
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)

            TextField("Confirm Password",
                      text: $password,
                      prompt: Text("Confirm Password").foregroundColor(.blue))
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)

            TextField("Email",
                      text: $email,
                      prompt: Text("Email").foregroundColor(.blue))
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                }
                .padding(.horizontal)

            Button(action: register) {
                Text("Submit")
            }

            Spacer() // Use all available space below the TextField
        }
    }

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle registration error
                print("Error registering user:", error.localizedDescription)
            } else {
                let userId = authResult?.user.uid ?? ""
                let username = self.username
                let bio = ""
                let favorites = [String]()

                do {
                    let db = Firestore.firestore()
                    var ref: DocumentReference? = nil
                    ref = try db.collection("users").addDocument(data: [
                        "user_id": userId,
                        "username": username,
                        "email": email,
                        "password": password,
                        "bio": bio,
                        "favorites": favorites
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }

                    // Additional actions after user creation
                    print("User registered successfully")
                } catch {
                    // Handle createNewUser error
                    print("Error creating new user:", error.localizedDescription)
                }
            }
        }
    }
}
    



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
