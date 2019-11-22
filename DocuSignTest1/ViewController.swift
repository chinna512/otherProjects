//
//  ViewController.swift
//  DocuSignTest1
//
//  Created by chinnababu kamanuri on 18/06/17.
//  Copyright © 2017 chinnababu kamanuri. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {

    let integartionKey = "f561bf41-197b-4f98-aaac-e33c37989845"
    let DS_AUTH_HEADER = "X-DocuSign-Authentication"
    let BaseUrl = "https://demo.docusign.net/restapi";
    var urlToLoad = ""
    var clientUserId = ""
    var documentId = ""
    var envelopmentId = ""
    var authString = ""
    var webview:UIWebView?
    var fileToLoad:NSURL?




//    struct Constants {
//        static let DS_AUTH:NSMutableString = NSMutableString()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
              // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

override    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
//    let obj = TestViewController1()
//    obj.customView = UIView(frame: self.view.frame)
//    obj.embeddedSending();
//    self.view.addSubview(obj.customView)
    embeddedSending()
    }

    func embeddedSending(){

        let userName = "chinnababu.2k14@gmail.com";
        let pasword = "Chinna@512"
        let recipientName = "chinnababu kamanuri"
        let recipientEmail = "maachinnaa@gmail.com"

        let path = Bundle.main.path(forResource: "Test", ofType: "pdf")

      let  DS_AUTH = String(format: "{\"Username\":\"%@\",\"Password\":\"%@\",\"IntegratorKey\":\"%@\",\"clientUserId\":\"%@\"}",  userName, pasword, integartionKey,"1001")

        let sharedCnfig = DSConfiguration.sharedConfig
        sharedCnfig().host = BaseUrl
        let authApi = DSAuthenticationApi()
        authApi.addHeader(DS_AUTH, forKey: DS_AUTH_HEADER)

        authApi.login(completionBlock: {(output ,error) -> Void in
            if ((error) != nil) {
                print(error)
            }
            if (output != nil) {
                NSLog("response can't be nil");
            }
            let loginAccounts =  output?.loginAccounts as? NSArray
            let loginAccount = loginAccounts?.object(at: 0) as! DSLoginAccount

            let accountId = loginAccount.accountId
            let envDef = DSEnvelopeDefinition()
            envDef.emailSubject = "Please sign this doc"
            envDef.emailBlurb = "Hello, Please sign my  Envelope";

            let doc = DSDocument();
            doc.name = "Test.pdf";  // does not have to be same as actual file name
            doc.documentId = "1";

            let myData = NSData(contentsOfFile: path!)
            doc.documentBase64 = myData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            envDef.documents = NSArray(object: doc) as! [Any];//NSArray(object: doc) as! [Any]

            let signer = DSSigner();
            signer.email = recipientEmail;
            signer.name = recipientName;
            signer.recipientId = "1";
            signer.userId = "1001";
            signer.clientUserId = "1001";


             let signHere = DSSignHere()
                        signHere.documentId = "1";
                        signHere.pageNumber = "1";
                        signHere.recipientId = "1";
                        signHere.xPosition = "100";
                        signHere.yPosition = "100";

            signer.tabs = DSTabs()
            signer.tabs.signHereTabs =  NSArray(object: signHere) as! [Any]
            let recipient = DSRecipients()

            let signers:NSMutableArray = []
            signers.add(signer)
            recipient.signers = signers as! [DSSigner];
            envDef.recipients = recipient;
            envDef.status = "sent";

            let envelopesApi = DSEnvelopesApi()
            envelopesApi.addHeader(DS_AUTH, forKey: self.DS_AUTH_HEADER)

            envelopesApi.createEnvelope(withCompletionBlock: accountId,  envelopeDefinition: envDef, completionHandler: {
                (output, error) -> Void in

                if ((error) != nil) {
                    print(error)
                }
                if (!(output != nil)) {
                    print(output)
                }
               let envelopeId = output?.envelopeId;

                let returnViewRequest = DSRecipientViewRequest()
                returnViewRequest.returnUrl = "https://www.docusign.com/devcenter"
                returnViewRequest.userName = recipientName;
                returnViewRequest.email = recipientEmail;
                returnViewRequest.recipientId = "1";
                returnViewRequest.clientUserId = "1001";
                returnViewRequest.authenticationMethod = "email"

                envelopesApi.createRecipientView(withAccountId: loginAccount.accountId!, envelopeId: envelopeId, recipientViewRequest: returnViewRequest, completionHandler: {
                    (output,error) -> Void in

                    if ((error) != nil) {
                        print(error)
                    }
                    if ((output) != nil) {

                        self.urlToLoad = (output?.url)!;
                        self.clientUserId = "1001";
                        self.documentId = "1";
                        self.envelopmentId =  envelopeId!;
                        self.authString  = DS_AUTH;
                        self.loadWebView();
                       // [self, loadWebView];
                    }

                })
            })
          })
    }

    func loadWebView(){
        self.webview = UIWebView();
        self.webview?.delegate = self;
        self.webview?.frame = self.view.frame;
        let url = NSURL(string: urlToLoad)
        let req = NSMutableURLRequest(url: url! as URL)
        webview?.loadRequest(req as URLRequest)
        self.view.addSubview(webview!)
    }

    func loadWebView1(){
        self.webview = UIWebView();
        self.webview?.delegate = self;
        self.webview?.frame = self.view.frame;

        let url = self.fileToLoad
        let req = NSMutableURLRequest(url: url! as URL)
        webview?.loadRequest(req as URLRequest)
        self.view.addSubview(webview!)
    }


    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        let url = request.url
        let absoluteStrng = url?.absoluteString;
        if(absoluteStrng == "https://b.company-target.com/ect.html"){
            self.webview?.removeFromSuperview();
            getEnvelopeDocuments()
        }
        return true
    }

    func getEnvelopeDocuments(){
         let userName = "chinnababu.2k14@gmail.com";
        let pasword = "Chinna@512"
        let envelopeId = self.envelopmentId
        let documentId = self.documentId



        let sharedCnfig = DSConfiguration.sharedConfig
        sharedCnfig().host = BaseUrl
        let authApi = DSAuthenticationApi()

        authApi.addHeader(authString, forKey: DS_AUTH_HEADER)

        authApi.login(completionBlock: {(output ,error) -> Void in
            if ((error) != nil) {
                print(error)
            }
            if (output != nil) {
                NSLog("response can't be nil");
            }
            let loginAccounts =  output?.loginAccounts as? NSArray
            let loginAccount = loginAccounts?.object(at: 0) as! DSLoginAccount

            let accountId = loginAccount.accountId

            let envelopesApi = DSEnvelopesApi()
            envelopesApi.addHeader(self.authString, forKey: self.DS_AUTH_HEADER)

            envelopesApi.getDocumentWithAccountId(loginAccount.accountId, envelopeId: self.envelopmentId, documentId: documentId, completionHandler: {
                (output,error) -> Void in
                if ((error) != nil) {
                    print(error);
                }
                if ((output) != nil) {
                    self.fileToLoad = output as! NSURL;
                    self.loadWebView1()

                }

            })
        })



        // Enter valid envelope ID from your account
        // The documentId is property is client defined at time of envelope creation (see first recipe)

        // create authentication JSON string and header
        //    NSString *const DS_AUTH = [NSMutableString stringWithFormat:@"{\"Username\":\"%@\",\"Password\":\"%@\",\"IntegratorKey\":\"%@\"}", username, password, IntegratorKey];

        ///////////////////////////////////////////////////////////////////////////////
        // STEP 1: Login API
        ///////////////////////////////////////////////////////////////////////////////

        // instantiate api client, configure environment URL and assign auth data

    }
}

