
import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {

    var numberOfColumns = 10
    var numberOfRows = 0
    var shouldPinFirstColumn = true
    var shouldPinFirstRow = true
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var itemsSize = [CGSize]()
    var contentSize: CGSize = .zero
    var dataArray = NSMutableArray()
    var gridData = NSMutableDictionary()

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if  let vc = collectionView.next?.next as? DataGridCollectionViewController {
            dataArray = vc.dataArray
            gridData = vc.gridDict
            numberOfRows = vc.numberOfSections
            numberOfColumns = vc.numberOfColumns
            
        }
        if collectionView.numberOfSections == 0 {
            return
        }

        if itemAttributes.count != collectionView.numberOfSections {
            generateItemAttributes(collectionView: collectionView)
            return
        }

        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if section != 0 && item != 0 {
                    continue
                }

                let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: section))!
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }

                if item == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
            }
        }

    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section][indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for section in itemAttributes {
            let filteredArray = section.filter { obj -> Bool in
                return rect.intersects(obj.frame)
            }

            attributes.append(contentsOf: filteredArray)
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}

// MARK: - Helpers
extension CustomCollectionViewLayout {

    func generateItemAttributes(collectionView: UICollectionView) {
        if itemsSize.count != numberOfColumns {
            calculateItemSizes()
        }

        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0

        itemAttributes = []

        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []

            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[section]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral

                if section == 0 && index == 0 {
                    // First cell should be on top
                    attributes.zIndex = 1024
                } else if section == 0 || index == 0 {
                    // First row/column should be above other cells
                    attributes.zIndex = 1023
                }

                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }

                sectionAttributes.append(attributes)

                xOffset += itemSize.width + 10
                column += 1

                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }

                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height + 10
                }
            }

            itemAttributes.append(sectionAttributes)
        }

        if let attributes = itemAttributes.last?.last {
            contentSize = CGSize(width: contentWidth, height: attributes.frame.maxY)
        }
    }

    func calculateItemSizes() {
        itemsSize = []

        for index in 0..<numberOfRows {
            itemsSize.append(sizeForItemWithColumnIndex(index))
        }
    }

    func sizeForItemWithColumnIndex(_ columnIndex: Int) -> CGSize {
        var text: NSString
        
        if columnIndex == 0 {
             return CGSize(width: 100, height: 30)
        }
        let stringArray = gridData.object(forKey:  String(columnIndex)) as! NSMutableArray
        var height:CGFloat = 0.0
        if let maxString = stringArray.max(by: {($1 as! String).count > ($0 as! String).count}){
            
            height = (maxString as! String).height(withConstrainedWidth: 100, font:  UIFont.systemFont(ofSize: 14.0))
        }
        switch columnIndex {
        case 0:
            text = "MMM-99"

        default:
            text = "Content"
        }

        let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
        
        let width: CGFloat = size.width + 16
        if height < 30 {
            height = 30
        }
        return CGSize(width: 100, height: height)
    }

}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
