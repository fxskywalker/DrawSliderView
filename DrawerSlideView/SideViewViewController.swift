//
//  SideViewViewController.swift
//  DrawerSlideView
//
//  Created by FangXin on 9/24/15.
//  Copyright © 2015 FangXin. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

typealias RootViewMoveBlock = (rootView:UIView, orginFrame:CGRect, xoffset:CGFloat) -> ()

class SideViewViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var needSwipeShowMenu:Bool!//是否开启手势滑动出菜单
    
    var  rootViewController:UIViewController!
    var  leftViewController:UIViewController!
    
    var leftViewShowWidth:CGFloat!//左侧栏的展示大小
    
    var  animationDuration:NSTimeInterval!//动画时长
    var showBoundsShadow:Bool!//是否显示边框阴影
    
    var rootViewMoveBlock:RootViewMoveBlock!//可在此block中重做动画效果
    
    var baseView:UIView!//目前是_baseView
    var currentView:UIView!//其实就是rootViewController.view
    
    var panGestureRecognizer:UIPanGestureRecognizer!
    
    var startPanPoint:CGPoint!
    var  lastPanPoint:CGPoint!
    var panMovingRightOrLeft:Bool!//true是向右，false是向左
    
    var  coverButton:UIButton!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        leftViewShowWidth = SCREEN_WIDTH*7/9
        animationDuration = 0.35
        showBoundsShadow = true
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        panGestureRecognizer.delegate = self
        
        panMovingRightOrLeft = false
        lastPanPoint = CGPointZero
        coverButton = UIButton(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        coverButton.addTarget(self, action: Selector("hideSideViewController"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseView = self.view
        self.needSwipeShowMenu = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            if(currentView != rootViewController.view){
                if(currentView != nil){
                    currentView.removeFromSuperview()

                }
                currentView = rootViewController.view
                baseView.addSubview(currentView)
                currentView.frame = baseView.bounds
            }
        setNeedSwipeShowMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNeedSwipeShowMenu(){
        baseView.addGestureRecognizer(self.panGestureRecognizer)
    }
    
    func showShadow(show:Bool){
        if(show){
            currentView.layer.shadowOpacity = 0.8
        }else{
            currentView.layer.shadowOpacity = 0.0
        }
        
        currentView.layer.cornerRadius = 4.0
        currentView.layer.shadowOffset = CGSizeZero
        currentView.layer.shadowRadius = 4.0
        currentView.layer.shadowPath = UIBezierPath(rect: currentView.bounds).CGPath
    }
    
    func willShowLeftViewController(){
        if(self.leftViewController == nil || self.leftViewController.view.superview != nil){
            return
        }
        self.leftViewController.view.frame = baseView.bounds
        self.baseView.insertSubview(self.leftViewController.view, belowSubview: currentView)
    }
    
    func showLeftViewController(animated:Bool){
        if(self.leftViewController == nil){
            return
        }
        self.willShowLeftViewController()
        var animatedTime:NSTimeInterval = 0
        if(animated){
            animatedTime = Double(abs(self.leftViewShowWidth - currentView.frame.origin.x) / self.leftViewShowWidth * CGFloat(animationDuration))
        }
        
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.animateWithDuration(animatedTime, animations: {
            self.layoutCurrentViewWithOffset(self.leftViewShowWidth)
            self.showShadow(self.showBoundsShadow)
        })
        self.currentView.addSubview(self.coverButton)
    }
    
    func hideSideViewController(animated:Bool){
        var animatedTime:NSTimeInterval = 0
        if(animated){
            animatedTime = Double(abs(currentView.frame.origin.x / leftViewShowWidth)) * self.animationDuration
        }
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.animateWithDuration(animatedTime, animations: {
            self.layoutCurrentViewWithOffset(0)
            }, completion: { finished in
                self.coverButton .removeFromSuperview()
                self.leftViewController.view.removeFromSuperview()
                
        })
        self.showShadow(false)
    }
    
    func hideSideViewController(){
        self.hideSideViewController(true)
    }
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(gestureRecognizer == self.panGestureRecognizer){
            let panGesture:UIPanGestureRecognizer =  gestureRecognizer as! UIPanGestureRecognizer
            let translation:CGPoint = panGesture.translationInView(baseView)
            if(panGesture.velocityInView(self.baseView).x < 600 && (abs(translation.x)/abs(translation.y))>1){
                return true
            }
            return false
        }
        return true
    }
    
    func pan(pan:UIPanGestureRecognizer){
        if(self.panGestureRecognizer.state == UIGestureRecognizerState.Began){
            self.startPanPoint = currentView.frame.origin
            if(currentView.frame.origin.x == 0 && pan.velocityInView(baseView).x >= 0){
                self.showShadow(showBoundsShadow)
            }
            let velocity:CGPoint = pan.velocityInView(baseView)
            
            if(velocity.x>0){
                if(currentView.frame.origin.x>=0 && leftViewController != nil && leftViewController.view.superview == nil){
                    self.willShowLeftViewController()
                }
            }
            return
        }
        
        let currentPosition:CGPoint = pan.translationInView(baseView)
        var xoffset:CGFloat = startPanPoint.x + currentPosition.x
        if(xoffset>0){
            if(self.leftViewController != nil && self.leftViewController.view.superview != nil){
                if(xoffset > self.leftViewShowWidth){
                    xoffset = self.leftViewShowWidth
                }
            }else{
                xoffset = 0
            }
        }
        if(xoffset != currentView.frame.origin.x){
            self.layoutCurrentViewWithOffset(xoffset)
        }
        if(panGestureRecognizer.state == UIGestureRecognizerState.Ended){
            if(currentView.frame.origin.x != 0 && currentView.frame.origin.x != leftViewShowWidth){
                if(self.panMovingRightOrLeft == true && currentView.frame.origin.x > 20){
                    self.showLeftViewController(true)
                }else if(self.panMovingRightOrLeft == false && currentView.frame.origin.x < -20){
                }else{
                    self.hideSideViewController()
                }
            }else if(currentView.frame.origin.x == 0){
                self.showShadow(false)
            }
            lastPanPoint = CGPointZero
        }else{
            let velocity:CGPoint = pan.velocityInView(baseView)
            if(velocity.x > 0){
                panMovingRightOrLeft = true
            }else if(velocity.x<0){
                panMovingRightOrLeft = false
            }
        }
    }
    

    func layoutCurrentViewWithOffset(xoffset:CGFloat){
        if(showBoundsShadow == true){
            currentView.layer.shadowPath = UIBezierPath(rect: currentView.bounds).CGPath
        }

            let scale = abs(1000 - abs(xoffset))/1000
       
        var totalWidth:CGFloat = baseView.frame.size.width
        var totalHeight:CGFloat = baseView.frame.size.height
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
            totalHeight = baseView.frame.size.width
            totalWidth = baseView.frame.size.height
        }
        if(xoffset>0){
            currentView.frame = CGRectMake(xoffset, baseView.bounds.origin.y + (totalHeight * (1 - scale) / 2), totalWidth * scale, totalHeight * scale)
        }else if(xoffset == 0){//向左滑的
            currentView.frame = CGRectMake(baseView.frame.size.width * (1 - scale) + xoffset, baseView.bounds.origin.y + (totalHeight*(1 - scale) / 2), totalWidth * scale, totalHeight * scale)
        }
    }

}


