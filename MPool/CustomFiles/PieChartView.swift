
//
//  PieChartView.swift
//  EXampleChart
//
//  Created by Chinnababu on 6/14/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

protocol CustomviewDelegate {
    func  selectedViewIndex(index:Int, forThePieChart pieChart:DLPieChart)
    func  deSlectedViewIndex(index:Int, forThePieChart pieChart:DLPieChart)
    func pieChart(_ pieChart: DLPieChart!, willSelectSliceAt index: UInt, andWithTheLayer point: CGPoint,customView:PieChartView, andDisplayValue displayValue:String, andPercentage percentage:String)
    func removeView()
    func share(image:UIImage)
    func searchBarSelectedWithText(searchText:String, andTag index:Int)

}
class PieChartView: UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CustomDelegate,UIPopoverPresentationControllerDelegate,UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchString: UILabel!
    @IBOutlet weak var titile: UILabel!
    @IBOutlet weak var heightConstarint: NSLayoutConstraint!
    @IBOutlet weak var pieChartView: UIView!
    
    @IBOutlet weak var titileTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTop: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var colorsArray = NSMutableArray()
    var valuesArray = NSMutableArray()
    var delegate:CustomviewDelegate?
    var isTwoRows:Bool = false
    var piechart:UIView?
    var viewHeight:CGFloat?

    class func instanceFromNib() -> PieChartView {
        return UINib(nibName: "PieChartView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PieChartView
    }
    
    func customizeSearchBar(){
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
        let textField = self.searchBar.value(forKey: "searchField") as! UITextField;
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 6
        textField.textAlignment = .center
    }
    
    func loadCustomPieChart(model:PieChartModel, withSearchBarDisplay isDisplay:Bool){
        if !isDisplay{
            self.titileTopConstarint.constant = 37
            self.searchBar.isHidden = true
        }
        else{
            customizeSearchBar()
            searchBar.text = model.searchBarTitile
        }
        var frame = self.pieChartView.frame
        frame.size.height = self.frame.size.width - 60
        frame.size.width =  frame.size.height
        viewHeight = self.frame.size.height
        frame.origin.y = 0
        let piechart = DLPieChart.init(frame: frame)
        piechart.customDelegate = self
        piechart.tag = self.tag + 1
        let array = NSMutableArray()
        for (index, value) in (model.valuesArray).enumerated(){
            array.add(value)
            colorsArray.add(generateRandomColor())
            valuesArray.add(model.keysArray.object(at: index))
        }
        self.titile.text = model.title
        self.searchString.text = model.searchResultsString
        if model.valuesArray.count > 12{
            self.heightConstarint.constant = 90
        }else{
            var value = CGFloat(model.valuesArray.count/3)
            if value != 0{
                value =   value.rounded(.up)
            }else{
                value = 1
            }
            self.heightConstarint.constant = CGFloat(value * 18)
        }
        piechart.showPercentage = model.showPercentage
        piechart.render(inLayer: piechart, dataArray: array, withColors: colorsArray, andWithDisplayValues: valuesArray)
        self.pieChartView.addSubview(piechart)
        if valuesArray.count == 2{
            isTwoRows = true
            self.collectionViewLeadingConstraint.constant = 70
            self.collectionViewTrailing.constant = 60
        }else{
            self.collectionViewLeadingConstraint.constant = 20
        }
        loadCollectionView()
        self.layoutSubviews()
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    func getRandomColor() -> UIColor{
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorsArray.count
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "uicollectionviewcell", for: indexPath) as! CollectionViewCell
    cell.colorButton.backgroundColor = self.colorsArray.object(at: indexPath.row) as? UIColor
    cell.descriptionLabel.text = self.valuesArray.object(at: indexPath.row) as? String
    return cell
    }
    
    func loadCollectionView(){
        self.collectionView.frame.size.width = self.frame.size.width
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        DispatchQueue.main.async {
            if !self.isTwoRows{
                let size = (self.collectionView.frame.size.width - 12)/3
                flowLayout.itemSize = CGSize(width: size, height: 15)
            }else{
                let size = (self.collectionView.frame.size.width - 12)/2
                flowLayout.itemSize = CGSize(width: size, height: 15)
            }
            flowLayout.invalidateLayout()
        }
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "uicollectionviewcell")
        self.collectionView.dataSource = self;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            let size = (self.collectionView.frame.size.width - 8)/3
            return CGSize(width: size, height: 30)
        } else {
            let size = (self.collectionView.frame.size.width - 8)/3
            return CGSize(width: size, height: 30)
        }
    }

     func viewWillLayoutSubviews() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        DispatchQueue.main.async {
            if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
                let size = (self.collectionView.frame.size.width - 12)/4
                flowLayout.itemSize = CGSize(width: size, height: size)
            } else {
                let size = (self.collectionView.frame.size.width - 10)/3
                flowLayout.itemSize = CGSize(width: size, height: size)
            }
            flowLayout.invalidateLayout()
        }
    }
    
    func pieChart(_ pieChart: DLPieChart!, willSelectSliceAt index: UInt, andWithTheLayer point: CGPoint, andDisplayVlaue displayValue:String ,andPercentage percentage:String) {
        let point1 = pieChart.convert(point, to: self)
        self.delegate?.pieChart(pieChart, willSelectSliceAt: index, andWithTheLayer: point1,customView: self, andDisplayValue:displayValue, andPercentage:percentage)
    }
    
    func removeView(){
        self.delegate?.removeView()
    }
    @IBAction func share(_ sender: Any) {
        self.delegate?.share(image: asImage())
    }
    

    func asImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.frame.size.width, height: viewHeight! + 20) )
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.size.width, height: viewHeight!), isOpaque, 0.0)
        if UIGraphicsGetCurrentContext() != nil {
            UIColor.white.setFill()
            drawHierarchy(in: bounds, afterScreenUpdates: true)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return screenshot
        }
        return nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.removeView()
        self.searchBar.endEditing(true)
        self.delegate?.searchBarSelectedWithText(searchText:searchBar.text!, andTag: self.tag)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.delegate?.removeView()
        self.searchBar.endEditing(true)
    }
    
}
extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
    
}
