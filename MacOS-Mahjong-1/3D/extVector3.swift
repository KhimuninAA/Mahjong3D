//
//  extVector3.swift
//  Mahjong
//
//  Created by Алексей Химунин on 06.08.2024.
//

import Foundation
import SceneKit

extension SCNVector3 {
    enum Axis {
        case x, y, z
        
        func getAxisVector() -> simd_float3 {
            switch self {
            case .x:
                return simd_float3(1,0,0)
            case .y:
                return simd_float3(0,1,0)
            case .z:
                return simd_float3(0,0,1)
            }
        }
    }

    func rotatedVector(aroundAxis: Axis, angle: Float) -> SCNVector3 {
        /// create quaternion with angle in radians and your axis
        let q = simd_quatf(angle: angle, axis: aroundAxis.getAxisVector())
        
        /// use ACT method of quaternion
        let simdVector = q.act(simd_float3(self))
        
        return SCNVector3(simdVector)
    }
    
    func length() -> CGFloat {
        return sqrt(x*x + y*y + z*z)
    }
    
    func normalized() -> SCNVector3 {
        if self.length() == 0 {
            return self
        }
        return self / self.length()
    }
    
    func dot(_ vec: SCNVector3) -> CGFloat {
        return (self.x * vec.x) + (self.y * vec.y) + (self.z * vec.z)
    }
}

func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
}

func / (vector: SCNVector3, scalar: CGFloat) -> SCNVector3 {
    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
}

func *(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}
