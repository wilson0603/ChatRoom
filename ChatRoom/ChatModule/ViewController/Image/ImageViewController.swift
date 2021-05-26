//
//  ImageViewController.swift
//  ChatRoom
//
//  Created by Wilson Hung on 2021/5/25.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var tintColor: UIColor = .white
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var indexPage = 0
    
    var postImage: PostImage
  
    init(postImage: PostImage) {
        self.postImage = postImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints( {$0.edges.equalToSuperview()} )
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.centerX.centerY.equalToSuperview()
        }
        
        if let image = postImage.image {
            self.imageView.image = image
        } else if let path = postImage.storagePath {
            self.imageView.kf_setImage(urlPath: path, placeholder: postImage.tempImage)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        guard scrollView.zoomScale > 1 else {
            scrollView.contentInset = UIEdgeInsets.zero
            return
        }
        
        if let image = imageView.image {
            let ratioW = imageView.frame.width / image.size.width
            let ratioH = imageView.frame.height / image.size.height

            let ratio = ratioW < ratioH ? ratioW:ratioH

            let newWidth = image.size.width*ratio
            let newHeight = image.size.height*ratio

            let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
            let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

            scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

