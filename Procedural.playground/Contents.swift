//: Playground - noun: a place where people can play

import UIKit
import GameplayKit

class PlanetGenerator {

    //the avaliable palettes
    private static let palettes:[Palette] = [EarthPalette(), MarsPalette()]

    //this function verifies if the point passed is inside of a circle with the center and radius passed in
    private static func isInsideCircle(point:CGPoint, center:CGPoint, radius:CGFloat) -> Bool {
        return pow(point.x - center.x, 2) + pow(point.y - center.y, 2) < pow(radius, 2)
    }
    
    ///here is were the magic happens. The Perlin Noise function is used (its common used for terrains textures, which is the case).
    ///- Properties
    /// - side: the size of the planet in pixels (its a square proportion generated image)
    ///     - Default value: 64
    /// - frequency: The initial value for the frequency property, which determines the number and size of visible features in any given unit area of generated noise.
    ///     - Default value: Double(arc4random_uniform(6) + 1)
    /// - octaves: The initial value for the octaveCount property, which determines the complexity of generated noise.
    ///     - Default value: Int(arc4random_uniform(7) + 4)
    /// - persistence: The initial value for the persistence property, which determines the decrease in amplitude between octaves and thus the roughness of generated noise.
    ///     - Default value: 0.5
    /// - lacunarity: The initial value for the lacunarity property, which determines the increase in frequency between octaves and thus the gradation between coarseness and uniformity in generated noise.
    ///     - Default value: 2.0
    /// - seed: The initial value for the seed property, which determines the overall structure of generated noise.
    ///
    static func generateTexture(side:Int = 64, userPalette:Palette? = nil, frequency:Double = Double(arc4random_uniform(6) + 1), octaves:Int = Int(arc4random_uniform(7) + 4),
                                persistence:Double = 0.5, lacunarity:Double = 2.0, seed:Int32 = Int32(arc4random_uniform(10000))) -> SKTexture {
        let noiseSource = GKPerlinNoiseSource(frequency: frequency, octaveCount: octaves, persistence: persistence, lacunarity: lacunarity, seed: seed)
        let noise = GKNoise(noiseSource)
        let sidef = Float(side)
        let size = CGSize(width: side, height: side)
        let radius = CGFloat(side) / 2
        let center = CGPoint(x: radius, y: radius)
        let palette = userPalette ?? palettes.random!
        var pixels:[Pixel] = []

        for x in 0..<side {
            let xMed = Float(x) / sidef - 0.5 //-.5 to .5
            
            for y in 0..<side {
                //here we verify if the given x,y point is inside of the "planet". If not, we draw a clear pixel (black w/ alpha = 0)
                guard isInsideCircle(point: CGPoint(x: x, y: y), center: center, radius: radius) else {
                    pixels.append(.clear)
                    continue
                }
                
                let yMed = Float(y) / sidef - 0.5 //-.5 to .5
                //here we get the terrain elevation from the generated noise
                let terrainElevation = Float(noise.value(atPosition: vector_float2(xMed, yMed)))
                //here we append the pixel color corresponding to the terrain elevation on a certain pallete
                pixels.append(palette.getTerrainColor(terrainElevation))
            }
        }

        let pixelsData = pixels.withUnsafeBufferPointer { Data(buffer: $0) }
        return SKTexture(data: pixelsData, size: size)
    }

}

//The base palette protocol
protocol Palette {
    func getTerrainColor(_ value:Float) -> Pixel
}

//Palette used to create earth like planets
struct EarthPalette : Palette {

    static let water = Pixel(r: 0, g: 0, b: 255, a: 255)
    static let beach = Pixel(r: 0, g: 153, b: 153, a: 255)
    static let jungle = Pixel(r: 0, g: 204, b: 102, a: 255)
    static let forest = Pixel(r: 0, g: 204, b: 0, a: 255)
    static let savannah = Pixel(r: 204, g: 255, b: 51, a: 255)
    static let desert = Pixel(r: 204, g: 204, b: 0, a: 255)
    static let snow = Pixel(r: 255, g: 255, b: 255, a: 255)

    func getTerrainColor(_ value:Float) -> Pixel {
        switch value {
        case -1.0..<0.0:
            return EarthPalette.water
        case 0.0..<0.15:
            return EarthPalette.beach
        case 0.15..<0.3:
            return EarthPalette.jungle
        case 0.3..<0.6:
            return EarthPalette.forest
        case 0.6..<0.7:
            return EarthPalette.savannah
        case 0.7..<0.9:
            return EarthPalette.desert
        default:
            return EarthPalette.snow
        }
    }

}

//Palette used to create mars like planets
struct MarsPalette : Palette {

    static let sand = Pixel(r: 180, g: 155, b: 99, a: 255)
    static let dirt = Pixel(r: 114, g: 81, b: 48, a: 255)
    static let dryDirt = Pixel(r: 182, g: 115, b: 47, a: 255)
    static let midOrange = Pixel(r: 199, g: 125, b: 78, a: 255)
    static let orange = Pixel(r: 244, g: 138, b: 54, a: 255)

    func getTerrainColor(_ value:Float) -> Pixel {
        switch value {
        case -1.0..<(-0.8):
            return MarsPalette.midOrange
        case -0.8..<0.10:
            return MarsPalette.orange
        case 0.10..<0.35:
            return MarsPalette.dirt
        case 0.35..<0.65:
            return MarsPalette.sand
        default:
            return MarsPalette.dryDirt
        }
    }

}

///The pixel structure. Must be in order r/g/b/a because of the way its bytes are organized in memory and converted to data, i.e., bitmap data.
struct Pixel {
    var r:UInt8
    var g:UInt8
    var b:UInt8
    var a:UInt8

    static let clear = Pixel(r: 0, g: 0, b: 0, a: 0)
}

extension Array {

    //returns a random element of the array
    var random:Element? {
        guard count != 0 else { return nil }
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }

}

let p1 = PlanetGenerator.generateTexture(side: 48)
let p1Image = UIImage(cgImage: p1.cgImage())


