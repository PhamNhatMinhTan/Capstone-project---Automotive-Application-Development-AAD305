import QtQuick 2.0

MouseArea {
    id: root
    implicitWidth: 316
    implicitHeight: 526 * scaleHeight
    property string icon
    property string title
    property bool isFocus: false
    property double scaleHeight: 1080/1200
    Image {
        id: idBackgroud
        width: root.width
        height: root.height
        source: icon + "_n.png"
    }
    Text {
        id: appTitle
        anchors.horizontalCenter: parent.horizontalCenter
        y: 350 * scaleHeight
        text: title
        font.pixelSize: 36
        color: "white"
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_n.png"
            }
        }
    ]

    onPressed: root.state = "Pressed"
    onReleased: {
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
    onPositionChanged: {
        root.state = "Pressed"
    }
}
