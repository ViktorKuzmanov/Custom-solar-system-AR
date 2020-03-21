import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    var pointOfView: SCNVector3 {
        guard let pointOfView = sceneView.pointOfView else { return SCNVector3(0, 0, 0) }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        return currentPositionOfCamera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // track device posistion and orientation at all times
        sceneView.session.run(configuration)
//        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        registerGestureRecognizers()
    }
    
    @IBAction func addPlanetTapped(_ sender: UIButton) {
        self.addTapticFeedback()
        let venus = UIAlertAction(title: "Venus", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "Venus Surface"))
        }
        let Mercury = UIAlertAction(title: "Mercury", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "2k_mercury"))
        }
        let jupiter = UIAlertAction(title: "Jupiter", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.41), diffuse: #imageLiteral(resourceName: "jupiter"))
        }
        let mars = UIAlertAction(title: "Mars", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "2k_mars"))
        }
        let saturn = UIAlertAction(title: "Saturn", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "2k_saturn"))
        }
        let uranus = UIAlertAction(title: "Uranus", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "Earth Normal"))
        }
        let neptune = UIAlertAction(title: "Neptune", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "2k_neptune"))
        }
        let earth = UIAlertAction(title: "Earth", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "Earth day"), specular: #imageLiteral(resourceName: "Earth Specular"), emission: #imageLiteral(resourceName: "2k_earth_clouds"))
        }
        let sun = UIAlertAction(title: "Sun", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "2k_sun"))
        }
        let makemake = UIAlertAction(title: "MakeMake", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: #imageLiteral(resourceName: "2k_makemake_fictional"))
        }
        let ceres = UIAlertAction(title: "Ceres", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: UIImage(named: "ceres")!)
        }
        let haumea = UIAlertAction(title: "Haumea", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: UIImage(named: "haumea")!)
        }
        let moon = UIAlertAction(title: "Moon", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: UIImage(named: "haumea")!)
        }
        let eris = UIAlertAction(title: "Eris", style: .default) { (action) in
            self.planet(geometry: SCNSphere(radius: 0.35), diffuse: UIImage(named: "eris")!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.showActionSheet(on: self, style: .actionSheet, title: "nez", message: "message", actions: [venus, Mercury,earth, jupiter, mars, saturn, uranus, neptune, moon, haumea, ceres, makemake, sun, cancel], completion: nil)
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.position = pointOfView
        let rotateForeverAction = Rotation(time: 8)
        planet.runAction(rotateForeverAction)
        sceneView.scene.rootNode.addChildNode(planet)
        return planet
        
    }
    
    func addTapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.position = self.pointOfView
        let rotateForeverAction = Rotation(time: 8)
        planet.runAction(rotateForeverAction)
        sceneView.scene.rootNode.addChildNode(planet)
        return planet
        
    }
    
    func Rotation(time: TimeInterval) -> SCNAction {
        let Rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(Rotation)
        return foreverRotation
    }
    
    
    
    func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotate))
        longPressGestureRecognizer.minimumPressDuration = 0.1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.addGestureRecognizer(longPressGestureRecognizer)
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            if let results = hitTest.first {
                let node = results.node
                let confetti = SCNParticleSystem(named: "Conffeti.scnp", inDirectory: nil)
                confetti?.loops = false
                confetti?.emitterShape = node.geometry
                let conffetiNode = SCNNode()
                conffetiNode.addParticleSystem(confetti!)
                conffetiNode.position = node.position
                sceneView.scene.rootNode.addChildNode(conffetiNode)
                node.removeFromParentNode()
            }
        }
    }
    
//    find . -path ./Pods -prune -o -name '*.swift' -print0 ! -name '/Pods' | xargs -0 wc -l
    
    @objc func rotate(sender: UILongPressGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let holdLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(holdLocation)
        if !hitTest.isEmpty {
            
            let result = hitTest.first!
            if sender.state == .began {
                let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 1)
                let forever = SCNAction.repeatForever(rotation)
                result.node.runAction(forever)
            } else if sender.state == .ended {
                result.node.removeAllActions()
            }
            // TUKA
            result.node.runAction(Rotation(time: 8))
        }
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let pinchLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(pinchLocation)
        
        if !hitTest.isEmpty {
            
            let results = hitTest.first!
            let node = results.node
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            print(sender.scale)
            node.runAction(pinchAction)
            sender.scale = 1.0
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 100 }
}

