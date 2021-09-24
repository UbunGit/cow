//
//  KoinudefViewController.swift
//  Cow
//
//  Created by admin on 2021/9/21.
//

import UIKit
import MJRefresh

class KoinudefViewController: UIViewController {
    var schemeId:Int? = nil
    var dataSouce:[Any] = []
    @IBOutlet weak var tableView: UITableView!
    
    enum SectionType:Int{
        case history = 1
        case risk = 2
    }
    lazy var settingBtn: UIButton = {
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        button.setTitle("设置", for: .normal)
        button.mb_radius = 18
        button.setTitleColor(UIColor(named: "Background 5"), for: .normal)
        button.mb_borderColor = UIColor(named: "Background 3")
        button.mb_borderWidth = 1
        button.titleEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        button.addBlock(for: .touchUpInside) { _ in
            let vc = KoinuSettingVC()
            vc.schemeId = self.schemeId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return button
    }()

    // 我
    lazy var settingItem: UIBarButtonItem = {

        let mineItem = UIBarButtonItem.init(customView: settingBtn)
        return mineItem
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableview()
        navigationItem.rightBarButtonItems = [settingItem]
        self.title = "策略详情"
    }
    func loadData()  {
        
    }
 

}

extension KoinudefViewController:UITableViewDelegate,UITableViewDataSource{
    
    func configTableview()  {

        tableView.estimatedRowHeight = 120
//        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "KoinuHistoryCell", bundle: nil), forCellReuseIdentifier: "KoinuHistoryCell")
        tableView.mj_header = MJRefreshGifHeader(refreshingBlock: {
            self.loadData()
        })
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.history.rawValue:
            return 1
        case SectionType.risk.rawValue:
            return 2
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.history.rawValue:
            return 300
        case SectionType.risk.rawValue:
            return 44
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.history.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "KoinuHistoryCell", for: indexPath) as! KoinuHistoryCell
//            cell.cellData = dataSouce[indexPath.row]
            cell.updateUI()
         
            return cell
        case SectionType.risk.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "KoinuListCell", for: indexPath) as! KoinuListCell
//            cell.cellData = dataSouce[indexPath.row]
            cell.updateUI()
         
            return cell
        default:
            return UITableViewCell()
        }
       
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionType.history.rawValue:
            return "历史收益"
        case SectionType.risk.rawValue:
            return "风险评估"
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    
}
