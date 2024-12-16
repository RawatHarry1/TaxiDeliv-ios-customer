//
//  VCIntroVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/06/23.
//

import UIKit

class VCIntroVC: VCBaseVC {

    // MARK: - Outlets
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VCIntroVC.instantiate(fromAppStoryboard: .main)
        return obj
    }

    // MARK: - Variables
    var currentIndex = 0

    override func initialSetup() {
        self.introCollectionView.register(UINib(nibName: "VCIntoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VCIntoCollectionViewCell")
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
    }
}

extension VCIntroVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VCIntoCollectionViewCell", for: indexPath) as? VCIntoCollectionViewCell
        cell?.updateUIWithData(index: indexPath.item)
        return  cell!
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in introCollectionView.visibleCells {
            let indexPath = introCollectionView.indexPath(for: cell)
            currentIndex = indexPath?.item ?? 0
            pageControl.currentPage = currentIndex
        }
    }
}

extension VCIntroVC {
    private func configureCellSize(index : Int) -> CGSize {
        guard let cell = Bundle.main.loadNibNamed("VCIntoCollectionViewCell", owner: self, options:nil)?.first as? VCIntoCollectionViewCell else { return CGSize(width: 0, height: 0) }
        cell.updateUIWithData(index: index)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let width = introCollectionView.width
        let height: CGFloat = 0
        let targetSize = CGSize(width: width, height: height)
        let size = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}

extension VCIntroVC {
    @IBAction func skipBtn(_ sender: UIButton) {
        self.navigationController?.pushViewController(VCWelcomeVC.create(), animated: true)
    }

    @IBAction func nextBtn(_ sender: UIButton) {
        if currentIndex == 3 {
            self.navigationController?.pushViewController(VCWelcomeVC.create(), animated: true)
        } else {
            currentIndex += 1
            pageControl.currentPage = currentIndex
            self.introCollectionView.setContentOffset(CGPoint(x: Int((UIScreen.main.bounds.width)) * currentIndex, y: 0), animated: true)
        }
    }
}
