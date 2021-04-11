//
//  WelcomeViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 10/04/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var cvPageControlSlide: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var imgArr = [  UIImage(named:"one"),
                    UIImage(named:"two") ,
                    UIImage(named:"thr") ,
                  ]
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvPageControlSlide.delegate = self
        self.cvPageControlSlide.dataSource = self

        // Do any additional setup after loading the view.
        pageController.numberOfPages = imgArr.count
        pageController.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    
    }
    
    
    @objc func changeImage() {
     
     if counter < imgArr.count {
         let index = IndexPath.init(item: counter, section: 0)
         self.cvPageControlSlide.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageController.currentPage = counter
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.cvPageControlSlide.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
         pageController.currentPage = counter
         counter = 1
     }
         
     }
    
    @IBAction func btnOnGetStarted(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCollectionViewCell", for: indexPath)as! WelcomeCollectionViewCell
       
        cell.imgVw.image = self.imgArr[indexPath.row]

        return cell
    }
}

extension WelcomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cvPageControlSlide.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
