//
//  RecommendVC.swift
//  Cow
//
//  Created by admin on 2021/8/23.
//

import UIKit

class RecommendVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    lazy var dataSouce:[AnyObject] = {
        let datas = [Kirogi()]
        return datas
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "RecommendCell", bundle: nil), forCellReuseIdentifier: "RecommendCell")

    }



}
extension RecommendVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "RecommendCell", for: indexPath) as! RecommendCell
        return cell
    }
}
