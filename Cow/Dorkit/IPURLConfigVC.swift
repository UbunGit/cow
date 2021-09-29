//
//  IPURLConfigVC.swift
//  Cow
//
//  Created by admin on 2021/9/29.
//

import UIKit

class IPURLConfigVC: UIViewController {
    var dataSouce:[String] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
    }
}

extension IPURLConfigVC:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
//        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "KoinuListCell", bundle: nil), forCellReuseIdentifier: "KoinuListCell")
    
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KoinuListCell", for: indexPath) as! KoinuListCell
        cell.cellData = dataSouce[indexPath.row]
        cell.updateUI()
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
    }

}
