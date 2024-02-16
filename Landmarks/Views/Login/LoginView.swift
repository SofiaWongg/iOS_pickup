//
//  loginView.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/27/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var isLoggedIn: Bool //interacts
        
        var body: some View {
           
            NavigationStack{
            VStack(alignment: .center, spacing: 15) {
                 
                Text("Welcome Back!")
                    .font(.largeTitle
                        .weight(.bold))
                Image("undraw_awesome")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200.0, height: 200.0)
                Text( "Sign in Here:")
                TextField("Email",
                          text: $email,
                          prompt: Text("Email").foregroundColor(.blue))
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
                //fix this button
                Button(action: login) {
                    Text("Submit")
                }
                
                    VStack{
                        Text("New User?")
                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                            }
                    }
                }
        }    
    }
        
    func login() {
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let error = error {
                    // Sign in nay
                    print("Error registering user:", error.localizedDescription)
                } else {
                    // Sign in yay
                    print("User signed in successfully")
                    isLoggedIn = true
                }
            }
        }
    
    
    struct loginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView(isLoggedIn: .constant(false))
        }
    }
}
