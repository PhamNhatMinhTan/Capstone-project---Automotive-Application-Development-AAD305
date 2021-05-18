import QtQuick 2.0
import QtQuick.Layouts 1.11
import "Common"
import QtQml 2.2

Item {
    width: 1920
    height: 104 * scaleHeight
    signal bntBackClicked
    property bool isShowBackBtn: false
    property double scaleHeight: 1080/1200
    Button {
        anchors.left: parent.left
        icon: "qrc:/Img/StatusBar/btn_top_back"
        width: 135
        height: 101 * scaleHeight
        iconWidth: width
        iconHeight: height
        onClicked: bntBackClicked()
        visible: isShowBackBtn
    }

    Item {
        id: clockArea
        x: 660
        width: 350
        height: parent.height
        Image {
            anchors.left: parent.left
            height: 104 * scaleHeight
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
        Text {
            id: clockTime
            text: "10:28"
            color: "white"
            font.pixelSize: 72
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
        Image {
            anchors.right: parent.right
            height: 104 * scaleHeight
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
    }
    Item {
        id: dayArea
        anchors.left: clockArea.right
        width: 350
        height: parent.height
        Text {
            id: day
            text: "Jun. 24"
            color: "white"
            font.pixelSize: 72
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
        Image {
            anchors.right: parent.right
            height: 104 * scaleHeight
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
    }

    QtObject {
        id: time
        property var locale: Qt.locale()
        property date currentTime: new Date()

        Component.onCompleted: {
            clockTime.text = currentTime.toLocaleTimeString(locale, "hh:mm");
            day.text = currentTime.toLocaleDateString(locale, "MMM. dd");
        }
    }

    Timer{
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            time.currentTime = new Date()
            clockTime.text = time.currentTime.toLocaleTimeString(locale, "hh:mm");
            day.text = time.currentTime.toLocaleDateString(locale, "MMM. dd");
        }
    }
}
