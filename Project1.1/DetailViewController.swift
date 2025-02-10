//  DetailViewController.swift
//  Project1.1
//
//  Created by apple on 24.09.2024.
import UIKit
class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalPictures = 0
    var selectedPictureNumber = 0
    
    func updateText (_ totZnach: Int, _ locZnach: Int){
        totalPictures.self = totZnach
        selectedPictureNumber.self = locZnach
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Это рисунок № \(selectedPictureNumber) из \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            //title = "Image № \(selectedImage!) or 4"
        }
    }
    override func viewWillAppear (_ animated: Bool){
        super.viewWillAppear(animated)
        updateText (totalPictures, selectedPictureNumber)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
