//
//  VideoPlayView.swift
//  Swift-AVKit
//
//  Created by k2hoon on 2023/07/05.
//

import SwiftUI
import AVKit

struct VideoPlayView: View {
    @State private var playtime: Double = 0
    @State private var duration: Double = 0
    @State private var seeking = false
    
    private let player: AVPlayer
    
    init(url: URL) {
        player = AVPlayer(url: url)
    }
    
    var body: some View {
        VStack {
            VideoPlayerView(playtime: $playtime,
                            duration: $duration,
                            seeking: $seeking,
                            player: player)
            
            VideoPlayerControlView(playtime: $playtime,
                                   duration: $duration,
                                   seeking: $seeking,
                                   player: player)
        }
        .onDisappear {
            self.player.replaceCurrentItem(with: nil)
        }
    }
}

struct VidePlayView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayView(url: Bundle.main.url(forResource: "Big_Buck_Bunny_1080_10s_20MB", withExtension: "mp4")!)
    }
}
