//
//  VFGLoadingIndicator.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/19/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import PureLayout

@objc public class VFGLoadingIndicator: UIView {

    // MARK: - Private Variables

    private var loadingIndicator: VFGLoadingView?
    private var defaultLoadingMessage: String = "loading..."
    private let defaultImageName: String = "evening_sl"
    private let hasBackButton: Bool = true
    private let hasMenuButton: Bool = true
    private let hasDimmedBackground: Bool = true
    private let appSectionAsBackground: Bool = false

    @objc public weak var delegate: VFGLoadingIndicatorViewProtocol?

    required  public init(frame: CGRect, loadingMessage: String) {
        super.init(frame: frame)
        self.defaultLoadingMessage = loadingMessage
    }

    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = aDecoder.decodeCGRect(forKey: "frame")
        if let defaultLoadingMessage = aDecoder.decodeObject(forKey: "defaultLoadingMessage") as? String {
            self.defaultLoadingMessage = defaultLoadingMessage
        }
    }

    override public var frame: CGRect {
        didSet {
            loadingIndicator?.removeFromSuperview()
            loadingIndicator = nil
            setupView()
        }
    }

    // MARK: - Private Methods
    private func setupView() {
        loadingIndicator = VFGLoadingView(frame: bounds, loadingMessage: defaultLoadingMessage)
        guard let loadingIndicator = loadingIndicator else {
          return
        }
        self.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadingIndicator.backgroundColor = UIColor.clear
        backgroundColor = UIColor.gray.withAlphaComponent(1)
    }

    // MARK: - Configuration Methods
    /**
     sets the loading message of the loading indicator
     - Parameter message: message to be shown
     */
    @objc public func setLoadingMessage(_ message: String) {
        loadingIndicator?.loadingMessage = message
    }

    /**
     Updates label position relative to the spinner
     - Parameter position: takes a value .top or .bottom to update the text position
                           (Only Top and Botton positions are supported)
     */
    @objc public func updateTextPositionTo(position: ALEdge) {
        loadingIndicator?.updateConstraintsForText(edge: position)
    }
    /*
     loading indicator initalizer, takes a class object which implements VFGLoadingIndicatorViewProtocol protocol.
     
     */
    @objc public init(delegate: VFGLoadingIndicatorViewProtocol) {
        super.init(frame: (UIApplication.shared.keyWindow?.frame)!)
        self.delegate = delegate
        let nib = UINib(nibName: "LoadingView", bundle: Bundle.vfgCommonUI)
        guard let loadingView = nib.instantiate(withOwner: nil, options: [:]).first as? VFGLoadingView else {
            return
        }
        loadingIndicator = loadingView
        loadingIndicator?.frame = (UIApplication.shared.keyWindow?.bounds)!
        loadingIndicator?.setLoadingViewController(loadingViewController: self)
    }

    // MARK: - configuration methods
    private func configureLoadingIndicator() {
        let defaultImage = UIImage(named: defaultImageName, in: Bundle.vfgCommonUI)
        loadingIndicator?.setBackgroundImage(image: delegate?.getBackgroundImage?() ?? defaultImage)
        loadingIndicator?.setHasBackButton(hasButton: delegate?.hasBackButton?() ?? hasBackButton)
        loadingIndicator?.sethasMenuButton(hasButton: delegate?.hasMenuButton?() ?? hasMenuButton)
        loadingIndicator?.setLoadingThemeColor(color: delegate?.getThemeColor?() ?? UIColor.white)
        loadingIndicator?.setHasDimmedBackground(isDimmed: delegate?.hasDimmedBackground?() ?? hasDimmedBackground)
        let sectionAsBackground = delegate?.showAppSectionAsBackground?() ?? appSectionAsBackground
        loadingIndicator?.setShowAppSectionAsBackground(appSectionAsBackground: sectionAsBackground)
        loadingIndicator?.setLoadingMessageTxT(message: delegate?.getLoadingMessage?() ?? defaultLoadingMessage)
        loadingIndicator?.shouldShowVodafoneLogo = self.delegate?.shouldShowVodafoneLogo?() ?? false
    }

    /*
     adds the loading view to the keywindow
     */
    @objc public func showLoading() {
        guard let loadingIndicator = loadingIndicator else {
            return
        }
        configureLoadingIndicator()
        loadingIndicator.startAnimating()
        UIApplication.shared.keyWindow?.addSubview(loadingIndicator)
    }

    /*
     remove the loading view to the keywindow
     */
    @objc public func hideLoading() {
        loadingIndicator?.startAnimating()
        loadingIndicator?.removeFromSuperview()
    }
}
