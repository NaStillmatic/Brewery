//
//  BeerListViewController.swift
//  Brewery
//
//  Created by HwangByungJo  on 2022/06/22.
//


import UIKit

class BeerListViewController: UITableViewController {
  
  var beerList = [Beer]()
  var currentPage = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UINavigationBar
    title = "패캠브루어리"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    // UITableView 설정
    tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
    tableView.rowHeight = 150
    
    fetchBeer(of: currentPage)
  }
}

extension BeerListViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beerList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
    
    let beer = beerList[indexPath.row]
    cell.configure(with: beer)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedBeer = beerList[indexPath.row]
    let detailViewController = BeerDetailViewControoller()
    detailViewController.beer = selectedBeer
    self.show(detailViewController, sender: nil)
  }
}

private extension BeerListViewController {
  func fetchBeer(of page: Int) {
    guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      guard error == nil,
            let self = self,
            let response = response as? HTTPURLResponse,
            let data = data,
            let beer = try? JSONDecoder().decode([Beer].self, from: data) else {
        print("ERROR: URLSession data task \(error?.localizedDescription ?? "")")
        return
      }
    
      switch response.statusCode {
      case 200...299: // 성공
        self.beerList += beer
        self.currentPage += 1
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      case 400...499: // 클라이언트 에러
        print("ERROR: Client ERROR \(response.statusCode)")
      case 500...599: // 서버 에러
        print("ERROR: Server ERROR \(response.statusCode)")
      default:
        break
      }
    }
    dataTask.resume()
  }
}
