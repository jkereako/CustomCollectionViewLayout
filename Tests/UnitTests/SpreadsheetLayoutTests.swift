//
//  SpreadsheetLayoutTests.swift
//  SpreadsheetLayoutTests
//
//  Created by Jeff Kereakoglow on 8/8/16.
//  Copyright © 2016 brightec. All rights reserved.
//

import XCTest
@testable import SpreadsheetLayout

final class SpreadsheetLayoutTests: XCTestCase {
  private enum Identifier: String {
    case Storyboard = "Main"
    case ViewController = "spreadsheet"
  }
  
  private var storyboard: UIStoryboard!
  private var sut: SpreadsheetViewController!
  
  override func setUp() {
    super.setUp()
    
    storyboard = UIStoryboard(name: Identifier.Storyboard.rawValue, bundle: Bundle.main)
    sut = storyboard.instantiateViewController(withIdentifier: Identifier.ViewController.rawValue) as!
    SpreadsheetViewController
    
    // This line gurantees that the initial view controller is the SpreadsheetViewController
    UIApplication.shared.keyWindow!.rootViewController = sut
  }
  
  override func tearDown() {
    storyboard = nil
    sut = nil
    UIApplication.shared.keyWindow!.rootViewController = nil
    
    super.tearDown()
  }
  
  func testStoryboardIsNotNil() {
    XCTAssertNotNil(
        UIStoryboard(name: Identifier.Storyboard.rawValue, bundle: Bundle.main)
    )
  }
  
  func testViewControllerIsNotNil() {
    let storyboard = UIStoryboard(
        name: Identifier.Storyboard.rawValue, bundle: Bundle.main
    )
    
    let viewController = storyboard.instantiateViewController(
        withIdentifier: Identifier.ViewController.rawValue
      ) as! SpreadsheetViewController
    
    XCTAssertNotNil(viewController)
  }}
