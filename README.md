# ProceduralPlanetGenerator
A procedural planet generator fully written in swift 4.
------------------

This procedural planet generator uses a Perlin Noise to create map textures in 2d planets.

## Usage
A simple example of the generation of a Planet with a diameter of 48px and an image size of 48x48px. It can be a earth like planet or a mars like planet.
```swift
    let p1 = PlanetGenerator.generateTexture(side: 48)
```
![Generated planet](https://raw.githubusercontent.com/gbrvalerio/ProceduralPlanetGenerator/master/example.png)

## Customization
If you want to, the color palettes are very customizable. You can easily create your own or change the existing ones.
```swift
struct EarthPalette : Palette {

    static let water = Pixel(r: 0, g: 0, b: 255, a: 255)
    static let beach = Pixel(r: 0, g: 153, b: 153, a: 255)
    static let jungle = Pixel(r: 0, g: 204, b: 102, a: 255)
    static let forest = Pixel(r: 0, g: 204, b: 0, a: 255)
    static let savannah = Pixel(r: 204, g: 255, b: 51, a: 255)
    static let desert = Pixel(r: 204, g: 204, b: 0, a: 255)
    static let snow = Pixel(r: 255, g: 255, b: 255, a: 255)

    //The value belongs to the interval [-1.0, 1.0]
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

//Generates a 32x32 earth like planet texture.
let earthLikePlanetTexture = PlanetGenerator.generateTexture(side: 32, userPalette: EarthPalette())
```

## Considerations
#### Yes, I know, the Playground is slow
When running the code on a non-playground project, it runs muuuuuuuch faster. Do not worry!

The Perlin noise is a very good noise for creating terrains textures but its not the most recommended actually. OpenSimplex is based on Perlin noise and has a faster processing. If you want to, you should check it out, I strogly recommend that.

If you wants the Data (bitmap format) object instead of a SKTexture as return of the function ```generateTexture``` this simple two-line change at the end of the function will solve your problem:
from:
```swift
    { ...
        let pixelsData = pixels.withUnsafeBufferPointer { Data(buffer: $0) }
        return SKTexture(data: pixelsData, size: size)
    }
```
to:
```swift
    { ...
        return pixels.withUnsafeBufferPointer { Data(buffer: $0) }
    }
```

Also, mixing other noises like Voronoi noise can create a very nice effect! Try it!

## Contact
I'm very open to critics and suggestions! My email is gbrvalerio@gmail.com and you can feel free to contact me if you want to 😁.
