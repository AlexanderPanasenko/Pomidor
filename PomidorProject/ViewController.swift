//
//  ViewController.swift
//  PomidorProject
//
//  Created by MacBook Pro on 25.05.2022.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    private lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.text = "25:00"
        label.font = .systemFont(ofSize: 55)
        label.textColor = UIColor.systemRed
        return label
    }()
    
//    private lazy var startPauseButton: UIButton = {
//        var button = UIButton()
//        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
//        button.tintColor = UIColor.systemRed
//        button.addTarget(self, action: #selector(startPauseButtonAction), for: .touchUpInside)
//        return button
//    }()
    
    let foreProgreessLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    var timer = Timer()
    var isStarted = false
    var isWorkTime = true
    var isAnimationStarted = false
    var time = 10
    
    private lazy var timeAndButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(timeLabel)
//        stackView.addArrangedSubview(startPauseButton)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuphierarhy()
        setupLayout()
        setupView()
//        drawBackLayer()
    }
    
    private func setuphierarhy() {
        view.addSubview(timeLabel)
//        view.addSubview(startPauseButton)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black
    }
    
    private func setupLayout() {
        timeAndButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = timeAndButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = timeAndButtonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = timeAndButtonStackView.widthAnchor.constraint(equalToConstant: 150)
        let heightConstraint = timeAndButtonStackView.heightAnchor.constraint(equalToConstant:150)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
}
