//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Pedro Sánchez Castro on 16/05/2019.
//  Copyright © 2019 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    var savedGifs : [Gif] = []
    let cellMargin: CGFloat = 12.0
    
    
    var gifsFilePath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("/savedGifs")
    }
    
    
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var collectioView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(hex: "#FF4170FF")]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        
        showWelcome()
        
        // Read save data
        do {
            if let loadedGifs = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: gifsFilePath)){
                savedGifs = loadedGifs as! [Gif]
            }
        } catch {
            print("Couldn't read file.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       navigationController?.navigationBar.barTintColor = view.backgroundColor
       navigationController?.navigationBar.isHidden = false
       emptyView.isHidden = (savedGifs.count != 0)
        if (!emptyView.isHidden) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    func showWelcome () {
        if !UserDefaults.standard.bool(forKey: "WelcomeViewSeen") {
            // Reference
            let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController?.pushViewController(welcomeVC, animated: true)
            
        }
    }
    
    // MARK: - CollectionView Delegate and Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = savedGifs [indexPath.item]
        cell.configureForGif(gif: gif)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // Gif Selected
        
        let gif = savedGifs [indexPath.item]
        
        // DetailViewController Reference
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        
        // Gif to GifPreviewVC
        detailVC.gif = gif
        detailVC.delegate = self 
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin * 2.0))/2.0
        return CGSize(width: width, height: width)
    }
    
    
    // MARK: - Unwind Segues
    @IBAction func unwindToSavedGifsViewController(segue:UIStoryboardSegue) {
        
    }

}

// MARK: - Preview Delegate
extension SavedGifsViewController: PreviewViewControllerDelegate {
    func previewViewController(add gif: Gif?) {
        if let gif = gif {
            savedGifs.append(gif)
            let indexPath = IndexPath(row: savedGifs.count - 1, section: 0)
            collectioView.insertItems(at: [indexPath])
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: savedGifs, requiringSecureCoding: false)
                try data.write(to: gifsFilePath)
            } catch {
                print("Couldn't write file")
            }
        }
    }
    
    func previewViewController(edit gif: Gif?, to gif2:Gif?) {
        if let gif = gif, let gif2 = gif2 {
            delete(gif: gif)
            let indexPath = IndexPath(row: savedGifs.count - 1, section: 0)
            savedGifs.insert(gif2, at: indexPath.row)
            collectioView.insertItems(at: [indexPath])
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: savedGifs, requiringSecureCoding: false)
                try data.write(to: gifsFilePath)
            } catch {
                print("Couldn't write file")
            }
        }
        
    }
}

extension SavedGifsViewController: DetailViewControllerDelegate {
    func delete(gif: Gif?) {
        //Find indexpath
        guard let index = savedGifs.firstIndex(where: { $0 == gif })
            else { return }
        //Update model
        savedGifs.remove(at: index)
        //Delete row
        collectioView.deleteItems(at: [IndexPath(item: index, section: 0 )])
    }
}
