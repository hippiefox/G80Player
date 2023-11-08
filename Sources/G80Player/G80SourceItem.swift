//
//  File.swift
//  
//
//  Created by pulei yu on 2023/11/7.
//

import Foundation
open class G80SourceItem{
    /// url
    public var remoteUrl: String!
    /// 是否为加密问价
    public var isEncrypted: Bool = false
    /// 是否为本地文件
    public var isLocalSource: Bool = false
    /// 本地地址
    public var localPath: String?
    /// 文件名
    public var fileName: String?
    /// 文件etag
    public var etag: String = ""
    /// 是否为cl文件
    public var isCLLink: Bool = false
    /// 鉴权头文件
    public var headers: [String: String]?
}

 
public struct G80BufferItem{
    public var dragTag: String = ""
    public var playTag: String = ""
    public var drag_ratio: Float = 0
    public var min_drag_duration: Int = 0

    public var k_trigger_boot: Int = 0
    // 固定周期
    public var m_playing_pause: Int = 0
    public var n_waiting_play: Int = 0
    // 随机周期
    public var max_m_playing_pause: Int = 0
    public var min_m_playing_pause: Int = 0
    public var max_n_waiting_play: Int = 0
    public var min_n_waiting_play: Int = 0
    
    public var trial_duration: Int = 0
}
