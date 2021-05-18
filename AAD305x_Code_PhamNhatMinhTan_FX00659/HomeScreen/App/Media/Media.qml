import QtQuick 2.6
import QtQuick.Controls 2.4

Item {
    width: 1920
    height: 1080-94
    property double scaleHeight: 1080/1200
    //Header
    AppHeader{
        id: headerItem
        width: parent.width
        height: 141 * scaleHeight
        //height: 100
        //height: 141
        playlistButtonStatus: playlist.opened ? 1 : 0
        onClickPlaylistButton: {
            if (!playlist.opened) {
                playlist.open()
            } else {
                playlist.close()
            }
        }
    }

    //Playlist
    PlaylistView{
        id: playlist
        y: (141 * scaleHeight) + (104 * scaleHeight)
        width: 675
        height: parent.height-headerItem.height-100
        //height: parent.height-headerItem.height
    }

    //Media Info
    MediaInfoControl{
        id: mediaInfoControl
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: playlist.position*playlist.width
        anchors.bottom: parent.bottom
    }
}
