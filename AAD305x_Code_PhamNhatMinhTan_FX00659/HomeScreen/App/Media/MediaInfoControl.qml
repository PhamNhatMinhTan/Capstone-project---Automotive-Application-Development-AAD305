import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.1
import QtMultimedia 5.9
Item {
    property double scaleHeight: 1080/1200
    Text {
        id: audioTitle
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: album_art_view.currentItem.myData.title
        color: "white"
        font.pixelSize: 36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        text: album_art_view.currentItem.myData.singer
        color: "white"
        font.pixelSize: 32
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: album_art_view.count
        color: "white"
        font.pixelSize: 36
    }
    Image {
        anchors.top: parent.top
        anchors.topMargin: 23
        anchors.right: audioCount.left
        anchors.rightMargin: 10
        source: "qrc:/App/Media/Image/music.png"
    }

    Component {
        id: appDelegate
        Item {
            property variant myData: model
            width: 400 * scaleHeight; height: 400 * scaleHeight
            //width: 400; height: 400
            scale: PathView.iconScale
            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20
                anchors.horizontalCenter: parent.horizontalCenter
                source: album_art
            }

            MouseArea {
                anchors.fill: parent
                onClicked: album_art_view.currentIndex = index
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - 1100)/2
        anchors.top: parent.top
        anchors.topMargin: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: myModel
        delegate: appDelegate
        pathItemCount: 3
        path: Path {
            startX: 65
            //startX: 10
            //startY: 20
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 550; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 1100; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        currentIndex: player.playlist.currentIndex
        onCurrentIndexChanged: {
            if (currentIndex != player.playlist.currentIndex) {
                player.playlist.currentIndex = currentIndex
            }
        }
    }
    //Progress
    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 357       //1080
        //anchors.bottomMargin: 250     //1200
        anchors.right: progressBar.left
        anchors.rightMargin: 20
        text: utility.getTimeInfo(player.position)
        color: "white"
        font.pixelSize: 24
    }
    Slider{
        id: progressBar
        width: 1491 - 675*playlist.position
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 350       //1080
        //anchors.bottomMargin: 245     //1200
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: player.duration
        value: player.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height * scaleHeight
                //height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: (progressBar.topPadding + progressBar.availableHeight / 2 - height / 2) * scaleHeight
            //y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/App/Media/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/App/Media/Image/center_point.png"
            }
        }
        onMoved: {
            if (player.seekable){
                player.setPosition(Math.floor(position*player.duration))
            }
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 357       //1080
        //anchors.bottomMargin: 250     //1200
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: utility.getTimeInfo(player.duration)
        color: "white"
        font.pixelSize: 24
    }
    //Media control
    SwitchButton {
        id: shuffer
        //anchors.bottom: parent.bottom
        //anchors.bottomMargin: 120
        anchors.top: progressBar.bottom
        anchors.topMargin: 50
        anchors.left: currentTime.left
        icon_off: "qrc:/App/Media/Image/shuffle.png"
        icon_on: "qrc:/App/Media/Image/shuffle-1.png"
        status: player.playlist.playbackMode === Playlist.Random ? 1 : 0
        onClicked: {
            console.log(player.playlist.playbackMode)
            if (player.playlist.playbackMode === Playlist.Random) {
                player.playlist.playbackMode = Playlist.Sequential
            } else {
                player.playlist.playbackMode = Playlist.Random
            }
        }
    }
    ButtonControl {
        id: prev
        anchors.top: progressBar.bottom
        anchors.topMargin: 50
        anchors.right: play.left
        icon_default: "qrc:/App/Media/Image/prev.png"
        icon_pressed: "qrc:/App/Media/Image/hold-prev.png"
        icon_released: "qrc:/App/Media/Image/prev.png"
        onClicked: {
            player.playlist.previous()
        }
    }
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        icon_default: player.state == MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        icon_pressed: player.state == MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/hold-pause.png" : "qrc:/App/Media/Image/hold-play.png"
        icon_released: player.state== MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        onClicked: {
            if (player.state != MediaPlayer.PlayingState){
                player.play()
            } else {
                player.pause()
            }
        }
        Connections {
            target: player
            onStateChanged:{
                play.source = player.state == MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
            }
        }
    }
    ButtonControl {
        id: next
        anchors.top: progressBar.bottom
        anchors.topMargin: 50
        anchors.left: play.right
        icon_default: "qrc:/App/Media/Image/next.png"
        icon_pressed: "qrc:/App/Media/Image/hold-next.png"
        icon_released: "qrc:/App/Media/Image/next.png"
        onClicked: {
            player.playlist.next()
        }
    }
    SwitchButton {
        id: repeater
        anchors.top: progressBar.bottom
        anchors.topMargin: 50
        anchors.right: totalTime.right
        icon_on: "qrc:/App/Media/Image/repeat1_hold.png"
        icon_off: "qrc:/App/Media/Image/repeat.png"
        status: player.playlist.playbackMode === Playlist.Loop ? 1 : 0
        onClicked: {
            console.log(player.playlist.playbackMode)
            if (player.playlist.playbackMode === Playlist.Loop) {
                player.playlist.playbackMode = Playlist.Sequential
            } else {
                player.playlist.playbackMode = Playlist.Loop
            }
        }
    }

    Connections{
        target: player.playlist
        onCurrentIndexChanged: {
            album_art_view.currentIndex = index;
        }
    }
}
