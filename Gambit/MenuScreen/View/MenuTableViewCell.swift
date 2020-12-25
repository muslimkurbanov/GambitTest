//
//  MenuTableViewCell.swift
//  Gambit
//
//  Created by Муслим Курбанов on 22.12.2020.
//

import UIKit
import SDWebImage

protocol MenuTableViewCellDelegate: class {
    func orderAdded(_ order: Menu)
    func orderDeleted(_ order: Menu)
}

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusOutlet: UIButton!
    
    
    private weak var delegate: MenuTableViewCellDelegate!
    private var cartManager = CartManager.shared
    private var order: Menu?
    
//    var isLiked: Bool = false
        

    func configurate(with model: Menu, delegate: MenuTableViewCellDelegate, _ isLiked: Bool) {
        self.order = model
        self.delegate = delegate

        order?.count = cartManager.getDishCount(by: model.id) ?? 0

//        priceLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 10)
        priceLabel.text = "\(model.price) ₽"
        
        name.font = UIFont(name: "SFProDisplay-Regular", size: 18)
        name.lineBreakMode = .byWordWrapping
        name.text = model.name
        dishImage?.sd_setImage(with: URL(string: model.image ?? ""), completed: nil)
        
        if order?.count ?? 0 > 0 {
            countLabel.text = String(order?.count ?? 0)
            addToCart.isHidden = true
        } else {
            addToCart.isHidden = false
        }
    }
    
    
    @IBAction func plus(_ sender: UIButton) {
        guard let order = self.order else { return }
        
        cartManager.plusDishes(order.id)
        
//        addToCart.isHidden = false
        
        self.order?.count! += 1
        countLabel.text = String(self.order?.count ?? 0)
        delegate.orderAdded(order)
    }
    
    
    @IBAction func minus(_ sender: UIButton) {
        guard let order = self.order else { return }
        
        cartManager.minusDishes(order.id)
        self.order?.count! -= 1
        countLabel.text = String(self.order?.count ?? 0)
        
        if order.count == 1 {
        addToCart.isHidden = false
            minusOutlet.isEnabled = false
        } else {
            
        }
        delegate.orderDeleted(order)
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
        guard let order = self.order else { return }
        
        cartManager.plusDishes(order.id)
        self.order?.count! += 1
        countLabel.text = String(self.order?.count ?? 0)
        
        delegate.orderAdded(order)
        addToCart.isHidden = true
        minusOutlet.isEnabled = true
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
