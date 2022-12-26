import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.3 as Maui
import QtGraphicalEffects 1.0

Control
{
    id : clock
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    spacing: Maui.Style.space.big
    font.bold: true
    font.weight: Font.Black
    font.pointSize: 24
    font.family: "Open 24 Display St"
    font.letterSpacing: Maui.Style.space.big
    padding: Maui.Style.space.big

    property string city: i18n("Local")
    property int hours
    property int minutes
    property int seconds
    property real shift
    property bool night: false
    property bool internationalTime: false //Unset for local time

    function timeChanged() {
        var date = new Date;
        hours = internationalTime ? date.getUTCHours() + Math.floor(clock.shift) : date.getHours()
        night = ( hours < 7 || hours > 17 )
        minutes = internationalTime ? date.getUTCMinutes() + ((clock.shift % 1) * 60) : date.getMinutes()
        seconds = date.getUTCSeconds();
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: clock.timeChanged()
    }

    contentItem: ColumnLayout
    {
        id: _layout
        spacing: clock.spacing

        Column
        {
            Layout.fillWidth: true
            Label
            {
                width: parent.width
//                font.pointSize: Maui.Style.fontSizes.small
                font.weight: Font.Bold
                font.bold: true
                opacity : 0.7
                horizontalAlignment: Qt.AlignHCenter
                text: clock.city + "  +" + clock.shift + " HRS"
            }


            Label
            {
                font: clock.font
                width: parent.width
                horizontalAlignment: Qt.AlignHCenter
                text: clock.hours + ":" + clock.minutes
            }
        }

        Item
        {
            Layout.preferredHeight: 200
            Layout.preferredWidth: 200

            Layout.alignment: Qt.AlignCenter
            Rectangle
            {
                id: _clockBg
                height: 200
                width: 200
                radius: height
                color: clock.night ? "#333" : "#fafafa"
                layer.enabled: true
                layer.effect: DropShadow
                {
                    horizontalOffset: 0
                    verticalOffset: 0
                    radius: 8
                    samples: 16
                    color: "#80000000"
                    transparentBorder: true
                }

            }



            Rectangle
            {
                id: _hourHandle
                x: 100; y: Math.floor(_clockBg.height/2 - height)
                height:50
                width: 5
                radius: width
                color: clock.night? "#fafafa" : "#333"
                transform: Rotation {
                    id: hourRotation
                    origin.x: _hourHandle.width/2; origin.y: _hourHandle.height;
                    angle: (clock.hours * 30) + (clock.minutes * 0.5)
                    Behavior on angle {
                        SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                    }
                }
            }

            Rectangle
            {
                id: _minuteHandle
                opacity: 0.5
                x: 100; y: Math.floor(_clockBg.height/2 - height)
                height: 60
                width: 5
                radius: width
                color: clock.night? "#fafafa" : "#333"

                transform: Rotation {
                    id: minuteRotation
                    origin.x: _minuteHandle.width/2; origin.y: _minuteHandle.height;
                    angle: clock.minutes * 6
                    Behavior on angle {
                        SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                    }
                }
            }

            Rectangle
            {
                id: _secondHandle
                x: 100; y: Math.floor(_clockBg.height/2 - height)
                height: 80
                width: 2
                radius: width
                color: Maui.Theme.highlightColor
                transform: Rotation {
                    id: secondRotation
                    origin.x: _secondHandle.width/2; origin.y: _secondHandle.height;
                    angle: clock.seconds * 6
                    Behavior on angle {
                        SpringAnimation { spring: 2; damping: 0.2; modulus: 360 }
                    }
                }
            }

            Rectangle
            {
                anchors.centerIn: _clockBg
                height: 16
                width: 16
                radius: width
                color: Qt.darker(_clockBg.color, 1.2)

                Rectangle
                {
                    anchors.fill: parent
                    anchors.margins: 4
                    color: _clockBg.color
                    radius: width
                }
            }
        }
    }
}
