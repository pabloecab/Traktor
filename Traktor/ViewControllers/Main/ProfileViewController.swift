//
//  ProfileViewController.swift
//  Traktor
//
//  Created by Pablo on 26/06/2019.
//  Copyright © 2019 Pablo. All rights reserved.
//

import UIKit
import TraktKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let stackView = UIStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TraktManager.sharedManager.getUserProfile { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async { [weak self] in
                    self?.refreshUI(for: user)
                }
            case .error(let error):
                print("Failed to get user profile: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    // MARK: - Actions
    
    private func refreshUI(for user: User) {
        func createLabel(title: String) -> UILabel {
            let label = UILabel()
            label.text = title
            label.numberOfLines = 0
            return label
        }
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(createLabel(title: "Name: \(user.name ?? "Unknown")"))
        stackView.addArrangedSubview(createLabel(title: "Username: \(user.username ?? "Unknown")"))
        stackView.addArrangedSubview(createLabel(title: "Profile is private: \(user.isPrivate)"))
        stackView.addArrangedSubview(createLabel(title: "is VIP: \(user.isVIP ?? false)"))
        stackView.addArrangedSubview(createLabel(title: "About: \(user.about ?? "Unknown")"))
    }
    
    // MARK: Setup
    
    private func setup() {
        self.title = "Profile"
        
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let label = UILabel()
        label.text = "Loading..."
        stackView.addArrangedSubview(label)
    }
}
