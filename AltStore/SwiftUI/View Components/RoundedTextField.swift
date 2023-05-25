//
//  RoundedTextField.swift
//  SideStore
//
//  Created by Fabian Thies on 29.11.22.
//  Copyright © 2022 SideStore. All rights reserved.
//

import SwiftUI

struct RoundedTextField: View {
    
    let title: String?
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    init(title: String?, placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
    }
    
    init(_ placeholder: String, text: Binding<String>, isSecure: Bool = false) {
        self.init(title: nil, placeholder: placeholder, text: text, isSecure: isSecure)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title {
                Text(title.uppercased())
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            HStack(alignment: .center) {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color(.secondarySystemBackground))
            )
        }
    }
}
