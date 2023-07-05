//
//  VideoPlayerControlView.swift
//  Swift-AVKit
//
//  Created by k2hoon on 2023/07/05.
//

import SwiftUI
import AVKit

struct VideoPlayerControlView : View {
    @Binding var playtime: Double
    @Binding var duration: Double
    @Binding var seeking: Bool
    
    var player: AVPlayer? = nil
    
    @State private var isPaused = true
    
    var body: some View {
        HStack {
            // play and pause button
            Button(action: self.togglePlay) {
                Image(systemName: self.isPaused ? "play" : "pause")
                    .padding(.trailing, 16)
            }
            
            // Current video play time
            Text("\(VideoUtility.formatSecondsToHMS(playtime * duration))")
            
            // Slider bar for seeking video progress
            Slider(value: $playtime, in: 0...1, onEditingChanged: self.onEditingChanged)
            
            // Total Video duration
            Text("\(VideoUtility.formatSecondsToHMS(duration))")
        }
        .padding(.horizontal, 8)
    }
    
    private func togglePlay() {
        self.isPaused.toggle()
        self.isPaused ? self.player?.pause() : self.player?.play()
    }
    
    private func onEditingChanged(_ isEditing: Bool) {
        if isEditing {
            self.seeking = true
        } else {
            let targetTime = CMTime(seconds: playtime * duration, preferredTimescale: 500)
            self.player?.seek(to: targetTime) { _ in
                self.seeking = false
            }
        }
        
        self.togglePlay()
    }
}

struct VideoPlayerControlView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerControlView(playtime: .constant(0), duration: .constant(10.0), seeking: .constant(false), player: nil)
    }
}
