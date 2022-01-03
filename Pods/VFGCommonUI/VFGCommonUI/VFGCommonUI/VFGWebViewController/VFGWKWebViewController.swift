//
//  VFGWKWebViewController.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 7/4/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils
import WebKit

@objc public protocol VFGWKWebViewDelegate: NSObjectProtocol {
    func webView(_ webview: WKWebView, didFailLoadWithError error: Error?)
    func webView(_ webView: WKWebView, shouldStartLoadWith request: URLRequest,
                 navigationType: WKNavigationType)
    func webViewDidStartLoad(_ webView: WKWebView)
    func webViewDidFinishLoad(_ webView: WKWebView)
}

/**
 Generic View Controller for displaying web contents on a webView
 */
@objc open class VFGWKWebViewController: UIViewController {

    // MARK: - Constants

    static private let storyboardName: String = "VFGWKWebViewController"
    static private let defaultURLString: String = "https://www.Vodafone.com"
    @objc static public let urlEndString: String = "end.html"
    static fileprivate let campaignSuccessEvent: String = "campaign_success"
    static fileprivate let campaignIdKey: String = "campaign_id"
    static fileprivate let campaignEventActionKey: String =  "event_action"
    static fileprivate let campaignEventActionValue: String =  "webview campaign complete"
    static fileprivate let campaignEventCategoryKey: String =  "event_category"
    static fileprivate let campaignEventCategoryValue: String =  "personalisation"
    static fileprivate let campaignEventLabelKey: String =  "event_label"
    static fileprivate let campaignPageNameKey: String =  "page_name"
    static fileprivate let campaignEventPageNameValue: String =  "Campaign Success Page - end.html"
    static fileprivate let campaignEventKey: String =  "event"
    static fileprivate let campaignEventValue: String =  "campaign_complete"
    static fileprivate let campaignVersionKey: String =  "campaign_version"
    static fileprivate let nextPageNameKey: String =  "page_name_next"
    // MARK: - Outlets

    @IBOutlet weak var closeButtonOutlet: UIButton!
    //adding webViewContainer to add on it WKWebView since adding it on storyBoard
    //demands making deployment target more than IOS11
    @IBOutlet weak var webViewContainer: UIView!
    var wkWebView: WKWebView!
    // MARK: - Actions

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - public Variables

    @objc public var campaignId: String?
    @objc public var campaignEventName: String?
    @objc public var campaignVersion: String?

    /**
     The requested URL
     */
    @objc open var url: URL? = URL(string: defaultURLString)

    /*
     a boolean to hide the close button in the top right for dismissing the view, default = true
     */
    @objc open var closeButtonIsHidden: Bool = true

    /**
     The requested URL
     */
    @objc open weak var delegate: VFGWKWebViewDelegate?

    // MARK: - Initialization

    /**
     Initialize View Controller of type 'VFGWKWebViewController'
     
     - Returns: VFGWKWebViewController instance
     */
   @objc static public func viewController() -> VFGWKWebViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.vfgCommonUI)
        guard let webVC = storyboard.instantiateInitialViewController() as? VFGWKWebViewController else {
            return VFGWKWebViewController()
        }
        return webVC
    }

    // MARK: - View Life Cycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadRequest()
    }

    // MARK: - Setup

    private func setupView() {
        wkWebView = WKWebView(frame: CGRect.zero,
                              configuration: WKWebViewConfiguration())
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        wkWebView.scrollView.bounces = false
        webViewContainer.addSubview(wkWebView)
        wkWebView.autoPinEdge(.leading, to: .leading, of: webViewContainer)
        wkWebView.autoPinEdge(.trailing, to: .trailing, of: webViewContainer)
        wkWebView.autoPinEdge(.bottom, to: .bottom, of: webViewContainer)
        wkWebView.autoPinEdge(.top, to: .top, of: webViewContainer)
        closeButtonOutlet.isHidden = closeButtonIsHidden
    }

    // MARK: - Reqeust

    private func loadRequest() {
        guard let url: URL = self.url else { return }
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }

    // MARK: - Network Indicator

    fileprivate func shouldShowNetworkIndicator(show: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = show
        }
    }

    private func extraTagsDec(url: URL) -> [String: String] {
        var trackViewDec: [String: String] =  url.paramsFromQuery()
        if let campaignId = campaignId {
            trackViewDec[VFGWKWebViewController.campaignIdKey] = campaignId
        }
        if let campaignVersion = campaignVersion {
            trackViewDec[VFGWKWebViewController.campaignVersionKey] = campaignVersion
        }
        if let campaignLabelValue = campaignEventName {
            trackViewDec[VFGWKWebViewController.campaignEventLabelKey] = campaignLabelValue
        }
        trackViewDec[VFGWKWebViewController.campaignEventActionKey] = VFGWKWebViewController.campaignEventActionValue
        trackViewDec[VFGWKWebViewController.campaignEventCategoryKey] =
            VFGWKWebViewController.campaignEventCategoryValue
        trackViewDec[VFGWKWebViewController.campaignPageNameKey] = VFGWKWebViewController.campaignEventPageNameValue
        trackViewDec[VFGWKWebViewController.campaignEventKey] = VFGWKWebViewController.campaignEventValue
        trackViewDec[VFGWKWebViewController.nextPageNameKey] = ""
        return trackViewDec
    }
}

// MARK: - WKNavigationDelegate, WKUIDelegate

extension VFGWKWebViewController: WKNavigationDelegate, WKUIDelegate {

    @objc public func webView(_ webView: WKWebView,
                              decidePolicyFor navigationAction: WKNavigationAction,
                              decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        delegate?.webView(webView, shouldStartLoadWith: navigationAction.request,
                          navigationType: navigationAction.navigationType)
    }

    @objc public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        shouldShowNetworkIndicator(show: false)
        delegate?.webView(webView, didFailLoadWithError: error)
    }
    //timeout
    @objc public func webView(_ webView: WKWebView,
                              didFailProvisionalNavigation navigation: WKNavigation!,
                              withError error: Error) {
        shouldShowNetworkIndicator(show: false)
        delegate?.webView(webView, didFailLoadWithError: error)
    }

    @objc public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        shouldShowNetworkIndicator(show: true)
        delegate?.webViewDidStartLoad(webView)
    }

    @objc public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        shouldShowNetworkIndicator(show: false)
        // Send campaign success event
        if let url = webView.url {
            if url.absoluteString.range(of: VFGWKWebViewController.urlEndString ) != nil {
                let trackViewDec = extraTagsDec(url: url)

                VFGAnalytics.trackEvent(VFGWKWebViewController.campaignSuccessEvent, dataSources:
                    trackViewDec)
            }
        }
        delegate?.webViewDidFinishLoad(webView)
    }
}
