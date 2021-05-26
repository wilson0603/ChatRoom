//
//  ImagePresent.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

class photoPresent: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    var isPresent = false
    var startingFrame = CGRect.zero
  
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            
            let containView = transitionContext.containerView
            let toVc = transitionContext.viewController(forKey: .to) as! ImagePageViewController
            let finalFrame = toVc.view.frame
            
            
            containView.addSubview(toVc.view)
            
            
            if let parentImageView = toVc.parentImageView {
                
                toVc.hideParentImageView(true)
                
                if let parentImageView = toVc.parentImageView , let size = parentImageView.superview?.convert(parentImageView.frame, to: nil)  {
                    
                    toVc.present.startingFrame = size
                    
                }
                
                toVc.tempImageView.contentMode = parentImageView.contentMode
                toVc.tempImageView.frame = startingFrame
                
                toVc.view.addSubview(toVc.tempImageView)
            }else {
                toVc.pageViewController.view.transform = CGAffineTransform(translationX: 0, y: finalFrame.height)
            }
            
            
            toVc.backButton.alpha = 0
            toVc.view.backgroundColor = .clear
            
            UIView.animate(withDuration: duration, animations: {
                toVc.view.backgroundColor = .black
                toVc.backButton.alpha = 1
            })
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .allowAnimatedContent, animations: {
                
                if toVc.parentImageView != nil {
                    if let size = toVc.parentImageView?.image?.size {
                        toVc.tempImageView.frame.size = size.getScaleSize(screen:finalFrame)
                    }
                    toVc.tempImageView.center = toVc.view.center
                    
                }else {
                    toVc.pageViewController.view.transform = CGAffineTransform.identity
                }
   
            }, completion: { (finished) in
                
                toVc.tempImageView.isHidden = true
                toVc.pageViewController.view.isHidden = false
                transitionContext.completeTransition(true)
   
            })

        } else { //leave
            
            let fromVc = transitionContext.viewController(forKey: .from) as! ImagePageViewController
            let finalFrame = fromVc.view.frame

            UIView.animate(withDuration: duration, animations: {
                fromVc.view.backgroundColor = .clear
                fromVc.backButton.alpha = 0
            })
            
            if fromVc.isOriginalIndex, let _ = fromVc.parentImageView {
                
                fromVc.pageViewController.view.isHidden = true
                fromVc.tempImageView.isHidden = false
               
                
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .allowAnimatedContent, animations: {
            
                    fromVc.tempImageView.frame = self.startingFrame
                    
                }, completion: { (finished) in
                    
                    fromVc.hideParentImageView(false)
                    transitionContext.completeTransition(true)
                })
                
            } else {
          
                UIView.animate(withDuration: duration, animations: {
                    
                    fromVc.pageViewController.view.transform = CGAffineTransform(translationX: 0, y: finalFrame.height)

                }, completion: { (finished) in
                   
                    transitionContext.completeTransition(true)
                })
            }
        }
    }
}

extension photoPresent: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
        
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension CGSize {
    func getScaleSize(screen:CGRect) -> CGSize {
        
        if self == CGSize.zero {
            return CGSize.zero
        }
        let aspect = self.width / self.height
        
        let widthFullSize = CGSize(width: screen.width, height: screen.width / aspect)
        let heightFullSize = CGSize(width: screen.height * aspect, height: screen.height)
        
        if widthFullSize.height > screen.height {
            return heightFullSize
        }else {
            return widthFullSize
        }
    }
}
