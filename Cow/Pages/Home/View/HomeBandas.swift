//
//  HomeBandas.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit
import Magicbox

class HomeBandas:UIView {
    
    public var index = 0
    
    private var beginpoint:CGPoint = CGPoint(x: 0, y: 0)
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    func configUI(){
        collectionView.register(UINib.init(nibName: "HomeBandasCell", bundle: nil), forCellWithReuseIdentifier: "HomeBandasCell")
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
        return 3
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
          scrollertoIndex(indexpath: nextIndexPath(), animated: true)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollertoIndex(indexpath: nextIndexPath(), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = true
    }
    
    func nextIndexPath() -> Int {
        
        let endpoint = collectionView.contentOffset
        var tpoint = self.convert(self.center, to: collectionView)
        let offset = endpoint.x - beginpoint.x
        tpoint.x = tpoint.x + offset
        guard let indexpath = collectionView.indexPathForItem(at: tpoint) else {
           return index
        }
        return indexpath.row
    }
    
    
    func scrollertoIndex(indexpath:Int, animated:Bool = false)  {
        
        guard let layout:UICollectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            print(" layout nil")
            return
        }
        
        switch layout.scrollDirection {
        case .horizontal:
            
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: animated)
        
        case .vertical:
            
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredVertically, animated: animated)
            
        default:
            break
        }
        self.index = indexpath
    }
}






