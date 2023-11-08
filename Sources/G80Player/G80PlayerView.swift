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


open class G80PlayerView: IOSVideoPlayerView {
    public lazy var moreButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(tapMore), for: .touchUpInside)
        return btn
    }()

    override open func customizeUIComponents() {
        super.customizeUIComponents()
        // navigation bar
        if let width = backButton.constraints.first(where: { $0.firstAttribute == .width }) {
            backButton.removeConstraint(width)
        }
        navigationBar.insertArrangedSubview(moreButton, at: navigationBar.subviews.count - 1)
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            moreButton.widthAnchor.constraint(equalToConstant: 44),
        ])
        navigationBar.snp.removeConstraints()
        navigationBar.snp.remakeConstraints {
            $0.height.equalTo(44)
            $0.left.equalTo(topMaskView.safeAreaLayoutGuide.snp.left).offset(5).priority(.high)
            $0.right.equalTo(topMaskView.safeAreaLayoutGuide.snp.right).offset(-5).priority(.high)
            $0.top.equalTo(topMaskView)
        }
        // tool bar
        toolBar.pipButton.removeFromSuperview()
        toolBar.audioSwitchButton.removeFromSuperview()
        toolBar.videoSwitchButton.removeFromSuperview()
        toolBar.srtButton.removeFromSuperview()
        toolBar.playbackRateButton.removeFromSuperview()
        toolBar.definitionButton.removeFromSuperview()
        (landscapeButton as? UIButton)?.setImage(UIImage(systemName: "rectangle.portrait.rotate"), for: .normal)
        (landscapeButton as? UIButton)?.setImage(UIImage(systemName: "rectangle.landscape.rotate"), for: .selected)
        // other
        lockButton.isHidden = false
    }

    override open func onButtonPressed(type: PlayerButtonType, button: UIButton) {
        switch type {
        case .back: break
        case .landscape: break
        default: super.onButtonPressed(type: type, button: button)
        }
    }

    override open func updateUI(isLandscape: Bool) {
        super.updateUI(isLandscape: isLandscape)
        landscapeButton.isHidden = false
        lockButton.isHidden = false
    }

    override open func player(layer: KSPlayerLayer, state: KSPlayerState) {
        super.player(layer: layer, state: state)
        // 刷新状态
        let isPlaying = playerLayer?.player.isPlaying ?? false
        toolBar.playButton.isSelected = isPlaying
    }

    @objc open func tapMore() {
    }
}
#endif
