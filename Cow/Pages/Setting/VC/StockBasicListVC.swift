//
//  StockBasicListVC.swift
//  Cow
//
//  Created by admin on 2021/8/9.
//

import UIKit
import Magicbox

class StockBasicListVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "股票列表"
        configNav()
    }
    
    // 刷新
    lazy var refreshItem: UIBarButtonItem = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        let searchItem = UIBarButtonItem.init(customView: button)
        button.addTarget(self, action: #selector(updateStockBasic), for: .touchUpInside)
        return searchItem
    }()
    
   

    func configNav()  {
        navigationItem.rightBarButtonItems = [refreshItem]
    }

}
extension StockBasicListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        return cell
    }
    
    
}
extension StockBasicListVC{
    @objc func updateStockBasic(){
        view.lodding()
        StockBasic.api_update { error in
            self.view.loadingDismiss()
            if error != nil{
                self.view.error(error!.msg)
            }
       
            
        }
    }
}
