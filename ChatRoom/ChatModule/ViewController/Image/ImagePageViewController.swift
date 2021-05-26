//
//  ImagePageViewController.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

class ImagePageViewController: UIViewController {

    let present = photoPresent()
    var pageViewController: UIPageViewController!
    var parentImageView: UIImageView?
    var backButton: UIButton!
    var pageControl: UIPageControl!
    var tempImageView: UIImageView!

    var imageArr = [PostImage]()
    var index = 0
    var indexNow = 0 {
        didSet {
            pageControl.currentPage = indexNow
        }
    }
    var isFinish = true
    var isOriginalIndex:Bool {
        get {
            return indexNow == index
        }
    }
    
    init(parentImageView: UIImageView? = nil, index: Int, images: [PostImage]) {
        self.imageArr = images
        self.index = index
        self.parentImageView = parentImageView
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.transitioningDelegate = self.present
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.modalPresentationCapturesStatusBarAppearance = true
        super.viewDidLoad()
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(pageViewController)
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.isHidden = parentImageView != nil
        pageViewController.view.backgroundColor = .clear
        pageViewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:))))
 
        tempImageView = UIImageView()
        tempImageView.clipsToBounds = true
        tempImageView.image = parentImageView?.image
        
        backButton = UIButton(type: .system)
        backButton.tintColor = UIColor.white
        backButton.setImage(#imageLiteral(resourceName: "Cancel"), for: .normal)
        backButton.addTarget(self, action: #selector(self.back(_:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.width.height.equalTo(44)
        }
        pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.numberOfPages = imageArr.count
        pageControl.isHidden = imageArr.count == 1
        pageControl.isUserInteractionEnabled = false
        
        self.view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottomMargin)
            make.centerX.width.equalToSuperview()
        }
        
        if let vc = getController(count: index) {
            self.pageViewController.setViewControllers([vc], direction: .forward, animated: false)
            self.indexNow = index
        }
    }
    
    func getController(count:Int) -> UIViewController? {
        guard count < imageArr.count else {
            return nil
        }
        let vc = ImageViewController(postImage: imageArr[count])
        vc.indexPage = count
        return vc
    }
    
    func getCurrentController() -> ImageViewController? {
        return self.pageViewController.viewControllers?.first as? ImageViewController
    }

    func hideParentImageView(_ bool: Bool) {
        
        parentImageView?.alpha = bool ? 0 : 1
    }
    
    @objc func back(_ sender: Any) {
        getCurrentController()?.scrollView.zoomScale = 1
        self.dismiss(animated: true, completion: nil)
    }

}

extension ImagePageViewController {
    
    @objc func pan(_ sender:UIPanGestureRecognizer) {
        
        guard let myView = sender.view else { return }
      
        if sender.state == .began {
            
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            
        } else if sender.state == .changed {
            
            let y = sender.translation(in: myView).y
            myView.transform = CGAffineTransform(translationX: 0, y: y)

        } else if sender.state == .ended {
            
            let y = myView.transform.ty
            
            if abs(y) > myView.frame.height*0.2 {
                
                sender.state = .cancelled
                
                self.backButton.sendActions(for: .touchUpInside)
                
                return
                
            } else {
                
                UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                    () -> Void in
                    
                    myView.transform = CGAffineTransform.identity
                    self.view.backgroundColor = UIColor.black
                })
            }
        }
    }
}

extension ImagePageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if !isFinish || imageArr.count <= 1 {
            return nil
        }
        
        if let controller = viewController as? ImageViewController {
            
            if controller.indexPage > 0 {
                return getController(count: controller.indexPage - 1)
            }else {
                return getController(count: imageArr.count - 1) //往左至最後一頁
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if !isFinish || imageArr.count <= 1 {
            return nil
        }
        
        if let controller = viewController as? ImageViewController {
            
            if controller.indexPage + 1 < imageArr.count {
                return getController(count: controller.indexPage + 1)
            }else {
                return getController(count: 0)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        if let vc = pageViewController.viewControllers?.first as? ImageViewController {
            self.indexNow = vc.indexPage
            self.hideParentImageView(isOriginalIndex)
        }
        
        isFinish = true
    }
}
