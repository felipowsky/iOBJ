//
//  MainViewController.swift
//  iOBJ
//
//  Created by Felipe Augusto Imianowsky on 02/05/17.
//
//

import UIKit
import GLKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var glkView: GLKView!
    
    private var camera: Camera!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGLKView()
        setupGL()
    }
    
    deinit {
        destroyGL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func setupGLKView() {
        glkView.delegate = self
        glkView.context = EAGLContext(api: .openGLES2)
        glkView.drawableColorFormat = .RGBA8888
        glkView.drawableDepthFormat = .format24
        glkView.drawableStencilFormat = .format8
    }
    
    private func setupGL() {
        EAGLContext.setCurrent(glkView.context)
        glEnable(GLbitfield(GL_DEPTH_TEST))
    }
    
    private func setupCamera() {
        let aspect = Float(glkView.bounds.width / glkView.bounds.height)
        let eye: (Float, Float, Float) = (0, 0, 100)
        camera = Camera(fovyDegrees: 60, aspect: aspect, eye: eye)
    }
    
    private func destroyGL() {
        EAGLContext.setCurrent(nil)
    }
}

extension MainViewController: GLKViewDelegate {
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.5, 0.5, 0.5, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glClear(GLbitfield(GL_DEPTH_BUFFER_BIT))
        glClear(GLbitfield(GL_STENCIL_BUFFER_BIT))
    }
}

