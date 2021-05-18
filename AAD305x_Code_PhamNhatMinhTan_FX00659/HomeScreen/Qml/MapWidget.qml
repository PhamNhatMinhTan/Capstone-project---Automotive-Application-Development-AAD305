import QtQuick 2.0
import QtLocation 5.6
import QtPositioning 5.6
MouseArea {
    id: root
    preventStealing: true
    propagateComposedEvents: true
    implicitWidth: 635
    implicitHeight: 570 * scaleHeight
    property bool isFocus: false
    property double scaleHeight: 1080/1200
    Rectangle {
        anchors{
            fill: parent
            margins: 10
        }
        opacity: 0.7
        color: "#111419"
    }
    Item {
        id: map
        x: 10
        y: 10
        width: 615
        height: 550 * scaleHeight
        Plugin {
            id: mapPlugin
            name: "osm" //"mapboxgl" //"osm" // , "esri", ...
        }
        MapQuickItem {
            id: marker
            anchorPoint.x: image.width/4
            anchorPoint.y: image.height
            coordinate: QtPositioning.coordinate(10.042800879135632, 105.77687604134051)
            sourceItem: Image {
                id: image
                source: "qrc:/Img/Map/car_icon.png"
            }
        }
        Map {
            id: mapView
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(10.042800879135632, 105.77687604134051)
            zoomLevel: 14
            copyrightsVisible: false
            enabled: false
            Component.onCompleted: {
                mapView.addMapItem(marker)
            }
        }
    }
    Image {
        id: idBackgroud
        width: root.width
        height: root.height
        source: ""
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: ""
            }
        }
    ]

    onPressed: root.state = "Pressed"
    onReleased:{
        root.focus = true
        root.state = "Focus"
    }
    onFocusChanged: {
        if (root.focus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }
    onIsFocusChanged: {
        if (root.isFocus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }
}
