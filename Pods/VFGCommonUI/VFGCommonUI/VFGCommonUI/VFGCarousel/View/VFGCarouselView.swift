//
//  VFGCarouselView.swift
//  VFGCommonUI
//
//  Created by Łukasz Lewiński on 20/3/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit

@objc public protocol VFGCarouselDelegate: class {
    func carouselCellImage(forIndex index: Int, isSelected: Bool) -> UIImage?
    func getCurrentCarouselIndex() -> Int
}

@objc public class VFGCarouselView: UIView, VFGViewProtocol {

    // MARK: Outlets

    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var carouselItemTypeLabel: UILabel!
    @IBOutlet weak var carouselItemIdLabel: UILabel!

    // MARK: Global Variables

    var carouselItemList = [VFGModelCarouselItem]()
    var lastSelectedIndexPath = IndexPath(row: 0, section: 0)
    @objc public var carouselItemDidChangeCallback: ((_ selectedItem: VFGModelCarouselItem) -> Void)?

    /** The delegate for VFGCarouselView */
    @objc public weak var delegate: VFGCarouselDelegate?

    // MARK: Constants
    private let nibFileName = "VFGCarouselView"
    private let nibCarouselItemCell = "VFGCarouselCollectionViewCell"

    var currentPage: Int = 0 {
        didSet {
            if currentPage < carouselItemList.count {
                let item = self.carouselItemList[self.currentPage]
                carouselItemTypeLabel.text = item.name ?? ""
                carouselItemIdLabel.text = item.itemId ?? ""
            }
        }
    }

    var pageSize: CGSize {
        var pageSize: CGSize = CGSize()
        if let layout = carouselCollectionView.collectionViewLayout as? UPCarouselFlowLayout {
            pageSize = layout.itemSize
            if layout.scrollDirection == .horizontal {
                pageSize.width += layout.minimumLineSpacing
            } else {
                pageSize.height += layout.minimumLineSpacing
            }
        }
        return pageSize
    }

    // MARK: Initialization and setup

    @objc public convenience init(frame: CGRect,
                                  carouselItemDidChange: @escaping (_ selectedItem: VFGModelCarouselItem) -> Void) {
        self.init(frame: frame)
        self.carouselItemDidChangeCallback = carouselItemDidChange
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        let currentCarouselItemIndex = delegate?.getCurrentCarouselIndex() ?? 0
        lastSelectedIndexPath = IndexPath(row: currentCarouselItemIndex, section: 0)
    }

    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        let view: UIView = loadViewFromNib()
        view.frame = bounds
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        setupCollectionView()
    }

    func setupCollectionView() {
        registerCollectionViewCell()
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
        setupLayout()
    }

    func registerCollectionViewCell() {
        let nib = UINib(nibName: nibCarouselItemCell, bundle: Bundle.vfgCommonUI)
        carouselCollectionView.register(nib, forCellWithReuseIdentifier: VFGCarouselCollectionViewCell.identifier)
    }

    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: nibFileName, bundle: Bundle.vfgCommonUI)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }

    func setupLayout() {
        let layout = UPCarouselFlowLayout()
        layout.itemSize = CGSize(width: carouselCollectionView.frame.size.height,
                                 height: carouselCollectionView.frame.size.height)
        layout.sideItemScale = 0.7
        layout.sideItemAlpha = 1
        layout.scrollDirection = .horizontal
        carouselCollectionView.collectionViewLayout = layout

        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 12)
    }

    // MARK: UI methods

    @objc public func refreshSelectedCarouselItem(list: [VFGModelCarouselItem]) {
        carouselItemList = list
        let currentCarouselItemIndex = delegate?.getCurrentCarouselIndex() ?? 0
        lastSelectedIndexPath = IndexPath(row: currentCarouselItemIndex, section: 0)
        carouselCollectionView.reloadData()
        scrollAndSelectCell(row: lastSelectedIndexPath.row)
    }

    func scrollAndSelectCell(row: Int) {
        if row < carouselItemList.count {
            DispatchQueue.main.async(execute: {
                let indexPath = IndexPath(row: row, section: 0)
                self.collectionView(self.carouselCollectionView, didSelectItemAt: indexPath)
            })
        }
    }

    func updateSelection(forCell cell: VFGCarouselCollectionViewCell?,
                         atIndexPath indexPath: IndexPath,
                         isSelected: Bool) {
        if isSelected {
            cell?.selectCell(image: delegate?.carouselCellImage(forIndex: indexPath.row, isSelected: isSelected))
        } else {
            cell?.unSelectCell(image: delegate?.carouselCellImage(forIndex: indexPath.row, isSelected: isSelected))
        }
    }

}

extension VFGCarouselView: UICollectionViewDataSource {

    @objc public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselItemList.count
    }

    @objc public func collectionView(_ collectionView: UICollectionView,
                                     cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VFGCarouselCollectionViewCell.identifier,
                                                      for: indexPath)

        guard let carouselCell = cell as? VFGCarouselCollectionViewCell else {
            return cell
        }

        let isSelected = lastSelectedIndexPath.row == indexPath.row
        updateSelection(forCell: carouselCell, atIndexPath: indexPath, isSelected: isSelected)

        if indexPath.row < carouselItemList.count {
            carouselCell.showSelectionIcon = carouselItemList[indexPath.row].showSelectionIcon
        } else {
            carouselCell.showSelectionIcon = true
        }

        return carouselCell
    }

    @objc public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.row < carouselItemList.count {
            let itemModel = carouselItemList[indexPath.row]
            if itemModel.showSelectionIcon == false {
                carouselItemDidChangeCallback?(itemModel)
                return
            }
        }

        let lastSelectedCell = collectionView.cellForItem(at:
            lastSelectedIndexPath) as? VFGCarouselCollectionViewCell

        updateSelection(forCell: lastSelectedCell, atIndexPath: lastSelectedIndexPath, isSelected: false)

        let cell = collectionView.cellForItem(at:
            indexPath) as? VFGCarouselCollectionViewCell

        updateSelection(forCell: cell, atIndexPath: indexPath, isSelected: true)

        lastSelectedIndexPath = indexPath

        carouselCollectionView.reloadData()

        currentPage = indexPath.row
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        let itemModel = carouselItemList[indexPath.row]
        carouselItemDidChangeCallback?(itemModel)
    }
}

extension VFGCarouselView: UICollectionViewDelegate {

    @objc public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let layout = carouselCollectionView.collectionViewLayout as? UPCarouselFlowLayout {
            let isHorizontal = layout.scrollDirection == .horizontal
            let pageSide = isHorizontal ? pageSize.width : pageSize.height
            let offset = isHorizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        }
    }
}
