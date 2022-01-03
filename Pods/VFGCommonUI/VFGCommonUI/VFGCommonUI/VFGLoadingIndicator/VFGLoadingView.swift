//
//  VFGLoadingView.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/19/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import PureLayout

@objc public class VFGLoadingView: UIView {

    // MARK: - outlets
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingBackgroundImage: UIImageView!
    @IBOutlet weak var loadingBackgroundImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundDimmedView: UIView!
    @IBOutlet weak var vodafoneLogoImageView: UIImageView!
    private let defaultLineWidth: CGFloat = 4.0
    private let maxSpinnerSize: CGFloat = 100.0

    var shouldShowVodafoneLogo: Bool = false {
        didSet {
            vodafoneLogoImageView.isHidden =  !shouldShowVodafoneLogo
        }
    }
    // MARK: - Private Variables
    @IBInspectable var loadingMessage: String? {
        didSet {
            textLabel?.text = loadingMessage
        }
    }

    // MARK: UIView
    @objc public init(frame: CGRect, loadingMessage: String?) {
        super.init(frame: frame)
        self.loadingMessage = loadingMessage
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Setup

    fileprivate func commonInit() {
        addSubview(spinner)
        if let textLabel: UILabel = textLabel {
            addSubview(textLabel)
        }
        setupConstraints()
    }

    // MARK: public methods

    @objc public func startAnimating() {
        spinner.startAnimating()
    }

    @objc public func stopAnimating() {
        spinner.stopAnimating()
    }

    // MARK: Constraints

    fileprivate func setupConstraints() {
        spinner.autoSetDimension(.height, toSize: 100.0)
        spinner.autoSetDimension(.width, toSize: 100.0)
        spinner.autoCenterInSuperview()

        textLabel?.autoAlignAxis(toSuperviewAxis: .vertical)
        textLabel?.autoPinEdge(.top, to: .bottom, of: spinner, withOffset: 16.0)
        textLabel?.autoPinEdge(toSuperviewEdge: .leading)
        textLabel?.autoPinEdge(toSuperviewEdge: .trailing)
        textLabel?.text = loadingMessage
        textLabel?.numberOfLines = 0
    }

    func updateConstraintsForText(edge: ALEdge) {
        resetTextLabel()
        textLabel?.autoPinEdge(toSuperviewEdge: .leading)
        textLabel?.autoPinEdge(toSuperviewEdge: .trailing)
        textLabel?.autoAlignAxis(toSuperviewAxis: .vertical)
        switch edge {
        case .top:
            textLabel?.autoPinEdge(.bottom, to: .top, of: spinner, withOffset: -16.0)
        case .bottom:
            textLabel?.autoPinEdge(.top, to: .bottom, of: spinner, withOffset: 16.0)
        default:
            break
        }
    }

    private func resetTextLabel() {
        textLabel?.removeFromSuperview()
        textLabel = nil
        textLabel = UILabel()
        textLabel?.textAlignment = .center
        textLabel?.textColor = UIColor.white
        textLabel?.text = loadingMessage

        guard let textLabel: UILabel = textLabel else {
            return
        }
        addSubview(textLabel)
    }

    // MARK: Property accessors
    fileprivate(set) var textLabel: UILabel? = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()

    // MARK: - Private Variables
    private var loadingViewController: VFGLoadingIndicator?

    fileprivate(set) var spinner: VFGSpinnerView = {
        let spinner = VFGSpinnerView()
        spinner.tintColor = UIColor.white
        return spinner
    }()

    override public func awakeFromNib() {
        setup()
    }

    // MARK: private methods

    private func setup() {
        backButton.setImage(UIImage(named: VFGTopBar.backIconImageName, in: Bundle.vfgCommonUI), for: .normal)
        menuButton.setImage(UIImage(named: VFGTopBar.menuIconImageName, in: Bundle.vfgCommonUI), for: .normal)
        spinner.frame = CGRect.init(x: 0,
                                    y: 0,
                                    width: loadingContainerView.frame.size.width,
                                    height: loadingContainerView.frame.size.height)
        loadingContainerView.backgroundColor = UIColor.clear
        loadingContainerView.addSubview(spinner)
        loadingBackgroundImageTopConstraint.constant = UIScreen.hasNotch ? 0 : 20

        self.vodafoneLogoImageView?.isHidden = !self.shouldShowVodafoneLogo

    }

    // MARK: public methods
    @objc public func setLoadingViewController(loadingViewController: VFGLoadingIndicator? = nil) {
        self.loadingViewController = loadingViewController
    }
    @objc public func setHasBackButton(hasButton: Bool) {
        backButton.isHidden = !hasButton
    }
    @objc public func sethasMenuButton(hasButton: Bool) {
        menuButton.isHidden = !hasButton
    }
    @objc public func setBackgroundImage(image: UIImage?) {
        loadingBackgroundImage.image = image
    }
    @objc public func setLoadingThemeColor(color: UIColor) {
        loadingLabel?.textColor = color
        spinner.tintColor = color

    }
    @objc public func setLoadingMessageTxT(message: String) {
        loadingLabel?.text = message
    }
    @objc public func setHasDimmedBackground(isDimmed: Bool) {
        if isDimmed {
            backgroundDimmedView.alpha = 0.5
        } else {
            backgroundDimmedView.alpha = 0
        }
    }
    @objc public func setShowAppSectionAsBackground(appSectionAsBackground: Bool) {
        if appSectionAsBackground {
            loadingBackgroundImage.alpha = 0
        } else {
            loadingBackgroundImage.alpha = 1
        }
    }
    @objc public func changeSpinnerSize(customSize: CGFloat) {
        spinner.autoSetDimension(.height, toSize: customSize)
        spinner.autoSetDimension(.width, toSize: customSize)
        spinner.lineWidth = defaultLineWidth * customSize/maxSpinnerSize
        spinner.autoCenterInSuperview()
    }

    // MARK: - actions

    @IBAction func menuClicked(_ sender: Any) {
        loadingViewController?.delegate?.menuButtonCallback()
    }

    @IBAction func backClicked(_ sender: Any) {
        loadingViewController?.delegate?.backButtonCallback()
    }

}
