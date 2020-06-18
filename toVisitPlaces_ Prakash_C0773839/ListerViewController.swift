//
//  ListerViewController.swift
//  toVisitPlaces_ Prakash_C0773839
//
//  Created by Prakash on 2020-06-15.
//  Copyright © 2020 com.lambton. All rights reserved.
//

import UIKit

class ListerViewController: UIViewController {

    @IBOutlet weak var placesTable: UITableView!
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesTable.dataSource  = self
        placesTable.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        placesTable.reloadData()
    }
    
    @IBAction func addBtnDown(_ sender: Any) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(mapViewController, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PlaceManager.getAllPlaces().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell")
        cell?.textLabel?.text = PlaceManager.getAllPlaces()[indexPath.row].key
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
         let mapViewController = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        mapViewController.selectedPlace = PlaceManager.getAllPlaces()[indexPath.row]
        mapViewController.editMode = true
         self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let placeToDelete = PlaceManager.getAllPlaces()[indexPath.row]
            PlaceManager.removePlace(place: placeToDelete)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}
