import QtQuick 2.0
import QtQuick.Controls 2.15

Item
{
    id : clock
    width: {
        if (ListView.view && ListView.view.width >= 200)
            return ListView.view.width / Math.floor(ListView.view.width / 200.0);
        else
            return 200;
    }

    height: {
        if (ListView.view && ListView.view.height >= 240)
            return ListView.view.height;
        else
            return 240;
    }

    property alias city: cityLabel.text
    property int hours
    property int minutes
    property int seconds
    property real shift
    property bool night: false
    property bool internationalTime: false //Unset for local time

    function timeChanged() {
        var date = new Date;
        hours = internationalTime ? date.getUTCHours() + Math.floor(clock.shift) : date.getHours()
        night = ( hours < 7 || hours > 19 )
        minutes = internationalTime ? date.getUTCMinutes() + ((clock.shift % 1) * 60) : date.getMinutes()
        seconds = date.getUTCSeconds();
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: clock.timeChanged()
    }

    Item {
        anchors.centerIn: parent
        width: 200; height: 240

        Image { id: background; source: "qrc:/analog/clock2.png"; visible: clock.night == false
            sourceSize.height: 200
//        sourceSize.width: 200
        }
        Image { source: "qrc:/analog/clock-night.png"; visible: clock.night == true }

        Image {
            id: _hourHandle
            x: 92.5; y: 50
            source: "qrc:/analog/hour2.png"
            sourceSize.height: 50
            transform: Rotation {
                id: hourRotation
                origin.x: _hourHandle.width/2; origin.y: _hourHandle.height;
                angle: (clock.hours * 30) + (clock.minutes * 0.5)
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            x: 93.5; y: 17
            source: "qrc:/analog/minute.png"
            sourceSize.height: 88
//        sourceSize.width: 13
            transform: Rotation {
                id: minuteRotation
                origin.x: 6.5; origin.y: 83;
                angle: clock.minutes * 6
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            id: _secondHandle
            x: 97.5; y: 50
            source: "qrc:/analog/second2.png"
            sourceSize.height: 50
//        sourceSize.width: 5
            transform: Rotation {
                id: secondRotation
                origin.x: _secondHandle.width/2; origin.y: _secondHandle.height;
                angle: clock.seconds * 6
                Behavior on angle {
                    SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                }
            }
        }

        Image {
            anchors.centerIn: background; source: "qrc:/analog/center2.png"
            sourceSize.height: 22
        sourceSize.width: 22
        }

        Label {
            id: cityLabel
            y: 210; anchors.horizontalCenter: parent.horizontalCenter

        }
    }
}
