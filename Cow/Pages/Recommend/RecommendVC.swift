//
//  RecommendVC.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import UIKit

class RecommendVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var dataSouce:[AnyObject] = []{
        didSet{
            tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.register(UINib(nibName: "RecommendCell", bundle: nil), forCellReuseIdentifier: "RecommendCell")
        loaddates()
    }
    func loaddates() {
        do {
            let data = try sm.kirogidates(limmit: NSRange(location: 0, length: 10), type: "etf").map{ item -> Kirogi in
                let kir = Kirogi()
                kir.date = item["date"].string()
                return kir
            }
            dataSouce = data
            
        } catch  {
            view.error(error.localizedDescription)
        }
        
        
    }



}
extension RecommendVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        280
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "RecommendCell", for: indexPath) as! RecommendCell
        cell.celldata = dataSouce[indexPath.row]
        return cell
    }
}
