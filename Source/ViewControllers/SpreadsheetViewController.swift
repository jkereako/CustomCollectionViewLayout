//
//  SpreadsheetViewController.swift
//  SpreadsheetLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit

final class SpreadsheetViewController: UIViewController {
    private var dataSource = SpreadsheetCollectionViewDataSource()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let layout = collectionView.collectionViewLayout as? SpreadsheetLayout else {
            assertionFailure("Expected a SpreadsheetLayout")
            return
        }
        
        collectionView!.dataSource = dataSource
        layout.delegate = self
        
        let reuseIdentifierMap = [
            SpreadsheetCollectionViewCellReuseIdentifier.header.rawValue: TextCollectionViewCell.self,
            
            SpreadsheetCollectionViewCellReuseIdentifier.content.rawValue: TextCollectionViewCell.self,
            ]
        
        collectionView!.registerNibsWithReuseIdentifierMap(reuseIdentifierMap)
    }
}

// MARK: - SpreadsheetLayoutDelegate
extension SpreadsheetViewController: SpreadsheetLayoutDelegate {
    func width(forColumn column: Int, collectionView: UICollectionView) -> CGFloat {
        return 100
    }
    
    func height(forRow row: Int, collectionView: UICollectionView) -> CGFloat {
        return 75
    }
}

