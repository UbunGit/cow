//
//  PlanFormViewController.swift
//  Cow
//
//  Created by admin on 2021/9/28.
//

import UIKit

class PlanFormViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CommitBtn: UIButton!
    
    var dataSouce:[BaseInputCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configTableview()
    }
    
    func loadData(){
        let nameCell = FormTextInputCell.initWithNib()
        nameCell.key = "name"
        nameCell.titleLab.text = "方案名"
        nameCell.iconImgView.image = .init(systemName: "doc.append")
        
        let desCell = FormTextInputCell.initWithNib()
        desCell.key = "name"
        desCell.titleLab.text = "方案描述"
        desCell.iconImgView.image = .init(systemName: "list.bullet.rectangle")
        
        dataSouce = [nameCell,desCell]
        tableView.reloadData()
    }

    @IBAction func commitBtnClick(_ sender: Any) {
        var dic:[String:Any] = [:]
        for cell in dataSouce {
            dic[cell.key] = cell.value()
        }
        print(dic)
    }
    
    
    

}

extension PlanFormViewController:UITableViewDelegate,UITableViewDataSource{
    
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

