import QtQuick 2.0

Item {
    width: 1920
    height: 1096 * scaleHeight
    property double scaleHeight: 1080/1200
    Image {
        source: "qrc:/App/Media/Image/title.png"
        height: 141 * scaleHeight
        Text {
            id: header
            text: qsTr("Climate")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }
    Item {
        id: root
        implicitWidth: 635
        implicitHeight: 570 * scaleHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        property bool isFocus: false

        Image {
            id: idBackgroud
            source: ""
            width: root.width
            height: root.height
        }
        //Driver
        Text {
            x: 43
            y: 95
            width: 184
            text: "DRIVER"
            color: "white"
            font.pixelSize: 34
            horizontalAlignment: Text.AlignHCenter
        }
        Image {
            x:43
            y: (95+41)
            width: 184
            source: "qrc:/Img/HomeScreen/widget_climate_line.png"
        }
        Image {
            x: (55+25+26)
            y:155
            width: 110
            height: 120
            source: "qrc:/Img/HomeScreen/widget_climate_arrow_seat.png"
        }
        Image {
            x: (55+25)
            y:(155+34)
            width: 70
            height: 50
            source: climateModel.driver_wind_mode == 0 || climateModel.driver_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_01_n.png"

        }
        Image {
            x: 55
            y:(155+34+26)
            width: 70
            height: 50
            source: climateModel.driver_wind_mode == 1 || climateModel.driver_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_02_n.png"
        }
        Text {
            id: driver_temp
            x: 43
            y: (188 + 100)
            width: 184
            text:  {
                //set data for driver temp
                if (climateModel.driver_temp == 16.5) {
                    driver_temp.text = "LOW"
                } else if (climateModel.driver_temp == 31.5) {
                    driver_temp.text = "HIGH"
                } else {
                    driver_temp.text = climateModel.driver_temp+"°C"
                }
            }
            color: "white"
            font.pixelSize: 46
            horizontalAlignment: Text.AlignHCenter
        }

        //Passenger
        Text {
            x: (43+184+182)
            y: 95
            width: 184
            text: "PASSENGER"
            color: "white"
            font.pixelSize: 34
            horizontalAlignment: Text.AlignHCenter
        }
        Image {
            x: (43+184+182)
            y: (95+41)
            width: 184
            source: "qrc:/Img/HomeScreen/widget_climate_line.png"
        }
        Image {
            x: (55+25+26+314+25+26)
            y:155
            width: 110
            height: 120
            source: "qrc:/Img/HomeScreen/widget_climate_arrow_seat.png"
        }
        Image {
            x: (55+25+26+314+25)
            y:(155+34)
            width: 70
            height: 50
            source: climateModel.passenger_wind_mode == 0 || climateModel.passenger_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_01_n.png"
        }
        Image {
            x: (55+25+26+314)
            y:(155+34+26)
            width: 70
            height: 50
            source: climateModel.passenger_wind_mode == 1 || climateModel.passenger_wind_mode == 2 ?
                        "qrc:/Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_02_n.png"
        }
        Text {
            id: passenger_temp
            x: (43+184+182)
            y: (198 + 100)
            width: 184
            text: {
                //set data for passenger temp
                if (climateModel.passenger_temp == 16.5) {
                    passenger_temp.text = "LOW"
                } else if (climateModel.passenger_temp == 31.5) {
                    passenger_temp.text = "HIGH"
                } else {
                    passenger_temp.text = climateModel.passenger_temp+"°C"
                }
            }

            color: "white"
            font.pixelSize: 46
            horizontalAlignment: Text.AlignHCenter
        }
        //Wind level
        Image {
            x: 172
            y: 198
            width: 290
            height: 100
            source: "qrc:/Img/HomeScreen/widget_climate_wind_level_bg.png"
        }
        Image {
            id: fan_level
            x: 172
            y: 198
            width: 290
            height: 100
            source: "qrc:/Img/HomeScreen/widget_climate_wind_level_0"+climateModel.fan_level+".png"
        }

        Connections{
            target: climateModel
            onDataChanged: {
                //set data for fan level
                if (climateModel.fan_level < 1) {
                    fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_01.png"
                }
                else if (climateModel.fan_level < 10) {
                    fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_0"+climateModel.fan_level+".png"
                } else {
                    fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_"+climateModel.fan_level+".png"
                }

                //set data for driver temp
                if (climateModel.driver_temp == 16.5) {
                    driver_temp.text = "LOW"
                } else if (climateModel.driver_temp == 31.5) {
                    driver_temp.text = "HIGH"
                } else {
                    driver_temp.text = climateModel.driver_temp+"°C"
                }

                //set data for passenger temp
                if (climateModel.passenger_temp == 16.5) {
                    passenger_temp.text = "LOW"
                } else if (climateModel.passenger_temp == 31.5) {
                    passenger_temp.text = "HIGH"
                } else {
                    passenger_temp.text = climateModel.passenger_temp+"°C"
                }
            }
        }

        //Fan
        Image {
            x: (172 + 115)
            y: (198 + 100)
            width: 60
            height: 60
            source: "qrc:/Img/HomeScreen/widget_climate_ico_wind.png"
        }
        //Bottom
        Text {
            x:30
            y:(396 + 18)
            width: 172
            horizontalAlignment: Text.AlignHCenter
            text: "AUTO"
            color: !climateModel.auto_mode ? "white" : "gray"
            font.pixelSize: 46
        }
        Text {
            x:(30+172+30)
            y:396
            width: 171
            horizontalAlignment: Text.AlignHCenter
            text: "OUTSIDE"
            color: "white"
            font.pixelSize: 26
        }
        Text {
            x:(30+172+30)
            y:(396 + 18 + 21)
            width: 171
            horizontalAlignment: Text.AlignHCenter
            text: "27.5°C"
            color: "white"
            font.pixelSize: 38
        }
        Text {
            x:(30+172+30+171+30)
            y:(396 + 18)
            width: 171
            horizontalAlignment: Text.AlignHCenter
            text: "SYNC"
            color: !climateModel.sync_mode ? "white" : "gray"
            font.pixelSize: 46
        }
    }
}
