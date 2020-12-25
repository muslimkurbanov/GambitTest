//
//  MenuPresenter.swift
//  Gambit
//
//  Created by Муслим Курбанов on 22.12.2020.
//

import Foundation

protocol MenuPresenterProtocol: class {
    init(view: MenuProtocol)
    func getMenu()
}

class MenuPresenter: MenuPresenterProtocol {
    
    
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
