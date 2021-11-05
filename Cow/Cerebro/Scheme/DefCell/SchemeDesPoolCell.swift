//
//  SchemeDesPoolCell.swift
//  Cow
//
//  Created by admin on 2021/11/5.
//

import UIKit
import Alamofire
class SchemeDesPool{
    var valueChange:(()->())? = nil
    var datas:[[String:Any]] = []
    var error:Any? = nil
    func loadData(){
        AF.scheme_pool(1)
            .responseModel([[String:Any]].self) { result in
                switch result{
                case .success(let value):
                    self.datas = value
                case .failure(let err):
                    self.error = err
                }
                
                self.valueChange?()
            }
    }
}
class SchemeDesPoolCell: UICollectionViewCell {

    var celldata:[String:Any]? = nil{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var codeLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func updateUI() {
        guard let data = celldata else{
            return
        }
        let name = data["name"].string()
        let code = data["code"].string()
        nameLab.text = name
        codeLab.text = code
    }

}
