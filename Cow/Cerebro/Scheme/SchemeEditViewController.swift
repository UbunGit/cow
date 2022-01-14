//
//  SchemeEditViewController.swift
//  Cow
//
//  Created by admin on 2021/11/26.
//

import UIKit
import Alamofire
class SchemeEditViewController: BaseViewController {
    var schemeID:Int? = nil // 策略id
    var schemeName:String? = nil // 策略名
    var template:[String:Any]? = nil
    var params:[[String:Any]] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "策略设置"
        makeTableView()
        if schemeID == nil{
            
        }
        
    }
    @IBAction func deleteScheme(_ sender: Any) {
        
    }
    
    @IBAction func updateScheme(_ sender: Any) {
        guard let name = schemeName else{
            self.view.error("策略名不能为空")
            return
        }
        guard let stemplate = template else{
            self.view.error("请选择模版")
            return
        }
        createOrupdateScheme(schemeID, name: name, templeId: stemplate["id"].int())
    }
    
}
extension SchemeEditViewController{
    // 获取参数列表
    func loadParam(){
        guard let templateid = template?["id"].int() else{
            return
        }
        UIView.loading()
        AF.scheme_template_param(templateid)
            .responseModel([[String:Any]].self) { result in
                UIView.loadingDismiss()
                switch result{
                case .success(let value):
                    self.params = value
                case .failure(let err):
                    self.error(err)
                }
                self.tableView.reloadData()
            }
    }
    // 创建策略
    func createOrupdateScheme(_ id:Int? = nil, name:String,templeId:Int){
        if id==nil{
            UIView.loading()
            AF.scheme_create(name: name, templateId: templeId)
                .responseModel([String:Any].self) { result in
                    UIView.loadingDismiss()
                    switch result{
                    case .success(let value):
                        self.view.success("添加成功\(value)")
                    case .failure(let err):
                        self.error(err)
                    }
                    self.tableView.reloadData()
                }
        }else{
            
        }
    }
    
    // 给策略添加参数
    func createSchemeParam(templeId:Int){
        
    }
}
extension SchemeEditViewController:UITableViewDelegate,UITableViewDataSource{
    func makeTableView(){
        tableView.register(UINib(nibName: "TableViewSelectCell", bundle: nil), forCellReuseIdentifier: "TableViewSelectCell")
        tableView.register(UINib(nibName: "TableViewIntCell", bundle: nil), forCellReuseIdentifier: "TableViewIntCell")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return params.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewIntCell", for: indexPath) as! TableViewIntCell
           
            cell.titleLab.text = "策略名"
            cell.valueTF.text = schemeName
            cell.valueTF.placeholder = "请输入策略名"
            cell.valueTF.addBlock(for: .editingDidEnd) { sender in
                self.schemeName = cell.valueTF.text
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewSelectCell", for: indexPath) as! TableViewSelectCell
            cell.titleLab.text = "选择策略模版"
            if let temp = template{
                cell.valueLab.text = temp["name"].string()
            }else{
                cell.valueLab.text = "点击选择"
            }
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewIntCell", for: indexPath) as! TableViewIntCell
            let celldata = params[indexPath.row]
            cell.titleLab.text = celldata["name"].string()
            if let value = celldata["value"]{
                cell.valueTF.text = "\(value)"
            }else{
                cell.valueTF.placeholder = celldata["defual"].string()
            }
            cell.valueTF.addBlock(for: .editingDidEnd) { _ in
                self.params[indexPath.row]["value"] = cell.valueTF.text
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 1:
            let vc = SchemeTemplateListVC()
            self.present(vc, animated: true, completion: nil)
            vc.selectBlock = { item in
                self.template = item
                self.loadParam()
            }
           
        default:
            break
        }
    }
}
