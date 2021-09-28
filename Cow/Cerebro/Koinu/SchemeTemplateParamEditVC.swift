//
//  SchemeTemplateParamEditVC.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit
import Alamofire

class SchemeTemplateParamEditVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CommitBtn: UIButton!
    var param:[String:Any]? = nil
    var dataSouce:[BaseInputCell] = []
    
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "trash.circle"), for: .normal)
        button.addBlock(for: .touchUpInside) { _ in
            guard let sid = self.param?["id"] else{
                self.view.error("没有id")
                return
            }
            self.commit(title: "你确定要删除这个参数么？", message: nil) { _ in
                let sql = sm.sql_delete(table: "scheme_template_param", value: sid)
                self.view.loading()
                AF.af_update(sql) { result in
                    self.view.loadingDismiss()
                    switch result{
                    case.success(_):
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let err):
                        self.view.error(err)
                    }
                    
                }
            }
        }
        return button
    }()
    
    // 添加
    lazy var mineItem: UIBarButtonItem = {
        let mineItem = UIBarButtonItem.init(customView: refresh)
        return mineItem
    }()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "模版编辑"
        loadData()
        configTableview()
        if param?["id"] != nil{
            navigationItem.rightBarButtonItems = [mineItem]
        }
    }
    
    func loadData(){
        
        let nameCell = FormTextInputCell.initWithNib()
        nameCell.textTF.maximumLimit = 30
        nameCell.key = "name"
        nameCell.titleLab.text = "参数名"
        nameCell.iconImgView.image = .init(systemName: "doc.append")
        
        let keyCell = FormTextInputCell.initWithNib()
        keyCell.textTF.maximumLimit = 30
        keyCell.key = "key"
        keyCell.titleLab.text = "参数Key"
        keyCell.iconImgView.image = .init(systemName: "list.bullet.rectangle")
        
        let typeCell = FormTextInputCell.initWithNib()
        typeCell.textTF.maximumLimit = 30
        typeCell.key = "type"
        typeCell.titleLab.text = "参数类型"
        typeCell.iconImgView.image = .init(systemName: "list.bullet.rectangle")
        
        let defualCell = FormTextInputCell.initWithNib()
        defualCell.textTF.maximumLimit = 30
        defualCell.key = "defual"
        defualCell.titleLab.text = "默认值"
        defualCell.iconImgView.image = .init(systemName: "list.bullet.rectangle")
        
        let desCell = FormTextInputCell.initWithNib()
        desCell.textTF.maximumLimit = 30
        desCell.key = "des"
        desCell.titleLab.text = "参数描述"
        desCell.iconImgView.image = .init(systemName: "list.bullet.rectangle")
        
        dataSouce = [nameCell,keyCell,typeCell,defualCell,desCell]
        if let data = param{
            nameCell.textTF.text = data["name"].string()
            keyCell.textTF.text = data["key"].string()
            typeCell.textTF.text = data["type"].string()
            defualCell.textTF.text = data["defual"].string()
            desCell.textTF.text = data["des"].string()
        }
        
        tableView.reloadData()
    }

    @IBAction func commitBtnClick(_ sender: Any) {
        var dic:[String:Any] = [:]
        for cell in dataSouce {
            dic[cell.key] = cell.value()
        }
    
        if let data = param?["id"] {
            dic["id"] = data
        }
        if let template = param?["template"] {
            dic["template"] = template
        }
        
        
        if let sql = sm.sql_update(table: "scheme_template_param", data: dic) {
            view.loading()
            AF.af_update(sql) { result in
                self.view.loadingDismiss()
                switch result{
                case.success(_):
                    self.dismiss(animated: true, completion: nil)
                case .failure(let err):
                    self.view.error(err)
                }
                
            }
        }
    }



}
extension SchemeTemplateParamEditVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
//        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
  
     
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dataSouce[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    }

}
