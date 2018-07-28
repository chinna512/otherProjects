//
//  ViewController.swift
//  MPool
//
//  Created by Chinnababu on 7/9/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate,CustomviewDelegate,PassTouchesScrollViewDelegate,UIScrollViewDelegate,UIPopoverPresentationControllerDelegate,ScatterDelegate {
    

    @IBOutlet weak var promoteButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var copyRightLabel: UILabel!
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
    var popoverView:UIViewController?
    var scatterModel:ScatterModel?
    var scatterChart:ScatterChart?
    var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isLoaded{
            configureSearchBar()
            self.keywordsLabel.isHidden = true
            addTextToCopyRightLabel()
            isLoaded = true
            self.scrollView.delegatePass = self

        }
    }
    
    func addTextToCopyRightLabel(){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy"
        self.copyRightLabel.text = String(format: "© Copyright %@ mpool.com", dateformatter.string(from: Date()))
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
       // self.heightConstraint.constant = yFrame
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        removePopover()
        if  Reachability()!.isReachable{
            self.modelArray.removeAllObjects()
            for subview in contentView.subviews {
                if subview.isKind(of: PieChartView.self){
                    subview.removeFromSuperview()
                    if self.scatterChart != nil{
                        self.scatterChart?.removeFromSuperview()
                    }
                    self.yFrame = self.view.frame.size.height
                }
            }
            self.keywordsLabel.isHidden = true
            self.loadDataForTheKeyword(keyWord: searchBar.text!)
        }else{
            showAlertForNoInternet(message: "No Internet Connection")
        }
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removePopover()
        self.searchBar.endEditing(true)
    }
    
    func loadDataForTheKeyword(keyWord:String){
        JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: nil, andFooter: "Loading")
        RestAPI.getDataForTheKeyWord(keyWord: keyWord,index:0,searchValue:"", callbackHandler:{
            (error:NSError?,data:NSDictionary?)  -> Void in
            DispatchQueue.main.async {
                if data != nil{
                    if let titileString = data?["similarskills"]{
                        let partOne = NSMutableAttributedString(string: "Suggested Keywords :" , attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
                        let partTwo = NSMutableAttributedString(string: titileString as! String, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
                        if partTwo.length>1{
                            partOne.append(partTwo)
                            self.suggestedKeywordsLabel.attributedText = partOne
                            self.keywordsLabel.isHidden = false
                        }
                        self.suggestedKeywordsLabel.layoutIfNeeded()
                        self.scrollView.layoutIfNeeded()
                    }
                    if let tempArray = data?["locations"]{
                        self.createModelFromTheArray(title: "Location Chart - Top Locations", array: tempArray as! NSArray, showPercenatge: false, displaySearchBar: false, searchBarTitile: "")
                        
                    }
                    if let tempArray = data?["experienceRanges"]{
                        self.createModelFromTheArray(title: "Level Chart", array: tempArray as! NSArray, showPercenatge: false, displaySearchBar: false, searchBarTitile: "")
                    }
                    if let tempArray = data?["gender"]{
                        self.createModelFromTheArray(title: "Gender Diversity", array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: false, searchBarTitile: "")
                    }
                    if let tempArray = data?["organizations"]{
                        self.createModelFromTheArray(title: "Organization Chart", array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: false, searchBarTitile: "")
                    }
                    if let tempArray = data?["organizationMovement"]{
                        var titile = ""
                        var searchBarTitile = ""
                        if let movementName = data!["organizationMovementName"]{
                            searchBarTitile = movementName as! String
                            titile = String(format: "Pool movement from %@ to Other companies", movementName as! CVarArg)
                        }
                        self.createModelFromTheArray(title:titile, array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: true, searchBarTitile: searchBarTitile)
                    }
                    if let tempArray = data?["locationMovement"]{
                        var titile = ""
                        var searchBarTitile = ""
                        if let movementName = data!["locationMovementName"]{
                            searchBarTitile = movementName as! String
                            titile = String(format: "Pool movement from %@ to Other locations", movementName as! CVarArg)
                        }
                        self.createModelFromTheArray(title:titile, array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: true, searchBarTitile: searchBarTitile)
                    }
                    if let tempArray = data?["organizationByLocation"]{
                        var titile = ""
                        var searchBarTitile = ""
                        if let movementName = data!["locationMovementName"]{
                            searchBarTitile = movementName as! String
                            titile = String(format: "Pool base at %@", movementName as! CVarArg)
                        }
                        self.createModelFromTheArray(title:titile, array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: true, searchBarTitile: searchBarTitile)
                    }
                    if let scatterDict = data?["skillCompensation"] as? NSDictionary{
                        self.scatterModel = ScatterModel()
                        if let average = scatterDict["skillCompensationAverage"] as? String{
                            self.scatterModel?.skillCompensationAverage = average
                        }
                        for  array in (scatterDict["skillCompensationList"]  as? [NSArray])!{
                            if  let obj = array[1] as? Int {
                                self.scatterModel?.skillCompensationListValues.add(obj)
                            }
                        }
                        for  array in (scatterDict["skillCompensationLevelNames"]  as? [NSArray])!{
                            self.scatterModel?.skillCompensationLevelNames.add(array[0])
                            self.scatterModel?.skillCompensationLevelNamesValues.add(array[1])
                        }
                    }
                    var y = self.suggestedKeywordsLabel.frame.size.height + self.suggestedKeywordsLabel.frame.origin.y
                    for  (index,model) in (self.modelArray as! [PieChartModel]).enumerated(){
                        let customView = PieChartView.instanceFromNib()
                        customView.tag = (index + 1) * 10
                        customView.frame.size.width = self.view.frame.size.width
                        if model.valuesArray.count >= 15{
                            customView.frame.size.height = self.view.frame.size.width + 180
                        }
                        else{
                            var value = CGFloat(model.valuesArray.count/3)
                            if value != 0{
                                value =   value.rounded(.up)
                            }else{
                                value = 1
                            }
                            customView.frame.size.height = self.view.frame.size.width + CGFloat(value * 18) + 90
                        }
                        if model.displaySearchBar{
                            customView.frame.size.height = customView.frame.size.height + 56
                        }
                        customView.backgroundColor = UIColor.clear
                        customView.frame.origin.y = y
                        (customView).loadCustomPieChart(model: model, withSearchBarDisplay: model.displaySearchBar)
                        self.contentView.addSubview(customView )
                        y = y + customView.frame.size.height + 5

//                        if index != self.modelArray.count - 1{
//                            y = y + customView.frame.size.height + 5
//                        }else{
//                            if (self.scatterModel?.skillCompensationListValues.count)!  > 0{
//                                y = y + customView.frame.size.height + 20
//                            }else{
//                                y = y + 20
//                            }
//                        }
                        customView.delegate = self
                    }
                    
                    if (self.scatterModel?.skillCompensationListValues.count)!  < 0{
                        let scatter = ScatterChart.loadInstance()
                        self.scatterChart =   scatter as? ScatterChart
                        self.scatterChart?.loadData(forThePickerValue: self.scatterModel?.skillCompensationAverage, lineIndex: self.scatterModel?.skillCompensationListValues, pointIndex: self.scatterModel?.skillCompensationLevelNamesValues, andSearchText: self.searchBar.text);
                        self.self.scatterChart?.frame.origin.y = y
                        y = y + 473
                        self.contentView.addSubview(self.scatterChart!)
                        self.scatterChart?.delegate = self
                        self.scatterChart?.tag = 100
                    }
                    if self.modelArray.count == 0{
                        self.showToast(message: "Sorry no data found")
                        y = 70
                    }
                    self.scrollView.isUserInteractionEnabled = true
                    self.scrollView.delegate = self
                    self.scrollView.isScrollEnabled = true
                    self.promoteButtonTopConstraint.constant = y
                    y = y + 30
                   // self.heightConstraint.constant = y - self.view.frame.size.height + 100

                    self.yFrame = y
                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: y)
                    self.scrollView.layoutSubviews()
                    self.view.layoutSubviews()

                }else{
                    self.showAlertForNoInternet(message: "Some thing went wrong")
                    
                }
                JHProgressHUD.sharedHUD.hide()
            }
        })
    }
    
    func createModelFromTheArray(title:String,array:NSArray,showPercenatge:Bool,displaySearchBar:Bool,searchBarTitile:String){
        let model = PieChartModel()
        model.title = title
        model.showPercentage = showPercenatge
        model.displaySearchBar = displaySearchBar
        model.searchBarTitile = searchBarTitile
        model.searchResultsString = String(format: "Search result for (%@)", self.searchBar.text!)
        for  array in array  {
            if  let obj = (array as AnyObject).lastObject as? NSNumber{
                if  obj != 0 {
                    model.valuesArray.add(obj)
                    model.keysArray.add((array as AnyObject).firstObject!!)
                }
            }
        }
        if model.valuesArray.count  > 0{
            self.modelArray.add(model)
        }
    }
    
    func scrollTouchBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        removePopover()
    }
    
    func loadPopForthePoint(point:CGPoint, text:String,percentage:String){
        showErrorReport(error:text, percentage: percentage, sender: self.contentView, forTheLocation:point)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func pieChart(_ pieChart: DLPieChart!, willSelectSliceAt index: UInt, andWithTheLayer point: CGPoint,customView:PieChartView, andDisplayValue displayValue:String,andPercentage percentage:String){
        DispatchQueue.main.async {
            self.removePopover()
            if self.selecetdPieChart == nil{
                self.selecetdPieChart = pieChart
            }
            else{
                if self.selecetdPieChart?.tag != pieChart.tag{
                    self.selecetdPieChart?.notifyDelegateOfSelectionChange(from: UInt(self.selecetdPieChart!.selectedSliceIndex), to: UInt(self.selecetdPieChart!.selectedSliceIndex), withChange: true)
                    self.selecetdPieChart = pieChart
                }
                
            }
            let point = customView.convert(point, to: self.contentView)
            self.loadPopForthePoint(point: point, text:displayValue, percentage: percentage)
        }
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = .any
    }
    
    func  selectedViewIndex(index:Int, forThePieChart pieChart:DLPieChart){
        removePopover()
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
    
    func showErrorReport(error: String,percentage:String, sender: AnyObject,forTheLocation location:CGPoint) {
        
        let width = getWidth(withConstrainedHeight: 24, text: error)
        let label = UILabel(frame: CGRect(x: 0, y: 5, width: width + 10, height: 17))
        label.numberOfLines = 1
        label.text = error
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .white
        
        
        let percentageLabel = UILabel(frame: CGRect(x: 0, y: 20, width:  width + 10, height: 17))
        percentageLabel.numberOfLines = 1
        percentageLabel.text = percentage
        percentageLabel.font = UIFont.systemFont(ofSize: 10)
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .white
        
        popoverView = UIViewController()
        popoverView?.view.frame = CGRect(x: location.x, y: location.y, width:  width + 10, height: 40)
        popoverView?.view.backgroundColor = UIColor.gray
        popoverView?.view.addSubview(label)
        popoverView?.view.addSubview(percentageLabel)
        let tempSender = sender as! UIView;
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverView?.preferredContentSize = CGSize(width: width + 10, height: 40)
        let popoverPresentationController = popoverView?.popoverPresentationController
        popoverPresentationController?.sourceView = tempSender
        popoverPresentationController?.sourceRect = CGRect(x: location.x, y: location.y, width: width + 10, height: 40)
        popoverPresentationController?.delegate = self
        popoverPresentationController?.passthroughViews = [self.view]
        present(popoverView!, animated: true, completion: nil)
    }
    
    func getWidth(withConstrainedHeight height: CGFloat, text: String) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return ceil(boundingBox.width)
    }
    
    func removeView() {
        removePopover()
    }
    
    func share(image: UIImage) {
        //        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities:[CustomActivity()])
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities:nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivityType.airDrop,.postToWeibo,.addToReadingList,.assignToContact,.copyToPasteboard,.mail,.message,.openInIBooks,.saveToCameraRoll,.print,.postToVimeo,.postToFlickr,.postToTencentWeibo,  UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
                                                        UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),UIActivityType(rawValue: "net.whatsapp.WhatsApp.ShareExtension"), UIActivityType(rawValue: "com.google.GooglePlus.ShareExtension")]
        
        
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showAlertForNoInternet(message:String){
        var showError : UIAlertController
        var okAction : UIAlertAction
        showError  = UIAlertController(title:"", message: message, preferredStyle:.alert)
        okAction  = UIAlertAction(title: "OK", style: .default, handler: { (action :UIAlertAction!) -> Void in
        })
        showError.addAction(okAction)
        self.present(showError, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removePopover()
    }
    
    func removePopover(){
        if(self.popoverView != nil){
            self.popoverView?.dismiss(animated: true, completion: nil)
            self.popoverView = nil
        }
    }
    
    func searchBarSelectedWithText(searchText:String, andTag index:Int){
        if  Reachability()!.isReachable{
            JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: nil, andFooter: "Loading")
            RestAPI.getDataForSubSearchToTheKeyWord(keyWord: searchText,index:index,  searchValue:searchText , callbackHandler:{
                (error:NSError?,data:NSMutableArray?)  -> Void in
                DispatchQueue.main.async {
                    if data != nil && (data?.count)! > 0{
                        var title =  ""
                        if index == 50{
                            title = String(format: "Pool movement from %@ to Other companies", searchText as CVarArg)
                        }
                        if index == 60{
                            title = String(format: "Pool movement from %@ to Other locations", searchText as CVarArg)
                            
                        }
                        if index == 70{
                            title = String(format: "Pool base at %@", searchText as CVarArg)
                        }
                        let model = PieChartModel()
                        if let arrays = data{
                            model.title = title
                            model.searchResultsString = String(format: "Search result for (%@)", self.searchBar.text!)
                            for  array in arrays {
                                if  let obj = (array as AnyObject).lastObject as? NSNumber{
                                    model.valuesArray.add(obj)
                                    model.keysArray.add((array as AnyObject).firstObject!!)
                                    model.displaySearchBar = true
                                    model.showPercentage = true
                                    
                                }
                            }
                        }
                        if model.valuesArray.count  > 0{
                            self.modelArray.replaceObject(at: 4, with: model)
                        }
                        let customView = PieChartView.instanceFromNib()
                        customView.tag = (index + 1) * 10
                        customView.frame.size.width = self.view.frame.size.width
                        if model.valuesArray.count >= 15{
                            customView.frame.size.height = self.view.frame.size.width + 180
                        }
                        else{
                            var value = CGFloat(model.valuesArray.count/3)
                            if value != 0{
                                value =   value.rounded(.up)
                            }else{
                                value = 1
                            }
                            customView.frame.size.height = self.view.frame.size.width + CGFloat(value * 18) + 90
                        }
                        customView.delegate = self
                        if model.displaySearchBar{
                            customView.frame.size.height = customView.frame.size.height + 56
                        }
                        customView.backgroundColor = UIColor.clear
                        (customView).loadCustomPieChart(model: model, withSearchBarDisplay: model.displaySearchBar)
                        let subView = self.contentView.viewWithTag(index)
                        customView.frame.origin.y = (subView?.frame.origin.y)!
                        customView.tag = (subView?.tag)!
                        subView?.removeFromSuperview()
                        self.contentView.addSubview(customView)
                    }else{
                        if error != nil{
                            self.showAlertForNoInternet(message: "Some thing went wrong")
                        }else{
                            self.showToast(message: "sorry No data found")
                        }
                    }
                    JHProgressHUD.sharedHUD.hide()
                }
            })
        }else{
            showAlertForNoInternet(message: "No Internet Connection")
        }
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func getDataFortheValues(forTheIndex index: Int) {
        if  Reachability()!.isReachable{
            JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: nil, andFooter: "Loading")
            let searchText = self.scatterModel?.skillCompensationLevelNames.object(at: index)
            RestAPI.getDataForTheKeyWord(keyWord: (self.searchBar.text)!,index:100, searchValue:searchText as! String, callbackHandler:{
                (error:NSError?,data:NSDictionary?)  -> Void in
                DispatchQueue.main.async {
                    if data != nil{
                        if let arrays = data!["skillCompensationList"] as? NSArray{
                            self.scatterModel?.skillCompensationListValues.removeAllObjects()
                            for array in (arrays as? [NSArray])!{
                                self.scatterModel?.skillCompensationListValues.add(array.object(at: 1))
                            }
                            if let average = data!["skillCompensationAverage"] as? String{
                                self.scatterChart?.reload(withValues: self.scatterModel?.skillCompensationListValues, andAverageSalary: average)
                            }
                        }
                    }else{
                        if error != nil{
                            self.showAlertForNoInternet(message: "Some thing went wrong")
                        }else{
                            self.showToast(message: "sorry No data found")
                        }
                    }
                    JHProgressHUD.sharedHUD.hide()
                }
            })
        }else{
            showAlertForNoInternet(message: "No Internet Connection")
        }
    }
    
    func scatterChart(_ scatterChart: PNScatterChart!, didSelectAt index: UInt, andWithTheLayer point: CGPoint) {
        removePopover()
        let point = scatterChart.convert(point, to: self.contentView)
        let percentage =  self.scatterModel?.skillCompensationListValues.object(at: Int(index)) as! Int
        self.loadPopForthePoint(point: CGPoint(x: point.x - 50, y: point.y - 5), text:"ExpectedSalary", percentage: String(format: "%d INR", percentage))
    }
    
    func removeScatterPopOver(){
        removePopover()
    }
    
    func shareView(_ scatter: Any!) {
        let tempScatter = scatter as! ScatterChart
        UIGraphicsBeginImageContext(CGSize(width: tempScatter.frame.size.width, height: 300) )
        tempScatter.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        share(image: image)
    }

    @IBAction func promoteApp(_ sender: Any) {
        let myWebsite = NSURL(string:"https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8")
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
}

