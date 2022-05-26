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
        label.font = .systemFont(ofSize: 40)
        label.textColor = UIColor.systemRed
        return label
    }()
    
    private lazy var startPauseButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.tintColor = UIColor.systemRed
        button.addTarget(self, action: #selector(startPauseButtonAction), for: .touchUpInside)
        return button
    }()
    
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
        stackView.addArrangedSubview(startPauseButton)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuphierarhy()
        setupLayout()
        setupView()
        drawBackLayer()
    }
    
    private func setuphierarhy() {
        view.addSubview(timeLabel)
        view.addSubview(startPauseButton)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.black
    }
    
    private func setupLayout() {
        timeAndButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = timeAndButtonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = timeAndButtonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthConstraint = timeAndButtonStackView.widthAnchor.constraint(equalToConstant: 170)
        let heightConstraint = timeAndButtonStackView.heightAnchor.constraint(equalToConstant:170)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 140, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        backProgressLayer.strokeColor = UIColor.systemRed.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 15
        view.layer.addSublayer(backProgressLayer)
    }
    
    func drawForLayer() {
        foreProgreessLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 140, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        foreProgreessLayer.strokeColor = UIColor.white.cgColor
        foreProgreessLayer.fillColor = UIColor.clear.cgColor
        foreProgreessLayer.lineWidth = 15
        view.layer.addSublayer(foreProgreessLayer)
    }
    
    func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    func startAnimation() {
        resetAnimation()
        foreProgreessLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(time)
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgreessLayer.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    
    func resetAnimation() {
        foreProgreessLayer.speed = 1.0
        foreProgreessLayer.timeOffset = 0.0
        foreProgreessLayer.beginTime = 0.0
        foreProgreessLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    func pauseAnimation() {
        let pausedTime = foreProgreessLayer.convertTime(CACurrentMediaTime(), from: nil)
        foreProgreessLayer.speed = 0.0
        foreProgreessLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = foreProgreessLayer.timeOffset
        foreProgreessLayer.speed = 1.0
        foreProgreessLayer.timeOffset = 0.0
        foreProgreessLayer.beginTime = 0.0
        let timeSincePaused = foreProgreessLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgreessLayer.beginTime = timeSincePaused
    }
    
    func stopAnimation() {
        foreProgreessLayer.speed = 1.0
        foreProgreessLayer.timeOffset = 0.0
        foreProgreessLayer.beginTime = 0.0
        foreProgreessLayer.strokeEnd = 0.0
        foreProgreessLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    
    @objc internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }

    @objc private func startPauseButtonAction() {
        if !isStarted{
            drawForLayer()
            startResumeAnimation()
            startTimer()
            isStarted = true
            startPauseButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            timer.invalidate()
            isStarted = false
            pauseAnimation()
            startPauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if time < 1 && isWorkTime {
            startPauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            timer.invalidate()
            time = 5
            isWorkTime = false
            isStarted = false
            timeLabel.text = "05:00"
            timeLabel.textColor = UIColor.systemGreen
            startPauseButton.tintColor = UIColor.systemGreen
            backProgressLayer.strokeColor = UIColor.systemGreen.cgColor
        }else if time < 1 && !isWorkTime {
            startPauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            timer.invalidate()
            time = 15
            isWorkTime = true
            isStarted = false
            timeLabel.text = "25:00"
            timeLabel.textColor = UIColor.systemRed
            startPauseButton.tintColor = UIColor.systemRed
            backProgressLayer.strokeColor = UIColor.systemRed.cgColor
        } else {
            time -= 1
            timeLabel.text = formatTime()
        }
    }
    
    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%1d:%02d:%02d", minutes, second)
    }
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

