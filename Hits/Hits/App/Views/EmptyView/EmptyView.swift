//
//  EmptyView.swift
//  Hits
//
//  Created by Romain Le Drogo on 08/10/2023.
//

import UIKit

protocol EmptyViewDelegate: AnyObject {
    func actionButtonDidTouchedUp()
}

final class EmptyView: UIView {
    
    // MARK: IBOutlet
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    private var delegate: EmptyViewDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        self.actionButton.layer.cornerRadius = 10
    }
    
    func setup(delegate: EmptyViewDelegate) {
        self.delegate = delegate
    }

    // MARK: IBAction
    @IBAction func actionButtonDidTouchedUp(_ sender: Any) {
        self.delegate?.actionButtonDidTouchedUp()
    }
    
    static var instanceFromNib: EmptyView {
        return UINib(nibName: "EmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EmptyView
    }
    
}
