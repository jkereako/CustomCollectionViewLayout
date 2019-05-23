//
//  SpreadsheetViewController.swift
//  SpreadsheetLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

final class SpreadsheetViewController: UICollectionViewController {
    private var viewModel = SpreadsheetCollectionViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let layout = collectionView?.collectionViewLayout as? SpreadsheetLayout else {
            assertionFailure("Expected a SpreadsheetLayout")
            return
        }
        
        collectionView?.dataSource = viewModel
        collectionView?.delegate = viewModel
        layout.delegate = viewModel
        
        let reuseIdentifierMap = [
            SpreadsheetCollectionViewCellReuseIdentifier.header.rawValue: TextCollectionViewCell.self,
            
            SpreadsheetCollectionViewCellReuseIdentifier.content.rawValue: TextCollectionViewCell.self,
            ]
        
        collectionView!.registerNibsWithReuseIdentifierMap(reuseIdentifierMap)
    }
}
