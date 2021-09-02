//
//  TransactionListViewController.swift
//  Cow
//
//  Created by admin on 2021/9/2.
//

import UIKit
class TransactionList {
    var dataSouce:[[String:Any]] = []
}

class TransactionListViewController: UIViewController {
    var pageData = TransactionList()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        // Do any additional setup after loading the view.
    }



}

extension TransactionListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
        tableView.register(UINib(nibName: "TransactionListCell", bundle: nil), forCellReuseIdentifier: "TransactionListCell")
     
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return pageData.dataSouce.count
        10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
//        cell.celldata = pageData.dataSouce[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       let vc = ETFDetaiViewController()
//        vc.code = pageData.dataSouce[indexPath.row]["code"].string()
//        vc.name = pageData.dataSouce[indexPath.row]["name"].string()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
}

