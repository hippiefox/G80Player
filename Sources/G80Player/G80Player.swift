// The Swift Programming Language
// https://docs.swift.org/swift-book
import KSPlayer

open class G80Player: G80PlayerPrototype {
    public var bufferItem: G80BufferItem?

    public lazy var fullPlayerView: G80FullPlayerView = {
        let view = G80FullPlayerView()
        return view
    }()

    override open func setupPlayerView() {
        playerView = fullPlayerView
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        if let bufferItem {
            fullPlayerView.maid.setup(item: bufferItem)
        }
    }
}
