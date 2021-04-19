//
//  HomeViewController.swift
//  TechnicalWorld
//
//  Created by Paras on 11/04/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var cvCategories: UICollectionView!
    @IBOutlet weak var imgVwBanner: UIImageView!
    @IBOutlet weak var btnOpenMenu: UIButton!
    
    var arrImages = [UIImage]()
    var arrTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.arrTitles = ["Consultants","Contractors","Suppliers","Real State","Services","Maintenance", "Jobs", "Lawyer and \n Arbitrations", "Bids"]
        self.arrImages = [#imageLiteral(resourceName: "consultants"),#imageLiteral(resourceName: "contractors"),#imageLiteral(resourceName: "suppliers"),#imageLiteral(resourceName: "real"),#imageLiteral(resourceName: "service"),#imageLiteral(resourceName: "main"),#imageLiteral(resourceName: "jobs"),#imageLiteral(resourceName: "lawyer"),#imageLiteral(resourceName: "bids")]
        
        self.cvCategories.delegate = self
        self.cvCategories.dataSource = self
        
        //Setup SideMenu
        if revealViewController() != nil {
            self.btnOpenMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer((revealViewController()?.tapGestureRecognizer())!)
        }
    }

}




extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)as? HomeCollectionViewCell{
            
            cell.lblTitle.text = self.arrTitles[indexPath.row]
            cell.imgvwCategory.image = self.arrImages[indexPath.row]
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        switch indexPath.row {
        case 0:
            pushVc(viewConterlerId: "ContactListViewController")
        case 1:
            pushVc(viewConterlerId: "SubCategoryListViewController")
        case 2:
            pushVc(viewConterlerId: "SubmitOfferViewController")
        case 3:
            pushVc(viewConterlerId: "RentViewController")
        case 4:
            pushVc(viewConterlerId: "AddPostViewController")
        case 5:
            pushVc(viewConterlerId: "GeneralAccountantViewController")
        case 6:
            pushVc(viewConterlerId: "ReviesViewController")
        case 7:
            pushVc(viewConterlerId: "GiveReviesViewController")
        case 8:
            pushVc(viewConterlerId: "BidsViewController")
        default:
            pushVc(viewConterlerId: "DetailViewController")
        }
        
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



