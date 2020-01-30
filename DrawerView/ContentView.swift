//
//  ContentView.swift
//  DrawerView
//
//  Created by Takuya Yokoyama on 2020/01/30.
//  Copyright © 2020 Takuya Yokoyama. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectingEmoji: String = ""
    @State private var isPresentedDrawerView: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                ForEach(["😄", "😩", "🥺"], id: \.self) { emoji in
                    Button(action: {
                        self.selectingEmoji = emoji
                        self.isPresentedDrawerView = true
                    }) {
                        Text(emoji)
                            .font(Font.title)
                    }
                }
            }
            
            DrawerView(isPresented: $isPresentedDrawerView) {
                MenuView(emoji: self.selectingEmoji)
                    .frame(width: 200)
            }
        }
    }
}

struct MenuView: View {
    let emoji: String
    
    var body: some View {
        VStack {
            Text(emoji)
                .font(Font.largeTitle)
            List {
                ForEach(0..<100) { number in
                    Text("\(number)")
                }
            }
        }
    }
}

struct DrawerView<Content>: View where Content: View {
    private struct MaskView: View {
        var body: some View {
            Rectangle()
                .background(Color.black)
                .opacity(0.2)
        }
    }
    
    @Binding private var isPresented: Bool
    private let content: () -> Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
    }
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ZStack(alignment: .leading) {
                if self.isPresented {
                    MaskView()
                        .transition(.opacity)
                        .onTapGesture {
                            self.isPresented = false
                        }
                    
                    self.content()
                        .padding(geometry.safeAreaInsets)
                        .background(Color.primary.colorInvert())
                        .transition(.move(edge: .leading))
                } else {
                    self.content()
                        .hidden()
                }
            }
            .animation(.spring())
            .edgesIgnoringSafeArea([.top, .bottom])        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
