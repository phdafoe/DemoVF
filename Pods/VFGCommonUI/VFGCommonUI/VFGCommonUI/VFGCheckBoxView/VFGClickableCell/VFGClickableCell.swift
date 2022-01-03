//
//  CustomTableViewCell.swift
//  TestProj
//
//  Created by Ahmed Askar on 8/9/17.
//  Copyright © 2017 Askar. All rights reserved.
//

import UIKit
import VFGCommonUtils

@objc public enum ClickableCellStyle: Int {
    case none = 0   // Simple cell with text label "title" and "sub title"
    case toggle     // Right aligned switch control
    case image      // Right aligned image
    case disclosureIndicator    // regular chevron.
    case expandable     //Right aligned down arrow
}

@objc public class ToggleStyle: NSObject {
    fileprivate(set) var isChecked: Bool = false
    fileprivate(set) var toggleSwitch: UISwitch?
    @objc public var onToggleActionComplete: ((_ isChecked: Bool) -> Void)?
}

@objc public class ImageStyle: NSObject {
    fileprivate(set) var contentViewImage: UIImageView?
    @objc public var onClickImageActionComplete: (() -> Void)?
}

@objc public class ExpandStyle: NSObject {
    fileprivate(set) var isExpanded: Bool = false
    @objc public var onExpandComplete: (() -> Void)?
}

@objc public class VFGClickableCell: UITableViewCell {

    @objc public var toggleStyle: ToggleStyle?

    @objc public var imageStyle: ImageStyle?

    @objc public var expandStyle: ExpandStyle?

    @IBOutlet weak private var stripViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak private var stripView: UIView!

    @IBOutlet weak private var viewContent: UIView!

    @IBOutlet weak private var customCellTitle: UILabel!

    @IBOutlet weak private var customCellSubtitle: UILabel!

    private var arrowImage = UIImageView()

    /** Property to set cell title */
    @objc public var cellTitle: String? {
        didSet {
            customCellTitle.text = cellTitle
            customCellTitle.applyStyle(VFGTextStyle.cellTitleColored(UIColor.VFGBlack))
        }
    }

    /** Property to set cell sub-title */
    @objc public var cellSubTitle: String? {
        didSet {
            customCellSubtitle.text = cellSubTitle
            customCellSubtitle.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGBlack))
        }
    }

    /** Property to set strip view color */
    @objc public var stripViewColor: UIColor? {
        didSet {
            stripView.backgroundColor = stripViewColor
        }
    }

    /** Property to assign strip view visibility */
    @objc public var stripViewHidden: Bool = false {
        didSet {
            stripViewWidthConstraint.constant = stripViewHidden ? 0 : 5
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
        }
    }

    /** Property to assign image button incase your cell of type image */
    @objc public var cellImage: UIImage? {
        didSet {
            imageStyle?.contentViewImage?.image = cellImage
        }
    }

    /** Property to assign cell click action */
    public var cellAction: (() -> Void)?

    /** Used to define the cell style */
    public var cellStyle: ClickableCellStyle? {
        didSet {
            switch cellStyle! {
            case .none :
                selectionStyle = .none
                viewContent.translatesAutoresizingMaskIntoConstraints = false
            case .toggle:
                toggleStyle = ToggleStyle()

                let switchBtn = UISwitch()

                switchBtn.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
                switchBtn.onTintColor = UIColor(red: 4/255, green: 123/255, blue: 147/255, alpha: 1)
                switchBtn.layer.cornerRadius = 16.0

                switchBtn.addTarget(self, action: #selector(toggleSwitchAction), for: UIControl.Event.valueChanged)
                switchBtn.translatesAutoresizingMaskIntoConstraints = false
                toggleStyle?.toggleSwitch = switchBtn

                if let toggleSwitch = toggleStyle?.toggleSwitch {
                    viewContent.addSubview(toggleSwitch)
                    let xConstraint = NSLayoutConstraint(item: toggleSwitch,
                                                         attribute: .centerX,
                                                         toItem: viewContent,
                                                         attribute: .centerX,
                                                         constant: 0)
                    let yConstraint = NSLayoutConstraint(item: toggleSwitch,
                                                         attribute: .centerY,
                                                         toItem: viewContent,
                                                         attribute: .centerY,
                                                         constant: 0)
                    viewContent.addConstraints([xConstraint, yConstraint])
                    selectionStyle = .none
                }

            case .image:

                imageStyle = ImageStyle()

                let image = UIImageView()
                image.frame = CGRect(x: 0, y: 20, width: 60.0, height: 60.0)
                image.translatesAutoresizingMaskIntoConstraints = false
                imageStyle?.contentViewImage = image

                guard let contentViewImage = imageStyle?.contentViewImage else {
                    return
                }

                viewContent.addSubview(contentViewImage)

                let topConstraint = NSLayoutConstraint(item: image,
                                                       attribute: .top,
                                                       toItem: viewContent,
                                                       attribute: .top,
                                                       constant: 25)

                let trailingConstraint = NSLayoutConstraint(item: viewContent,
                                                            attribute: .trailing,
                                                            toItem: image,
                                                            attribute: .trailing,
                                                            constant: 11)

                let widthConstraint = NSLayoutConstraint(item: image,
                                                         attribute: .width,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         constant: image.frame.size.width)

                let heightConstraint = NSLayoutConstraint(item: image,
                                                          attribute: .height,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          constant: image.frame.size.height)

                viewContent.addConstraints([widthConstraint, heightConstraint, topConstraint, trailingConstraint])
                NSLayoutConstraint.activate([topConstraint, trailingConstraint, widthConstraint, heightConstraint])

                contentViewImage.contentMode = UIView.ContentMode.center
                selectionStyle = .none

                image.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(clickImageAction(tapGestureRecognizer:)))
                image.addGestureRecognizer(tapGesture)

            case .disclosureIndicator:

                let arrowImage = UIImageView()
                arrowImage.frame = CGRect(x: 0, y: 0, width: 11, height: 20)
                let image = UIImage(named: "right_arrow", in: Bundle.vfgCommonUI, compatibleWith: nil)
                arrowImage.image = image
                arrowImage.contentMode = .scaleToFill
                arrowImage.translatesAutoresizingMaskIntoConstraints = false
                viewContent.addSubview(arrowImage)

                let trailingConstraint = NSLayoutConstraint(item: viewContent,
                                                            attribute: .trailing,
                                                            toItem: arrowImage,
                                                            attribute: .trailing,
                                                            constant: 20)

                let yConstraint = NSLayoutConstraint(item: arrowImage,
                                                     attribute: .centerY,
                                                     toItem: viewContent,
                                                     attribute: .centerY,
                                                     constant: 0)

                let widthConstraint = NSLayoutConstraint(item: arrowImage,
                                                         attribute: .width,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         constant: arrowImage.frame.size.width)

                let heightConstraint = NSLayoutConstraint(item: arrowImage,
                                                          attribute: .height,
                                                          toItem: nil,
                                                          attribute: .notAnAttribute,
                                                          constant: arrowImage.frame.size.height)

                viewContent.addConstraints([trailingConstraint, yConstraint, widthConstraint, heightConstraint])
                selectionStyle = .none
                let clickGesture = UITapGestureRecognizer(target: self, action: #selector(clickAction))
                viewContent.addGestureRecognizer(clickGesture)

            case .expandable:

                expandStyle = ExpandStyle()
                arrowImage.frame = CGRect(x: 0, y: 15, width: 24, height: 13)
                let image = UIImage(named: "down_arrow", in: Bundle.vfgCommonUI, compatibleWith: nil)
                arrowImage.image = image
                arrowImage.contentMode = .scaleToFill
                arrowImage.translatesAutoresizingMaskIntoConstraints = false
                addSubview(arrowImage)

                let topConstraint = NSLayoutConstraint(item: arrowImage, attribute: .top,
                                                       toItem: viewContent, attribute: .top, constant: 44)

                let trailingConstraint = NSLayoutConstraint(item: viewContent, attribute: .trailing,
                                                            toItem: arrowImage, attribute: .trailing, constant: 20)

                let widthConstraint = NSLayoutConstraint(item: arrowImage, attribute: .width,
                                                         toItem: nil, attribute: .notAnAttribute,
                                                         constant: arrowImage.frame.size.width)

                let heightConstraint = NSLayoutConstraint(item: arrowImage, attribute: .height,
                                                          toItem: nil, attribute: .notAnAttribute,
                                                          constant: arrowImage.frame.size.height)

                addConstraints([topConstraint, trailingConstraint, widthConstraint, heightConstraint])
                selectionStyle = .none
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandAction))
                viewContent.addGestureRecognizer(tapGesture)
            }
        }
    }

    @objc public override func awakeFromNib() {
        viewContent.layer.shadowColor = UIColor.lightGray.cgColor
        viewContent.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewContent.layer.shadowOpacity = 0.8
        viewContent.layer.shadowRadius = 3
        viewContent.layer.masksToBounds = false
    }

    @objc private func clickAction() {
        cellAction?()
    }

    @objc public func setImageAction(_ action: @escaping () -> Void) {
        guard let image = imageStyle else {
            VFGDebugLog("Calling setImage action on empty image optional")
            return
        }
        image.onClickImageActionComplete = action
    }

    @objc public  func setToggleAction(_ action: @escaping (Bool) -> Void) {
        guard let toggle = toggleStyle else {
            VFGDebugLog("Calling setToggleAction on empty toggle optional")
            return
        }
        toggle.onToggleActionComplete = action
    }

    @objc public func setExpandAction(_ action: @escaping () -> Void) {
        if let expand = expandStyle {
            expand.onExpandComplete = action
        }
    }

    @objc private func toggleSwitchAction(sender: AnyObject) {
        guard let switchBtn: UISwitch = sender as? UISwitch else {
            VFGErrorLog("Calling toggleSwitchAction on empty UISwitch optional")
            return
        }

        toggleStyle?.isChecked = switchBtn.isOn

        guard let toggleStyle = toggleStyle,
            let callback = toggleStyle.onToggleActionComplete else {
            VFGErrorLog("ToggleSwitchAction callback is missing")
            return
        }
        callback(toggleStyle.isChecked)
    }

    @objc private func clickImageAction(tapGestureRecognizer: UITapGestureRecognizer) {
        guard let callback = imageStyle?.onClickImageActionComplete else {
            VFGErrorLog("clickImageAction callback is missing")
            return
        }
        callback()
    }
}

extension VFGClickableCell {
    @objc private func expandAction() {
        var angle: CGFloat = 0.0
        if let expand = expandStyle {
            if expand.isExpanded {
                angle = Angle.doublePi
                stripViewHidden = false
                expandStyle?.isExpanded = false
            } else {
                angle = CGFloat.pi
                stripViewHidden = true
                expand.isExpanded = true
            }
        }

        UIView.animate(withDuration: 2, animations: {
            self.layoutIfNeeded()
        })

        UIView.animate(withDuration: 0.7) {[weak self] in
            let cgaTransform = CGAffineTransform.identity.rotated(by: angle)
            self?.arrowImage.transform = cgaTransform
        }

        if let callBack = expandStyle?.onExpandComplete {
            callBack()
        }
    }
}
