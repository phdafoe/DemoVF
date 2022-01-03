//
//  VFUserGuidesViewController.swift
//  VFGMVA10Foundation
//
//  Created by Yago de Martín on 23/07/2019.
//  Copyright © 2021 TSSE. All rights reserved.
//

import UIKit

public class VFUserGuidesViewController: MVA10BottomPopupViewController {
    private let userGuides: UserGuides
    private var currentPageId: String?
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBackground: GradientView! {
        didSet {
            containerViewBackground.startPosition = CGPoint(x: 0.5, y: 0.0)
            containerViewBackground.endPosition = CGPoint(x: 0.5, y: 1.0)
            let color1 = UIColor.VFGWhiteBackground.cgColor
            let color2 = UIColor.VFGVodafonePlatinum.cgColor
            containerViewBackground.colors = [color1, color2]
            containerViewBackground.locations = [0, 1]
        }
    }

    @IBOutlet weak var containerViewShadow: UIView! {
        didSet {
            containerViewShadow.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            containerViewShadow.dropShadow(color: UIColor.black, alpha: 0.7, x: 0, y: -4, blur: 10, spread: 0)
        }
    }

    @IBOutlet weak var userGuidesContainer: UIView!
    @IBOutlet weak var nextCTA: UIButton! {
        didSet {
            nextCTA.addTarget(self, action: #selector(nextCTATapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            let image = UIImage(named: "close")
            closeButton.adjustsImageWhenHighlighted = false
            closeButton.setImage(image, for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
            closeButton.tintColor = UIColor.darkGray
        }
    }
    @IBOutlet weak var tobbyIcon: UIImageView!
    @IBOutlet weak var tobbyContainerView: UIView! {
        didSet {
            tobbyContainerView.dropShadow()
        }
    }
    @IBOutlet weak var tobbyBackgroundView: UIView!
    // MARK: - Constraints
    private var leftConstraint: NSLayoutConstraint?
    // MARK: - UIElements
    private var currentPage: VFUserGuidesPageView?
    public weak var delegate: VFUserGuidesProtocol?
    var initialPage: UserGuidesPage? {
        let page = userGuides.pages[userGuides.initialPage]
        currentPageId = page?.pageId
        return page
    }

    // MARK: - Initializers
    public init(userGuides: UserGuides) {
        self.userGuides = userGuides
        super.init(nibName: "VFUserGuidesViewController", bundle: Bundle.init(for: VFUserGuidesViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configurePage()
        guard let initial = self.initialPage else { return }
        applyButtonStyle(for: initial)
    }

    public func configurePage() {
        guard let initialPage = self.initialPage else { return }
        replacePage(initialPage)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.delegate?.viewIsReady(userGuides: self.userGuides)
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        applyTobbyContainerRound()
        applyContainerViewRoundedCorners()
        applyContainerMask()
        applyMaskOnUserGuidesContainer()
    }

    // MARK: - Autolayout functions
    private func applyTobbyContainerRound() {
        tobbyBackgroundView.layer.cornerRadius = tobbyBackgroundView.bounds.height / 2
        tobbyBackgroundView.layer.masksToBounds = true
    }

    private func applyContainerViewRoundedCorners() {
        if #available(iOS 11.0, *) {
            containerView.layer.cornerRadius = 10
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            containerView.clipsToBounds = true
        }
    }
    private func applyContainerMask() {
        let topRadius: CGFloat = 18.0
        let bottomRadius: CGFloat = 38.0
        let mask = CAShapeLayer()
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        let origin = CGPoint(x: containerView.bounds.width / 2, y: 0)
        let topLeftCorner = CGPoint(x: origin.x - (topRadius + bottomRadius), y: 0)
        let topLeftCirCenter = CGPoint(x: topLeftCorner.x, y: topLeftCorner.y + topRadius)
        let centerCircle = CGPoint(x: topLeftCirCenter.x + (topRadius + bottomRadius), y: topLeftCirCenter.y)
        let topRight = CGPoint(x: centerCircle.x + (topRadius + bottomRadius), y: centerCircle.y)
        let path = UIBezierPath.init(rect: containerView.bounds)
        path.move(to: origin)
        path.addLine(to: topLeftCorner)
        path.addArc(withCenter: topLeftCirCenter, radius: topRadius, startAngle: -.pi / 2, endAngle: 0, clockwise: true)
        path.addArc(withCenter: centerCircle, radius: bottomRadius, startAngle: .pi, endAngle: 0, clockwise: false)
        path.addArc(withCenter: topRight, radius: topRadius, startAngle: -.pi, endAngle: -.pi / 2, clockwise: true)
        path.addLine(to: origin)
        path.close()
        mask.path = path.cgPath
        containerView.layer.mask = mask
    }

    private func applyMaskOnUserGuidesContainer() {
        let heightOfMask: CGFloat = 16.0
        let startPointOfMask = userGuidesContainer.bounds.height - heightOfMask
        let startLocation = startPointOfMask / userGuidesContainer.bounds.height
        let gradientMask = CAGradientLayer(layer: userGuidesContainer.layer)
        gradientMask.frame = userGuidesContainer.bounds
        gradientMask.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientMask.locations = [0.0, NSNumber.init(value: Double(startLocation)), 1.0]
        gradientMask.startPoint = .zero
        gradientMask.endPoint = CGPoint(x: 0, y: 1)
        userGuidesContainer.layer.mask = gradientMask
    }

    @objc private func closeButtonTapped(_ sender: Any) {
        viewWillClose()
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func nextCTATapped(_ sender: Any) {
        guard let currentPage = currentPage else { return }
        self.navigationRequested(for: currentPage.page.pageId)
    }

    private func viewWillClose() {
        guard let currentPageId = currentPageId, let currentPage = userGuides.pages[currentPageId] else { return }
        delegate?.viewWillClose(userGuides: self.userGuides, page: currentPage)
    }

    func navigationRequested(for pageId: String) {
        guard let currentPage = userGuides.pages[pageId] else { return }
        let navigation = currentPage.navigation
        let navigationId = navigation.navigationId.lowercased()
        guard let nextPage = userGuides.pages[navigationId] else { return }
        switch navigation.type {
        case .app:
        self.close(completion: {})
            self.delegate?.sectionActionRequested(userGuides: self.userGuides, page: nextPage)
        case .userguides:
            self.delegate?.nextActionRequested(userGuides: self.userGuides, page: nextPage)
            self.currentPageId = nextPage.pageId
            self.display(page: nextPage)
        }
    }
    func display(page: UserGuidesPage) {
        applyButtonStyle(for: page)
        replacePage(page)
    }

    func close(completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }

    private func applyButtonStyle(for page: UserGuidesPage) {
        let navigation = page.navigation
        nextCTA.setTitle(navigation.navigationTitle, for: .normal)
        UIButton.apply(to: nextCTA, mva10Style: navigation.type.buttonStyle)
    }

    private func replacePage(_ page: UserGuidesPage) {
        let newPage = addPageView(with: page)
        if currentPage != nil {
            let anchor = userGuidesContainer.leadingAnchor
            let width = userGuidesContainer.bounds.width
            let newLeadingConst = newPage.leadingAnchor.constraint(equalTo: anchor, constant: width)
            newLeadingConst.isActive = true
            newPage.alpha = 0
            userGuidesContainer.layoutIfNeeded()
            leftConstraint?.constant = -userGuidesContainer.bounds.width
            newLeadingConst.constant = 0
            UIView.animate(withDuration: 0.35, delay: 0) { self.userGuidesContainer.layoutIfNeeded()
                newPage.alpha = 1.0
                self.currentPage?.alpha = 0.0 } completion: { _ in
                    self.leftConstraint?.isActive = false
                    self.leftConstraint = newLeadingConst
                    self.currentPage = newPage
            }
        } else {
            currentPage = newPage
            leftConstraint = currentPage?.leadingAnchor.constraint(equalTo: userGuidesContainer.leadingAnchor)
            leftConstraint?.isActive = true
        }
    }

    private func addPageView(with page: UserGuidesPage) -> VFUserGuidesPageView {
        let pageView = VFUserGuidesPageView(frame: userGuidesContainer.bounds, page: page)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        userGuidesContainer.addSubview(pageView)
        pageView.topAnchor.constraint(equalTo: userGuidesContainer.topAnchor).isActive = true
        pageView.bottomAnchor.constraint(equalTo: userGuidesContainer.bottomAnchor).isActive = true
        pageView.widthAnchor.constraint(equalTo: userGuidesContainer.widthAnchor).isActive = true
        return pageView
    }

    public override func getPopupHeight() -> CGFloat {
        return min(UIScreen.main.bounds.height, self.view.bounds.height)
    }
        public override func getPopupTopCornerRadius() -> CGFloat {
        return 0
    }
    public override func getDimmingViewAlpha() -> CGFloat {
        return 0.9
    }
    public override func getDimmingViewBackgroundColor() -> UIColor {
        return .white
    }
    public override func shouldPopupDismissInteractivelty() -> Bool {
        return false
    }
}
