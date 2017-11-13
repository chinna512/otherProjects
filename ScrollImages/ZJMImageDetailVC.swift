//
//  Created by Chinnababu on 11/13/17.
//  Copyright © 2017 Chinnababu. All rights reserved.
//

import UIKit

open class ZJMImageDetailVC: UIViewController,UIScrollViewDelegate, GalleryViewDelegate {
    
    @IBOutlet weak var testView: UIView!
    // MARK: - Private properties
    fileprivate var pictures: [GalleryPicture] = []
    fileprivate var pictureViews: [GalleryView] = []
    fileprivate var isShowingLandscapeView: Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        switch (orientation) {
        case UIInterfaceOrientation.landscapeLeft, UIInterfaceOrientation.landscapeRight:
            return true
        default:
            return false
        }
    }
    fileprivate var isShowingActionControls: Bool {
        get {
            return false
        }
    }
    fileprivate var activityController: UIActivityViewController!
    internal var options = CollieGalleryOptions()
    internal var displayedView: GalleryView {
        get {
            return pictureViews[currentPageIndex]
        }
    }
    open weak var delegate: PaginationDelegate?
    open var currentPageIndex: Int = 0
    open var pagingScrollView: UIScrollView!
    open var progressTrackView: UIView?
    open var progressBarView: UIView?
    
    /// The view used to display the title and caption properties
    
    /// The currently displayed imageview
    open var displayedImageView: UIImageView {
        get {
            return displayedView.imageView
        }
    }
    
    // MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    /**
     
     Default gallery initializer
     
     - Parameters:
     - pictures: The pictures to display in the gallery
     - options: An optional object with the customization options
     - theme: An optional theme to customize the gallery appearance
     
     */
    public convenience init(pictures: [GalleryPicture],
                            options: CollieGalleryOptions? = nil,
                            theme: UIColor? = nil){
        self.init(nibName: nil, bundle: nil)
        self.pictures = pictures
        self.options = (options != nil) ? options! : CollieGalleryOptions.sharedOptions
    }
    
    // MARK: - UIViewController functions
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ZJMImageDetailVC.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        setupView()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateView(view.bounds.size)
    }
    
    func back(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UIApplication.shared.isStatusBarHidden {
            UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.slide)
        }
        pagingScrollView.delegate = self
        scrollToIndex(options.openAtIndex, animated: false)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UIApplication.shared.isStatusBarHidden {
            UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
        }
        pagingScrollView.delegate = nil
    }
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        clearImagesFarFromIndex(currentPageIndex)
    }
    
    override open var prefersStatusBarHidden : Bool {
        return true
    }
    // MARK: - Private functions
    fileprivate func setupView() {
        view.backgroundColor = .blue
        setupScrollView()
        setupPictures()
        loadImagesNextToIndex(currentPageIndex)
    }
    
    fileprivate func setupScrollView() {
        let avaiableSize = getInitialAvaiableSize()
        let scrollFrame = getScrollViewFrame(avaiableSize)
        let contentSize = getScrollViewContentSize(scrollFrame)
        
        pagingScrollView = UIScrollView(frame: scrollFrame)
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.showsHorizontalScrollIndicator = !options.showProgress
        pagingScrollView.backgroundColor = UIColor.blue
        pagingScrollView.contentSize = contentSize
        pagingScrollView.indicatorStyle = .white
        view.addSubview(pagingScrollView)
    }
    
    fileprivate func setupPictures() {
        let avaiableSize = getInitialAvaiableSize()
        let scrollFrame = getScrollViewFrame(avaiableSize)
        
        for i in 0 ..< pictures.count {
            let picture = pictures[i]
            let pictureFrame = getPictureFrame(scrollFrame, pictureIndex: i)
            let pictureView = GalleryView(picture: picture, frame: pictureFrame, options: options, theme: .black)
            pictureView.delegate = self
            
            pagingScrollView.addSubview(pictureView)
            pictureViews.append(pictureView)
        }
    }
    
    fileprivate func updateView(_ avaiableSize: CGSize) {
        pagingScrollView.frame = getScrollViewFrame(avaiableSize)
        pagingScrollView.contentSize = getScrollViewContentSize(pagingScrollView.frame)
        for i in 0 ..< pictureViews.count {
            let innerView = pictureViews[i]
            innerView.frame = getPictureFrame(pagingScrollView.frame, pictureIndex: i)
        }
        if let progressTrackView = progressTrackView {
            progressTrackView.frame = getProgressViewFrame(avaiableSize)
        }
        var popOverPresentationRect = getActionButtonFrame(view.frame.size)
        popOverPresentationRect.origin.x += popOverPresentationRect.size.width
        activityController?.popoverPresentationController?.sourceView = view
        activityController?.popoverPresentationController?.sourceRect = popOverPresentationRect
        updateContentOffset()
    }
    
    fileprivate func loadImagesNextToIndex(_ index: Int) {
        pictureViews[index].loadImage()
        let imagesToLoad = options.preLoadedImages
        
        for i in 1 ... imagesToLoad {
            let previousIndex = index - i
            let nextIndex = index + i
            
            if previousIndex >= 0 {
                pictureViews[previousIndex].loadImage()
            }
            
            if nextIndex < pictureViews.count {
                pictureViews[nextIndex].loadImage()
            }
        }
    }
    
    fileprivate func clearImagesFarFromIndex(_ index: Int) {
        let imagesToLoad = options.preLoadedImages
        let firstIndex = max(index - imagesToLoad, 0)
        let lastIndex = min(index + imagesToLoad, pictureViews.count - 1)
        var imagesCleared = 0
        
        for i in 0 ..< pictureViews.count {
            if i < firstIndex || i > lastIndex {
                pictureViews[i].clearImage()
                imagesCleared += 1
            }
        }
    }
    
    fileprivate func updateContentOffset() {
        pagingScrollView.setContentOffset(CGPoint(x: pagingScrollView.frame.size.width * CGFloat(currentPageIndex), y: 0), animated: false)
    }
    
    fileprivate func getInitialAvaiableSize() -> CGSize {
        return view.bounds.size
    }
    
    fileprivate func getScrollViewFrame(_ avaiableSize: CGSize) -> CGRect {
        let x: CGFloat = -options.gapBetweenPages
        let y: CGFloat = 0.0
        let width: CGFloat = avaiableSize.width + options.gapBetweenPages
        let height: CGFloat = avaiableSize.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func getScrollViewContentSize(_ scrollFrame: CGRect) -> CGSize {
        let width = scrollFrame.size.width * CGFloat(pictures.count)
        let height = scrollFrame.size.height
        
        return CGSize(width: width, height: height)
    }
    
    fileprivate func getPictureFrame(_ scrollFrame: CGRect, pictureIndex: Int) -> CGRect {
        let x: CGFloat = ((scrollFrame.size.width) * CGFloat(pictureIndex)) + options.gapBetweenPages
        let y: CGFloat = 0.0
        let width: CGFloat = scrollFrame.size.width - (1 * options.gapBetweenPages)
        let height: CGFloat = scrollFrame.size.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    fileprivate func getCaptionViewFrame(_ availableSize: CGSize) -> CGRect {
        return CGRect(x: 0.0, y: availableSize.height - 70, width: availableSize.width, height: 70)
    }
    
    fileprivate func getProgressViewFrame(_ avaiableSize: CGSize) -> CGRect {
        return CGRect(x: 0.0, y: avaiableSize.height - 2, width: avaiableSize.width, height: 2)
    }
    
    fileprivate func getProgressInnerViewFrame(_ progressFrame: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: progressFrame.size.height)
    }
    
    fileprivate func getCloseButtonFrame(_ avaiableSize: CGSize) -> CGRect {
        return CGRect(x: 0, y: 0, width: 50, height: 50)
    }
    
    fileprivate func getActionButtonFrame(_ avaiableSize: CGSize) -> CGRect {
        return CGRect(x: avaiableSize.width - 50, y: 0, width: 50, height: 50)
    }
    
    fileprivate func getCustomButtonFrame(_ avaiableSize: CGSize, forIndex index: Int) -> CGRect {
        let position = index + 2
        
        return CGRect(x: avaiableSize.width - CGFloat(50 * position), y: 0, width: 50, height: 50)
    }
    
    // MARK: - Internal functions
    @objc internal func closeButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIScrollView delegate
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0 ..< pictureViews.count {
            pictureViews[i].scrollView.contentOffset = CGPoint(x: (scrollView.contentOffset.x - pictureViews[i].frame.origin.x + options.gapBetweenPages) * -options.parallaxFactor, y: 0)
        }
        
        if let progressBarView = progressBarView, let progressTrackView = progressTrackView {
            let maxProgress = progressTrackView.frame.size.width * CGFloat(pictures.count - 1)
            let currentGap = CGFloat(currentPageIndex) * options.gapBetweenPages
            let offset = scrollView.contentOffset.x - currentGap
            let progress = (maxProgress - (maxProgress - offset)) / CGFloat(pictures.count - 1)
            progressBarView.frame.size.width = max(progress, 0)
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if page != currentPageIndex {
            delegate?.gallery?(self, indexChangedTo: page)
        }
        currentPageIndex = page
        loadImagesNextToIndex(currentPageIndex)
    }
    
    // MARK: - CollieGalleryView delegate
    func galleryViewTapped(_ scrollview: GalleryView) {
        if(navigationController?.navigationBar.isHidden)!{
            scrollview.backgroundColor = UIColor.white
        }else{
            scrollview.backgroundColor = UIColor.black
        }
        self.navigationController?.navigationBar.isHidden =  !(self.navigationController?.navigationBar.isHidden)!
    }
    
    func galleryViewDidRestoreZoom(_ galleryView: GalleryView) {
        self.navigationController?.navigationBar.isHidden  = true
    }
    
    func galleryViewDidZoomIn(_ galleryView: GalleryView) {
        galleryView.backgroundColor = UIColor.black
    }
    
    func galleryViewDidEnableScroll(_ galleryView: GalleryView) {
        pagingScrollView.isScrollEnabled = false
    }
    
    func galleryViewDidDisableScroll(_ galleryView: GalleryView) {
        pagingScrollView.isScrollEnabled = true
    }
    
    
    // MARK: - Public functions
    
    /**
     
     Scrolls the gallery to an index
     
     - Parameters:
     - index: The index to scroll
     - animated: Indicates if it should be animated or not
     
     */
    open func scrollToIndex(_ index: Int, animated: Bool = true) {
        currentPageIndex = index
        loadImagesNextToIndex(currentPageIndex)
        pagingScrollView.setContentOffset(CGPoint(x: pagingScrollView.frame.size.width * CGFloat(index), y: 0), animated: animated)
    }
    
    /**
     
     Presents the gallery from a view controller
     
     - Parameters:
     - sourceViewController: The source view controller
     - transitionType: The transition type used to present the gallery
     
     */
    open func presentInViewController(_ sourceViewController: UIViewController, transitionType: GalleryTransitionType? = nil) {
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        sourceViewController.present(self, animated: true, completion: nil)
    }
}
