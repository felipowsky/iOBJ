//
//  Camera.swift
//  iOBJ
//
//  Created by Felipe Augusto Imianowsky on 07/05/17.
//
//

import Foundation
import GLKit

struct Camera {
    
    private(set) var perspectiveMatrix: GLKMatrix4
    private(set) var lookAtMatrix: GLKMatrix4
    let fovyDegrees: Float
    let aspect: Float
    let limit: (near: Float, far: Float)
    let eye: (x: Float, y: Float, z: Float)
    let center: (x: Float, y: Float, z: Float)
    let up: (x: Float, y: Float, z: Float)
    
    init(fovyDegrees: Float = 60, aspect: Float = 1, limit: (near: Float, far: Float) = (1, -1), eye: (x: Float, y: Float, z: Float) = (0, 0,0), center: (x: Float, y: Float, z: Float) = (0, 0, 0), up: (x: Float, y: Float, z: Float) = (0, 1, 0)) {
        self.fovyDegrees = fovyDegrees
        self.aspect = aspect
        self.limit = limit
        self.eye = eye
        self.center = center
        self.up = up
        self.perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fovyDegrees), aspect, limit.near, limit.far)
        self.lookAtMatrix = GLKMatrix4MakeLookAt(eye.x, eye.y, eye.z, center.x, center.y, center.z, up.x, up.y, up.z)
    }
}
