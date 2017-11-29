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

private let kPlayerImageBorderDefaultSize = Float(16)
private let kPlayerImageBorderDefaultColor = UIColor(red: 25 / 255, green: 25 / 255, blue: 25 / 255, alpha: 1.0)

private let kPlayerBottomAudioHeightConstraint = CGFloat(136)
private let kPlayerBottomVideoHeightConstraint = CGFloat(88)

@IBDesignable public class GMPlayer: UIView {
    // MARK: - Vars.
    private var playerView: UIView!
    private var playerViewTopBottomViewAreHidden = false
    private var playerDispatcher: GMDispatcher?
    
    private var player: AVQueuePlayer!
    private var playerLooper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer!
    private var playerTimeObserver: Any?
    private var playerItems = [AVPlayerItem]()
    private var playerItemsShuffleBackup = [AVPlayerItem]()
    private var playerItemsProtocols = [GMPlayerItemProtocol]()
    private var playerItemsProtocolsShuffleBackup = [GMPlayerItemProtocol]()
    private var playerCurrentItemIndex = Int(0)
    
    private var playerTimeSliderHasCustomImage: Bool = false
    
    private var playerCanHideBars = true
    
    private var playerLoops = false
    
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
    @IBOutlet private var playerShuffleButton: UIButton?
    @IBOutlet private var playerLoopButton: UIButton?
    
    @IBOutlet private var playerCurrentTimeLabel: UILabel?
    @IBOutlet private var playerDurationTimeLabel: UILabel?
    
    @IBOutlet private var playerTimeSlider: UISlider?
    
    @IBOutlet private var playerImageView: UIImageView?
    
    @IBOutlet private var playerTitleLabel: UILabel?
    
    @IBOutlet private var playerItemNameLabel: UILabel?
    @IBOutlet private var playerItemAuthorLabel: UILabel?
    
    // MARK: - Inspectables properties.
    @IBInspectable public var tintPlayer: UIColor = UIColor.black {
        didSet {
            self.backgroundColor = tintPlayer
            self.playerView.backgroundColor = tintPlayer
        }
    }
    
    @IBInspectable public var tintBars: UIColor = UIColor.black {
        didSet {
            self.playerTopView?.backgroundColor = tintBars
            self.playerBottomView?.backgroundColor = tintBars
            self.playerPlayPauseButton?.backgroundColor = tintBars
            self.playerSeekForwardButton?.backgroundColor = tintBars
            self.playerSeekBackwardButton?.backgroundColor = tintBars
            self.playerPreviousButton?.backgroundColor = tintBars
            self.playerNextButton?.backgroundColor = tintBars
            self.playerCurrentTimeLabel?.backgroundColor = tintBars
            self.playerDurationTimeLabel?.backgroundColor = tintBars
            self.playerTimeSlider?.backgroundColor = tintBars
            self.playerShuffleButton?.backgroundColor = tintBars
            self.playerLoopButton?.backgroundColor = tintBars
            self.playerTitleLabel?.backgroundColor = tintBars
            self.playerItemNameLabel?.backgroundColor = tintBars
            self.playerItemAuthorLabel?.backgroundColor = tintBars
        }
    }
    
    @IBInspectable public var tintControls: UIColor = UIColor.white {
        didSet {
            self.playerTimeSlider?.minimumTrackTintColor = tintControls
            self.playerTimeSlider?.maximumTrackTintColor = tintControls.withAlphaComponent(kPlayerSliderMaximumTintColorAlpha)
            
            self.playerCurrentTimeLabel?.textColor = tintControls
            self.playerDurationTimeLabel?.textColor = tintControls
            
            self.playerTitleLabel?.textColor = tintControls
            self.playerItemNameLabel?.textColor = tintControls
            self.playerItemAuthorLabel?.textColor = tintControls
            
            self.imagePrevious = self.imagePrevious.imageMaskWithColor(color: tintControls)!
            self.imageBack = self.imageBack.imageMaskWithColor(color: tintControls)!
            self.imagePlay = self.imagePlay.imageMaskWithColor(color: tintControls)!
            self.imagePause = self.imagePause.imageMaskWithColor(color: tintControls)!
            self.imageForward = self.imageForward.imageMaskWithColor(color: tintControls)!
            self.imageNext = self.imageNext.imageMaskWithColor(color: tintControls)!
            self.imageLoop = self.imageLoop.imageMaskWithColor(color: tintControls)!
            self.imageLoopSelected = self.imageLoopSelected.imageMaskWithColor(color: tintControls)!
            self.imageShuffle = self.imageShuffle.imageMaskWithColor(color: tintControls)!
            self.imageShuffleSelected = self.imageShuffleSelected.imageMaskWithColor(color: tintControls)!
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
            self.playerPlayPauseButton?.setBackgroundImage(imagePause, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var imageForward: UIImage = UIImage.image(name: "PlayerSeekForward") {
        didSet {
            self.playerPlayPauseButton?.setBackgroundImage(imageForward, for: UIControlState.selected)
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
    
    @IBInspectable public var imageShuffle: UIImage = UIImage.image(name: "shuffle") {
        didSet {
            self.playerShuffleButton?.setImage(imageShuffle, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var imageShuffleSelected: UIImage = UIImage.image(name: "shuffleSelected") {
        didSet {
            self.playerShuffleButton?.setImage(imageShuffleSelected, for: UIControlState.selected)
        }
    }
    
    @IBInspectable public var imageLoop: UIImage = UIImage.image(name: "PlayerLoop") {
        didSet {
            self.playerLoopButton?.setImage(imageLoop, for: UIControlState.normal)
        }
    }
    
    @IBInspectable public var imageLoopSelected: UIImage = UIImage.image(name: "PlayerLoopSelected") {
        didSet {
            self.playerLoopButton?.setImage(imageLoopSelected, for: UIControlState.selected)
        }
    }
    
    @IBInspectable public var sliderImage: UIImage = UIImage.imageDot(size: kPlayerSliderImageSize, color: UIColor.white) {
        didSet {
            self.playerTimeSliderHasCustomImage = true
        }
    }
    
    @IBInspectable public var sliderSize: Float = kPlayerSliderImageSize
    
    @IBInspectable public var barsHidden: Bool = false {
        didSet {
            self.playerTopView?.isHidden = barsHidden
            self.playerBottomView?.isHidden = barsHidden
        }
    }
    
    @IBInspectable public var imageBorderSize: Float = kPlayerImageBorderDefaultSize
    @IBInspectable public var imageBorderColor: UIColor = kPlayerImageBorderDefaultColor
    
    @IBInspectable public var layerGravity: AVLayerVideoGravity = AVLayerVideoGravity.resizeAspect
    
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
        guard self.playerPlayPauseButton != nil else {
            return
        }
        
        self.playerDispatcher?.dispatcherStop()
        
        self.playerPlayPauseButton?.isSelected = !self.playerPlayPauseButton!.isSelected
        
        if self.player.rate > 0 {
            self.player.pause()
//            self.playerPlayPauseButton?.setImage(self.imagePlay, for: UIControlState.normal)
        } else {
            self.player.play()
//            self.playerPlayPauseButton?.setImage(self.imagePause, for: UIControlState.normal)
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
        if self.player.rate > 0 {
            if Int(CMTimeGetSeconds(self.player.currentTime())) >= 1 || self.playerItems.count <= 1 {
                self.controlSeek(addingSeconds: -Int(CMTimeGetSeconds(self.player.currentTime())))
            } else {
                self.previousItemSelected()
            }
        }
    }
    
    // MARK: - Loop action functions.
    private func loopAddMissingItems() {
        for item in self.playerItems {
            if self.player.canInsert(item, after: self.player.items().last) {
                self.player.insert(item, after: self.player.items().last)
            }
        }
    }
    
    private func loopDeletePlayedItems() {
        for item in self.playerItems {
            if self.playerItems.index(of: item)! < self.playerCurrentItemIndex {
                self.player.remove(item)
            }
        }
    }
    
    @IBAction private func controlLoopAction() {
        guard self.playerLoopButton != nil else {
            return
        }
        
        self.playerLoops = !self.playerLoops
        
        if self.playerLoops == true {
            self.loopAddMissingItems()
        } else {
            self.loopDeletePlayedItems()
        }
        
        self.playerLoopButton!.isSelected = !self.playerLoopButton!.isSelected
        self.configurePlayerNextButton()
    }
    
    // MARK: - Shuffle functions.
    private func shuffleDeleteItemsExceptCurrent() {
        for item in self.player.items() {
            if item != self.player.currentItem {
                self.player.remove(item)
            }
        }
        
        self.playerItems.removeAll()
        self.playerItemsProtocols.removeAll()
        
        self.playerItems.append(self.player.currentItem!)
        self.playerItemsProtocols.append(self.playerItemsProtocolsShuffleBackup[self.playerCurrentItemIndex])
    }
    
    private func shuffleAddRandomItems() {
        while self.player.items().count < self.playerItemsShuffleBackup.count {
            let randomInt = Int.random(range: 0..<self.playerItemsShuffleBackup.count)
            let randomItem = self.playerItemsShuffleBackup[randomInt]
            let randomProtocol = self.playerItemsProtocolsShuffleBackup[randomInt]
            
            if self.player.canInsert(randomItem, after: self.player.items().last) {
                self.player.insert(randomItem, after: self.player.items().last)
                self.playerItems.append(randomItem)
                self.playerItemsProtocols.append(randomProtocol)
            }
        }
        
        self.playerCurrentItemIndex = 0
    }
    
    private func shuffleAddNotPlayedItems() {
        self.playerItems = self.playerItemsShuffleBackup
        self.playerItemsProtocols = self.playerItemsProtocolsShuffleBackup
        self.playerCurrentItemIndex = self.playerItems.index(of: self.player.currentItem!)!
        
        for item in self.playerItems {
            if self.playerItems.index(of: item)! > self.playerCurrentItemIndex {
                self.player.insert(item, after: self.player.items().last)
            }
        }
    }
    
    private func shuffleAddPlayedItems() {
        for item in self.playerItems {
            if self.playerItems.index(of: item)! < self.playerCurrentItemIndex {
                self.player.insert(item, after: self.player.items().last)
            }
        }
    }
    
    @IBAction private func controlShuffleAction() {
        guard self.playerShuffleButton != nil else {
            return
        }
        
        self.playerShuffleButton!.isSelected = !self.playerShuffleButton!.isSelected
        
        self.shuffleDeleteItemsExceptCurrent()
        
        if self.playerShuffleButton!.isSelected == true {
            self.shuffleAddRandomItems()
        } else {
            self.shuffleAddNotPlayedItems()
            
            if self.playerLoops {
                self.shuffleAddPlayedItems()
            }
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
    private func configurePlayerNextButton() {
        let isOnlyItem = self.playerItems.count == 1
        let isLastItem = self.playerCurrentItemIndex >= self.playerItemsProtocols.count - 1
        self.playerNextButton?.isEnabled = (!isLastItem || self.playerLoops) && !isOnlyItem
        self.playerShuffleButton?.isEnabled = !isOnlyItem
    }
    
    private func configureView(forItem item: GMPlayerItemProtocol) {
        self.configurePlayerNextButton()
        
        self.timeSliderSetDuration()
        self.playerImageView?.isHidden = true
        
        if let audioItem = item as? GMPlayerItemAudio {
            self.configureViewForAudio(audioItem: audioItem)
        } else if let videoItem = item as? GMPlayerItemVideo {
            self.configureViewForVideo(videoItem: videoItem)
        }
    }
    
    private func configureViewForVideo(videoItem: GMPlayerItemVideo) {
        self.playerDispatcher?.dispatcherDispatch(after: self.timerBarHidden)
        self.playerCanHideBars = true
        self.setTitle(forItem: videoItem)
    }
    
    private func configureViewForAudio(audioItem: GMPlayerItemAudio) {
        if let image = audioItem.playerItemImage() {
            self.setImage(imageNameOrURL: image)
        }
        
        self.setTextProperties(forItem: audioItem)
        
        self.playerCanHideBars = false
        self.showTopAndBottomViews()
    }
    
    private func setImage(imageNameOrURL: String) {
        self.playerImageView?.setImage(fromPathOrURL: imageNameOrURL, success: { [unowned self] image in
            guard self.playerImageView != nil else {
                return
            }
            
            self.playerImageView!.isHidden = false
            
            let playerSize = (self.playerImageView!.frameWidth() > self.playerImageView!.frameHeight()) ? self.playerImageView!.frameHeight() : self.playerImageView!.frameWidth()
            
            self.playerImageView?.border(withRadius: Float(playerSize / 2), borderWidth: self.imageBorderSize, borderColor: self.imageBorderColor)
            }, fail: { [unowned self] error in
                self.playerImageView?.isHidden = true
        })
    }
    
    // MARK: - Player functions.
    private func createPlayer(layerGravity: AVLayerVideoGravity) {
        self.player = AVQueuePlayer(items: self.playerItems)
        
        // AVPlayerLooper only works with 1 item.
        if self.playerLoops && self.playerItems.count == 1 {
            self.playerLooper = AVPlayerLooper(player: self.player, templateItem: self.playerItems[0])
        }
        
        self.playerAddKVOs()
        
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = layerGravity
        self.playerView!.layer.insertSublayer(self.playerLayer, at: 0)
        self.playerLayer.backgroundColor = tintPlayer.cgColor
        
        self.playerAddTimeObserver()
        
        self.playerLayer.frame = self.playerView.bounds
    }
    
    private func configurePlayer(forItem item: GMPlayerItemProtocol) {
        
    }
    
    // MARK: - Items functions.
    private func playNextItem(lastItem: AVPlayerItem) {
        self.player.seek(to: kCMTimeZero)
        self.configureView(forItem: self.playerItemsProtocols[self.playerCurrentItemIndex])
        self.player.play()
        
        if self.playerLoops && self.player.canInsert(lastItem, after: self.player.items().last) {
            self.player.insert(lastItem, after: self.player.items().last)
        }
    }
    
    private func currentItemChanged() {
        self.playerCurrentItemIndex += 1
        
        guard self.self.playerCurrentItemIndex >= 0 && self.playerCurrentItemIndex < self.playerItemsProtocols.count else {
            // If it's a single video looping is going to enter here everytime.
            
            if self.playerItems.count > 1 && self.playerLoops {
                // Set to 0 because if player is looping with multiples videos is going to entre here again.
                // So set playerCurrentItemIndex to 0 to restar the looping.
                self.playerCurrentItemIndex = 0
                self.playNextItem(lastItem: self.playerItems.last!)
            } else {
                // Last item finished.
                guard self.player.items().count < 1 else {
                    return
                }
                
                self.controlPlayPauseAction()
                
                var currentItem: AVPlayerItem?
                
                for playerItem in self.playerItems {
                    self.player.insert(playerItem, after: currentItem)
                    currentItem = playerItem
                }
                
                self.playerCurrentItemIndex = 0
                self.playNextItem(lastItem: self.playerItems[self.playerCurrentItemIndex])
                
                if self.playerLoops == false {
                    self.player.pause()
                }
            }
            
            return
        }
        
        self.playNextItem(lastItem: self.playerItems[self.playerCurrentItemIndex - 1])
    }
    
    private func loadPlayerItems(items: [GMPlayerItemProtocol]) {
        for item in items {
            self.playerItems.append(AVPlayerItem(url: item.playerItemURL()))
        }
        
        self.playerItemsShuffleBackup = self.playerItems
    }
    
    private func getPlayerItems(fromProtocol items: [GMPlayerItemProtocol]) -> [AVPlayerItem] {
        var avItems = [AVPlayerItem]()
        
        for item in items {
            avItems.append(AVPlayerItem(url: item.playerItemURL()))
        }
        
        return avItems
    }
    
    private func previousItemSelected() {
        let currentItemIndex = self.playerCurrentItemIndex - 1
        
        guard currentItemIndex >= 0 else {
            self.playerCurrentItemIndex = 0
            
            if self.playerLoops {
                self.playerCurrentItemIndex = self.playerItems.count
                self.previousItemSelected()
            }
            
            return
        }
        
        self.player.pause()
        
        let lastItem = self.player.items().first
        let currentItem = self.playerItems[currentItemIndex]
        
        self.player.remove(currentItem)
        self.player.insert(currentItem, after: lastItem)
        
        self.player.advanceToNextItem()
        self.configureView(forItem: self.playerItemsProtocols[currentItemIndex])
        
        self.player.remove(lastItem!)
        self.player.insert(lastItem!, after: currentItem)
        
        self.playerCurrentItemIndex = currentItemIndex
    }
    
    private func setTextProperties(forItem item: GMPlayerItemAudio) {
        self.playerTitleLabel?.text = item.playerTitle()
        
        self.playerBottomViewHeightConstraint?.constant = kPlayerBottomAudioHeightConstraint
        self.playerItemNameLabel?.text = item.playerItemTitle()
        self.playerItemAuthorLabel?.text = item.playerItemAuthor()
    }
    
    private func setTitle(forItem item: GMPlayerItemVideo) {
        self.playerTitleLabel?.text = "\(item.playerItemAuthor() ?? "") - \(item.playerItemTitle() ?? "")"
        
        self.playerBottomViewHeightConstraint?.constant = kPlayerBottomVideoHeightConstraint
        self.playerItemNameLabel?.text = ""
        self.playerItemAuthorLabel?.text = ""
    }
    
    // MARK: - Play functions.
    public func playerPlay(items: [GMPlayerItemProtocol], layerGravity: AVLayerVideoGravity = .resizeAspect) {
        self.playerItemsProtocols = items
        self.playerItemsProtocolsShuffleBackup = self.playerItemsProtocols
        
        self.playerNextButton?.isEnabled = items.count > 1
        
        self.loadPlayerItems(items: items)
        self.createPlayer(layerGravity: layerGravity)
        self.player.play()
        
        self.configureView(forItem: items[0])
    }
}
