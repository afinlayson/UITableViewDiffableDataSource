//
//  ClickableTableViewController.swift
//  TestDiffable2
//
//  Created by Alex Finlayson on 8/24/19.
//  Copyright © 2019 Wm Alex Finlayson. All rights reserved.
//

import UIKit

class ClickableTableViewController: UITableViewController {
    struct Seconds: WithTitle, Comparable {
        static func < (lhs: ClickableTableViewController.Seconds, rhs: ClickableTableViewController.Seconds) -> Bool {
            return lhs.seconds < rhs.seconds
        }
        
        var seconds: String
        
        static var timeFormatter: DateFormatter = {
            let tf = DateFormatter()
            tf.dateFormat = "ss"
            return tf
        }()
        
        init(date: Date) {
            self.seconds = Seconds.timeFormatter.string(from: date)
        }
        
        var title: String {
            return self.seconds
        }
        
        
    }
    struct Object: Hashable {
        var name: String
        var date: Date
        
        init(_ date: Date = Date()) {
            self.date = date
            self.name = "\(date)"
        }
    }
    
    enum SortOrder: Int {
        case alpha
        case date
    }
    
    
    var sortOrder = SortOrder.date
    var datasource: CustomDiff<Seconds, Object>!
    var objects: [Seconds: [Object]] = [:]
    var order: [Seconds] = []
    var numeric: [Seconds] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.datasource = CustomDiff(tableView: self.tableView, cellProvider: { (tableview, indexPath, data) -> UITableViewCell? in
             if let cell = tableview.dequeueReusableCell(withIdentifier: "Cell") {
                   cell.textLabel?.text = data.name
                   cell.showsReorderControl = true
                   
                   return cell
               }
               return nil
        })
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        let sorting = UIBarButtonItem(title: "numeric", style: .plain, target: self, action: #selector(sorting(_:))) //(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.leftBarButtonItem = sorting
        
    }
    
    @objc func sorting(_ button: UIBarButtonItem) {
        if self.sortOrder == .alpha {
            button.title = "date"
            self.refresh(self.order)
        } else {
            button.title = "numeric"
            self.refresh(self.numeric)
        }
        
        if let so = SortOrder(rawValue: self.sortOrder.rawValue + 1) {
            self.sortOrder = so
        } else {
            self.sortOrder = .alpha
        }
    }
    
    @objc func insertNewObject(_ button: UIButton) {
        let newObj = Object()
        let section = Seconds(date: newObj.date)
        
        
        if self.objects[section] != nil {
            self.objects[section]!.insert(newObj, at: 0)
            if let index = self.order.firstIndex(of: section) {
                self.order.remove(at: index)
            }
                        
        } else {
            self.objects[section] = [newObj]
            self.numeric.insertSort(section)
        }
        
        self.order.insert(section, at: 0)
        
        if self.sortOrder == .alpha {
            self.refresh(numeric)
        } else {
            self.refresh(order)
        }
        
    }
    
    func refresh(_ order: [Seconds]) {
        var snapshot = NSDiffableDataSourceSnapshot<Seconds, Object>()
        snapshot.appendSections(order)
        for section in order {
            if let items = self.objects[section] {
                snapshot.appendItems(items, toSection: section)
            }
        }
        self.datasource.apply(snapshot)
        
    }
    
}
