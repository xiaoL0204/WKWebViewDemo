//
//  ViewController.swift
//  WKWebViewDemo
//
//  Created by xiaoL on 17/1/22.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    
    @IBAction func ClickLoadButton(_ sender: UIButton) {
        let vc = WKWebViewController(urlStr: "https://mp.weixin.qq.com/s?__biz=MzIzMzM1MTYzMw==&mid=2247485846&idx=1&sn=00c2f0143688bf80206183fd25d5dafc#rd")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

