//
//  RecommendCell.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import UIKit
import YYKit
protocol RecommendCellDelegate{
    func codeclick(code:String,name:String, celldata:SchemeProtocol)
    func reloadHeight()
}

class RecommendCell: UITableViewCell {
    var delegate:RecommendCellDelegate? = nil
    var celldata:SchemeProtocol?{
        didSet{
            updateUI()
        }
    }

    
    @IBOutlet weak var recommentCodeLab: YYLabel!
    @IBOutlet weak var datelab: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var siginLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        recommentCodeLab.textAlignment = .left
        recommentCodeLab.isUserInteractionEnabled = true
    }

    @IBAction func moreBtnClick(_ sender: Any) {
        delegate?.reloadHeight()
    }
    func updateUI() {
        self.moreBtn.isHidden = true
        guard let obj = celldata else {
            return
        }
        siginLab.text = .init(format: "信号量:%0.2f" , obj.signal)
        datelab.text = obj.date
        self.loading()
        obj.recommend(didchange: { result in
            let muatt = NSMutableAttributedString(string: "")
            for item in result{
                let str = " \(item["code"].string())\(item["name"].string()) "
                let t = NSMutableAttributedString(string:str )
                t.font = .systemFont(ofSize: 14)
                t.setTextHighlight(_NSRange(location: 0, length: str.count),
                                   color:.white ,
                                   backgroundColor: UIColor(named: "AccentColor"))
                { view, attstr, range, recet in
                    
                    self.delegate?.codeclick(code: item["code"].string(),name: item["name"].string(), celldata: self.celldata!)
                }
                t.backgroundColor = .clear
                muatt.append(t)
                muatt.append(NSMutableAttributedString(string: " "))
               
            }
            muatt.lineSpacing = 4
            self.recommentCodeLab.attributedText = muatt
            self.loadingDismiss()
            
            let h = (muatt.size().width/(self.recommentCodeLab.frame.size.width - 30)) * (muatt.size().height+4)
            
            if h > self.celldata!.cellheight{
                self.celldata?.cellheight = h+20
                self.moreBtn.isHidden = false
            }
        })

    }
    
}
