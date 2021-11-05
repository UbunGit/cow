//
//  CollectionHeaderView.swift
//  Cow
//
//  Created by admin on 2021/11/4.
//

import UIKit
import SnapKit

class CollectionHeaderCell:UICollectionViewCell{
    var cellData:Any? = nil
    lazy var titleLab:UILabel = {
        let lab = UILabel()
        lab.textColor = .cw_text4
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    override var isSelected: Bool{
        didSet{
            if isSelected{
                titleLab.textColor = .theme
                
            }else{
                titleLab.textColor = .cw_text4
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override  func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    func makeUI(){
        addSubview(titleLab)
    }
    override func updateUI() {
        guard let data = cellData as? String else {
            return
        }
        titleLab.text = data
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
class CollectionHeaderView: UIControl {
    var _value:Int=0
    var value:Int{
        set{
            if _value == newValue{
                return
            }
            let indexpath:IndexPath = .init(row: _value, section: 0)
            let oldcell = collectionView.cellForItem(at: indexpath)
            oldcell?.isSelected = false
            if newValue>=dataSource.count{
                _value = dataSource.count-1
            }else{
                _value = newValue
            }
            
            let newpath:IndexPath = .init(row: _value, section: 0)
            collectionView.scrollToItem(at: newpath, at: .centeredHorizontally, animated: true)
            if let newcell = collectionView.cellForItem(at: newpath){
                newcell.isSelected = true
                self.layoutIfNeeded()
                self.remarkView.snp.remakeConstraints {[weak self] make in
                    make.bottom.equalToSuperview().offset(-4)
                    make.centerX.equalTo(newcell.snp.centerX)
                    make.width.equalTo(self?.remarkView.width ?? 44)
                    make.height.equalTo(self?.remarkView.height ?? 4)
                }
                self.remarkView.width = 10
                UIView.animate(withDuration: 0.35) {
                    self.layoutIfNeeded()
                    self.remarkView.width = 32
                }
            }else{
                collectionView.reloadData()
            }
            
            
            
        }
        get{
            return _value
        }
    }
    var dataSource:[Any] = []{
        didSet{
            updateUI()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.35, execute: {
                self.value = 0
            })
            
        }
    }
    override func updateUI() {
        collectionView.reloadData()
    }
    
    
    lazy var layout:UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.sectionInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        lay.scrollDirection = .horizontal
  
        return lay
    }()
    lazy var collectionView:UICollectionView = {
        let coll = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        coll.register(CollectionHeaderCell.self, forCellWithReuseIdentifier: "CollectionHeaderCell")
        coll.dataSource = self
        coll.delegate = self
        coll.showsHorizontalScrollIndicator = false
        coll.bounces = false

        return coll
    }()
    private lazy var _remarkView:UIView = {
        let aview = UIView.init(frame: .init(x: 0, y: self.height, width: 32, height: 4))
        aview.backgroundColor = .red
        aview.mb_radius = 2
        addSubview(aview)
        return aview
    }()
    
    
    var remarkView:UIView{
        set{
            _remarkView = newValue
            addSubview(_remarkView)
        }
        get{
            return _remarkView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
}

extension CollectionHeaderView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionHeaderCell", for: indexPath) as!  CollectionHeaderCell
        cell.cellData = dataSource[indexPath.row]
        cell.updateUI()
        cell.isSelected = (indexPath.row == value)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        value = indexPath.row
        self.sendActions(for: .valueChanged)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 80, height: collectionView.height)
    }
   
    
}
