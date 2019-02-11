//
//  ViewController.swift
//  P7WhitehousePetitions
//
//  Created by Encompass on 1/15/19.
//  Copyright © 2019 exiaj9. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
 var jsonObjects = [JsonObject]()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    } //end viewDidLoad()

    @objc func fetchJSON() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https:/swiftjsonapi.herokuapp.com/api/items"
        } else {
            urlString = "https:/swiftjsonapi.herokuapp.com/api/items"
        }
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return jsonObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "Cell", for: indexPath)
        
        let theJsonObject = jsonObjects[indexPath.row]
        cell.textLabel?.text = theJsonObject.title
        cell.detailTextLabel?.text = theJsonObject.subtitle
        return cell
    }
 
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let theData = try? decoder.decode([JsonObject].self, from: json) {
            jsonObjects = theData
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = jsonObjects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
   @objc func showError() {
        
        DispatchQueue.main.async { [unowned self] in
            let ac = UIAlertController(title: "Loading error", message:
                "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
      
    }
  
    
} //end ViewController

