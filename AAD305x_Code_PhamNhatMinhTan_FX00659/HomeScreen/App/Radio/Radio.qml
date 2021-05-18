import QtQuick 2.0

Item {
    id: root
    width: 1920
    height: 1080-94

    Image {
        source: "qrc:/App/Media/Image/title.png"
        Text {
            id: header
            text: qsTr("Radio")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }
}
