//
//  CameraNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 06.08.2024.
//

import Foundation
import SceneKit

class CameraNode: SCNNode {
    let eulerA = SCNVector3Make(-CGFloat.pi*0.5, 0, 0)
    var outHeight: CGFloat = 0
    var outX: CGFloat = 0
    var outY: CGFloat = 0
    
    func setHeight(_ height: CGFloat) {
        outHeight = height
        updateCamera()
    }
    
    func setXY(_ x: CGFloat, _ y: CGFloat) {
        outX = -x
        outY = y
        updateCamera()
    }
    
    func updateCamera() {
        self.position = SCNVector3Make(outX, outHeight, outY)
        
        //а=(2;-1;-2)
//        |a|=корень (2^2+(-1)^2+(-2)^2)=3
//        cos aX=2/3; угол aX=48 градусов
//        cos aY=-1/3; угол aX=109,5 градусов
//        cos aZ=-2/3; угол aZ=132 градуса
        //let z = sqrt(outX*outX + outY*outY + outHeight*outHeight)
        
//        let aX = atan(outX/outHeight)
//        let aY = atan(outY/outHeight)
        
//        let aX = acos(-outX/z)
//        let aY = acos(-outY/z)
//        let aZ = acos(-outHeight/z)
//        print("x: \(aX); y: \(aY); z: \(aZ); ")
        
        
//        let p = SCNVector3Make(-5,-5,-5)
//        let angle_H=atan2(p.y,p.x)
//        let angle_P=asin(p.normalized().z)
//        //let
        
        
        //self.eulerAngles = SCNVector3Make(-CGFloat.pi*0.5, aY, aX)
        //self.eulerAngles = SCNVector3Make(aY, aZ, aX + CGFloat.pi*0.5)
        //self.eulerAngles = SCNVector3Make(aZ, aX - CGFloat.pi*0.5, aY + CGFloat.pi*0.5)
        
//        let d = SCNVector3Make(outX, outY, outHeight)
//        
//        let aX = atan2(d.z,d.y)
//        let aY = asin(d.normalized().x)
//        var U = d.rotatedVector(aroundAxis: .y, angle: .pi/2) //y
//        U = U / U.length()
//        let w0 = SCNVector3Make(d.z,d.y,0) //x->y //( -YD, XD, 0 )
//        let D = d / d.length()
//        let u0 = w0 * D
//        
//        let aZ = atan2( w0.dot(U) / w0.length(), u0.dot(U) / u0.length() )
//        
//        self.eulerAngles = SCNVector3Make(aX + CGFloat.pi, aY, -aZ)
    }
}
