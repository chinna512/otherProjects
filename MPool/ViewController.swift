//
//  ViewController.swift
//  MPool
//
//  Created by Chinnababu on 7/9/18.
//  Copyright © 2018 Chinnababu. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ViewController: UIViewController,UISearchBarDelegate,CustomviewDelegate,PassTouchesScrollViewDelegate,UIScrollViewDelegate,UIPopoverPresentationControllerDelegate,ScatterDelegate,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var scrollView: CustomScrollView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestedKeywordsLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var promotAppButton: UIButton!
    
    
    var yFrame:CGFloat = 0
    var selecetdPieChart:DLPieChart?
    var lastselectedViewIndex:Int?
    var lastSelectedSliceIndex:Int?
    var modelArray = NSMutableArray()
    var popoverView:POPOverViewController?
    var scatterModel:ScatterModel?
    var scatterChart:ScatterChart?
    var isLoaded = false
    var searchResultsArray:NSArray = NSArray()
    var isSearchBarClicked:Bool = false
    var listOfSearches:NSMutableArray = NSMutableArray()
    var searchTableView:UITableView?
    var image:UIImage?
    var searchText:String = ""
    
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
            self.totalCount.isHidden = true
            addTextToCopyRightLabel()
            isLoaded = true
            self.scrollView.delegatePass = self
            self.promotAppButton.layer.cornerRadius = 5
            self.searchButton.roundedButton()

        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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
        textField.clearButtonMode = .never
        let placeholderLabel = textField.value(forKey: "placeholderLabel") as? UILabel
        placeholderLabel?.font     = UIFont.systemFont(ofSize: 10.0)
        textField.leftViewMode = .never;

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func startSearchingResults(){
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
            self.totalCount.isHidden = true
            var text = searchBar?.text
          text =  text?.trimmingCharacters(in: .whitespaces)
            if (text?.count)! > 0{
                self.loadDataForTheKeyword(keyWord: searchBar.text!)
            }
        }else{
            showAlertForNoInternet(message: "No Internet Connection")
        }
        self.searchBar.endEditing(true)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if ((searchBar.text?.count)! > 0) {
            self.isSearchBarClicked = false
            removePopover()
            checkIsDatAvailableAlready()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchBarClicked = true
        startSearchingResults()
        removeTableView()
    }
    
    func loadDataForTheKeyword(keyWord:String){
        JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: nil, andFooter: "Loading")
        RestAPI.getDataForTheKeyWord(keyWord: keyWord,index:0,searchValue:"", callbackHandler:{
            (error:NSError?,data:NSDictionary?)  -> Void in
            DispatchQueue.main.async {
                if data != nil{
                    self.searchText = self.searchBar.text!
                    if let titileString = data?["similarskills"]{
                        let partOne = NSMutableAttributedString(string: "Suggested Keywords :" , attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)])
                        let partTwo = NSMutableAttributedString(string: titileString as! String, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)])
                        if partTwo.length>1{
                            partOne.append(partTwo)
                            self.suggestedKeywordsLabel.attributedText = partOne
                            self.keywordsLabel.isHidden = false
                            self.totalCount.isHidden = false
                        }
                        self.suggestedKeywordsLabel.layoutIfNeeded()
                        self.scrollView.layoutIfNeeded()
                    }
                    
                    if let totalCount = data!["totalCount"]{
                        self.totalCount.text = String(format: "Total Pool Count : %d", totalCount as! Int)
                    }
                    if let tempArray = data?["locations"]{
                         let model =  self.createModelFromTheArray(title: "Location Chart - Top Locations", array: tempArray as! NSArray, showPercenatge: false, displaySearchBar: false, searchBarTitile: "")
                        model.customTag = 160

                        
                    }
                    if let tempArray = data?["experienceRanges"]{
                        self.createModelFromTheArray(title: "Level Chart", array: tempArray as! NSArray, showPercenatge: false, displaySearchBar: false, searchBarTitile: "")
                    }
                    if let tempArray = data?["gender"]{
                        let model = self.createModelFromTheArray(title: "Gender Diversity", array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: false, searchBarTitile: "")
                        model.isGenderView = true
                        model.customTag = 150
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
                        let model =
                            self.createModelFromTheArray(title:titile, array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: true, searchBarTitile: searchBarTitile)
                        model.customTag = 120
                        
                    }
                    if let tempArray = data?["locationMovement"]{
                        var titile = ""
                        var searchBarTitile = ""
                        if let movementName = data!["locationMovementName"]{
                            searchBarTitile = movementName as! String
                            titile = String(format: "Pool movement from %@ to Other locations", movementName as! CVarArg)
                        }
                        let model =      self.createModelFromTheArray(title:titile, array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: true, searchBarTitile: searchBarTitile)
                        model.customTag = 130
                    }
                    if let tempArray = data?["organizationByLocation"]{
                        var titile = ""
                        var searchBarTitile = ""
                        if let movementName = data!["locationMovementName"]{
                            searchBarTitile = movementName as! String
                            titile = String(format: "Pool base at %@", movementName as! CVarArg)
                        }
                        let model =     self.createModelFromTheArray(title:titile, array: tempArray as! NSArray, showPercenatge: true, displaySearchBar: true, searchBarTitile: searchBarTitile)
                        model.customTag = 140
                        
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
                            if  let obj = array[3] as? Int {
                                self.scatterModel?.averageSalary = Float(obj)
                            }
                        }
                        for  array in (scatterDict["skillCompensationLevelNames"]  as? [NSArray])!{
                            self.scatterModel?.skillCompensationLevelNames.add(array[0])
                            self.scatterModel?.skillCompensationLevelNamesValues.add(array[1])
                        }
                    }
                    var y = self.suggestedKeywordsLabel.frame.size.height + self.suggestedKeywordsLabel.frame.origin.y + 30
                    for  (index,model) in (self.modelArray as! [PieChartModel]).enumerated(){
                        var tempHeight:CGFloat = 0.0
                        if model.valuesArray.count >= 15{
                            tempHeight  = self.view.frame.size.width + 150 + 20
                        }
                        else{
                            var value = CGFloat(model.valuesArray.count/3)
                            if value != 0{
                                value =   value.rounded(.up)
                            }else{
                                value = 1
                            }
                            tempHeight = self.view.frame.size.width + CGFloat(value * 18) + 60
                        }
                        if index == self.modelArray.count - 1 {
                            if !((self.scatterModel?.skillCompensationListValues.count)!  > 0) {
                                model.showPromotButton = true
                                tempHeight = tempHeight + 50
                            }else{
                            }
                        }
                        if model.displaySearchBar{
                            tempHeight = tempHeight + 56
                        }
                        
                        let customView =  PieChartView.instanceFromNib()
                        customView.tag = (index + 1) * 10
                        customView.customTag = model.customTag
                        customView.backgroundColor = UIColor.clear
                        customView.frame.size.width = self.view.frame.size.width
                        customView.viewHeight = tempHeight
                    
                        customView.frame.origin.y = y
                        (customView).loadCustomPieChart(model: model, withSearchBarDisplay: model.displaySearchBar)
                        self.contentView.addSubview(customView )
                        y = y + customView.frame.size.height + 5
                        customView.delegate = self
                    }
                    
                    if (self.scatterModel?.skillCompensationListValues.count)!  > 0{
                        let scatter = ScatterChart.loadInstance()
                        self.scatterChart =   scatter as? ScatterChart
                        
                        self.scatterChart?.averageSalary = CGFloat((self.scatterModel?.averageSalary)!)
                        self.scatterChart?.viewWidth = self.view.frame.size.width
                        self.scatterChart?.loadData(forThePickerValue: self.scatterModel?.skillCompensationAverage, lineIndex: self.scatterModel?.skillCompensationListValues, pointIndex: self.scatterModel?.skillCompensationLevelNamesValues, andSearchText: self.searchBar.text);
                        self.self.scatterChart?.frame.origin.y = y
                        y = y + 462
                        self.contentView.addSubview(self.scatterChart!)
                        self.scatterChart?.delegate = self
                        self.scatterChart?.tag = 190
                    }else{
                        y = y + 30
                    }
                    if self.modelArray.count == 0{
                        self.showToast(message: "Sorry no data found")
                        y = self.scrollView.frame.size.height
                        self.promotAppButton.isHidden = false
                    }
                    else{
                        self.promotAppButton.isHidden = true
                    }
                    self.scrollView.isUserInteractionEnabled = true
                    self.scrollView.delegate = self
                    self.scrollView.isScrollEnabled = true
                    self.heightConstraint.constant = y - self.scrollView.frame.size.height
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
    
  @discardableResult  func createModelFromTheArray(title:String,array:NSArray,showPercenatge:Bool,displaySearchBar:Bool,searchBarTitile:String) -> PieChartModel {
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
        return model
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
        
      //  let width = getWidth(withConstrainedHeight: 24, text: error)
        popoverView = POPOverViewController(nibName: "POPOverViewController", bundle: nil)
        popoverView?.view.frame = CGRect(x: location.x, y: location.y, width:130, height: 40)
        popoverView?.view.backgroundColor = .white
        popoverView?.loadDataWith(title:error,subTitile:percentage)
        let tempSender = sender as! UIView;
        popoverView?.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverView?.preferredContentSize = CGSize(width:130, height: 40)
        let popoverPresentationController = popoverView?.popoverPresentationController
        popoverPresentationController?.sourceView = tempSender
        popoverPresentationController?.sourceRect = CGRect(x: location.x, y: location.y, width: 130, height: 40)
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
        
        shareView(self.scatterChart)

//        let myWebsite = NSURL(string:"https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8")
//        guard let url = myWebsite else {
//            print("nothing found")
//            return
//        }
//        self.image = image
//
//        let text = "iOSDevCenter have best tutorials of swift"
//        let image1 = UIImage(named: "Image")
//        let shareAll = [text , image , url] as [Any]
//        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
//
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)

        
        
        
        
        
        
//        let shareItems:Array = [url]
////        let activityViewController1:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
////        self.present(activityViewController1, animated: true, completion: nil)
//
//
//
//
//        //        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities:[CustomActivity()])
//
//        let activityViewController = UIActivityViewController(activityItems: [image, URL.init(string: "https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8")!], applicationActivities: nil)

      //  let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities:nil)
    //    activityViewController.popoverPresentationController?.sourceView = self.view
//      //  activityViewController.excludedActivityTypes = [UIActivityType.airDrop,.postToWeibo,.addToReadingList,.assignToContact,.copyToPasteboard,.mail,.message,.openInIBooks,.saveToCameraRoll,.print,.postToVimeo,.postToFlickr,.postToTencentWeibo,  UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"),
//                                                        UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),UIActivityType(rawValue: "net.whatsapp.WhatsApp.ShareExtension"), UIActivityType(rawValue: "com.google.GooglePlus.ShareExtension")]
//        
        
        
        //self.present(activityViewController, animated: true, completion: nil)
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
    
    func searchBarSelectedWithText(searchText:String, andTag index:Int,andCustomTag customTag:Int){
        if  Reachability()!.isReachable{
            JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: nil, andFooter: "Loading")
            RestAPI.getDataForSubSearchToTheKeyWord(keyWord: searchText,index:index,  searchValue:self.searchBar.text!, customTag: customTag , callbackHandler:{
                (error:NSError?,data:NSMutableArray?)  -> Void in
                DispatchQueue.main.async {
                    if data != nil && (data?.count)! > 0{
                        var title =  ""
                        if customTag == 120{
                            title = String(format: "Pool movement from %@ to Other companies", searchText as CVarArg)
                        }
                        if customTag == 130{
                            title = String(format: "Pool movement from %@ to Other locations", searchText as CVarArg)
                            
                        }
                        if customTag == 140{
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
                        let tempIndex = (index/10) - 1
                        if model.valuesArray.count  > 0{
                            self.modelArray.replaceObject(at: tempIndex, with: model)
                        }
                        let customView = PieChartView.instanceFromNib()
                        customView.tag = (index + 1) * 10
                        customView.customTag = customTag
                        customView.frame.size.width = self.view.frame.size.width
                        if model.valuesArray.count >= 15{
                            customView.frame.size.height = self.view.frame.size.width + 150 + 20
                        }
                        else{
                            var value = CGFloat(model.valuesArray.count/3)
                            if value != 0{
                                value =   value.rounded(.up)
                            }else{
                                value = 1
                            }
                            customView.frame.size.height = self.view.frame.size.width + CGFloat(value * 18) + 60
                        }
                        customView.delegate = self
                        if model.displaySearchBar{
                            customView.frame.size.height = customView.frame.size.height + 56
                        }
                        if tempIndex == self.modelArray.count - 1 {
                            if !((self.scatterModel?.skillCompensationListValues.count)!  > 0) {
                                model.showPromotButton = true
                                customView.frame.size.height = customView.frame.size.height + 50
                            }else{
                            }
                        }
                        if model.displaySearchBar{
                            customView.frame.size.height = customView.frame.size.height + 56
                        }
                        model.searchBarTitile = searchText
                        customView.backgroundColor = UIColor.clear
                        customView.viewHeight = customView.frame.size.height
                        (customView).loadCustomPieChart(model: model, withSearchBarDisplay: model.displaySearchBar)
                        let subView = self.contentView.viewWithTag(index)
                        customView.frame.origin.y = (subView?.frame.origin.y)!
                        customView.tag = (subView?.tag)!
                        customView.customTag = customTag
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
            RestAPI.getDataForTheKeyWord(keyWord: (self.searchBar.text)!,index:190, searchValue:searchText as! String, callbackHandler:{
                (error:NSError?,data:NSDictionary?)  -> Void in
                DispatchQueue.main.async {
                    if data != nil{
                        if let arrays = data!["skillCompensationList"] as? NSArray{
                            self.scatterModel?.skillCompensationListValues.removeAllObjects()
                            for array in (arrays as? [NSArray])!{
                                self.scatterModel?.skillCompensationListValues.add(array.object(at: 1))
                                if  let obj = array[3] as? Int {
                                    self.scatterModel?.averageSalary = Float(obj)
                                }
                            }
                            if let average = data!["skillCompensationAverage"] as? String{
   self.scatterChart?.averageSalary = CGFloat((self.scatterModel?.averageSalary)!)
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
        
        let value = percentage
        
        // "1,605,436" where Locale == en_US
        
        let formattedInt = String(format: "%d", locale:Locale(identifier:"en_IN"), value)
        self.loadPopForthePoint(point: CGPoint(x: point.x - 50, y: point.y - 5), text:"ExpectedSalary", percentage: String(format: "%@ INR", formattedInt))
    }
    
    func removeScatterPopOver(){
        removePopover()
    }
    
    func promoteApp(){
        let myWebsite = NSURL(string:"https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8")
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareView(_ scatter: Any!) {
        let tempScatter = self.contentView
        UIGraphicsBeginImageContext(CGSize(width: self.contentView.frame.size.width, height: yFrame) )
        tempScatter?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        composeMailImage(image: image)
    }
    
    func composeMailImage(image:UIImage){
        let emailTitle = String(format: "Market Intelligence for Skills %@ ", searchText)
        let messageBody = String(format: "Please find market intelligence for Skills %@, \n %@",searchText,"https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8")
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "mPool.jpeg")
        if MFMailComposeViewController.canSendMail(){
            self.present(mc, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Mail", message: "Please install Mail App to share", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
    
    func promoteAPPScatterChart(){
        let myWebsite = NSURL(string:"https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8")
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        let shareItems:Array = [url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func startSearching(_ sender: Any) {
        for view in self.contentView.subviews{
            if [10,20,30,40,50,60,100].contains(view.tag){
                view.removeFromSuperview()
            }
        }
        isSearchBarClicked = true
        startSearchingResults()
        removeTableView()
    }
    
    func scrollTableViewCustom(){
        removeTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  searchResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.searchTableView!.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as UITableViewCell?)!
        cell.textLabel?.text = self.searchResultsArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.text = self.searchResultsArray[indexPath.row] as! String
        removeTableView()
    }
    
    func getResultsForTheSearchText(text:String){
        if  Reachability()!.isReachable{
            //JHProgressHUD.sharedHUD.showInView(view: self.view, withHeader: nil, andFooter: "Loading")
            RestAPI.getDataForSubSearchToTheKeyWord(keyWord: text, index: 600,  searchValue:"", customTag: 0, callbackHandler:{
                (error:NSError?,data:NSMutableArray?)  -> Void in
                DispatchQueue.main.async {
                    if data != nil{
                        for str in data!{
                            if !self.listOfSearches.contains(str){
                                self.listOfSearches.add(str)
                            }
                        }
                        self.loadTableView();                        self.filterAndReloadDataForTheKeyword(text: self.searchBar.text!)
                    }else{
                        if error != nil{
                            self.showAlertForNoInternet(message: "Some thing went wrong")
                        }else{
                            self.showToast(message: "sorry No data found")
                        }
                    }
                }
            })
        }else{
        }
    }
    
    func checkIsDatAvailableAlready(){
        let predicate = NSPredicate(format: "SELF BEGINSWITH[cd] %@",searchBar.text!)
        self.searchResultsArray = self.listOfSearches.filtered(using: predicate) as NSArray
        if searchResultsArray.count > 0{
            loadTableView()
        }
        else{
            loadTableView()
            let array = self.searchBar.text?.components(separatedBy: ",")
            if let array = array{
                if array.count > 1 {
                    let formattedString = array.last?.replacingOccurrences(of: " ", with: "")
                    if formattedString != "" {
                        getResultsForTheSearchText(text: array.last!)
                    }
                }
            }
            let formattedString = searchBar.text!.replacingOccurrences(of: " ", with: "")
            if formattedString != "" {
                getResultsForTheSearchText(text: searchBar.text!)
            }
        }
    }
    
    func filterAndReloadDataForTheKeyword(text:String){
        let array = self.searchBar.text?.components(separatedBy: ",")
        var tempText = ""
        if let array = array{
            if array.count > 1 {
                tempText  = array.last!
            }
            else{
                tempText  = array.first!
            }
        }else{
            tempText  = searchBar.text!
        }
        let predicate = NSPredicate(format: "SELF BEGINSWITH[cd] %@",text)
        self.searchResultsArray = self.listOfSearches.filtered(using: predicate) as NSArray
        loadTableView()
    }
    
    func loadTableView(){
        if !self.isSearchBarClicked{
            if searchTableView == nil{
                searchTableView = UITableView(frame:CGRect(x: self.searchBar.frame.origin.x, y: self.keywordsLabel.frame.origin.y, width:  self.contentView.frame.size.width - self.searchBar.frame.origin.x, height: self.view.frame.size.height - 178 - 67 ))
                self.contentView.addSubview(searchTableView!)
                self.searchTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
                self.searchTableView?.isHidden = false
                self.searchTableView?.delegate = self
                self.searchTableView?.dataSource = self
                searchTableView?.tableFooterView = UIView()
            }
            else{
                self.searchTableView?.reloadData()
            }
        }else{
            self.removeTableView()
        }
    }
    
    func removeTableView(){
        if self.searchTableView != nil{
            self.searchTableView?.isHidden = true
            self.searchTableView = nil
        }
    }
    
    func averagSalary(_ point: CGPoint, andSalary salary: CGFloat) {
              let formattedInt = String(format: "%f", locale:Locale(identifier:"en_IN"), salary)
        self.loadPopForthePoint(point: CGPoint(x: point.x - 50, y: point.y - 5), text:"ExpectedSalary", percentage: String(format: "%@ INR", formattedInt))

    }
    
    func twitter(){
        let facebookShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if let facebookShare = facebookShare{
                facebookShare.setInitialText("Nice Tutorials of iOSDevCenters")
                facebookShare.add(self.image)
               // facebookShare.add(URL(string: "https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8"))
                self.present(facebookShare, animated: true, completion: nil)
            }
     
    }
}

extension UIButton{
    func roundedButton(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight , .topRight],
                                     cornerRadii: CGSize(width: 4, height: 4))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
}
    
    
}

extension ViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        return URL.init(string: "https://itunes.apple.com/us/app/mpool/id1414796786?ls=1&mt=8")!
    }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return "ScreenSort for iOS: https://itunes.apple.com/app/id1170886809"
    }

    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivityType?, suggestedSize size: CGSize) -> UIImage? {
        return self.image
    }
}

