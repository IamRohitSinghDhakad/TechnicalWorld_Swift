//
//  DetailViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 12/04/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgVwCategory: UIImageView!
    @IBOutlet weak var cvPictures: UICollectionView!
    @IBOutlet weak var btnHome: UIButton!

    var arrImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvPictures.delegate = self
        self.cvPictures.dataSource = self
        
        self.arrImages = [#imageLiteral(resourceName: "consultants"),#imageLiteral(resourceName: "contractors"),#imageLiteral(resourceName: "suppliers"),#imageLiteral(resourceName: "real"),#imageLiteral(resourceName: "service"),#imageLiteral(resourceName: "main"),#imageLiteral(resourceName: "jobs"),#imageLiteral(resourceName: "lawyer"),#imageLiteral(resourceName: "bids")]
        
    }
    @IBAction func btnOnHome(_ sender: Any) {
        
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    
    @IBAction func btnOpenWhatsapp(_ sender: Any) {
    }
    
    @IBAction func btnOnCallAction(_ sender: Any) {
        
    }
    @IBAction func btnOnLocation(_ sender: Any) {
        
        self.pushVc(viewConterlerId: "MapViewViewController")
        
    }
    
}


extension DetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath)as? DetailCollectionViewCell{
            
            cell.imgVw.image = self.arrImages[indexPath.row]
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size + 10)
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
 

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     */
}



