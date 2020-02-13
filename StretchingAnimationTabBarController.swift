//
//  StretchingAnimationTabBarController.swift
//  CustomTabBarAnimations
//
//  Created by Oskar Figiel on 14/02/2020.
//

import UIKit

class StretchingAnimationTabBarController: UITabBarController {
    var lineView = UIImageView()
    var currentIndex = 0
    var currentSelectedView = UIView()
    var newSelectedView = UIView()
    var itemsMax = CGFloat()
    var constraintCenter = NSLayoutConstraint()
    var constraintLeft = NSLayoutConstraint()
    var constraintRight = NSLayoutConstraint()
    var constraintTop = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        itemsMax = CGFloat(tabBar.items!.count)
        lineView.image = UIImage(systemName: "circle.fill")?.resize(to: CGSize(width: 15, height: 10)).withTintColor(.systemRed)
        tabBar.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        currentSelectedView = tabBar.items![0].value(forKey: "view") as! UIView
        
        constraintTop = lineView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 45)
        constraintTop.isActive = true
        
        constraintLeft = lineView.leftAnchor.constraint(equalTo: currentSelectedView.leftAnchor, constant: 35)
        constraintLeft.isActive = true
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tabBarIndex = (tabBar.items?.firstIndex(of: item))!
        print("Obecny przycisk: \(String(describing: tabBarIndex))")
        currentSelectedView = tabBar.selectedItem?.value(forKey: "view") as! UIView
        print("Poprzedni przycisk: \(currentIndex)")
        if(tabBarIndex != currentIndex){
            if(tabBarIndex > currentIndex) {
                goRightAnimation()
            } else {
                goLeftAnimation()
            }
        }
        currentIndex = tabBarIndex

    }
    
    func goLeftAnimation() {
        print("goRightAnimation")
        constraintLeft.isActive = false
        lineView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        constraintLeft = lineView.leftAnchor.constraint(equalTo: currentSelectedView.leftAnchor, constant: 35)
        constraintLeft.isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.lineView.transform = CGAffineTransform.identity
            self.tabBar.layoutIfNeeded()
        }, completion:{ (finished: Bool) in
            UIView.animate(withDuration: 0.2) {
                self.constraintRight.isActive = false
                self.constraintRight = self.lineView.rightAnchor.constraint(equalTo: self.currentSelectedView.rightAnchor, constant: -35)
                self.constraintRight.isActive = true
                self.tabBar.layoutIfNeeded()
            }
        })
    }
    
    func goRightAnimation() {
        print("goRightAnimation")
        constraintRight.isActive = false
        constraintCenter.isActive = false

        lineView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        constraintCenter = lineView.centerXAnchor.constraint(equalTo: currentSelectedView.centerXAnchor)
        constraintCenter.isActive = true
        
        constraintRight = lineView.rightAnchor.constraint(equalTo: currentSelectedView.rightAnchor, constant: -35)
        constraintRight.isActive = true
        
      
        
        UIView.animate(withDuration: 0.5, animations: {
            self.lineView.transform = CGAffineTransform.identity
            self.tabBar.layoutIfNeeded()
        }, completion:{ (finished: Bool) in
            UIView.animate(withDuration: 0.2) {
                self.constraintLeft.isActive = false
                self.constraintLeft = self.lineView.leftAnchor.constraint(equalTo: self.currentSelectedView.leftAnchor, constant: 35)
                self.constraintLeft.isActive = true
                self.tabBar.layoutIfNeeded()
            }
        })
    }
}
