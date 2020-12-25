//
//  ViewController.swift
//  Gambit
//
//  Created by Муслим Курбанов on 22.12.2020.
//

import UIKit

protocol MenuProtocol: class {
    func applyData(model: [Menu])
    func failure(error: Error)
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var searchResponse = [Menu]() {
        didSet {
            menuTableView.reloadData()
        }
    }
    
    private let cartManager = CartManager.shared
    var presenter: MenuPresenterProtocol!
    var strImage: String?
//    var favoriteImage = #imageLiteral(resourceName: "heart")
    var favoriteImage = #imageLiteral(resourceName: "heart")
    private var id: Int!
    private let favoriteManager = FavoriteManager.shared

    var isLiked: Bool = false {
        didSet {
            toggleProduct()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MenuPresenter(view: self)
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        presenter.addItemCenter(view: view, item: navigationItem)
    }
    // Do any additional setup after loading the view.
}




extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResponse.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        let item = searchResponse[indexPath.row]
        var count = cartManager.getDishCount(by: item.id) ?? 0
        let isLiked = favoriteManager.addToFavoriteProduct(item.id)
        cell.configurate(with: item, delegate: self, isLiked)
        self.isLiked = isLiked
        self.id = item.id
        cell.selectionStyle = .none
        return cell
    }
    func toggleProduct() {
        let imageName = isLiked ? "fillHeart" : "heart"
//        addToFavoriteImage?.setBackgroundImage(UIImage(named: imageName), for: .normal)
        self.favoriteImage = UIImage(named: imageName)!
    }
    
    func handleMarkAsFavorite() {
        print("Add to favorite")

        isLiked ? print("like") : print("dislike")

        let change = favoriteManager.selectFavorite(by: id)
        isLiked = change

    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completion) in
            
//            let item = self?.searchResponse[indexPath.row]
//            let isLiked = self?.favoriteManager.addToFavoriteProduct(item?.id ?? 0)
//            self?.isLiked = isLiked ?? false
//            self?.configurate(with: item!, isLiked: isLiked!)
            
            self?.handleMarkAsFavorite()
            completion(true)
        }
        action.image = favoriteImage
        action.backgroundColor = .none
        return UISwipeActionsConfiguration(actions: [action])

    }
    
}

extension MenuViewController: MenuProtocol {
    func applyData(model: [Menu]) {
        searchResponse.append(contentsOf: model)
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

extension MenuViewController: MenuTableViewCellDelegate {
    func orderAdded(_ order: Menu) {
        guard cartManager.dishesIds.count < 2 else { return }
    }
    
    func orderDeleted(_ order: Menu) {
        guard cartManager.dishesIds.count == 0 else { return }
    }
    
    
}
