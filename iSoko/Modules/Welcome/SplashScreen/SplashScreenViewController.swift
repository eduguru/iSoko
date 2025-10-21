//
//  SplashScreenViewController.swift
//  
//
//  Created by Edwin Weru on 21/10/2025.
//

import UIKit
import Lottie

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Optional: set background color
        
        addLottieAnimation(named: "logo-lottie-01") // Replace with your JSON filename
    }

    private func addLottieAnimation(named name: String) {
        let animationView = LottieAnimationView(name: name)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        view.addSubview(animationView)

        // Center the animation view
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
