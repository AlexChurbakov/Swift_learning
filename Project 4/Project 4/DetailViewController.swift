import UIKit
class DetailViewController: UIViewController {
    
    @IBOutlet var myImage: UIImageView!
    
    
    var selectedImage: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedImage
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            myImage.image = UIImage(named: imageToLoad)
            //title = "Image № \(selectedImage!) or 4"
        }
    }
    override func viewWillAppear (_ animated: Bool){
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
