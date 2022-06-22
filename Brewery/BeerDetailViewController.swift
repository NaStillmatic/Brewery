//
//  BeerDetailViewController.swift
//  Brewery
//
//  Created by HwangByungJo  on 2022/06/22.
//

import UIKit

class BeerDetailViewControoller: UITableViewController {
  
  var beer: Beer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = beer?.name ?? "이름 없는 맥주"
    
    tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
    tableView.rowHeight = UITableView.automaticDimension
    
    let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
    let headerView = UIImageView(frame: frame)
    let imageURL = URL(string: beer?.imageURL ?? "")
    
    headerView.contentMode = .scaleAspectFit
    headerView.kf.setImage(with: imageURL, placeholder: nil)
    tableView.tableHeaderView = headerView
  }
}

// UITableView DataSource, Delegate

extension BeerDetailViewControoller {
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 3:
      return beer?.foodParing?.count ?? 0
    default:
      return 1
    }
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "ID"
    case 1:
      return "Description"
    case 2:
      return "Brewers Tips"
    case 3:
      let isFoodParingEmpty = beer?.foodParing?.isEmpty ?? true
      return isFoodParingEmpty ? nil : "Food Paring"
    default:
      return nil
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
    
    cell.textLabel?.numberOfLines = 0
    cell.selectionStyle = .none
    
    cell.textLabel?.text = nil
    
    switch indexPath.section {
    case 0:
      cell.textLabel?.text = String(describing: beer?.id ?? 0)
    case 1:
      cell.textLabel?.text = beer?.description ?? "설명없는 맥주"
    case 2:
      cell.textLabel?.text = beer?.brewersTips ?? "팁 없는 맥주"
    case 3:
      cell.textLabel?.text = beer?.foodParing?[indexPath.row] ?? ""
    default:
      break
    }
    return cell
  }
}
