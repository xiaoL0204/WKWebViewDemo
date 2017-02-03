//
//  WKWebViewController.swift
//  WKWebViewDemo
//
//  Created by xiaoL on 17/1/22.
//  Copyright © 2017年 xiaolin. All rights reserved.
//

import UIKit
import WebKit

let kEstimatedProgressKey = "estimatedProgress"
let YES = true
let NO = false

let FuncHistoryBack = "FuncHistoryBack"
let FuncAddHotelLike = "FuncAddHotelLike"
let FuncClickPhoto = "FuncClickPhoto"
let DocumentEnd = "DocumentEnd"

class WKWebViewController: BaseWebViewController,WKNavigationDelegate,WKUIDelegate,ScriptMessageHandlerDelegate,XLPhotoBrowserTapDelegate {
    var webView: WKWebView!
    
    
    deinit{
        webView.removeObserver(self, forKeyPath: kEstimatedProgressKey)
        removeScriptMessageHandler(name: FuncHistoryBack)
        removeScriptMessageHandler(name: FuncAddHotelLike)
        removeScriptMessageHandler(name: DocumentEnd)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNaviProgressView()
        let string : String? = webView.title;
        title = string;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createWKWebView()
    }
    
    
    
    
    func removeScriptMessageHandler(name:String?) -> Void {
        if name != nil {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name!)
        }
    }
    
    
    override func popSelf() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func refreshWebViewSelf() {
        webView.reload()
    }
    
    func createWKWebView() -> Void {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.userContentController = WKUserContentController()
        config.preferences.javaScriptCanOpenWindowsAutomatically = true;
        config.preferences.javaScriptEnabled = true
        
        
        
        webView = WKWebView(frame: CGRect(x:0, y:0, width:S_SCREEN_WIDTH, height:S_SCREEN_HEIGHT),configuration:config)
        webView.backgroundColor = UIColor.clear
        webView.scrollView.bounces = NO
        webView.scrollView.alwaysBounceVertical = NO
        webView.allowsBackForwardNavigationGestures = YES
        webView.isMultipleTouchEnabled = YES
        if #available(iOS 9.0, *) {webView.allowsLinkPreview = YES}
        webView.navigationDelegate = self;
        webView.uiDelegate = self;
        view.addSubview(webView)
        webView.addObserver(self, forKeyPath: kEstimatedProgressKey, options:
            [NSKeyValueObservingOptions.new , NSKeyValueObservingOptions.old], context: nil)
        
        if (urlString != "") {
            webView.load(URLRequest(url: URL(string: urlString)!))
        }
        
        
        
        addCustomUserScript()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath==kEstimatedProgressKey {
            let oldProgress  = Float(change![NSKeyValueChangeKey.oldKey] as! NSNumber)
            let newProgress  = Float(change![NSKeyValueChangeKey.newKey] as! NSNumber)
            webviewProgressView.setProgress(newProgress, animated: (newProgress > oldProgress ? true : false))
        }
    }
    
    
    func addCustomUserScript() -> Void {
        addAppInfoScript()
        addPopSelfScript()
        addChangeHotelLikeSpan()
        addLikeHotel()
        addAnalyzePhoto()
        addDocumentEndCallback()
    }
    
    
    
    
    func addAppInfoScript() -> Void {
        let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        let packageString = Bundle.main.infoDictionary!["CFBundleIdentifier"]
        let appInfoString : String = "\(packageString!)/\(versionString!)"
        webView.configuration.userContentController.addUserScript(WKUserScript(source: "injectAppInfo('\(appInfoString)')", injectionTime: .atDocumentStart, forMainFrameOnly: true))
    }
    
    func addPopSelfScript() -> Void {
        webView.configuration.userContentController.addUserScript(WKUserScript(source: "window.history.back=function(){window.webkit.messageHandlers.\(FuncHistoryBack).postMessage({body: ''});}", injectionTime: .atDocumentStart, forMainFrameOnly: true))
        webView.configuration.userContentController.add(ScriptMessageHandler(handlerDelegate:self), name: FuncHistoryBack)
    }
    
    
    func addLikeHotel() -> Void {
        webView.configuration.userContentController.addUserScript(WKUserScript(source: "function addLike(x,y,z){var spanLikeEle=oc_getSpanLikeEle();var f=1;if($(spanLikeEle).hasClass('like-act')){f=0}window.webkit.messageHandlers.\(FuncAddHotelLike).postMessage(f+','+y+','+z);}", injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        webView.configuration.userContentController.add(ScriptMessageHandler(handlerDelegate:self), name: FuncAddHotelLike)
    }
    
    func addChangeHotelLikeSpan() {
        webView.configuration.userContentController.addUserScript(WKUserScript(source: jsChangeHotelLikeSpanMethod, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
    }
    
    
    func addAnalyzePhoto() {
        let string1 : String = "var oc_photoColl=new Array();var ps=document.getElementsByTagName('img');for(var i=0;i<ps.length;i++){var temp=ps[i].getAttribute('data-src');if(temp!=null){oc_photoColl.push(temp);ps[i].onclick=function(){var oc_imgUrl=this.getAttribute('data-src');window.webkit.messageHandlers.\(FuncClickPhoto).postMessage({oc_imgUrl,oc_photoColl});}}}"
        
        webView.configuration.userContentController.addUserScript(WKUserScript(source: string1, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        webView.configuration.userContentController.add(ScriptMessageHandler(handlerDelegate:self), name: FuncClickPhoto)
    }
    
    
    
    //document加载完成回调
    func addDocumentEndCallback() {
        webView.configuration.userContentController.addUserScript(WKUserScript(source: "window.webkit.messageHandlers.\(DocumentEnd).postMessage({body: ''});", injectionTime: .atDocumentEnd, forMainFrameOnly: false))
        webView.configuration.userContentController.add(ScriptMessageHandler(handlerDelegate:self), name: DocumentEnd)
    }
    
    
    
    
    
    
    
    func scriptHandlerUserController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print("contentController:\(userContentController)  message.name:\(message.name)    message.body:\(message.body)")
        
        
        if message.name == DocumentEnd {
            if webView.url?.relativePath.hasPrefix("/hotel/detail") != nil { //详情页
                if let paramString = webView.url?.absoluteString.components(separatedBy: "?").last  {
                    checkHotelDetailIsFavorite(paramString)
                }
            }
        }else if message.name == FuncHistoryBack {
            popSelf()
        }else if message.name == FuncAddHotelLike {
            handlerAddHotelLikeAction((message.body as? String)!)
        }else if message.name == FuncClickPhoto {
            if let dic = message.body as? Dictionary<String, Any> {
                handlerClickImageTag(dic: dic)
            }
        }
    }
    
    
    //点击image
    func handlerClickImageTag(dic: Dictionary<String, Any>) {
        guard let currImgUrl = dic["oc_imgUrl"] as? NSString else {return}
        guard let imgBankArr = dic["oc_photoColl"] as? NSMutableArray else {return}
        
        var currImgInfo : WebPhotoImgInfo? = nil
        let urlBankArr = NSMutableArray()
        for i in 0 ..< imgBankArr.count  {
            let url = imgBankArr[i] as? NSString
            
            let tempInfo : WebPhotoImgInfo = WebPhotoImgInfo()
            tempInfo.imgUrl = url!
            if url == currImgUrl {
                currImgInfo = tempInfo
            }
            
            urlBankArr.add(tempInfo)
        }
        
        
        let vc : XLPhotoBrowserController = XLPhotoBrowserController()
        vc.delegate = self
        vc.setupUI(withCurrentImgAdapter: currImgInfo, imageAdaptersBank: NSArray(array:urlBankArr) as! [XLPhotoBrowserAdapterDelegate])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //改变收藏状态
    func checkHotelDetailIsFavorite(_ paramString:String?) {
        webView.evaluateJavaScript("oc_changeLikeSpan(\(YES))", completionHandler: { (object, error) in
            print("evaluateJavaScript    oc_changeLikeSpan:\(object)   error:\(error)")
        })
    }
    
    
    //收藏/取消收藏
    func handlerAddHotelLikeAction(_ arguments : String) -> Void {
        print("handlerAddHotelLikeAction   arguments:\(arguments)")
    }
    
    
    
    func handleTapPhotoView(withItem item: XLPhotoBrowserAdapterDelegate!) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    //在JS端调用alert函数时，会触发此代理方法
    //在原生得到结果后，需要回调JS，是通过completionHandler回调
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertVC = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
            _ in completionHandler()
        })
        present(alertVC, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: {
            _ in completionHandler(true)
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel){
            _ in completionHandler(false)
        })
        present(alertVC, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertVC = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alertVC.addTextField { (textField : UITextField) in
            textField.text = defaultText
        }
        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (alertAction : UIAlertAction) in
            completionHandler(alertVC.textFields?.last?.text)
        }))
        present(alertVC, animated: true) {
            
        }
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
