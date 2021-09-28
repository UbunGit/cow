//
//  PlanFormViewController.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit

class SchemeTemplateEditVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CommitBtn: UIButton!
    var param:[String:Any]? = nil
    var dataSouce:[BaseInputCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configTableview()
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
        
        tableView.reloadData()
    }

    @IBAction func commitBtnClick(_ sender: Any) {
        var dic:[String:Any] = [:]
        for cell in dataSouce {
            dic[cell.key] = cell.value()
        }
        let sql = """
            INSERT INTO "etffollow" (code,userId,follow,status)
            values ('\(code)',\(userId),1,0);
            """
        print(dic)
        self.dismiss(animated: true, completion: nil)
    }


}

extension SchemeTemplateEditVC:UITableViewDelegate,UITableViewDataSource{
    
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

