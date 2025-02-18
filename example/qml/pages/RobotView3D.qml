import QtQuick
import QtQuick.Controls
import "../controls"
import QtQuick3D
import QtQuick3D.Helpers

View3D {
    id: view3D

    property string model_name: "delta_xs_v5_d600"

    function setModelName(_model_name){
        model_name = _model_name
    }

    environment: sceneEnvironment
    camera: sceneCamera
    importScene: scene

    implicitWidth: 600
    implicitHeight: 600

    SceneEnvironment {
        id: sceneEnvironment
        antialiasingMode: SceneEnvironment.MSAA
        antialiasingQuality: SceneEnvironment.High
    }

    CustomOrbitCameraController {
        anchors.fill: parent
        targetCamera: sceneCamera
    }


    Node {
        id: scene
        DirectionalLight {
            id: directionalLight
            x: 0
            y: -5.928
            brightness: 0.
            z: 1608.12695
            visible: false
        }

        PointLight {
            id: pointLight
            x: -0
            y: -59.06
            quadraticFade: 0.70014
            brightness: 0.3
            z: 30.31681
        }

        PointLight {
            id: pointLight1
            x: -294.956
            y: 255.237
            quadraticFade: 0.70014
            brightness: 0.3
            z: 30.31681
        }

        PointLight {
            id: pointLight2
            x: 222.426
            y: 274.578
            quadraticFade: 0.70014
            brightness: 0.3
            z: 30.31681
        }

        SpotLight {
            id: spotLight
            x: 0
            y: -5.928
            brightness: 25
            z: 1608.12695
        }

        SpotLight {
            id: spotLightTop
            x: 0
            y: 1340.03
            eulerRotation.x: -124
            brightness: 25
            z: -898.37244
        }

        SpotLight {
            id: spotLightBottom
            x: -0.001
            y: -1527.758
            eulerRotation.x: 124
            brightness: 25
            z: -1039.87207
        }

        PerspectiveCamera {
            id: sceneCamera
            x: 0
            y: 0
            pivot.x: 0
            eulerRotation.y: 0
            pivot.z: -1000
            z: 36.76205
        }

        Model {

            id: cubeModel
            x: -353.148
            y: -340.701
            //source: "../mesh/meshes/" + model_name + ".mesh"
            source: "file:///" + applicationDirPath + "/qml/mesh/meshes/" + model_name + ".mesh"

            pivot.x: 0
            eulerRotation.z: 0
            z: -282.17102
            scale.z: 1
            scale.y: 1
            scale.x: 1
            DefaultMaterial {
                id: defaultMaterial_material
            }
            materials: [
                defaultMaterial_material,
                defaultMaterial_material,
                defaultMaterial_material,
                defaultMaterial_material
            ]
            eulerRotation.x: 0
            eulerRotation.y: 0
        }

    }
}
