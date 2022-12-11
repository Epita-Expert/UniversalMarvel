//
//  MarvelTVC.swift
//  UniversalMarvel
//
//  Created by Nathan Podesta on 09/12/2022.
//

import UIKit

class MarvelTVC: UITableViewController, UISearchResultsUpdating {
    var alphabet : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var namesGrouped : [[String]] = []
    var namesToDisplay : [[String]] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        namesGrouped = self.groupBy(names: cleanNames)
        namesToDisplay = namesGrouped
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        if (!(text?.isEmpty ?? true)) { // dlfkjdlskfjqlkjfoiezalemazkfmdskl
            let filteredNames = cleanNames.filter {
                $0.lowercased().folding(options: .diacriticInsensitive, locale: .current).contains(text!.lowercased())
            }
            namesToDisplay = groupBy(names: filteredNames)
        } else {
            namesToDisplay = namesGrouped
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return namesToDisplay.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return namesToDisplay[section].count
    }
    
    let cleanNames = Marvel.characters.map { name in
        return name.replacingOccurrences(of: "\\s?\\([^)]*\\)", with: "", options: .regularExpression)
    }
    
    func groupBy(names: [String]) -> [[String]] {
        var namesByLetter = [[String]]()
        for index in alphabet.indices {
            let prefix = "\(alphabet[index])"
            let namesGroupByPrefix = names.filter { name in
                return name.starts(with: prefix)
            }
            if (!namesGroupByPrefix.isEmpty) {
                namesByLetter.append(namesGroupByPrefix)
            }
            
        }
        return namesByLetter
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        cell.textLabel?.text = namesToDisplay[indexPath.section][indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(namesToDisplay[section].first?.first ?? "0")
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
