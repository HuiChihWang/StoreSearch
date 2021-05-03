//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Hui Chih Wang on 2021/5/3.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.layer.borderWidth = 2
        }
    }
    
    lazy var search = SearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let gridView = createGridView(with: Array(0..<10), buttonSize: CGSize(width: 80, height: 80), buttonSpacing: CGSize(width: 7, height: 7))
        gridView.backgroundColor = .red
        
        view.addSubview(gridView)
        
    }
    
    private func createGridView(with results: [Any], buttonSize: CGSize, buttonSpacing: CGSize) -> UIView {
        
        let gridView = UIView(frame: view.frame)
        
        let Nh = floor((gridView.frame.width + buttonSpacing.width) / (buttonSize.width + buttonSpacing.width))
        
        let Nv = ceil(CGFloat(results.count) / Nh)
        
        let height = buttonSize.height * Nv + (Nv - 1) * buttonSpacing.height
        
        gridView.frame.size.height = height
        
        for (index, result) in (0..<10).enumerated() {
            let button = UIButton()
            button.backgroundColor = .white
            button.setTitle("\(index)", for: .normal)
            button.frame = CGRect(origin: gridView.frame.origin, size: buttonSize)
            
            let rowIndex = index / Int(Nv)
            let colIndex = index % Int(Nh)
            button.frame.origin.x += CGFloat(colIndex) * (buttonSize.width + buttonSpacing.width)
            button.frame.origin.y += CGFloat(rowIndex) * (buttonSize.height + buttonSpacing.height)
            
            gridView.addSubview(button)
        }
        
        return gridView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
