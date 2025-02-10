//
//  ViewController.swift
//  Project 7
//
//  Created by apple on 12.10.2024.
//

import UIKit

class ViewController: UITableViewController {
    var keyWord = "tratatata"
    var dataOne: Data? = nil
    var petitions = [Petition]()
    var startPetitions = [Petition]()
    override func viewDidLoad() {
        super.viewDidLoad()
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTitle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showWarning))
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                dataOne = data
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func searchTitle (){
        let dc = UIAlertController(title: "Search", message: "Write necessury word", preferredStyle: .alert)
        dc.addTextField()
        let submitAction = UIAlertAction(title: "submit", style: .default){_ in 
            guard let answer = dc.textFields?[0].text else {return}
            self.keyWord = answer
            guard let data = self.dataOne else {return}
            self.parse(json: data)
        }
        dc.addAction(submitAction)
        present(dc , animated: true)
    }
    
    @objc func showWarning (){
        let vc = UIAlertController(title: "Warning", message: "This petitions has get from https://www.hackingwithswift.com/samples/petitions-1.json", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default))
        present(vc, animated: true)
    }
    
    @objc func showError (){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        if keyWord == "tratatata" {
            if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
                startPetitions = jsonPetitions.results
                petitions = jsonPetitions.results
                tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
                
            }
        } else {
            if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
                for result in jsonPetitions.results{
                    if result.title.contains(keyWord){
                        petitions = jsonPetitions.results
                    }
                }
            }
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
