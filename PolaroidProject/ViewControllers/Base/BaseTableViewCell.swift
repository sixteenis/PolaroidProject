//
//  BaseTableViewCell.swift
//  MeaningOutProject
//
//  Created by 박성민 on 7/8/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpHierarchy()
        setUpLayout()
        setUpView()
    }
    func setUpHierarchy() {}
    
    func setUpLayout() {}
    
    func setUpView() {}
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
