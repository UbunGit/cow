//
//  HomeBandas.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit
import Magicbox

class HomeBandas: UIView {
    
    var beginpoint:CGPoint = CGPoint(x: 0, y: 0)
    var index = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    func configUI(){
        collectionView.register(UINib.init(nibName: "HomeBandasCell", bundle: nil), forCellWithReuseIdentifier: "HomeBandasCell")
        collectionView.isPagingEnabled = true
        guard let layout:UICollectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.estimatedItemSize = CGSize(width: KWidth-40, height: 300)
        layout.itemSize = CGSize(width: KWidth-40, height: 300)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    }
    
    

}
extension HomeBandas:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBandasCell", for: indexPath)
        return cell
    }
  
}
extension HomeBandas:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        beginpoint = collectionView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
          scrollertoIndex()
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollertoIndex()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = true
    }
    func scrollertoIndex(animated:Bool = true)  {
      
        let  endpoint = collectionView.contentOffset
         var tpoint = collectionView.convert(self.center, to: collectionView)
         let offset = endpoint.x - beginpoint.x
         tpoint.x = tpoint.x + offset
//        let indexpath = IndexPath(item: index.row+2, section: 1)

        guard let indexpath = collectionView.indexPathForItem(at: tpoint) else {
            print("indexpath nil")
            return
        }
        
        guard let layout:UICollectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            print(" layout nil")
            return
        }
//        collectionView.scrollToItem(at: IndexPath.init(row: 5, section: 0), at: .centeredHorizontally, animated: true)
        collectionView.scrollToItem(at: IndexPath.init(row: 5, section: 0), at: .centeredVertically, animated: true)
//        switch layout.scrollDirection {
//        case .horizontal:
//            collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: animated)
//            print("\(indexpath.row) - \(indexpath.section)")
//        case .vertical:
//            collectionView.scrollToItem(at: indexpath, at: .centeredVertically, animated: animated)
//            print("\(indexpath.row) - \(indexpath.section)")
//        default:
//            break
//        }
        index = indexpath
    }
}





