//
//  RootViewController.swift
//  DrawerSlideView
//
//  Created by FangXin on 9/24/15.
//  Copyright © 2015 FangXin. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var showLeftView: UIButton!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        let sideViewController:SideViewViewController = delegate.sideViewController!
//        sideViewController.setNeedSwipeShowMenu()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showLeft(sender: AnyObject) {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.sideViewController.showLeftViewController(true)
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
