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
    @IBAction func dismissView( sender: Any? ) {
    }
    var predictions: [Prediction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
print( "Predcition View Did Load" )
        navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: nil, action: nil)
        
        view.layer.shadowOpacity = 0.4
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
        
        print( " View Will appear." )
        print( "Old frame = \(view.frame)")
        //view.frame = preferredFrame()
        print( "new frame = \(view.frame)")
        super.viewWillAppear(true)
        /*
       let endFrame = self.preferredFrame()
        
        // Start with the window off screen then animate it up.
        let startFrame = self.view.frame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        self.view.frame = startFrame
        UIView.animate(withDuration: 0.5, animations: {self.view.frame = endFrame} )
*/
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate func dismissAnimated() {
        let endFrame = self.view.frame.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)

        UIView.animate(withDuration: 0.5,
                       animations: {self.view.frame = endFrame},
                       completion:
            {(finished: Bool) in
                if finished {
                    self.view.removeFromSuperview()
                }});
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
