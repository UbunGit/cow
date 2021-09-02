//
//  ETFRecommendDetaiVC.swift
//  Cow
//
//  Created by admin on 2021/8/30.
//

import UIKit
class ETFRecommendDetaiModel {
    var delegate:BasetModelDelegate?
 
    var dataSouce:[[String:Any]] = []{
        didSet{
            delegate?.updateUI()
        }
    }
    var scheme:Scheme? = nil
    
    func updateData()  {
        scheme?.recommend(didchange: { result in
            self.dataSouce = result
        })
    }
    
}

class ETFRecommendDetaiVC: BaseViewController {
    
    lazy var pageData: ETFRecommendDetaiModel = {
        let data = ETFRecommendDetaiModel()
        data.delegate = self
        return data
    }()

   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var schemeName: UILabel! // 方案名称
    @IBOutlet weak var dateLab: UILabel! // 推荐日期
    @IBOutlet weak var signLab: UILabel! // 信号量下限
    @IBOutlet weak var countLab: UILabel! // 推荐个数/总数
    
    @IBOutlet weak var speedLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "推荐详情"
        configTableview()
        pageData.updateData()
    }
    override func updateUI() {
        guard  let scheme = pageData.scheme as? Kirogi else {
            return
        }
        schemeName.text = scheme.name
        dateLab.text = scheme.date
        signLab.text = "信号量：\(scheme.signal)"
        speedLab.text = "天数：\(scheme.speed)"
        if let first = pageData.dataSouce.first {
            countLab.text = "\(pageData.dataSouce.count)\n\(first["count"].int())"
        }else{
            countLab.text = "-\n-"
        }
       
        tableView.reloadData()
    }
}


extension ETFRecommendDetaiVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 60
//        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "ETFBaseListTableviewCell", bundle: nil), forCellReuseIdentifier: "ETFBaseListTableviewCell")
     
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ETFBaseListTableviewCell", for: indexPath) as! ETFBaseListTableviewCell
        cell.selectionStyle = .none
        cell.celldata = pageData.dataSouce[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let scheme =  pageData.scheme else {
            return
        }
        let vc = ETFDetaiViewController()
        vc.code = pageData.dataSouce[indexPath.row]["code"].string()
        vc.name = pageData.dataSouce[indexPath.row]["name"].string()
        vc.scheme = scheme
        self.navigationController?.pushViewController(vc, animated: true)
    }


    
    
}

