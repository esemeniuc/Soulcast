
import UIKit

@objc protocol Appearable {
  /// called when the view finish decelerating onto the screen.
  func didAppearOnScreen()
  /// called when the view finish decelerating off the screen.
  func didDisappearFromScreen()
  /// called when the view begin decelerating onto the screen.
  func willAppearOnScreen()
  /// called when the view begin decelerating off the screen.
  func willDisappearFromScreen()
}

protocol JKPageVCDelegate: class{
  func jkDidFinishScrolling(to pageIndex:Int)
}

/** A pre-configured wrapper class for UIPageViewController with a simple implementation that:

 - encapsulates common delegate methods
 - keeps track of indexes
 - turns page control on/off with the pageControlEnabled boolean
 - comes with an Appearable hook for child view controllers

*/
@objc class JKPageViewController: UIPageViewController {
  /// for inspecting view hierarchy and current index.
  var debugging:Bool = false {
    didSet {
      print("JKPageViewController debugging: \(debugging)")
    }
  }
  /// allows for removal of dead space at the bottom when configured before viewDidLoad
  var pageControlEnabled:Bool = false
  /// the child view controllers.
  var pages:[UIViewController] = [UIViewController](){
    didSet{
      setInitialPage()
    }
  }
  var currentVC:UIViewController!
  var nextVC:UIViewController!
  var previousIndex = 0
  var currentIndex = 0
  var nextIndex = 0
  var initialIndex = 0
  
  weak var jkDelegate:JKPageVCDelegate?
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]?) {
    super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.clipsToBounds = false
    delegate = self
    dataSource = self
  }
  
 
  
  /// should call to conform to Apple's guidelines for adding child view controllers
  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    parent!.view.gestureRecognizers = gestureRecognizers
    //recursivelyIterateSubviews(view)
    view.frame = parent!.view.bounds
  }
  
  /// should call manually.
  func setInitialPage() {
    if pages.count > 0 {
      currentVC = pages[initialIndex]
      currentIndex = initialIndex
      setViewControllers([pages[initialIndex]], direction: .forward, animated: false, completion: { (finished:Bool) -> Void in
      })
      (self.currentVC as? Appearable)?.willAppearOnScreen()
    } else if debugging {
      print("JKPageViewController does not have any pages!")
    }
  }
  
  func recursivelyIterateSubviews(_ view: UIView) {
    if debugging {
      print("\(String(cString: object_getClassName(view))) :: frame: \(view.frame)")
    }
    for eachSubview in view.subviews {
      if eachSubview is UIScrollView {
        (eachSubview as! UIScrollView).delegate = self
        eachSubview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
      }
      recursivelyIterateSubviews(eachSubview)
    }
  }

}

extension JKPageViewController: UIPageViewControllerDelegate {
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if !completed { return }
    previousIndex = currentIndex
    currentIndex = nextIndex
    currentVC = pages[currentIndex]
    
  }
  func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    
    nextVC = pendingViewControllers.first
    nextIndex = pages.index(of: nextVC)!

  }
  
  
  func viewControllerAtIndex(_ index: Int) -> UIViewController?{
    if pages.count == 0 || index >= pages.count {
      return nil
    }
    return pages[index]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    if pageControlEnabled {
      return pages.count
    }
    return 0
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    if pageControlEnabled {
      return currentIndex
    }
    return 0
  }
  
  func scrollToVC(_ pageIndex:Int!, direction:UIPageViewControllerNavigationDirection) {
    if (pageIndex < 0 || pageIndex >= pages.count) {return}
    (currentVC as? Appearable)?.willDisappearFromScreen()
    (pages[pageIndex] as? Appearable)?.willAppearOnScreen()
    setViewControllers([pages[pageIndex]], direction: direction, animated: true) { (completed:Bool) -> Void in
      (self.pages[self.currentIndex] as? Appearable)?.didDisappearFromScreen()
      (self.pages[pageIndex] as? Appearable)?.didAppearOnScreen()
      self.currentIndex = pageIndex
      self.currentVC = self.pages[pageIndex]
      self.jkDelegate?.jkDidFinishScrolling(to: self.currentIndex)
    }
  }
  
  func disableScroll() {
    for eachView in view.subviews {
      if eachView.isKind(of: UIScrollView.self) {
        (eachView as! UIScrollView).isScrollEnabled = false
      }
    }
  }
  func enableScroll() {
    for eachView in view.subviews {
      if eachView.isKind(of: UIScrollView.self) {
        (eachView as! UIScrollView).isScrollEnabled = true
      }
    }
  }
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
}

extension JKPageViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    (pages[previousIndex] as? Appearable)?.didDisappearFromScreen()
    (pages[currentIndex] as? Appearable)?.didAppearOnScreen()
    currentVC = pages[currentIndex]
    if debugging {
      print("previousIndex: \(previousIndex) viewController: \(pages[previousIndex])")
      print("currentIndex: \(currentIndex) viewController: \(pages[currentIndex])")
    }
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    if debugging {
      print("nextIndex: \(nextIndex) viewController: \(pages[nextIndex])")
    }
    (pages[currentIndex] as? Appearable)?.willDisappearFromScreen()
    (pages[nextIndex] as? Appearable)?.willAppearOnScreen()
    
  }
  
}

extension JKPageViewController: UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    if currentIndex == 0 {
      return nil
    }
    return viewControllerAtIndex(currentIndex-1)
  }
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    if (currentIndex == pages.count - 1) {
      return nil
    }
    return viewControllerAtIndex(currentIndex + 1)
  }
  
}

/* Implementation:

func makeViewControllers() {
  let loginMockVC = MockupVC()
  loginMockVC.mockupImage = UIImage(named: "login.png")
  let exploreMockVC = MockupVC()
  exploreMockVC.mockupImage = UIImage(named: "explore.png")
  let trendingMockVC = MockupVC()
  trendingMockVC.mockupImage = UIImage(named: "trending.png")
  let specificMockVC = MockupVC()
  specificMockVC.mockupImage = UIImage(named: "specific.png")

  viewControllers = [loginMockVC, exploreMockVC, trendingMockVC, specificMockVC]
}

func addPageVC() {
  pageViewController = PageVC(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: .Horizontal, options: nil)

  pageViewController.pageControlEnabled = true
  pageViewController.debugging = true
  pageViewController.pages = viewControllers
  addChildViewController(self.pageViewController)
  view.addSubview(self.pageViewController.view)
  pageViewController.didMoveToParentViewController(self)

  pageViewController.setInitialPage()
}

*/
