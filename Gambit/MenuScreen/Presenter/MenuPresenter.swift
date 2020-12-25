//
//  MenuPresenter.swift
//  Gambit
//
//  Created by Муслим Курбанов on 22.12.2020.
//

import Foundation
import UIKit

protocol MenuPresenterProtocol: class {
    init(view: MenuProtocol)
    func getMenu()
    func addItemCenter(view: UIView, item: UINavigationItem)
}

class MenuPresenter: MenuPresenterProtocol {
    var menuView = UIView()
    var navigationItem = UINavigationItem()

    func addItemCenter(view: UIView, item: UINavigationItem) {
        let image = #imageLiteral(resourceName: "gambit")
        let imageView = UIImageView()
        self.menuView = view
        self.navigationItem = item
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 19).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.07058823529, blue: 0.5607843137, alpha: 1)
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.07058823529, blue: 0.5607843137, alpha: 1)
        }
    }
    
    
    
    private weak var view: MenuProtocol?
    private let networkService: NetworkServiceProtocol = NetworkService()
    private var searchResponce: [Menu]? = nil
    private var id: Int!
    var imageTest: String?
    private let favoriteManager = FavoriteManager.shared

    required init(view: MenuProtocol) {
        self.view = view
        self.getMenu()
    }
    
    func getMenu() {
        networkService.getMenu { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let searchResponce):
                    
                    self.searchResponce = searchResponce
                    self.view?.applyData(model: searchResponce!)
                    
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    
}
