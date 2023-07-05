//
//  ContentView.swift
//  Swift-AVKit
//
//  Created by k2hoon on 2023/07/05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VideoPlayView(url: Bundle.main.url(forResource: "Big_Buck_Bunny_1080_10s_20MB", withExtension: "mp4")!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
