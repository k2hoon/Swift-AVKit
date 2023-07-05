//
//  VideoPlayerView.swift
//  Swift-AVKit
//
//  Created by k2hoon on 2023/07/05.
//

import SwiftUI
import AVKit

// Wraps the UIKit-based VideoPlayer below
struct VideoPlayerView: UIViewRepresentable {
    @Binding var playtime: Double
    @Binding var duration: Double
    @Binding var seeking: Bool
    
    var player: AVPlayer? = nil
    
    func makeUIView(context: UIViewRepresentableContext<VideoPlayerView>) -> UIView {
        return VideoPlayer(player: player, playtime: $playtime, duration: $duration, seeking: $seeking)
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoPlayerView>) { }
    
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(playtime: .constant(0), duration: .constant(10.0), seeking: .constant(false), player: nil)
    }
}

// MARK: VideoPlayer
class VideoPlayer: UIView {
    private let playtime: Binding<Double>
    private let duration: Binding<Double>
    private let seeking: Binding<Bool>
    private let playerLayer = AVPlayerLayer()
    
    private var player: AVPlayer? = nil
    private var durationObservation: NSKeyValueObservation?
    private var timeObservation: Any?
    private var playCount = 0
    private var repeatCount = 2
    
    init(player: AVPlayer?, playtime: Binding<Double>, duration: Binding<Double>, seeking: Binding<Bool>) {
        self.player = player
        self.playtime = playtime
        self.duration = duration
        self.seeking = seeking
        
        super.init(frame: .zero)
        
        backgroundColor = .lightGray
        
        self.playerLayer.player = player
        layer.addSublayer(playerLayer)
        
        // Observe the duration of the player
        self.durationObservation = self.player?.currentItem?.observe(\.duration, changeHandler: { [weak self] item, change in
            guard let self = self else { return }
            self.duration.wrappedValue = item.duration.seconds
        })
        
        // Observe the player time
        self.timeObservation = self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 500), queue: nil) { [weak self] time in
            guard let self = self else { return }
            guard !self.seeking.wrappedValue else { return }
            
            // update the current video play time
            self.playtime.wrappedValue = time.seconds / self.duration.wrappedValue
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didFinish),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.destory()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = bounds
    }
    
    private func destory() {
        // Remove observers
        self.durationObservation?.invalidate()
        self.durationObservation = nil
        
        if let observation = timeObservation {
            self.player?.removeTimeObserver(observation)
            self.timeObservation = nil
        }
    }
    
    @objc private func didFinish(notification: Notification) {
        self.playCount += 1
        if self.repeatCount > self.playCount {
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
}
