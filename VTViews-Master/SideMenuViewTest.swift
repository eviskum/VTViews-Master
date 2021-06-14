//
//  SideMenuViewTest.swift
//  VTViews-Master
//
//  Created by Esben Viskum on 14/06/2021.
//

import SwiftUI
import VTViews

struct SideMenuTest: View {
    @State private var showSideMenu = false

    var body: some View {
        NavigationView {
            List(1..<6) { index in
                Text("Item \(index)")
            } // .blueNavigation
            .navigationBarTitle("Dashboard", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.showSideMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))

        }.vtSideMenu(isShowing: $showSideMenu) {
            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation {
                        self.showSideMenu = false
                    }
                }) {
                    HStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                        Text("close menu")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .padding(.leading, 15.0)
                    }
                }
                .padding(.top, 20)
                
                Divider()
                    .frame(height: 20)
                
                Text("Sample item 1")
                    .foregroundColor(.white)
                
                Text("Sample item 2")
                    .foregroundColor(.white)
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
