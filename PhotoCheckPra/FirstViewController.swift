//
//  FirstViewController.swift
//  PhotoCheckPra
//
//  Created by armong on 7/19/2560 BE.
//  Copyright © 2560 Natthakit Srikanjanapert. All rights reserved.
//

import UIKit
import SideMenu
import FacebookCore
import FacebookLogin

import Firebase
import FirebaseAuth
import GoogleSignIn

class FirstViewController: UIViewController {
    
    @IBOutlet weak var btnGoogle: GIDSignInButton!
    
    
    var loginManager: LoginManager!
    var fbToken: String!
    var fbUserID: String!
    var fbEmail: String!
    var fbName: String!
    var fbPhoto: String!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
//        UIScreenEdgePanGestureRecognizer
        for item in (self.navigationController?.view.subviews)!
        {
            print(item)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginManager = LoginManager()
        
        //SideMenuManager.menuLeftNavigationController = nil

        //self.view.reloadInputViews()
       
        // Do any additional setup after loading the view.
        //ScreenEdgePanGestures
        
        if let recognizers = self.view.gestureRecognizers {
            for gesture in recognizers {
                // This check for UIPanGestureRecognizer but you can check for the one you need
                if let gRecognizer = gesture as? UIPanGestureRecognizer {
                    print("Gesture recognizer found")
                    self.view.removeGestureRecognizer(gRecognizer)
                }
            }
        }

        
        
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        btnGoogle.style = .wide
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if AccessToken.current != nil
        {
            loginAsyncFB()
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   // MARK: - Login Facebook
    @IBAction func facebook_auth(_ sender: Any) {
    

        login(target: self)
    }
    
    func login(target: UIViewController)
    {
        let readPermission = [ReadPermission.publicProfile, ReadPermission.email]
        loginManager.logIn(readPermission, viewController: target) { (result) in
            self.loginManagerDidComplete(result)
        }
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        switch result {
        case .cancelled:
            print("User cancelled login.")
        case .failed(let error):
            print("Login failed with error \(error)")
        case .success(_, _, let accessToken):
            fbToken = accessToken.authenticationToken
            UserDefaults.standard.set(fbToken, forKey: "fbToken")
            fbUserID = accessToken.userId
            fbPhoto = "https://graph.facebook.com/\(accessToken.userId!)/picture?type=normal"
            return
        }
    }
    
    
    
    func loginAsyncFB()
    {
        if let authenticationToken = AccessToken.current?.authenticationToken
        {
            let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
            self.signInWithCredential(credential)
        }
    }
    
    func signInWithCredential(_ credential: AuthCredential)
    {
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let er = error {
                
                print(er)
                
                return
            }
            
            if let user = Auth.auth().currentUser
            {
                //let name = user.displayName
                //let email = self.gAppDelegate.facebookCore.fbEmail //user.email
                //let photoUrl = user.photoURL
                let uid = user.uid;  // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with
                // your backend server, if you have one. Use
                // getTokenWithCompletion:completion: instead.
                
                // ทำต่อตรงนี้
                self.userLogin(self)
            }
        }
    }
    
    
    
    @IBAction func google_auth(_ sender: Any) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoogleAuth") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func unwindToDestinationViewController (sender: UIStoryboardSegue){
        print("back")
    }
    
    
    @IBAction func adminLogin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AdminManager") as! CheckerManageViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func checkerLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CheckerManager") as! PhotoStockViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func userLogin(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserManager") as! PhotoSenderViewController
        self.navigationController?.pushViewController(vc, animated: true)
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

//MARK:- GIDSignInUIDelegate
extension FirstViewController: GIDSignInUIDelegate, GIDSignInDelegate
{
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("Nothing!")
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let user = Auth.auth().currentUser {
                let name = user.displayName
                let email = user.email
                let photoUrl = user.photoURL
                let uid = user.uid;  // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with
                // your backend server, if you have one. Use
                // getTokenWithCompletion:completion: instead.
                
                // ทำต่อตรงนี้
                self.userLogin(self)
                
                
            } else {
                // No user is signed in.
            }
        }
        
        
        if (signIn.hasAuthInKeychain()) {
            NSLog("Signed in");
        } else {
            NSLog("Not signed in");
        }
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
}

