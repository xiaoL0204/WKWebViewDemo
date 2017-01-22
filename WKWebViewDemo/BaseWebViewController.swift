//
//  BaseWebViewController.swift
//  WKWebViewDemo
//
//  Created by xiaoL on 17/1/22.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

import UIKit
import WebKit


class BaseWebViewController: BaseViewController {
    open var urlString : String = ""
    open var webviewProgressView = NJKWebViewProgressView()
    
    
    required public init(urlStr:String){
        urlString = urlStr
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webviewProgressView.removeFromSuperview()
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    open func popSelf() {
        
        
    }
    
    open func refreshWebViewSelf(){
        
    }
    
    
    func setupNaviProgressView() -> Void {
        webviewProgressView.removeFromSuperview()
        webviewProgressView = NJKWebViewProgressView()
        let progressBarHeight : CGFloat = 2.0
        webviewProgressView = NJKWebViewProgressView(frame: CGRect(x: 0, y: 44, width: S_SCREEN_WIDTH, height:progressBarHeight))
        webviewProgressView.setProgress(0, animated: false)
        webviewProgressView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        navigationController?.navigationBar.addSubview(webviewProgressView)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
