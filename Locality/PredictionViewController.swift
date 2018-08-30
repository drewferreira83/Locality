//
//  PredictionViewController.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/30/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import UIKit

class PredictionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var predictionTable: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    var predictions: [Prediction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        predictionTable.delegate = self
        predictionTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return predictions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath) as! PredictionCell

        let prediction = predictions[ indexPath.row ]
        cell.titleLabel.text = prediction.route.displayName
        cell.subtitleLabel.text = prediction.directionDescription
        cell.timeFieldLabel.text = prediction.timeDescription

        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        guard predictions != nil else {
            fatalError( "PredictionView does not have any predictions!")
        }
        super.viewWillAppear(animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
