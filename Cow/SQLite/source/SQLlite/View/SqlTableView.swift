//
//  SqlTableView.swift
//  Cow
//
//  Created by admin on 2021/9/29.
//

import UIKit
import Alamofire
import Magicbox
protocol StackHeaderViewDelegate {
    func stackHeaderViewClick(view:StackHeaderView,index:Int)
}

class StackHeaderView:UIView{
   
    var datas:[Any] = []
    var delegate:StackHeaderViewDelegate?
    var labs:[UIButton] = []
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
    
    func reloadUI(){
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
        }
        for (index,item) in datas.enumerated(){
            
            if index<labs.count{
                let lab = labs[index]
                lab.setTitle("\(item)", for: .normal)
                lab.tag = index
            }else{
                let lab = UIButton()
                lab.tag = index
                lab.titleLabel?.font = .systemFont(ofSize: 12)
                lab.titleLabel?.adjustsFontSizeToFitWidth = true
                lab.setTitleColor(.darkGray, for: .normal)
                lab.setTitle("\(item)", for: .normal)
                lab.addBlock(for: .touchUpInside) { sender in
                    let btn = sender as! UIButton
                    self.delegate?.stackHeaderViewClick(view: self, index: btn.tag)
                }
                labs.append(lab)
               
            }
            stackView.addArrangedSubview(labs[index])
        }
     
    }
}

class SqlTableValueCell:UITableViewCell{
    
    lazy var stackView: StackHeaderView = {
        let stackView = StackHeaderView()
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }

}


class SqlTableView: UIView {
    
    var tableName:String!
    var rootIn = 0 // 0 服务器 1 本的
    
    var page:NSRange = NSRange(location: 0, length: 10)
    var sort:String? = nil
    var desc:Bool = false
    var allPage = 0
    
    var keys =  ["1","2","3","4","5","6","7","8"]
    var dataSource:[[String:Any]] = [["1":"ee"],["2":"ee"],["3":"ee"]]
    var handleScroll:UIScrollView? = nil
    
    lazy var whereTF : UITextField = {
        let tf = UITextField()
        tf.returnKeyType = .send
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = .darkText
        
        tf.placeholder = "你可以在此输入过滤条件: id>9"
        tf.addBlock(for: .editingDidEnd) { _ in
            self.loadData()
        }
        tf.addBlock(for: .editingDidEndOnExit) { _ in
            self.loadData()
        }
        tf.backgroundColor = .black.alpha(0.1)
        
        tf.mb_radius = 8
        
        return tf
    }()
    lazy var pageView:TablePageView = {
        let view = TablePageView.initWithNib()
        view.leftBtn.addBlock(for: .touchUpInside) { _ in
            if self.page.location==0{
                self.error("已经第一页了")
                return
            }
            self.page.location = (self.page.location-1) >= 0 ? self.page.location-1 : 0
            self.loadData()
        }
        view.rightBtn.addBlock(for: .touchUpInside) { _ in
            if self.page.location==self.allPage{
                self.error("已经最后一页了")
                return
            }
            self.page.location = (self.page.location+1) >= self.allPage ? self.allPage : self.page.location+1
            self.loadData()
            
        }
        view.pageNoTF.addBlock(for: .editingDidEndOnExit) { sender in
            if let tf = sender as? UITextField{
                self.page.location = tf.text.int()
                self.loadData()
            }
            
        }
        view.pageNoTF.addBlock(for: .editingDidEnd) { sender in
            if let tf = sender as? UITextField{
                self.page.location = tf.text.int()
                self.loadData()
            }
            
        }
        return view
    }()
    
    lazy var titleTable : UITableView = {
        
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        return table
    }()
    
    lazy var valueHeader : StackHeaderView = {
        let view = StackHeaderView()
        view.backgroundColor = .white
        view.delegate = self
        return view
    }()
    
    lazy var valueTableView : UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.register(SqlTableValueCell.self, forCellReuseIdentifier: "SqlTableValueCell")
        return table
    }()
    
    lazy var valueScrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        return scroll
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configTableView()
        addSubview(whereTF)
        addSubview(titleTable)
        addSubview(valueScrollView)
        addSubview(pageView)
        valueScrollView.addSubview(valueTableView) 
    }
    
    override func updateUI()
    {
        valueHeader.datas = keys
        pageView.allPageCountLab.text = (self.allPage+1).string()
        pageView.pageNoTF.text = (page.location+1).string()
        valueHeader.reloadUI()
        titleTable.reloadData()
        valueTableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        whereTF.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        titleTable.snp.makeConstraints { make in
            make.top.equalTo(44)
            make.left.equalTo(0)
            make.bottom.equalTo(-40)
            make.width.equalTo(80)
        }
        valueScrollView.snp.makeConstraints { make in
            make.top.equalTo(44)
            make.left.equalTo(titleTable.snp.right)
            make.bottom.equalTo(-40)
            make.right.equalTo(0)
        }
        valueTableView.snp.makeConstraints { make in
            make.top.equalTo(valueScrollView)
            make.left.equalTo(valueScrollView)
            make.bottom.equalTo(valueScrollView)
            make.width.equalTo(keys.count*80)
            make.height.equalTo(titleTable)
            valueScrollView.contentSize = valueTableView.bounds.size
        }
        pageView.snp.makeConstraints { make in
            make.top.equalTo(titleTable.snp.bottom)
            make.left.equalToSuperview()
            make.bottom.equalTo(0)
            make.right.equalToSuperview()
        }
    }
   

}

extension SqlTableView:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    
    func configTableView(){
        titleTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        valueTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        if tableView == titleTable{
           
            let view = StackHeaderView()
            view.datas = ["序号"]
            view.reloadUI()
            view.backgroundColor = .white
            return view
        }else{
           
            return valueHeader
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == titleTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ((page.location*page.length)+indexPath.row).string()
            cell.textLabel?.font = .systemFont(ofSize: 12)
            if indexPath.row%2==0{
                cell.backgroundColor = .lightGray.alpha(0.2)
            }else{
                cell.backgroundColor = .white
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SqlTableValueCell", for: indexPath) as! SqlTableValueCell
            let celldata = dataSource[indexPath.row]
            cell.stackView.datas = keys.map{ celldata[$0].tableStr() }
            cell.stackView.reloadUI()
            if indexPath.row%2==0{
                cell.backgroundColor = .lightGray.alpha(0.2)
            }else{
                cell.backgroundColor = .white
            }
            return cell
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        handleScroll = scrollView
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false{
            handleScroll = nil
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScroll = nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           
           if scrollView == self.titleTable && handleScroll ==  self.titleTable{
               self.valueTableView.setContentOffset(CGPoint(x: 0, y: self.titleTable.contentOffset.y), animated: false)
           }

           if scrollView == self.valueTableView && handleScroll ==  self.valueTableView  {
               self.titleTable.setContentOffset(CGPoint(x: 0, y: self.valueTableView.contentOffset.y), animated: false)
           }
          
           
       }
    
    
}
extension SqlTableView:StackHeaderViewDelegate{
    func stackHeaderViewClick(view: StackHeaderView, index: Int) {
        let  tsort = keys[index]
        if tsort == sort{
            desc.toggle()
            view.labs[index].setImage(.init(systemName: "chevron.up"), for: .normal)
            
        }else{
            if let oldindex = keys.firstIndex(of: sort ?? ""){
                view.labs[oldindex].setImage(nil, for: .normal )
            }
            view.labs[index].setImage(.init(systemName: "chevron.down"), for: .normal )
            sort = tsort
            desc = false
        }
        page.location = 0
        loadData()
    }
    
    
}


extension SqlTableView{
    
    func loadeCacheConfig() -> [String:Any]{
        
        let key = "sql.table.cache.config.\(tableName.string())"
        if let config = UserDefaults.standard.object(forKey: key) as? [String:Any]{
            return config
        }else{
            return [:]
        }
    }
    func saveCacheConfig(){
        let dic = [
            "keys":keys,
            "sort":sort.string(),
            "desc":desc
        ] as [String : Any]
        let key = "sql.table.cache.config.\(tableName.string())"
        UserDefaults.standard.set(dic, forKey: key)
        
        
    }
    
    func setup(){
        let config = loadeCacheConfig()
        if let tkeys = config["keys"] as? [String]{
            keys = tkeys
        }
        if let tsort = config["sort"] as? String{
            sort = tsort
        }
        if let tdesc = config["desc"] as? String{
            desc = tdesc.int()>0
        }
     
    }
    
    func loadData(){
        saveCacheConfig()
        var sql = """
        select * from \(tableName.string())
        """
        if  whereTF.text?.count ?? 0>0{
            var wherestr:String = whereTF.text!
            wherestr = wherestr.replacingOccurrences(of: "“", with: "'")
            wherestr = wherestr.replacingOccurrences(of: "‘", with: "'")
            sql.append(" where \(wherestr)")
        }
        if sort != nil{
            sql.append(" order by \(sort.string()) \(desc ? "ASC" : "DESC")")
        }
        sql.append(" LIMIT \(page.length) OFFSET \(page.location*page.length) ")
        if rootIn==0{
            serverLoadData(sql)
        }else{
            localLoadData(sql)
        }
     
    }
    func localLoadData(_ sql:String){
        self.dataSource = sm.select(sql)
        if let first = self.dataSource .first{
            let fkeys = first.keys
            self.keys = self.keys.filter { fkeys.contains($0) }
            fkeys.forEach {
                if self.keys.contains($0) == false{
                    self.keys.append($0)
                }
            }
        }
        let countsql = countSql()
        if let first = sm.select(countsql).first{
            self.allPage = first["count"].int()/self.page.length
        }
        self.updateUI()
       
    }
    
    func serverLoadData(_ sql:String){
      
        
        loading()
        let group = DispatchGroup()
        group.enter()
        AF.af_select(sql) { result in
            
            switch result{
            case .success(let value):
                if let first = value.first{
                    let fkeys = first.keys
                    self.keys = self.keys.filter { fkeys.contains($0) }
                    fkeys.forEach {
                        if self.keys.contains($0) == false{
                            self.keys.append($0)
                        }
                    }
                }
                self.dataSource = value
            case .failure(let err):
                self.error(err)
            }
            group.leave()
            
        }
        
        group.enter()
        loadcount(group: group)
        group.notify(queue: .main) {
            self.loadingDismiss()
            self.updateUI()
        }
    }
    func countSql()->String{
        var sql = """
        select count(*) as count from \(tableName.string())
        """
        if  whereTF.text?.count ?? 0>0{
            var wherestr:String = whereTF.text!
            wherestr = wherestr.replacingOccurrences(of: "“", with: "'")
            wherestr = wherestr.replacingOccurrences(of: "‘", with: "'")
            sql.append(" where \(wherestr)")
        }
        if sort != nil{
            sql.append(" order by \(sort.string()) \(desc ? "ASC" : "DESC")")
        }
        return sql
    }
    func loadcount(group:DispatchGroup){
        saveCacheConfig()
        let sql = countSql()
       
        AF.af_select(sql) { result in
            
            switch result{
            case .success(let value):
                if let first = value.first{
                    self.allPage = first["count"].int()/self.page.length
                }
            case .failure(_ ):
                self.error("总页码请求失败")
            }
            group.leave()
        }
    }
}
