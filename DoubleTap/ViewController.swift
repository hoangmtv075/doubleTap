//
//  ViewController.swift
//  DoubleTap
//
//  Created by Thanh Hoang on 16/6/24.
//

import UIKit

class ViewController: UIViewController {

    let bgImageView = UIImageView()
    let favoriteImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//MARK: - Setups

extension ViewController {
    
    private func setupViews() {
        //TODO: - BGImageView
        bgImageView.frame = view.bounds
        bgImageView.clipsToBounds = true
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "e_3")
        view.addSubview(bgImageView)
        
        //TODO: - FavoriteImageView
        let favW: CGFloat = view.frame.width * 0.5
        
        favoriteImageView.frame = CGRect(
            x: (view.frame.width-favW)/2,
            y: (view.frame.height-favW)/2,
            width: favW,
            height: favW
        )
        favoriteImageView.isHidden = true
        favoriteImageView.image = UIImage(named: "icon-doubleTap")?.withRenderingMode(.alwaysTemplate)
        favoriteImageView.tintColor = UIColor(hex: 0xEB3323)
        favoriteImageView.clipsToBounds = true
        favoriteImageView.contentMode = .scaleAspectFit
        view.addSubview(favoriteImageView)
        
        //TODO: - DoubleTap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandle))
        doubleTap.numberOfTapsRequired = 2
        
        bgImageView.isUserInteractionEnabled = true
        bgImageView.addGestureRecognizer(doubleTap)
    }
    
    private func animateFavorite() {
        favoriteImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        favoriteImageView.isHidden = false
        
        let rotateTransform = CGAffineTransform(rotationAngle: CGFloat(Int.random(min: -10, max: 10)).degreesToRadians())
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.334) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3).concatenating(rotateTransform)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9).concatenating(rotateTransform)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(rotateTransform)
            }
            
        } completion: { _ in
            UIView.animate(withDuration: 0.33) {
                self.favoriteImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).concatenating(rotateTransform)
                
            } completion: { _ in
                self.favoriteImageView.isHidden = true
            }
        }
    }
    
    @objc private func doubleTapHandle(_ sender: UITapGestureRecognizer) {
        let pt = sender.location(in: view)
        
        favoriteImageView.center = CGPoint(x: pt.x, y: pt.y)
        favoriteImageView.layer.shouldRasterize = true
        
        animateFavorite()
    }
}

//MARK: - UIColor

internal extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let b = CGFloat(hex & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

//MARK: - CGFloat

internal extension CGFloat {
    
    func radiansToDegrees() -> CGFloat {
        return self * 180 / .pi
    }
    
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180
    }
}

//MARK: - Int

internal extension Int {
    
    static func random(min: Int, max: Int) -> Int {
        assert(min < max)
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}
