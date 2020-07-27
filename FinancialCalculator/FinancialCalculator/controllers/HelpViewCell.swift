//
//  MCDropCell.swift
//  FinancialCalculator
//
//  Created by Shenali Samaranayake on 3/10/20.
//  Copyright © 2020 Shenali Samaranayake. All rights reserved.
//

import UIKit

class HelpViewCell : UITableViewCell {
    var data: HelpViewCellData? {
           didSet {
               guard let data = data else { return }
               self.title.text = data.title
               self.content.text = data.content
           }
       }
       
       func animate() {
           UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
               self.contentView.layoutIfNeeded()
           })
       }
       
       fileprivate let title: UILabel = {
           let titleLabel = UILabel()
           titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
           titleLabel.text = "title"
           titleLabel.textColor = .systemOrange
           titleLabel.textAlignment = .center
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           return titleLabel
       }()
       
       
       fileprivate let content: UILabel = {
           let infoLabel = UILabel()
           infoLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
           infoLabel.text = "Info"
           infoLabel.textColor = .white
           infoLabel.numberOfLines = -1
           infoLabel.translatesAutoresizingMaskIntoConstraints = false
           return infoLabel
       }()
       
       fileprivate let containerView: UIView = {
          let containerView = UIView()
           containerView.translatesAutoresizingMaskIntoConstraints = false
           containerView.clipsToBounds = true
           containerView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
           containerView.layer.cornerRadius = 10
           return containerView
       }()
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           contentView.addSubview(containerView)
           containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
           containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
           containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
           containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
           
           containerView.addSubview(title)
           containerView.addSubview(content)
           
           title.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
           title.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4).isActive = true
           title.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4).isActive = true
           title.heightAnchor.constraint(equalToConstant: 60).isActive = true
           
           content.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
           content.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
           content.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
           content.heightAnchor.constraint(equalToConstant: 180).isActive = true
           
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) is not implemented")
       }
    }

