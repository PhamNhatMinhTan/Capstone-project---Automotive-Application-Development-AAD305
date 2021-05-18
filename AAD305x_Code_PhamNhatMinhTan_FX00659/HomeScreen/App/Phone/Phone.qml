import QtQuick 2.11
import QtQuick.Controls 2.4

Item {
    id: root
    width: 1920
    height: 1080-94

    Image {
        source: "qrc:/App/Media/Image/title.png"
        Text {
            id: header
            text: qsTr("Phone")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }
}
