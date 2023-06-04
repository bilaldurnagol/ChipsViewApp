//
//  Home.swift
//  ChipsViewApp
//
//  Created by Bilal Durnagöl on 4.06.2023.
//

import SwiftUI

struct Home: View {
    
    @State var text: String = ""
    @State var tags: [Tag] = []
    @State var showAlert: Bool = false
    var body: some View {
        
        VStack {
            Text("Filter \nMenus")
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(Color("Tag"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Custom tag view
            
            TagView(maxLimit: 150, tags: $tags)
                .frame(height: 250)
                .padding(.top, 20)
            
            
            // Textfield
            TextField("apple", text: $text)
                .font(.title3)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color("Tag").opacity(0.4), lineWidth: 2)
                }
                .environment(\.colorScheme, .dark)
                .padding(.vertical, 18)
            
            // Add Button
            Button {
                // adding tag
                addTag(tags: tags, text: text, fontSize: 16, maxLimit: 150) { alert, tag in
                    if alert {
                        showAlert.toggle()
                    } else {
                        tags.append(tag)
                        text = ""
                    }
                }
               
            } label: {
                Text("Add Tag")
                    .fontWeight(.semibold)
                    .foregroundColor(Color("BG"))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 45)
                    .background(Color("Tag"))
                    .cornerRadius(15.0)
            }
// Disabling Button
            .disabled(text == "")
            .opacity(text == "" ? 0.6 : 1)
            
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Tag limit exceeded try to delete some tags"), dismissButton: .destructive(Text("Ok")))
        }
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
