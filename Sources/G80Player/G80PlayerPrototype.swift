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


open class G80PlayerPrototype: UIViewController {
    public var item: G80SourceItem!
    public var playerView: G80PlayerView!

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
        configUI()
        setupPlayer()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    open func setupPlayerView() {
        fatalError("stub implementation")
    }

    open func configUI() {
        view.backgroundColor = .black
        view.addSubview(playerView)
        playerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    open func setupPlayer() {
        KSOptions.logLevel = .panic
        KSOptions.isSecondOpen = true
        KSOptions.isAutoPlay = true
        KSOptions.isAccurateSeek = true
        KSOptions.firstPlayerType = item.isCLLink ? KSMEPlayer.self : KSAVPlayer.self
        KSOptions.secondPlayerType = KSMEPlayer.self

        let options = KSOptions()
        options.hardwareDecode = true
        options.subtitleDisable = true
        // 配置headers
        if let headers = item.headers {
            options.appendHeader(headers)
        }

        // 播放源URL
        var url: URL?
        let isLocalFile: Bool = item.isLocalSource

        if isLocalFile,
           let localPath = item.localPath {
            url = URL(fileURLWithPath: localPath)
        } else {
            url = URL(string: item.remoteUrl)
        }

        guard var playURL = url else {
            print("player url error,exit and retry...")
            return
        }

        // 播放源加密
        if item.isEncrypted,
           isLocalFile == false {
            playURL = transmitUrl(url: playURL)
        }

        // 播放源播放
        let resource = KSPlayerResource(url: playURL, options: options, name: item.fileName ?? "")
        playerView.set(resource: resource)
        // 卡顿配置
    }

    open func transmitUrl(url: URL) -> URL {
        fatalError("stub implementation")
    }

    deinit {
        print("-----> \(self.classForCoder.description()) deinit")
        NotificationCenter.default.removeObserver(self)
    }
}
#endif
