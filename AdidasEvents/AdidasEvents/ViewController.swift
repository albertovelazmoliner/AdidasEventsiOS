//
//  ViewController.swift
//  AdidasEvents
//
//  Created by Alberto Velaz Moliner on 16/10/2016.
//  Copyright © 2016 Alberto. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton?
    @IBOutlet weak var joinButton: UIButton?
    @IBOutlet weak var backGroundImage: UIImageView?
    @IBOutlet weak var eventName: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadButton?.setTitle(NSLocalizedString("load_again", comment: ""), for: UIControlState.normal)
        joinButton?.setTitle(NSLocalizedString("join_event", comment: ""), for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData() {
        Alamofire.request("http://192.168.1.44:3000/api/event").responseJSON { response in
            guard response.result.isSuccess else {
                return
            }
            
            let value = response.result.value as? [String: AnyObject]
            let imageUrl = value?["image"];
            let eventName = value?["name"];
            self.loadImage(imageUrl: imageUrl as! String)
            self.eventName?.text = (eventName as! String);
            self.joinButton?.isHidden = false;
        
        }
    }
    
    func loadImage(imageUrl: String) {
        backGroundImage?.sd_setImage(with: URL(string: imageUrl))
        backGroundImage?.contentMode = .scaleAspectFill
    }
}

