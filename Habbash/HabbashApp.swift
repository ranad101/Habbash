//
//  HabbashApp.swift
//  Habbash
//
//  Created by Ranad aldawood on 26/11/1446 AH.


import SwiftUI

extension Font {
    static func balooBhaijaan2(size: CGFloat) -> Font {
        return .custom("BalooBhaijaan2", size: size)
    }
}

@main
struct HabbashApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .font(.custom("BalooBhaijaan2-Medium", size: 20))
        }
    }
}
