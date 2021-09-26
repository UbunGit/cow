//
//  InputNumberTableCell.swift
//  Cow
//
//  Created by admin on 2021/9/26.
//

import UIKit

class InputNumberTableCell: UITableViewCell {
    
    lazy var valueView:InputNumberView = {
        let view = InputNumberView.initWithNib()
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(valueView)
        selectionStyle = .none
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        valueView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }

}
