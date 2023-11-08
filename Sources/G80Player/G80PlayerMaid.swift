//
//  File.swift
//  
//
//  Created by pulei yu on 2023/11/7.
//
#if canImport(UIKit)

import Foundation
import UIKit


public protocol G80PlayerMaidProtocol: AnyObject {
    var isBufferingPause: Bool { get set }
    func playerNeedsBuffer()
    func playerNeedsDismissBuffer()
    func playerBufferPeriodEnds()
    func playerDragLimit()
    func playerTrying(count:Int)
    func playerTryEnd()
}

public class G80PlayerMaid {
    public var bufferItem: G80BufferItem!
    public var __isDragLimited: Bool = false
    public var __isBufferLimited: Bool = false
    public var isTryingSp = false

    public weak var deletegate: G80PlayerMaidProtocol?
    
    // 配置缓冲项目
    public func setup(item: G80BufferItem) {
        bufferItem = item
        __isDragLimited = item.dragTag.isEmpty == false
        __isBufferLimited = item.playTag.isEmpty == false
    }

    /// 播放开始时间
    private var __playStartTime: TimeInterval?
    /// 播放时长
    private var __playDuration: Int = 0
    /// buffer时长
    private var __bufferDuration: Int = 0
    /// buffer周期次数
    private var __bufferedTime: Int = 0

    public func playDurationRepeat() {
        guard __isBufferLimited == true else { return }
        guard deletegate?.isBufferingPause == false else { return }
        guard isTryingSp == false else { return }

        // 一个play period的开始
        if __playStartTime == nil {
            __playStartTime = Date().timeIntervalSince1970
            random(from: bufferItem.min_m_playing_pause,
                   to: bufferItem.max_m_playing_pause,
                   raw: bufferItem.m_playing_pause,
                   assignTo: &__playDuration)
            return
        }

        let now = Date().timeIntervalSince1970
        let lag = now - __playStartTime!
        if Int(lag) > __playDuration {
            // 一个play period结束
            __playStartTime = nil
            deletegate?.playerNeedsBuffer()
            playBufferBegin()
        }
    }

    public func resetBuffer() {
        deletegate?.isBufferingPause = false
        __playStartTime = nil
        __playDuration = 0
        __bufferDuration = 0
        __bufferedTime = 0
    }

    private func playBufferBegin() {
        guard self.isTryingSp == false else { return }

        random(from: bufferItem.min_n_waiting_play,
               to: bufferItem.max_n_waiting_play,
               raw: bufferItem.n_waiting_play,
               assignTo: &__bufferDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(__bufferDuration)) {
            guard self.isTryingSp == false else { return }

            self.__bufferedTime += 1
            self.deletegate?.playerNeedsDismissBuffer()
            if self.__bufferedTime >= self.bufferItem.k_trigger_boot {
                self.deletegate?.playerBufferPeriodEnds()
            }
        }
    }
    //MARK: (trying supreme)
    private var tsTimer: DispatchSourceTimer?
    public var tsLeft: Int = 0
    public func trySp() {
        guard __isBufferLimited == true, let boot = bufferItem else {   return}
        
        tsLeft = boot.trial_duration / 1000
        isTryingSp = true
        let timer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: .global())
        timer.schedule(deadline: .now(), repeating: .milliseconds(1000))
        timer.setEventHandler {
            DispatchQueue.main.async {
                self.tsLeft -= 1
                if self.tsLeft < 0 {
                    self.deletegate?.playerTrying(count: self.tsLeft)
                    self.clearTs()
                } else {
                    self.deletegate?.playerTryEnd()
                }
            }
        }
        timer.activate()
        tsTimer = timer
    }

    private func clearTs() {
        isTryingSp = false
        tsTimer?.cancel()
        tsTimer = nil
        tsLeft = 0
    }
}


extension G80PlayerMaid{
    private func random(from: Int, to: Int, raw: Int, assignTo: inout Int) {
        guard __isBufferLimited == true else { return }

        var max = raw / 1000
        var min = raw / 1000
        if to > 0 { max = to / 1000 }
        if from > 0 { min = from / 1000 }
        let gap = abs(max - min)
        if gap > 0 {
            assignTo = Int(arc4random()) % gap + min
        } else {
            assignTo = min
        }
    }
}
#endif
