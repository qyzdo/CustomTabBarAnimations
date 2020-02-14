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
    var constraintTop = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        itemsMax = CGFloat(tabBar.items!.count)
        lineView.image = UIImage(systemName: "circle.fill")?.resize(to: CGSize(width: 5, height: 5)).withTintColor(.systemRed)
        tabBar.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        currentSelectedView = tabBar.items![0].value(forKey: "view") as! UIView
        
        constraintTop = lineView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 50)
        constraintTop.isActive = true
        
        constraintCenter = lineView.centerXAnchor.constraint(equalTo: currentSelectedView.centerXAnchor)
        constraintCenter.isActive = true

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tabBarIndex = (tabBar.items?.firstIndex(of: item))!
        print("Obecny przycisk: \(String(describing: tabBarIndex))")
        currentSelectedView = tabBar.selectedItem?.value(forKey: "view") as! UIView
        print("Poprzedni przycisk: \(currentIndex)")
        if(tabBarIndex != currentIndex){
            animation()
        }
        currentIndex = tabBarIndex

    }
    
    func animation() {
        constraintCenter.isActive = false
        
        constraintCenter = lineView.centerXAnchor.constraint(equalTo: currentSelectedView.centerXAnchor)
        constraintCenter.isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.tabBar.layoutIfNeeded()
            UIView.animate(withDuration: 0.15, delay: 0.001, animations: {
                self.lineView.transform = CGAffineTransform(scaleX: 60, y: 1.7)
                
                self.lineView.transform = CGAffineTransform.identity
            })
        }
    }
}
