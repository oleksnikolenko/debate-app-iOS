//
//  AuthorizationScreenRouter.swift
//  WhoCooler
//
//  Created by Artem Trubacheev on 04.04.2020.
//  Copyright (c) 2020 Artem Trubacheev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AuthorizationScreenRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AuthorizationScreenDataPassing
{
  var dataStore: AuthorizationScreenDataStore? { get }
}

class AuthorizationScreenRouter: NSObject, AuthorizationScreenRoutingLogic, AuthorizationScreenDataPassing
{
  weak var viewController: AuthorizationScreenViewController?
  var dataStore: AuthorizationScreenDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: AuthorizationScreenViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: AuthorizationScreenDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
