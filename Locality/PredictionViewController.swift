//
//  PredictionViewController.swift
//  Locality
//
//  Created by Andrew Ferreira on 8/30/18.
//  Copyright © 2018 Andrew Ferreira. All rights reserved.
//

import UIKit

class PredictionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var predictionTable: UITableView!
    @IBAction func dismissView( _ sender: AnyObject ) {
        print( "DismissView!")
        dismissAnimated()
    }
    
    var offScreenFrame: CGRect!
    var onScreenFrame: CGRect!
    var onScreen = false
    
    fileprivate var _predictions = [Prediction]()
    var predictions: [Prediction] {
        get {
            return _predictions
        }
        
        set (value) {
            _predictions = value
            if onScreen {
                predictionTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        view.layer.shadowOpacity = 0.4
        onScreenFrame = preferredFrame()
        offScreenFrame = onScreenFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        view.frame = offScreenFrame
        
        super.viewDidLoad()
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
        cell.titleLabel.text = prediction.route.fullName
        cell.subtitleLabel.text = prediction.directionDescription
        cell.timeFieldLabel.text = prediction.timeDescription

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public func dismissAnimated() {
        UIView.animate(withDuration: 0.5,
                       animations: {self.view.frame = self.offScreenFrame})
        onScreen = false
    }
    
    public func showAnimated() {
        UIView.animate(withDuration: 0.5,
                       animations: {self.view.frame = self.onScreenFrame})
        onScreen = true
        predictionTable.reloadData()
    }
    
    fileprivate func preferredFrame() -> CGRect {
        let preferredHeight: CGFloat = 250
        let preferredWidth = min( UIScreen.main.bounds.width, 800 )
        
        let newSize = CGSize(width: preferredWidth, height: preferredHeight)
        
        let newX = (UIScreen.main.bounds.width - preferredWidth) / 2
        let parentHeight = parent?.view.frame.height ?? UIScreen.main.bounds.height
        let newOrigin = CGPoint(x: newX, y: parentHeight - preferredHeight)
        
        return(CGRect(origin: newOrigin, size: newSize ))
    }
}
