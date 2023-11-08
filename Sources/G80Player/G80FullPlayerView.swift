//
//  File.swift
//  
//
//  Created by pulei yu on 2023/11/7.
//
#if canImport(UIKit)

import Foundation
import KSPlayer
import SnapKit
import UIKit

open class G80FullPlayerView: G80PlayerView, G80PlayerMaidProtocol {
    open func showLoading(isBuffer: Bool = false) {
        if isBuffer {
            toolBar.playButton.isEnabled = false
            replayButton.isEnabled = false
            doubleTapGesture.isEnabled = false
        }
    }

    open func hideLoading(isBuffer: Bool = false) {
        if isBuffer {
            toolBar.playButton.isEnabled = true
            replayButton.isEnabled = true
            doubleTapGesture.isEnabled = true
        }
    }

    public lazy var maid: G80PlayerMaid = {
        let m = G80PlayerMaid()
        m.deletegate = self
        return m
    }()

    override open func slider(value: Double, event: ControlEvents) {
        guard maid.__isDragLimited,
              maid.isTryingSp == false
        else {
            super.slider(value: value, event: event)
            return
        }

        let minSec = Double(maid.bufferItem.min_drag_duration / 1000)
        let ratioSec = Double(maid.bufferItem.drag_ratio) * (playerLayer?.player.duration ?? 0)
        let maxDragableSec = max(minSec, ratioSec)
        if value > maxDragableSec {
            playerDragLimit()
        } else {
            super.slider(value: value, event: event)
        }
    }

    override open func player(layer: KSPlayerLayer, currentTime: TimeInterval, totalTime: TimeInterval) {
        super.player(layer: layer, currentTime: currentTime, totalTime: totalTime)
        maid.playDurationRepeat()
    }
    
    // MARK: (G80PlayerMaidProtocol)

    public var isBufferingPause: Bool = false

    open func playerNeedsBuffer() {
        showLoading(isBuffer: true)
        isBufferingPause = true
        pause()
    }

    open func playerNeedsDismissBuffer() {
        hideLoading(isBuffer: true)
        isBufferingPause = false
        play()
    }

    open func playerBufferPeriodEnds() {
        hideLoading(isBuffer: true)
        isBufferingPause = true
        pause()
    }

    open func playerDragLimit() {
        fatalError("stub implementation")
    }

    open func playerTryEnd() {

    }

    open func playerTrying(count: Int) {
    }
}
#endif
