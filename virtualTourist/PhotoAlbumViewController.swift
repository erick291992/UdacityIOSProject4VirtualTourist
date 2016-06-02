//
//  PhotoAlbumViewController.swift
//  virtualTourist
//
//  Created by Erick Manrique on 6/1/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController {

    var pin:Pin!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        NetworkClient.sharedInstance().searchByLatLon("37",longitude: "-119") { (success, error) in
//            print("worked ")
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let myPin = self.pin{
            print("pin was succesfully planted")
            print(myPin.latitude)
        }
        else{
            print("not found pin")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
