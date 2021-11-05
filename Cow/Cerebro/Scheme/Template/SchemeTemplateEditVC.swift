//
//  PlanFormViewController.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit
import Magicbox
import Alamofire

class SchemeTemplateEditVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CommitBtn: UIButton!
    lazy var addCell:UITableViewAddCell = {
        let cell = UITableViewAddCell.initWithNib()
        return cell
    }()
    var param:[String:Any]? = nil
    var templateParams:[[String:Any]] = []
    var dataSouce:[BaseInputCell] = []
    
    lazy var refresh: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setImage(.init(systemName: "trash.circle"), for: .normal)
        button.addBlock(for: .touchUpInside) { _ in
            guard let sid = self.param?["id"] else{
                self.view.error("没有id")
                return
            }
            self.commit(title: "你确定要删除这个模版么？", message: nil) { _ in
                let sql = sm.sql_delete(table: "scheme_template", value: sid)
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
       
        configTableview()
        if param?["id"] != nil{
            navigationItem.rightBarButtonItems = [mineItem]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        
        let nameCell = FormTextInputCell.initWithNib()
        nameCell.textTF.maximumLimit = 30
        nameCell.key = "name"
        nameCell.titleLab.text = "方案名"
        nameCell.iconImgView.image = .init(systemName: "doc.append")
        
        let desCell = FormTextInputCell.initWithNib()
        desCell.textTF.maximumLimit = 30
        desCell.key = "des"
        desCell.titleLab.text = "方案描述"
        desCell.iconImgView.image = .init(systemName: "list.bullet.rectangle")
        
        dataSouce = [nameCell,desCell]
        if let data = param{
            
            nameCell.textTF.text = data["name"].string()
            desCell.textTF.text = data["des"].string()
        }
        if param?["id"] != nil{
            navigationItem.rightBarButtonItems = [mineItem]
        }
        loadtemplateParams()
        
    }
    func loadtemplateParams(){
        guard let templateId:Int = param?["id"].int()  else{
            tableView.reloadData()
            return
        }
       
        AF.scheme_template_param_list(templateId)
            .responseModel([[String:Any]].self) { result in
                
                switch result{
                case .success(let value):
                    self.templateParams = value
                case .failure(let err):
                    self.view.error(err)
                }
                self.tableView.reloadData()
            }
    }

    @IBAction func commitBtnClick(_ sender: Any) {
        var dic:[String:Any] = [:]
        for cell in dataSouce {
            dic[cell.key] = cell.value()
        }
        if let data = param?["id"] {
            dic["id"] = data
        }
        
        if let sql = sm.sql_update(table: "scheme_template", data: dic) {
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

extension SchemeTemplateEditVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
//        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SchemeTemplateParamCell", bundle: nil), forCellReuseIdentifier: "SchemeTemplateParamCell")
        tableView.register(UINib(nibName: "FormRoundHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "FormRoundHeader")
        tableView.register(UINib(nibName: "FormRoundFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "FormRoundFooter")
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return dataSouce.count
        case 1:
            return templateParams.count
        case 2:
            return param?["id"].int() ?? 0>0 ? 1 : 0
        default:
            return 0
        }
       

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 60
        case 1:
            return 44
        case 2:
            return 40
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = dataSouce[indexPath.row]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SchemeTemplateParamCell", for: indexPath) as! SchemeTemplateParamCell
            let celldata = templateParams[indexPath.row]
            cell.nameLab.text = celldata["name"].string()
            cell.keyLab.text = celldata["key"].string()
            cell.desLab.text = celldata["des"].string()
            cell.typeLab.text = celldata["type"].string()
            cell.defualLab.text = celldata["defual"].string()
            return cell
        case 2:
            return addCell
        default:
            return UITableViewCell()
        }
        
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aview = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FormRoundHeader") as! FormRoundHeader
        switch section{
        case 0:
            aview.titleLab.text = "策略信息"
        case 1:
            aview.titleLab.text = "策略参数列表"
        default:
            return nil
        }
        return aview
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let aview = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FormRoundFooter") as! FormRoundFooter
       
        return aview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 44
        case 1:
            return 44
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section{
        case 0:
            return 20
        case 1:
            return 20
        default:
            return 0
        }
    }
 
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
           break
        case 1:
            let vc = SchemeTemplateParamEditVC()
            vc.param = templateParams[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: false)
        case 2:
            if let template = param?["id"].int(){
                let vc = SchemeTemplateParamEditVC()
                vc.param = ["template":template];
                self.navigationController?.pushViewController(vc, animated: false)
            }
            
        default:
            break
        }
    }

}





