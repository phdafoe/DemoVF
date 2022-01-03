//
//  VFGSettingsViewController.swift
//  VFGCommonUI
//
//  Created by Ehab on 11/28/17.
//

import UIKit

@objc public protocol SettingDelegate: class {
    func itemDidSelected(title: String)
    func userMsisdn() -> String
}

public protocol SettingDataSource {
    func sectionsDataSource() -> [VFGSettingsSection]
}

@objc open class VFGSettingsViewController: UIViewController, VFGViewControllerContent {

    private var bottomInsetValue: CGFloat = 50.0
    private var topInsetValue: CGFloat = UIScreen.hasNotch ? 109 : 65
    private var greyViewTopOffset: CGFloat = 148

    @objc public weak var delegate: SettingDelegate?

    public var dataSource: SettingDataSource?

    var sections: [VFGSettingsSection] = [VFGSettingsSection]()

    @IBOutlet var tableView: UITableView!

    private let privacySettingsMsisdnUserdefaultsKey: String = "PrivacySettingsMsisdn"
    // MARK: - VFGViewControllerContent
    public var statusBarState: VFGRootViewControllerStatusBarState = .defaultState
    @objc public var topBarScrollState: VFGTopBarScrollState? = VFGTopBarScrollState()
    @objc public var topBarTitle: String = "Settings"
    @objc public var topBarRightButtonHidden: Bool = false

    // MARK: - Top Bar
    internal var containerYOffsetBasedOnContenView: CGFloat = 0 {
        didSet {
            topBarScrollState?.didScroll(withOffset: containerYOffsetBasedOnContenView)
        }
    }

    internal var contentOriginYBasedOnContainer: CGFloat = 0 {
        didSet {
            topBarScrollState?.alphaChangeYPosition = contentOriginYBasedOnContainer
        }
    }

    private func resetTopBar() {
        tableView.setContentOffset(.zero, animated: false)
        containerYOffsetBasedOnContenView = 0.0
    }

    private func computedContentYOrigin() -> CGFloat {
        return VFGCommonUISizes.statusBarHeight + baseFrameForShadowBackground().minY
    }

    private func baseFrameForShadowBackground() -> CGRect {
        var frame = view.bounds
        frame.origin.y = VFGTopBar.topBarHeight
        frame.size.height -= frame.origin.y
        return frame
    }

    @IBOutlet weak private var pagetitleLabel: UILabel!
    @IBOutlet weak private var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var greyViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @objc static public func viewController() -> VFGSettingsViewController {
        let story = UIStoryboard(name: "VFGSettings", bundle: Bundle.vfgCommonUI)
        guard let settingsVC = story.instantiateInitialViewController() as? VFGSettingsViewController else {
            return VFGSettingsViewController()
        }
        return settingsVC
    }

    @objc override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        let msisdn: String = self.delegate?.userMsisdn() ?? ""
        UserDefaults.standard.set(msisdn, forKey: self.privacySettingsMsisdnUserdefaultsKey)
        if let sectionsList: [VFGSettingsSection] = self.dataSource?.sectionsDataSource() {
            sections = sectionsList
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.bounces = true
        tableView.contentInset.bottom = bottomInsetValue
        tableViewTopConstraint.constant = topInsetValue
    }

    /// Use to setup the view with the content of the model
    private func setupView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        pagetitleLabel.applyStyle(VFGTextStyle.pageTitleColored(UIColor.VFGWhite))
        pagetitleLabel.text = "Settings"
    }

    @objc override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTopBar()
    }
}

// MARK: UITableViewDataSource
extension VFGSettingsViewController: UITableViewDataSource {

    @objc public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    @objc public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].subSection.count
    }

    @objc public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCellID",
                                                 for: indexPath)
        guard let settingsCell = cell as? VFGSettingsTableViewCell else {
            return cell
        }
        settingsCell.setup(title: sections[indexPath.section].subSection[indexPath.row].title,
                           body: sections[indexPath.section].subSection[indexPath.row].body,
                           isSwitchHidden: sections[indexPath.section].subSection[indexPath.row].isSwitchHidden)
        return settingsCell

    }

}
extension VFGSettingsViewController: UITableViewDelegate {

    @objc public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderTableViewCellID")
        guard let settingHeaderCell = cell as? VFGSettingsHeaderTableViewCell else {
            return cell
        }
        settingHeaderCell.setup(title: sections[section].title)
        return settingHeaderCell.contentView
    }

    @objc public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }

    @objc public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }

    @objc public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.itemDidSelected(title: self.sections[indexPath.section].subSection[indexPath.row].title)
    }
}

extension VFGSettingsViewController: UIScrollViewDelegate {
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !contentOriginYBasedOnContainer.equalsWithEpsilon(other: computedContentYOrigin()) {
            contentOriginYBasedOnContainer = computedContentYOrigin()
        }
        if UIScreen.hasNotch {
            if VFGRootViewController.shared.nudgeView.willDisappear {
                topInsetValue = 109
            } else {
                topInsetValue = 109 - VFGCommonUISizes.statusBarHeight
            }
            tableViewTopConstraint.constant = topInsetValue
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        greyViewTopConstraint.constant = -scrollView.contentOffset.y + greyViewTopOffset
        let offset = scrollView.contentOffset.y >= 0 ? scrollView.contentOffset.y : 0
        containerYOffsetBasedOnContenView = offset
    }
}
