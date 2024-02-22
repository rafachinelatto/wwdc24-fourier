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




