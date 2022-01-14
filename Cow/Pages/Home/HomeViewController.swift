//
//  HomeViewController.swift
//  Cow
//
//  Created by admin on 2021/8/4.
//

import UIKit
import Magicbox
import SnapKit
import YYKit
class HomeViewController: BaseViewController {
	
	@IBOutlet weak var collecttionView: UICollectionView!
	lazy var minebtn: UIButton = {
		let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
		button.setTitle("🐂", for: .normal)
		button.mb_radius = 18
		button.setTitleColor(UIColor(named: "Background 5"), for: .normal)
		button.mb_borderColor = UIColor(named: "Background 3")
		button.mb_borderWidth = 1
		button.titleEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
		button.addTarget(self, action: #selector(userInfo), for: .touchUpInside)
		return button
	}()
	
	// 我
	lazy var mineItem: UIBarButtonItem = {
		
		let mineItem = UIBarButtonItem.init(customView: minebtn)
		
		return mineItem
	}()
	@objc func userInfo()  {
		if Global.share.user == nil{
			self.tabBarController?.present(loginViewController(), animated: true, completion: nil)
		}
	}
	// 搜素
	lazy var searchBtn: UIBarButtonItem = {
		let button = UIButton()
		button.setTitle("🔍", for: .normal)
		let searchItem = UIBarButtonItem.init(customView: button)
		return searchItem
	}()
	
	// 消息
	lazy var newItem: UIBarButtonItem = {
		let button = UIButton()
		button.setTitle("🔔", for: .normal)
		let newItem = UIBarButtonItem.init(customView: button)
		return newItem
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configNav()
		configUI()
		updateLayer()
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let gu = Global.share.user?.userName{
			let f:String = String(gu.prefix(1))
			minebtn.setTitle(f, for: .normal)
		}
		updatebuyList()
	}
	
	lazy var griddata:[[String:Any]]={
		let datas = [
			[
				"name":"持仓",
				"icon":"sterlingsign.circle",
				"selector":"pushTransaction0"
			],
			[
				"name":"卖出",
				"icon":"sterlingsign.circle",
				"selector":"pushTransaction1"
			],
			[
				"name":"占位",
				"icon":"sterlingsign.circle",
				"selector":""
			],
			[
				"name":0,
				"icon":"sterlingsign.circle",
				"selector":""
			],
			[
				"name":"占位",
				"icon":"sterlingsign.circle",
				"selector":""
			]
		]
		return datas
	}()
	var buylist:[[String:Any]] = []
	var selllist:[[String:Any]] = []
	
}

extension HomeViewController{
	func configNav() {
		
		navigationItem.leftBarButtonItems = [mineItem]
		navigationItem.rightBarButtonItems = [newItem,searchBtn]
	}
	func configUI() {
		collecttionView.register(UINib(nibName: "HomeSummarizeCell", bundle: nil), forCellWithReuseIdentifier: "HomeSummarizeCell")
		collecttionView.register(UINib(nibName: "CollectionViewGridCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewGridCell")
		collecttionView.register(UINib(nibName: "HomeRecommendCell", bundle: nil), forCellWithReuseIdentifier: "HomeRecommendCell")
		
		
	}
	func updateLayer()  {
		
		
	}
	
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		4
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section{
		case 0:
			return 1
		case 1:
			return griddata.count
		case 2:
			return buylist.count
		case 3:
			return selllist.count
		default:
			return 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch indexPath.section{
		case 0:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HomeSummarizeCell", for: indexPath)
			cell.mb_radius = 8
			return cell
		case 1:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CollectionViewGridCell", for: indexPath) as! CollectionViewGridCell
			let data = griddata[indexPath.row]
			cell.imageView.image = .init(systemName: data["icon"].string())
			cell.titleLab.text = data["name"].string()
			
			return cell
		case 2:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HomeRecommendCell", for: indexPath) as! HomeRecommendCell
			let celldata = buylist[indexPath.row]
			let bprice = celldata["bprice"].double()
			let price = celldata["price"].double()
			let orderdata = bprice*0.90
			let pix = ((price/bprice) - 1)*100
			
			let code = celldata["code"].string()
			cell.codeLab.text = celldata["code"].string()
			cell.costLab.text = bprice.price()
			cell.orderLab.text = orderdata.price()
			cell.priceLab.text = price.price()
			cell.rateLab.backgroundColor = (pix>=0) ? .red : .green
			cell.rateLab.text = "\(pix.string("%0.1f"))%"
            cell.nameLab.text = StockManage.share.storeName(code)
			cell.bgview.backgroundColor = .down
			
			return cell
		case 3:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HomeRecommendCell", for: indexPath) as! HomeRecommendCell
			let celldata = selllist[indexPath.row]
			let bprice = celldata["bprice"].double()
			let price = celldata["price"].double()
			let orderdata = celldata["target"].double()
			let pix = ((price/bprice) - 1)*100
			
			let code = celldata["code"].string()
			cell.codeLab.text = celldata["code"].string()
			cell.costLab.text = bprice.price()
			cell.orderLab.text = orderdata.price()
			cell.priceLab.text = price.price()
			cell.rateLab.backgroundColor = (pix>=0) ? .red : .green
			
			cell.rateLab.text = "\(pix.string("%0.1f"))%"
            cell.nameLab.text = StockManage.share.storeName(code)
			cell.bgview.backgroundColor = .up
			
			return cell
		default:
			return UICollectionViewCell()
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
		switch indexPath.section{
		case 0:
			return .init(width: collectionView.size.width-16, height: 200)
		case 1:
			return .init(width: (collectionView.size.width-16)/5, height: (collectionView.size.width-16)/5)
		case 2,3:
			return .init(width: (collectionView.size.width-16)/2, height: 72)
		
		default:
			return .zero
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		switch indexPath.section{
		case 0:
			break
		case 1:
			let data = griddata[indexPath.row]
			if let selector = data["selector"] as? String,
			   selector.count>0
			{
				self.perform(Selector(selector), with: nil)
			}
		case 2:
			let data = buylist[indexPath.row]
			self.push_transaction(code: data["code"].string())
		case 3:
			let data = selllist[indexPath.row]
			self.push_transaction(code: data["code"].string())
			
			
			
		default:
			break
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 4
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		switch section{
		case 0:
			return .init(top: 8, left: 8, bottom: 0, right: 8)
		case 1,2,3:
			return .init(top: 4, left: 8, bottom: 0, right: 8)
		default:
			return .zero
		}
	}
	
}

// 表格交易策略
extension HomeViewController{
	
	func updatebuyList(){
		let codes = StockManage.share.codes
		var mindatas:[[String:Any]] = []
		codes.forEach { code in
			let sql = """
  select t1.*,t2.price from rel_transaction t1
  left join stock_price t2 on t2.code=t1.code
  where t1.userid=\(Global.share.userId) and t1.code='\(code)' and sdate=''
  """
			let datas = sm.select(sql)
			if let data = datas.min(by: { a, b in
				a["bprice"].double()<b["bprice"].double()
			}){
				mindatas.append(data)
			}
			
		}
		buylist = mindatas.filter { item in
			let bprice = item["bprice"].double()
			let price = item["price"].double()
			let waramprice = bprice*0.91
			return price<=waramprice
		}
		selllist = mindatas.filter { item in
			if item["code"].string() == "sz159825"{
				log("")
			}
	
			let price = item["price"].double()
			let target = item["target"].double()
			return price>=target*0.99
		}
		
		collecttionView.reloadData()
		
	}
}



