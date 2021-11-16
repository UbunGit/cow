//
//  UItableViewEmptyFootView.swift
//  Cow
//
//  Created by admin on 2021/11/16.
//

import UIKit

class UICollectionEmptyFootView: UICollectionReusableView {

    lazy var empthLab:UILabel={
       let lable = UILabel()
        lable.text = "无"
        lable.textAlignment = .center
        lable.textColor = .cw_text4
        lable.font = .systemFont(ofSize: 14)
        return lable
    }()
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(empthLab)
        backgroundColor = .cw_bg1
        mb_blRadius = 4
        mb_brRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        empthLab.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}
