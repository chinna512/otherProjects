//
//  ViewController.swift
//  MPool
//
//  Created by Chinnababu on 7/9/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate,CustomviewDelegate,PassTouchesScrollViewDelegate,UIScrollViewDelegate,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var scrollView: CustomScrollView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestedKeywordsLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var yFrame:CGFloat = 0
    var selecetdPieChart:DLPieChart?
    var lastselectedViewIndex:Int?
    var lastSelectedSliceIndex:Int?
    var modelArray = NSMutableArray()
    var popoverView:PopOverViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSearchBar()
    }
    
    func configureSearchBar(){
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
        let textField = self.searchBar.value(forKey: "searchField") as! UITextField;
        textField.frame.size.height = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 6
        let placeholderLabel       = textField.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font     = UIFont.systemFont(ofSize: 10.0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.modelArray.removeAllObjects()
        for subview in contentView.subviews {
            if subview.isKind(of: PieChartView.self){
                subview.removeFromSuperview()
            }
        }
        self.loadDataForTheKeyword(keyWord: searchBar.text!)
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func loadDataForTheKeyword(keyWord:String){
        JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: nil, andFooter: "Loading")
        RestAPI.getDataForTheKeyWord(keyWord: keyWord, callbackHandler:{
            (error:NSError?,data:NSDictionary?)  -> Void in
            DispatchQueue.main.async {
                if data != nil{
                    let keys = data?.allKeys
                    if let titileString = data?["similarskills"]{
                        
                        let partOne = NSMutableAttributedString(string: "Suggested Keywords :" , attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
                        let partTwo = NSMutableAttributedString(string: titileString as! String, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
                        partOne.append(partTwo)
                        self.suggestedKeywordsLabel.attributedText = partOne
                        self.suggestedKeywordsLabel.layoutIfNeeded()
                        self.scrollView.layoutIfNeeded()
                    }
                    for
                        jsonKey in keys! {
                            let model = PieChartModel()
                            let tempArray = data?[jsonKey]
                            if let arrays = tempArray as? NSArray{
                                model.title = jsonKey as! String
                                model.searchResultsString = self.searchBar.text!
                                for  array in arrays {
                                    if  let obj = (array as AnyObject).lastObject as? NSNumber{
                                        model.valuesArray.add(obj)
                                        model.keysArray.add((array as AnyObject).firstObject!!)
                                    }
                                }
                            }
                            if model.valuesArray.count  > 0{
                                self.modelArray.add(model)
                            }
                    }
                    
                    var y = self.suggestedKeywordsLabel.frame.size.height + self.suggestedKeywordsLabel.frame.origin.y
                    for  (index,model) in (self.modelArray as! [PieChartModel]).enumerated(){
                        let customView = PieChartView.instanceFromNib()
                        customView.tag = index + 1
                        customView.frame.size.width = self.view.frame.size.width
                        if model.valuesArray.count >= 15{
                            customView.frame.size.height = self.view.frame.size.width + 90 + 55 + 40
                        }else{
                            var value = CGFloat(model.valuesArray.count/3)
                            if value != 0{
                                value =   value.rounded(.up)
                            }else{
                                value = 1
                            }
                            customView.frame.size.height = self.view.frame.size.width + CGFloat(value * 15) + 65 + 20 + 40
                        }
                        customView.backgroundColor = UIColor.clear
                        customView.frame.origin.y = y
                        ( customView).loadCustomPieChart(model: model, withSearchBarDisplay: true)
                        self.contentView.addSubview(customView )
                        y = y + customView.frame.height + 10
                        customView.delegate = self
                    }
                    self.heightConstraint.constant = y
                    self.scrollView.isUserInteractionEnabled = true
                    self.scrollView.delegate = self
                    self.scrollView.isScrollEnabled = true
                    self.yFrame = y
                    
                }
                JHProgressHUD.sharedHUD.hide()
            }
            
        })
    }
    
    func scrollTouchBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        
    }
    
    func loadPopForthePoint(point:CGPoint){
        showErrorReport(error: "test", sender: self.contentView, forTheLocation:point)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func pieChart(_ pieChart: DLPieChart!, willSelectSliceAt index: UInt, andWithTheLayer pont: CGPoint,customView:PieChartView) {
        DispatchQueue.main.async {
            if(self.popoverView != nil){
                self.popoverView?.dismiss(animated: true, completion: nil)
                self.popoverView = nil
            }
            if self.selecetdPieChart == nil{
                self.selecetdPieChart = pieChart
            }
            else{
                if self.selecetdPieChart?.tag != pieChart.tag{
                    self.selecetdPieChart?.notifyDelegateOfSelectionChange(from: UInt(self.selecetdPieChart!.selectedSliceIndex), to: UInt(self.selecetdPieChart!.selectedSliceIndex), withChange: true)
                    self.selecetdPieChart = pieChart
                }
                
            }
            let point = customView.convert(pont, to: self.contentView)
            self.loadPopForthePoint(point: point)
        }
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = .any
    }
    
    func  selectedViewIndex(index:Int, forThePieChart pieChart:DLPieChart){
        if selecetdPieChart == nil{
            selecetdPieChart = pieChart
        }
        else{
            if selecetdPieChart?.tag != pieChart.tag{
                selecetdPieChart?.notifyDelegateOfSelectionChange(from: UInt(selecetdPieChart!.selectedSliceIndex), to: UInt(selecetdPieChart!.selectedSliceIndex), withChange: true)
                selecetdPieChart = pieChart
            }
        }
    }
    
    func  deSlectedViewIndex(index:Int, forThePieChart pieChart:DLPieChart){
        self.selecetdPieChart = nil
    }
    
    func selectedViewIndex(index:Int) {
        print(index)
    }
    
    func showErrorReport(error: String,sender: AnyObject,forTheLocation location:CGPoint) {
        popoverView = PopOverViewController(nibName: "PopOverViewController", bundle: nil)
        let tempSender = sender as! UIView;
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverView?.textToDisplay = error;
        let font = UIFont.systemFont(ofSize: 17)
        popoverView?.font = font
        popoverView?.preferredContentSize = CGSize(width: 50, height: 50)
        let popoverPresentationController = popoverView?.popoverPresentationController
        popoverPresentationController?.sourceView = tempSender
        popoverPresentationController?.sourceRect = CGRect(x: location.x, y: location.y, width: 10, height: 10)
        popoverPresentationController?.delegate = self
        popoverPresentationController?.passthroughViews = [self.view]
        present(popoverView!, animated: true, completion: nil)
    }
    
    func removeView() {
    }
    
    func share(image: UIImage) {
    }

}

