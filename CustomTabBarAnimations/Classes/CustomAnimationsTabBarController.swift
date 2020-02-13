import UIKit

class CustomAnimationsTabBarController: UITabBarController {
    var dotsView = UIStackView()
    var currentIndex = 0
    var currentSelectedView = UIView()
    var newSelectedView = UIView()
    var itemsMax = CGFloat()
    var constraintLeft = NSLayoutConstraint()
    var constraintRight = NSLayoutConstraint()
    var constraintTop = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        itemsMax = CGFloat(tabBar.items!.count)
        addStackView()
        constraintTop = dotsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: 20)
        constraintTop.isActive = true
        currentSelectedView = tabBar.items![0].value(forKey: "view") as! UIView
        constraintLeft = dotsView.leftAnchor.constraint(equalTo: currentSelectedView.leftAnchor, constant: setConstraintValue())
        constraintLeft.isActive = true
    }
    
    
    func addStackView() {
        for _ in 1...3 {
            let dotView = UIImageView()
            dotView.image = UIImage(systemName: "circle.fill")?.resize(to: CGSize(width: 10, height: 10)).withTintColor(.systemRed)
            dotsView.addArrangedSubview(dotView)
        }
        dotsView.alignment = UIStackView.Alignment.center
        dotsView.axis = .horizontal
        dotsView.distribution = .fillEqually
        dotsView.translatesAutoresizingMaskIntoConstraints = false
        dotsView.isHidden = true

        tabBar.addSubview(dotsView)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tabBarIndex = (tabBar.items?.firstIndex(of: item))!
        self.currentSelectedView.subviews.forEach({$0.layer.removeAllAnimations()})
        self.currentSelectedView.layer.removeAllAnimations()
        self.currentSelectedView.layoutIfNeeded()
        print("pressed tabBar: \(String(describing: tabBarIndex))")
        currentSelectedView = tabBar.selectedItem?.value(forKey: "view") as! UIView
        print(currentSelectedView)
        print("Kliknięty przycisk nr: \(currentIndex)")
        if(tabBarIndex != currentIndex){
            print(currentSelectedView)
            newAnimation(newIndex: tabBarIndex)
        }
    }
    
    func newAnimation(newIndex: Int) {
        dotsView.isHidden = false
        print("Items max: \(itemsMax)")
        constraintLeft.isActive = false
        constraintRight.isActive = false
        let constraintValue = setConstraintValue()
        if(newIndex>currentIndex) {
            constraintLeft = dotsView.leftAnchor.constraint(equalTo: currentSelectedView.leftAnchor, constant: constraintValue / 8)
            print("Changed constraint to: \(constraintValue / 8)")
            constraintLeft.isActive = true
            self.dotsView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            tabChangedAnimation() {_ in
                self.constraintLeft.constant = constraintValue
                self.tabChangedAnimationPart2()
                print("Changed constraint to: \(constraintValue)")
            }
        }
        if(newIndex<currentIndex){
            constraintRight = dotsView.rightAnchor.constraint(equalTo: currentSelectedView.rightAnchor, constant: constraintValue * -1 / 8)
            print("Changed constraint to: \(constraintValue / 8)")
            constraintRight.isActive = true
            tabChangedAnimation() {_ in
                self.constraintRight.constant = constraintValue * -1
                self.tabChangedAnimationPart2()
                print("Changed constraint to: \(constraintValue)")
            }
        }
        currentIndex = newIndex
    }
    
    func tabChangedAnimation(completion: @escaping (Bool) -> ()){
        //let time = abs(newIndex-currentIndex)
        //let time = itemsMax - 1
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.dotsView.transform = CGAffineTransform.identity
            self.tabBar.layoutIfNeeded()
        }, completion:{ (finished: Bool) in
            completion(true)
        })
    }
    
    func tabChangedAnimationPart2() {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.dotsView.transform = CGAffineTransform.identity
            self.dotsView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.tabBar.layoutIfNeeded()
        }, completion:{ (finished: Bool) in
            self.currentSelectedView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.dotsView.isHidden = true
            UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
                self.currentSelectedView.transform = CGAffineTransform.identity
            })
        })
    }
    
    func setConstraintValue() -> CGFloat {
        var constraint = CGFloat()
        if(itemsMax == 2) {
            constraint = 80
        }
        if(itemsMax == 3) {
            constraint = 45
        }
        if(itemsMax == 4) {
            constraint = 30
        }
        return constraint
    }
}


extension UIImage {
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resize(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    func resize(width: CGFloat) -> UIImage {
        return resize(to: CGSize(width: width, height: width / (size.width / size.height)))
    }
    func resize(height: CGFloat) -> UIImage {
        return resize(to: CGSize(width: height * (size.width / size.height), height: height))
    }
}
