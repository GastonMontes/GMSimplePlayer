//
//  GMPlayer.swift
//  GMSimplePlayer
//
//  Created by Gaston Montes on 11/3/17.
//

import AVFoundation
import Kingfisher
import UIKit

private let kPlayerTopBarDefaultHeight = CGFloat(40)
private let kPlayerBottomBarDefaultHeight = CGFloat(72)

private let kPlayerHideBarsAnimationDuration = 0.5
private let kPlayerHideBarsAfterSeconds = Double(5.0)

private let kPlayerSeekingSeconds = Int(15)

private let kPlayerSecondsPerMinute = 60
private let kPlayerSecondsPerHour = 3600
private let kPlayerMinutesPerHour = 60
private let kPlayerTimeFormarHoursMinutesSeconds = "%02i:%02i:%02i"
private let kPlayerTimeFormarMinutesSeconds = "%02i:%02i"

private let kPlayerSliderMaximumTintColorAlpha = CGFloat(0.4)
private let kPlayerSliderImageSize = Float(16)

private let kPlayerTitleFontDefaultSize = 17

@IBDesignable public class GMPlayer: UIView {
    // MARK: - Vars.
    private var playerView: UIView!
    private var playerViewTopBottomViewAreHidden = false
    private var playerDispatcher: GMDispatcher?
    
    private var player: AVQueuePlayer!
    private var playerLayer: AVPlayerLayer!
    private var playerTimeObserver: Any?
    private var playerItemsProtocols = [GMPlayerItemProtocol]()
    private var playerCurrentItemIndex = Int(0)
    
    private var playerTimeSliderHasCustomImage: Bool = false
    
    private var playerCanHideBars = true
    
    // MARK: - IBOutlets.
    @IBOutlet private var playerTopView: UIView?
    @IBOutlet private var playerTopViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var playerTopViewTopMarginConstraint: NSLayoutConstraint?
    
    @IBOutlet private var playerBottomView: UIView?
    @IBOutlet private var playerBottomViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var playerBottomViewBottomMarginConstraint: NSLayoutConstraint?
    
    @IBOutlet private var playerPlayPauseButton: UIButton?
    @IBOutlet private var playerSeekForwardButton: UIButton?
    @IBOutlet private var playerSeekBackwardButton: UIButton?
    @IBOutlet private var playerPreviousButton: UIButton?
    @IBOutlet private var playerNextButton: UIButton?
    
    @IBOutlet private var playerCurrentTimeLabel: UILabel?
    @IBOutlet private var playerDurationTimeLabel: UILabel?
    
    @IBOutlet private var playerTimeSlider: UISlider?
    
    @IBOutlet private var playerImageView: UIImageView?
    
    @IBOutlet private var playerTitleLabel: UILabel?
    
    // MARK: - Inspectables properties.
    @IBInspectable public var tintPlayer: UIColor = UIColor.black {
        didSet {
            self.backgroundColor = tintPlayer
            self.playerView.backgroundColor = tintPlayer
            self.playerLayer.backgroundColor = tintPlayer.cgColor
        }
    }
    
    @IBInspectable public var tintBars: UIColor = UIColor.black {
        didSet {
            self.playerTopView?.backgroundColor = tintBars
            self.playerBottomView?.backgroundColor = tintBars
            self.playerPlayPauseButton?.backgroundColor = tintBars
            self.playerPlayPauseButton?.backgroundColor = tintBars
            self.playerSeekForwardButton?.backgroundColor = tintBars
            self.playerSeekBackwardButton?.backgroundColor = tintBars
            self.playerPreviousButton?.backgroundColor = tintBars
            self.playerNextButton?.backgroundColor = tintBars
            self.playerCurrentTimeLabel?.backgroundColor = tintBars
            self.playerDurationTimeLabel?.backgroundColor = tintBars
            self.playerTimeSlider?.backgroundColor = tintBars
        }
    }
    
    @IBInspectable public var tintControls: UIColor = UIColor.white {
        didSet {
            self.playerTimeSlider?.minimumTrackTintColor = tintControls
            self.playerTimeSlider?.maximumTrackTintColor = tintControls.withAlphaComponent(kPlayerSliderMaximumTintColorAlpha)
            
            self.playerCurrentTimeLabel?.textColor = tintControls
            self.playerDurationTimeLabel?.textColor = tintControls
            
            self.imagePrevious = self.imagePrevious.imageMaskWithColor(color: tintControls)!
            self.imageBack = self.imageBack.imageMaskWithColor(color: tintControls)!
            self.imagePlay = self.imagePlay.imageMaskWithColor(color: tintControls)!
            self.imagePause = self.imagePause.imageMaskWithColor(color: tintControls)!
            self.imageForward = self.imageForward.imageMaskWithColor(color: tintControls)!
            self.imageNext = self.imageNext.imageMaskWithColor(color: tintControls)!
        }
    }
    
    @IBInspectable public var heightControls: CGFloat = kPlayerBottomBarDefaultHeight {
        didSet {
            self.playerBottomViewHeightConstraint?.constant = heightControls
        }
    }
    
    @IBInspectable public var heightNavBar: CGFloat = kPlayerTopBarDefaultHeight {
        didSet {
            self.playerTopViewHeightConstraint?.constant = heightNavBar
        }
    }
    
    @IBInspectable public var timerBarHidden: Double = kPlayerHideBarsAfterSeconds
    @IBInspectable public var timerAnimation: Double = kPlayerHideBarsAnimationDuration
    @IBInspectable public var timerSeek: Int = kPlayerSeekingSeconds
    
    @IBInspectable public var imagePlay: UIImage = UIImage.image(name: "PlayerPlay")
    
    @IBInspectable public var imagePause: UIImage = UIImage.image(name: "PlayerPause") {
        didSet {
            self.playerPlayPauseButton?.setImage(imagePause, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var imageForward: UIImage = UIImage.image(name: "PlayerSeekForward") {
        didSet {
            self.playerSeekForwardButton?.setImage(imageForward, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var imageBack: UIImage = UIImage.image(name: "PlayerSeekBackward") {
        didSet {
            self.playerSeekBackwardButton?.setImage(imageBack, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var imagePrevious: UIImage = UIImage.image(name: "PlayerPrevious") {
        didSet {
            self.playerPreviousButton?.setImage(imagePrevious, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var imageNext: UIImage = UIImage.image(name: "PlayerNext") {
        didSet {
            self.playerNextButton?.setImage(imageNext, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var sliderImage: UIImage = UIImage.imageDot(size: kPlayerSliderImageSize, color: UIColor.white) {
        didSet {
            self.playerTimeSliderHasCustomImage = true
        }
    }
    
    @IBInspectable public var sliderSize: Float = kPlayerSliderImageSize
    
    @IBInspectable public var titleFontSize: Int = kPlayerTitleFontDefaultSize {
        didSet {
            self.playerTitleLabel?.font = UIFont.systemFont(ofSize: CGFloat(titleFontSize))
        }
    }
    
    @IBInspectable public var barsHidden: Bool = false {
        didSet {
            self.playerTopView?.isHidden = barsHidden
            self.playerBottomView?.isHidden = barsHidden
        }
    }
    
    @IBInspectable public var playerLoops: Bool = false
    
    // MARK: - Initialization.
    private func initializeViews() {
        self.loadView()
        self.createDispatcher()
    }
    
    override public init(frame: CGRect) {
        
        super.init(frame: frame)
        
        initializeViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        initializeViews()
    }
    
    deinit {
        self.playerRemoveTimeObserver()
    }
    
    // MARK: - View life cycle.
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        guard self.playerLayer != nil else {
            return
        }
        
        self.playerLayer.frame = self.playerView.bounds
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.playerView.prepareForInterfaceBuilder()
        
        self.initializeViews()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeSliderSetDefaultImage()
    }
    
    // MARK: - Dispatcher functions.
    private func createDispatcher() {
        self.playerDispatcher = GMDispatcher(closure: { [unowned self] in
            if self.playerViewTopBottomViewAreHidden == false {
                self.hideTopAndBottomViews()
            }
        })
    }
    
    // MARK: - View functions.
    private func loadView() {
        self.playerView = Bundle.bundleForPod().bundleLoadViewFromNib(nibName: String(describing: type(of: self)), nibOwner: self)
        self.playerView.frame = self.bounds
        self.addSubview(self.playerView)
        
        self.playerView.constraintsSizeSameAsSuperview()
    }
    
    // MARK: - Top and bottom views functions.
    private func hideTopAndBottomViews() {
        guard self.timerBarHidden > 0 && self.playerCanHideBars else {
            return
        }
        
        self.playerDispatcher?.dispatcherStop()
        
        UIView.animate(withDuration: self.timerAnimation, animations: { [unowned self] in
            self.playerTopViewTopMarginConstraint?.constant = -self.playerTopView!.frameHeight()
            self.playerBottomViewBottomMarginConstraint?.constant = -self.playerBottomView!.frameHeight()
            self.layoutIfNeeded()
            }, completion: { finished in
                self.playerViewTopBottomViewAreHidden = true
        })
    }
    
    private func showTopAndBottomViews() {
        self.playerDispatcher?.dispatcherStop()
        
        UIView.animate(withDuration: self.timerAnimation, animations: { [unowned self] in
            self.playerTopViewTopMarginConstraint?.constant = 0
            self.playerBottomViewBottomMarginConstraint?.constant = 0
            self.layoutIfNeeded()
            }, completion: { finished in
                self.playerViewTopBottomViewAreHidden = false
                self.playerDispatcher?.dispatcherDispatch(after: self.timerBarHidden)
        })
    }
    
    @IBAction private func playerViewTapEvent(sender: UIButton?) {
        if self.playerViewTopBottomViewAreHidden {
            self.showTopAndBottomViews()
        } else {
            self.hideTopAndBottomViews()
        }
    }
    
    // MARK: - Player functions.
    private func playerHandlerStatusChanged() {
        if self.player.status == .readyToPlay {
            self.timeSliderSetDuration()
        }
    }
    
    private func playerAddKVOs() {
        self.player.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.player.addObserver(self, forKeyPath: "currentItem", options: .new, context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let path = keyPath {
            switch path {
            case "status":
                self.playerHandlerStatusChanged()
            case "currentItem":
                self.currentItemChanged()
            default:
                print("Unused KVO key path")
            }
        }
    }
    
    private func playerAddTimeObserver() {
        self.playerRemoveTimeObserver()
        self.playerTimeObserver = self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0, 100),
                                                                      queue: DispatchQueue.main,
                                                                      using: { [unowned self] (elapsedTime: CMTime) -> Void in
                                                                        self.timeSliderUpdateCurrentTime(elapsedTime: Int(CMTimeGetSeconds(elapsedTime)))
        })
    }
    
    private func playerRemoveTimeObserver() {
        if self.playerTimeObserver != nil {
            self.player.removeTimeObserver(self.playerTimeObserver!)
            self.playerTimeObserver = nil
        }
    }
    
    // MARK: - Controls actions.
    @IBAction private func controlPlayPauseAction() {
        self.playerDispatcher?.dispatcherStop()
        
        if self.player.rate > 0 {
            self.player.pause()
            self.playerPlayPauseButton?.setImage(self.imagePlay, for: UIControlState.normal)
        } else {
            self.player.play()
            self.playerPlayPauseButton?.setImage(self.imagePause, for: UIControlState.normal)
        }
        
        if self.timerBarHidden > 0 && self.playerCanHideBars {
            self.playerDispatcher?.dispatcherDispatch(after: self.timerBarHidden)
        }
    }
    
    private func controlSeek(addingSeconds: Int) {
        self.playerDispatcher?.dispatcherStop()
        
        let playerCurrentTime = CMTimeGetSeconds(self.player.currentTime())
        let playerForwardTime = playerCurrentTime + Float64(addingSeconds)
        
        self.player.seek(to: CMTimeMakeWithSeconds(playerForwardTime, 100), completionHandler: { [unowned self] completed in
            if self.timerBarHidden > 0 && self.playerCanHideBars {
                self.playerDispatcher?.dispatcherDispatch(after: self.timerBarHidden)
            }
        })
    }
    
    @IBAction private func controlSeekForwardAction() {
        self.controlSeek(addingSeconds: self.timerSeek)
    }
    
    @IBAction private func controlSeekBackwardAction() {
        self.controlSeek(addingSeconds: -self.timerSeek)
    }
    
    @IBAction private func controlNextAction() {
        self.player.pause()
        self.player.advanceToNextItem()
    }
    
    @IBAction private func controlPreviousAction() {
        if Int(CMTimeGetSeconds(self.player.currentTime())) >= 1 {
            self.controlSeek(addingSeconds: -Int(CMTimeGetSeconds(self.player.currentTime())))
        } else {
            self.previousItemSelected()
        }
    }
    
    // MARK: - Time slider functions.
    private func timeSliderSetDefaultImage() {
        if self.playerTimeSliderHasCustomImage {
            self.playerTimeSlider?.setThumbImage(self.sliderImage, for: UIControlState.normal)
            self.playerTimeSlider?.setThumbImage(self.sliderImage, for: UIControlState.highlighted)
        } else {
            let customImage = UIImage.imageDot(size: self.sliderSize, color: self.tintControls)
            self.playerTimeSlider?.setThumbImage(customImage, for: UIControlState.normal)
            self.playerTimeSlider?.setThumbImage(customImage, for: UIControlState.highlighted)
        }
    }
    
    private func timeSliderSetDuration() {
        guard self.player.currentItem != nil else {
            return
        }
        
        let duration = Int(CMTimeGetSeconds(self.player.currentItem!.asset.duration))
        let hours = duration / kPlayerSecondsPerHour
        let minutes = (duration - kPlayerMinutesPerHour * hours) / kPlayerSecondsPerMinute
        let seconds = duration - kPlayerSecondsPerMinute * minutes - kPlayerSecondsPerHour * hours
        
        if hours > 0 {
            self.playerDurationTimeLabel?.text = String(format: kPlayerTimeFormarHoursMinutesSeconds, hours, minutes, seconds)
        } else {
            self.playerDurationTimeLabel?.text = String(format: kPlayerTimeFormarMinutesSeconds, minutes, seconds)
        }
    }
    
    private func timeSliderUpdateCurrentTime(elapsedTime: Int) {
        let itemDuration = Int(CMTimeGetSeconds(self.player.currentItem!.asset.duration))
        let minutes = elapsedTime / kPlayerSecondsPerMinute
        let seconds = elapsedTime - minutes * kPlayerSecondsPerMinute
        
        self.playerCurrentTimeLabel?.text = String(format: kPlayerTimeFormarMinutesSeconds, minutes, seconds)
        self.playerTimeSlider?.value = Float(elapsedTime) / Float(itemDuration)
    }
    
    @IBAction func timeSliderValueChanged(slider: UISlider) {
        let itemDuration = Int(CMTimeGetSeconds(self.player.currentItem!.asset.duration))
        let timeElapsed = Float(itemDuration) * slider.value
        self.timeSliderUpdateCurrentTime(elapsedTime: Int(timeElapsed))
    }
    
    @IBAction func timeSliderEditionBegins(slider: UISlider) {
        self.player.pause()
        self.playerDispatcher?.dispatcherStop()
    }
    
    @IBAction func timeSliderEditionEnds(slider: UISlider) {
        let currentTime = Int(CMTimeGetSeconds(self.player.currentTime()))
        let itemDuration = Int(CMTimeGetSeconds(self.player.currentItem!.asset.duration))
        let timeSelected = Int(Float(itemDuration) * slider.value)
        
        self.controlSeek(addingSeconds: timeSelected - currentTime)
        self.player.play()
        
        if self.timerBarHidden > 0 && self.playerCanHideBars {
            self.playerDispatcher?.dispatcherDispatch(after: self.timerBarHidden)
        }
    }
    
    // MARK: - Video & audio item functions.
    private func configureView(forItem item: GMPlayerItemProtocol) {
        self.playerImageView?.isHidden = true
        
        if let audioItem = item as? GMPlayerItemAudio {
            self.configureViewForAudio(audioItem: audioItem)
        } else if let videoItem = item as? GMPlayerItemVideo {
            self.configureViewForVideo(videoItem: videoItem)
        }
        
        self.setTitle(forItem: item)
    }
    
    private func configureViewForVideo(videoItem: GMPlayerItemVideo) {
        self.playerDispatcher?.dispatcherDispatch(after: self.timerBarHidden)
        self.playerCanHideBars = true
    }
    
    private func configureViewForAudio(audioItem: GMPlayerItemAudio) {
        if let image = audioItem.playerItemImage() {
            self.setImage(imageNameOrURL: image)
        }
        
        self.playerCanHideBars = false
        self.showTopAndBottomViews()
    }
    
    private func setImage(imageNameOrURL: String) {
        self.playerImageView?.setImage(fromPathOrURL: imageNameOrURL, success: { [unowned self] image in
            self.playerImageView?.isHidden = false
            }, fail: { [unowned self] error in
            self.playerImageView?.isHidden = true
        })
    }
    
    // MARK: - Player functions.
    private func createPlayer(items: [AVPlayerItem]) {
        self.player = AVQueuePlayer(items: items)
        
        self.playerAddKVOs()
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerView!.layer.insertSublayer(self.playerLayer, at: 0)
        
        self.playerAddTimeObserver()
        
        self.playerLayer.frame = self.playerView.bounds
    }
    
    // MARK: - Items functions.
    private func isLastItem() -> Bool {
        return self.player.items().count == 0
    }
    
    private func currentItemChanged() {
        self.playerCurrentItemIndex += 1
        
        guard self.self.playerCurrentItemIndex >= 0 && self.playerCurrentItemIndex < self.playerItemsProtocols.count else {
            if self.isLastItem() && self.playerLoops {
                let items = self.loadItems(items: self.playerItemsProtocols)
                var currentItem = self.player.currentItem
                
                for item in items {
                    self.player.insert(item, after: currentItem)
                    currentItem = item
                }
                
                self.playerCurrentItemIndex = 0
                self.configureView(forItem: self.playerItemsProtocols[0])
                
                self.player.pause()
                self.player.play()
            }
            
            return
        }
        self.playerNextButton?.isEnabled = self.playerCurrentItemIndex < self.playerItemsProtocols.count - 1 || self.playerLoops
        self.timeSliderSetDuration()
        
        self.configureView(forItem: self.playerItemsProtocols[self.playerCurrentItemIndex])

        self.player.play()
    }
    
    private func loadItems(items: [GMPlayerItemProtocol]) -> [AVPlayerItem] {
        var avItems = [AVPlayerItem]()
        
        for item in items {
            avItems.append(AVPlayerItem(url: item.playerItemURL()))
        }
        
        return avItems
    }
    
    private func previousItemsToAdd(currentIndex: Int) -> [GMPlayerItemProtocol] {
        var newItems = [GMPlayerItemProtocol]()
        
        newItems.append(self.playerItemsProtocols[self.playerCurrentItemIndex])
        newItems.append(self.playerItemsProtocols[self.playerCurrentItemIndex + 1])
        
        return newItems
    }
    
    private func previousItemSelected() {
        guard self.playerCurrentItemIndex > 0 else {
            return
        }
        
        self.player.pause()
        self.playerCurrentItemIndex -= 1
        
        let newItems = self.loadItems(items: self.previousItemsToAdd(currentIndex: self.playerCurrentItemIndex))
        
        // NOTE: Decrements again because KVO observer function (currentItemChanged:) increments everytimes.
        self.playerCurrentItemIndex -= 1
        
        var currentItem = self.player.currentItem!
        
        for item in newItems {
            self.player.insert(item, after: currentItem)
            currentItem = item
        }
        
        self.player.advanceToNextItem()
    }
    
    private func setTitle(forItem item: GMPlayerItemProtocol) {
        self.playerTitleLabel?.text = "\(item.playerItemAuthor() ?? "") - \(item.playerItemTitle() ?? "")"
    }
    
    // MARK: - Play functions.
    public func playerPlay(items: [GMPlayerItemProtocol]) {
        self.playerItemsProtocols = items
        self.playerNextButton?.isEnabled = items.count > 1
        
        self.createPlayer(items: self.loadItems(items: items))
        self.player.play()
        
        self.configureView(forItem: items[0])
    }
}
