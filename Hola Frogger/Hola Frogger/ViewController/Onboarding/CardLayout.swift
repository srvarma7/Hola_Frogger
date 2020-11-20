//
//  CardLayout.swift
//  TabView
//
//  Created by 李昶辰 on 14/5/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import UIKit
class CardLayout: UICollectionViewFlowLayout {
  
  /// MARK: some methods avoiding the code repeat
  
  private var collectionViewHeight: CGFloat {
    return collectionView!.frame.height
  }
  private var collectionViewWidth: CGFloat {
    return collectionView!.frame.width
  }
  
  private var cellWidth: CGFloat {
    return collectionViewWidth*0.7
  }
  
  private var cellMargin: CGFloat {
    return (collectionViewWidth - cellWidth)/7
  }

  private var margin: CGFloat {
    return (collectionViewWidth - cellWidth)/2
  }
    
//preparethe all layout
  override func prepare() {
      super.prepare()
      scrollDirection = .horizontal
      sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
      minimumLineSpacing = 10
      itemSize = CGSize(width: cellWidth, height: collectionViewHeight*0.90)
  }
    
    //caculate the animation for card scroll
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView else { return nil }

        guard let visibleAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        let centerX = collectionView.contentOffset.x + collectionView.bounds.size.width/2
        for attribute in visibleAttributes {

          let distance = abs(attribute.center.x - centerX)
          
          let aprtScale = distance / collectionView.bounds.size.width

          let scale = abs(cos(aprtScale * CGFloat(Double.pi/4)))
          attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return visibleAttributes
    }

    //whether refresh the layout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

