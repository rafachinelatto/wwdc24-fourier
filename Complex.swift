//
//  Complex.swift
//  wwdc
//
//  Created by Rafael Antonio Chinelatto on 17/01/24.
//

import Foundation

struct Complex {
    
    var re: Double
    var im: Double
    
    var freq: Int =  0
    
    var mod: Double {
        sqrt((re * re) + (im * im))
    }
    
    var phase: Double {
        atan2(im, re)
    }
}

extension Complex {
    static func +(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(re: (lhs.re + rhs.re), im: (lhs.im + rhs.im), freq: lhs.freq)
    }
    
    static func -(lhs: Complex, rhs: Complex) -> Complex {
        return Complex(re: (lhs.re - rhs.re), im: (lhs.im - rhs.im), freq: lhs.freq)
    }
    
    static func *(lhs: Complex, rhs: Complex) -> Complex {
        let real = (lhs.re * rhs.re) - (lhs.im * rhs.im)
        let imaginary = (lhs.im * rhs.re) + (lhs.re * rhs.im)
        return Complex(re: real, im: imaginary, freq: lhs.freq)
    }
}

func DFT(_ x:[Complex]) -> [Complex] {
    
    var X = [Complex]()
    let N = x.count
    
    for k in 0..<N {
        var Xk = Complex(re: 0, im: 0, freq: k)
        
        for n in 0..<N {
            let aux = Complex(re: cos((2*Double.pi*Double(k*n))/Double(N)), im: -sin((2*Double.pi*Double(k*n))/Double(N)))
            
            Xk = Xk + (x[n] * aux)
        }
        
        Xk = Xk * Complex(re: 1/Double(N), im: 0)
        X.append(Xk)
    }
    
    let XSorted = X.sorted{ $0.mod > $1.mod }
    return XSorted
}


