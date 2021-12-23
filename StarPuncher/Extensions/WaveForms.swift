import SwiftUI

func triangleWave(_ input: Double) -> Double {
    return (abs((input + Double.pi/2).remainder(dividingBy:Double.pi*2)/Double.pi)-0.5)*2
}

func squareWave(_ input: Double) -> Double  {
    return (input.remainder(dividingBy: Double.pi*2) >= 0) ? 1 : -1
}

func sawWave(_ input: Double) -> Double {
    return input.remainder(dividingBy: Double.pi*2)/(Double.pi*2)*2
}

func noise(_ input: Double) -> Double {
    return Double.random(in: -1...1)
}
func calcRGB(_ index: Int,
              total: Double,
              redWav: (Double)->Double = {_ in 0},
              blueWav: (Double)->Double = {_ in 0},
              greenWav: (Double)->Double = {_ in 0}) -> (Double, Double, Double, Color) {
    calcRGB(Double(index)/Double(total), redWav: redWav, blueWav: blueWav, greenWav: greenWav)
}


func calcRGB(_ delta: Double,
              redWav: (Double)->Double = {_ in 0},
              blueWav: (Double)->Double = {_ in 0},
              greenWav: (Double)->Double = {_ in 0}) -> (Double, Double, Double, Color) {
    let circ = Double.pi*2
    
    let theta = delta*circ
    let red = (redWav(theta))
    let blue = (blueWav(theta))
    let green = (greenWav(theta))
    let color = Color(red: red, green: green, blue: blue, opacity: 1.0)
    
    return (red, blue, green, color)
}
