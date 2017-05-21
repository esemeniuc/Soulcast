
import Foundation
import UIKit

protocol DetailModalVCDelegate: class {
  func detailModalCancelled(_ vc:UIViewController)
}

class DetailModalVC: UIViewController, SoulPlayerDelegate {
  
  weak var delegate: DetailModalVCDelegate?
  let grayOverlay = UIView()
  let containerView = UIView()
  let playButton = UIButton()
  
  let sideInset: CGFloat = 30
  let verticalInset: CGFloat = 60
  let soul: Soul
  
  init(soul: Soul) {
    self.soul = soul
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addCancelAction()
    addGrayOverlay()
    addContainerView()
    addPlayButton()
    //report button on one corner
    //wave button in center
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    soulPlayer.subscribe(self)
    soulPlayer.startPlaying(soul)
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    soulPlayer.unsubscribe(self)
  }
  func addGrayOverlay() {
    grayOverlay.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
    grayOverlay.frame = view.bounds
    grayOverlay.isHidden = true
    view.addSubview(grayOverlay)
  }

  func addPlayButton() {
    let buttonSize:CGFloat = 80
    playButton.frame = CGRect(
      x: (containerView.width - buttonSize)/2,
      y: (containerView.height - buttonSize)/2,
      width: buttonSize, height: buttonSize)
    containerView.addSubview(playButton)
    playButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
    playButton.setImage(imageFrom(systemItem: .play), for: .normal)
    playButton.setImage(imageFrom(systemItem: .pause), for: .disabled)
  }
  
  func didTapPlayButton() {
    soulPlayer.startPlaying(soul)
  }
  
  override func didMove(toParentViewController parent: UIViewController?) {
    super.didMove(toParentViewController: parent)
    UIView.transition(with: grayOverlay, duration: 0.3, options: .transitionCrossDissolve, animations: {
      self.grayOverlay.isHidden = false
    }, completion: nil)
  }
  
  func addCancelAction() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGrayOverlay))
    grayOverlay.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func addContainerView() {
    containerView.frame = CGRect(
      x: sideInset, y: verticalInset,
      width: view.width - sideInset * 2,
      height: view.height - verticalInset * 2)
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 15
    containerView.clipsToBounds = true
    grayOverlay.addSubview(containerView)
  }
  
  func didTapGrayOverlay() {
    soulPlayer.reset()
    UIView.transition(with: self.grayOverlay, duration: 0.3, options: .transitionCrossDissolve, animations: {
      self.grayOverlay.isHidden = true
    }) { _ in
      self.delegate?.detailModalCancelled(self)
    }
    
  }
  
////// SoulPlayerDelegate
  func didStartPlaying(_ voice:Voice) {
    playButton.isEnabled = false
  }
  
  func didFinishPlaying(_ voice:Voice) {
    playButton.isEnabled = true
  }
  
  func didFailToPlay(_ voice:Voice) {
    
  }
//////
  
}
