//
//  AppDelegate.swift
//  DrawerSlideView
//
//  Created by FangXin on 9/24/15.
//  Copyright © 2015 FangXin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sideViewController:SideViewViewController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController:RootViewController = storyBoard.instantiateViewControllerWithIdentifier("RootViewController") as! RootViewController
        mainViewController.view.backgroundColor = UIColor.yellowColor()
        
        let leftViewController:UIViewController = UIViewController(nibName: nil, bundle: nil)
        leftViewController.view.backgroundColor = UIColor.greenColor()
        
        sideViewController=SideViewViewController(nibName: nil, bundle: nil)
        
        sideViewController!.rootViewController=mainViewController;
        sideViewController!.leftViewController=leftViewController;
        
        
        //_sideViewController.leftViewShowWidth=200;
        sideViewController!.needSwipeShowMenu=true;//默认开启的可滑动展示
        //动画效果可以被自己自定义，具体请看api
        
        
        self.window!.rootViewController = sideViewController;
        
        self.window!.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

