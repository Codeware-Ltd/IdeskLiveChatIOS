//
//  WebView.swift
//  WebViewKit
//
//  Created by Daniel Saidi on 2022-03-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//
#if os(iOS)
typealias WebViewRepresentable = UIViewRepresentable
//#elseif os(macOS)
//typealias WebViewRepresentable = NSViewRepresentable
#endif

#if os(iOS)
//|| os(macOS)
import SwiftUI
import WebKit
import MobileCoreServices
/**
 This view wraps a `WKWebView` and can be used to load a URL
 that refers to both remote or local web pages.
 
 When you create this view, you can either provide it with a
 url, or an optional url and a view configuration block that
 can be used to configure the created `WKWebView`.

 You can also provide a custom `WKWebViewConfiguration` that
 can be used when initializing the `WKWebView` instance.
 */
public struct WebViewTS: WebViewRepresentable {
    
    // MARK: - Initializers
    
    /**
     Create a web view that loads the provided url after the
     provided configuration has been applied.
     
     If the `url` parameter is `nil`, you must manually load
     a url in the configuration block. If you don't, the web
     view will not present any content.
     
     - Parameters:
       - url: The url of the page to load into the web view, if any.
       - webConfiguration: The WKWebViewConfiguration to apply to the web view, if any.
       - webView: The custom configuration block to apply to the web view, if any.
     */
    public init(

        ideskAppData: String,
        webConfiguration: WKWebViewConfiguration? = nil,
        viewConfiguration: @escaping (WKWebView) -> Void = { _ in },
        callback: @escaping (DownloadRes) -> ()){
            
        self.ideskAppData = ideskAppData
        self.webConfiguration = webConfiguration
        self.viewConfiguration = viewConfiguration
        self.callback = callback
    }
    
    
    // MARK: - Properties
    
    private let ideskAppData: String
    private let webConfiguration: WKWebViewConfiguration?
    private let viewConfiguration: (WKWebView) -> Void
    let callback: (DownloadRes) -> ()
    var downloadUrl = URL(fileURLWithPath: "")

    
    // MARK: - Functions
    
    #if os(iOS)
    public func makeUIView(context: Context) -> WKWebView {
        makeView(context: context)
    }
    
  
    public func updateUIView(_ uiView: WKWebView, context: Context) {}
    #endif
    
    #if os(macOS)
    public func makeNSView(context: Context) -> WKWebView {
        makeView()
    }
    
    public func updateNSView(_ view: WKWebView, context: Context) {}
    #endif
    
    private func setupFilePicker(for webView: WKWebView, context: Context) {
           webView.navigationDelegate = context.coordinator
       }
    private func setupDownloadHandling(for webView: WKWebView,  context: Context) {
         webView.navigationDelegate = context.coordinator
     }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
      }
    
  
    
    public class Coordinator: NSObject, WKNavigationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WKDownloadDelegate {

        
        
        @available(iOS 14.5, *)
        public func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
            download.delegate = self
            
        }
        
        
        @available(iOS 14.5, *)
        public func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
            print(suggestedFilename)
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileUrl =  documentDirectory.appendingPathComponent("\(suggestedFilename)", isDirectory: false)
            
            parent.downloadUrl = fileUrl
            
            
            
            completionHandler(fileUrl)
            
        }
        
        // MARK: - Optional
        @available(iOS 14.5, *)
        public  func downloadDidFinish(_ download: WKDownload) {
         
    
               // Present the alert controller on the main thread
            DispatchQueue.main.async {
       
                let downRes = DownloadRes(isSuccess: true, path: self.parent.downloadUrl.absoluteString, url: self.parent.downloadUrl)
                
                self.parent.callback(downRes)
                
            }
            
        }
        
        @available(iOS 14.5, *)
        public func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        
            DispatchQueue.main.async {
       
                let downRes = DownloadRes(isSuccess: false, path: "", url: URL(fileURLWithPath:""))
                self.parent.callback(downRes)
                
            }
        }
        
           var parent: WebViewTS

           init(_ parent: WebViewTS) {
               self.parent = parent
           }

           // Implement WKNavigationDelegate methods for file upload
           // For example, you can use webView(_:decidePolicyFor:decisionHandler:)
           // to handle file upload requests.
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            if #available(iOS 14.5, *) {
                if navigationAction.shouldPerformDownload {
                    decisionHandler(.download, preferences)
                } else {
                    decisionHandler(.allow, preferences)
                }
            } else {
                // Fallback on earlier versions
            }
        }
       }
    
     
}


private extension WebViewTS {

    func makeWebView() -> WKWebView {
        

        
        let script =    """
                        var script = document.createElement('script');
                        script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=default&#038;ver=1.3.8';
                        script.type = 'text/javascript';
                        document.getElementsByTagName('head')[0].appendChild(script);
                        """
        let userScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)

        let contentController = WKUserContentController()
        contentController.addUserScript(userScript)

        let webViewConfiguration = WKWebViewConfiguration()
        
        webViewConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
//        let preferences = WKWebpagePreferences()
//        if #available(iOS 14.0, *) {
//            preferences.allowsContentJavaScript = true
//        } else {
//            // Fallback on earlier versions
//            preferences.allowsContentJavaScript = true
//        }
//        webViewConfiguration.defaultWebpagePreferences = preferences
        
        webViewConfiguration.userContentController = contentController
        
        
        return WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: 0.1, height: 0.1), configuration: webViewConfiguration)
    }
    
    func makeView(context: Context) -> WKWebView {
        let view = makeWebView()
        viewConfiguration(view)
        setupFilePicker(for: view, context: context)
        setupDownloadHandling(for: view, context: context)
        tryLoad(into: view)
        return view
    }
    
    func tryLoad( into view: WKWebView) {
        
        let url = URL(string: AppConstants.BASE_URL)
        view.loadHTMLString(ideskAppData, baseURL: url)
        
        
    }
        
}

#endif

