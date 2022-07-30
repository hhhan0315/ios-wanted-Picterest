//
//  PinterestLayout.swift
//  Picterest
//
//  Created by rae on 2022/07/26.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    private var numberOfItems = 0
    
    // 콜렉션 뷰 콘텐츠 사이즈
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // 캐시에 저장
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // 초기화되거나 뷰가 변경될 때마다 실행
    override func prepare() {
        cache.removeAll()
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }

        let numberOfColumns: Int = 2
        let cellPadding: CGFloat = Constants.spacing
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        // cell의 x 위치 배열
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        // cell의 y 위치 배열
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // 현재 행의 위치
        var column = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            
            let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 위에 계산한 frame을 기반으로 캐시에 저장
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            // 한쪽 열에만 추가되는 것을 방지
            column = yOffset[0] > yOffset[1] ? 1 : 0
        }
    }
    
    // 사각형 내의 모든 셀과 보충 뷰의 레이아웃 속성 반환
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    // 모든 셀의 레이아웃 정보 리턴 (indexPath로 요청 들어올 경우)
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    func update(numberOfItems: Int) {
        self.numberOfItems = numberOfItems
    }
}
