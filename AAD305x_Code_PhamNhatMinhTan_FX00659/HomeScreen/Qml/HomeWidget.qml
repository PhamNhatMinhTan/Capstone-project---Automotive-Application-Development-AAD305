import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.1

Item {
    id: root
    width: 1920
    height: 1096 * scaleHeight
    property double scaleHeight: 1080/1200
    property int widgetFocused: 0      //0: Map, 1: Climate, 2: Media
    property int appFocused: 1         //0: widget focused, 1: application focused
    function openApplication(url){
        parent.push(url)
    }

    // Widget
    ListView {
        id: lvWidget
        spacing: 10
        orientation: ListView.Horizontal
        width: 1920
        height: 570 * scaleHeight
        interactive: false

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                ListElement { type: "map" }
                ListElement { type: "climate" }
                ListElement { type: "media" }
            }

            delegate: DropArea {
                id: delegateRootWidget
                width: 635; height: 570 * scaleHeight
                keys: ["widget"]

                onEntered: {
                    visualModelWidget.items.move(drag.source.visualIndex, iconWidget.visualIndex)
                    iconWidget.item.enabled = false
                }
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: iconWidget; property: "visualIndex"; value: visualIndex }
                onExited: iconWidget.item.enabled = true
                onDropped: {
                    console.log(drop.source.visualIndex)
                }

                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 635; height: 570 * scaleHeight
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    sourceComponent: {
                        switch(model.type) {
                        case "map": return mapWidget
                        case "climate": return climateWidget
                        case "media": return mediaWidget
                        }
                    }

                    Drag.active: iconWidget.item.drag.active
                    Drag.keys: "widget"
                    Drag.hotSpot.x: delegateRootWidget.width/2
                    Drag.hotSpot.y: delegateRootWidget.height/2

                    states: [
                        State {
                            when: iconWidget.Drag.active
                            ParentChange {
                                target: iconWidget
                                parent: root
                            }

                            AnchorChanges {
                                target: iconWidget
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        Component {
            id: mapWidget
            MapWidget{
                id: mapWidgetId
                onClicked:  {
                    widgetFocused = 0
                    appFocused = 0
                    openApplication("qrc:/App/Map/Map.qml")
                }
                isFocus: (root.widgetFocused === 0 && root.appFocused === 0) ? true : false
            }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                id: climateWidgetId
                onClicked: {
                    widgetFocused = 1
                    appFocused = 0
                    openApplication("qrc:/App/Climate/Climate.qml")
                }
                isFocus: (root.widgetFocused === 1 && root.appFocused === 0) ? true : false
            }
        }
        Component {
            id: mediaWidget
            MediaWidget{
                id: mediaWidgetId
                onClicked: {
                    widgetFocused = 2
                    appFocused = 0
                    openApplication("qrc:/App/Media/Media.qml")
                }
                isFocus: (root.widgetFocused === 2 && root.appFocused === 0) ? true : false
            }
        }
    }

    // Application
    ListView {
        id: appListview
        x: 0
        y: 570 * scaleHeight
        width: 1920; height: 526 *  scaleHeight
        orientation: ListView.Horizontal
        interactive: false
        spacing: 5

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModel
            model: appsModel
            delegate: DropArea {
                id: delegateRoot
                width: 316; height: 526 *  scaleHeight
                keys: "AppButton"

                onEntered: visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Item {
                    id: icon
                    property int visualIndex: 0
                    width: 316; height: 526 *  scaleHeight
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    AppButton{
                        id: app
                        anchors.fill: parent
                        title: model.title
                        icon: model.iconPath
                        drag.axis: Drag.XAxis
                        drag.target: parent

                        onClicked: openApplication(model.url)
                        onReleased: {
                            app.focus = true
                            app.state = "Focus"

                            // Handle application model
                            var listIndex = []
                            for (var index = 0; index < visualModel.items.count;index++){
                                if (index !== icon.visualIndex)
                                    visualModel.items.get(index).focus = false
                                else
                                    visualModel.items.get(index).focus = true

                                // Pass data to C++
                                listIndex[index] = visualModel.items.get(index).model
                                appsModel.getApplication(index, listIndex[index].title, listIndex[index].url,
                                                         listIndex[index].iconPath)
                            }
                            XMLHandler.writeXMLFile()   // Write data to file

                            appFocused = 1
                            widgetFocused = icon.visualIndex
                        }
                        onPositionChanged: widgetFocused = icon.visualIndex
                        isFocus: (appFocused === 1 && widgetFocused === icon.visualIndex) ? true : false
                    }

                    onFocusChanged: app.focus = icon.focus

                    Drag.active: app.drag.active
                    Drag.keys: "AppButton"

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: appListview
                            }

                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        // Scrollbar
        ScrollBar.horizontal: ScrollBar {
            policy: ScrollBar.AsNeeded
            anchors.bottom: parent.top
        }
    }
}
