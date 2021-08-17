//
//  SQLTableInfoVC.swift
//  Cow
//
//  Created by admin on 2021/8/17.
//

import UIKit

class SQLTableInfoVC: UIViewController {

    @objc var tableInfo:[String:Any] = [:]
    @IBOutlet weak var createSql: UILabel!
    @IBOutlet weak var countLab: UILabel!
    @IBOutlet weak var lastDataLab: UILabel!
    @IBOutlet weak var infoLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    }
    func updateUI()  {
        if let sql = tableInfo["sql"] as? String {
            createSql.text = sql
        }
        do {
            guard let tablename = tableInfo["name"] as? String else {
                return
            }
            let count = try sm.count(table: tablename)
            countLab.text = "数据量：\(count)"
            let lastdata = try sm.last(table: tablename)
            lastDataLab.text = lastdata?.description
            
            let tableinfo = try sm.info(table: tablename)
            infoLab.text = tableinfo.map({ $0.description
            }).joined(separator: "\n")
        } catch  {
            view.error(error.localizedDescription)
        }
    }



}
