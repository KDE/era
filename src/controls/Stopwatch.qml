import QtQuick 2.12
import org.mauikit.controls 1.3 as Maui

import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtGraphicalEffects 1.13

Item {
    id: root
    clip: true
    property bool running: false
    property var times: []
    Maui.Theme.colorSet: Maui.Theme.View

    Rectangle { anchors.fill: parent; color: Maui.Theme.backgroundColor }

    Item {
        width: root.height * (2/3)
        height: width
        anchors.centerIn: parent
        Rectangle {
            anchors.centerIn: parent
            width: root.height * (2/3)
            height: width
            id: spinnerProgress
            anchors {
                margins: Maui.Style.space.small
            }
            radius: width
            color: "transparent"
            opacity: 0.8
            border.color: Maui.Theme.backgroundColor
            border.width: Maui.Style.space.big
            property real progress: 0.1
        }

        ConicalGradient {
            id: cone
            source: spinnerProgress
            visible: spinnerProgress.visible
            anchors.fill: spinnerProgress
            property int deg: 0
            gradient: Gradient {
                GradientStop { position: 0.00; color: Maui.Theme.highlightColor }
                GradientStop { position: spinnerProgress.progress; color: Maui.Theme.highlightColor }
                GradientStop { position: spinnerProgress.progress + 0.0001; color: Qt.rgba(Kirigami.Theme.textColor.r,Kirigami.Theme.textColor.g,Kirigami.Theme.textColor.b,0.2) }
            }
            transform: Rotation { angle: cone.deg; origin.x: cone.width / 2; origin.y: cone.height / 2 }
        }
        SequentialAnimation {
            running: root.running
            loops: Animation.Infinite
            NumberAnimation {
                target: cone
                duration: 1000
                property: "deg"
                from: 0
                to: 360
            }
        }
        Column {
            id: col
            anchors.centerIn: parent
            Item {
                height: hhmmss.height
                width: hhmmss.width
                anchors.horizontalCenter: parent.horizontalCenter
                Label {
                    id: hhmmss
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: stoppy.getString()
                }
               Label {
//                    level: 3
                    anchors.verticalCenter: hhmmss.verticalCenter
                    anchors.left: hhmmss.right
                    anchors.leftMargin: Maui.Style.space.big
                    text: stoppy.getMS()
                }
            }
            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: root.running ? "Stop" : "Start"
                    onClicked: root.running = !root.running
                }
                Button {
                    text: root.running ? "Lap" : "Reset"
                    onClicked: root.running ? root.lap() : root.clear()
                }
            }
        }
        ListView {
            clip: true
            anchors.horizontalCenter: col.horizontalCenter
            anchors.top: col.bottom
            anchors.topMargin: Maui.Style.space.big
            height: ((cone.y + cone.height) - (col.y + col.height)) - (Kirigami.Units.gridUnit * 3)
            width: col.width
            id: repeat
            model: root.times
            delegate: Label
            {
//                level: 3
                text: modelData
            }
            displaced: Transition {
                NumberAnimation { properties: "y"; duration: 5000 }
            }
        }
    }
    Timer {
        interval: 10
        repeat: true
        running: root.running
        onTriggered: {
            stoppy.delta()
        }
    }
    Component.onCompleted: {
        stoppy.start()
    }
    function lap() {
        var str = stoppy.getString() + "." + stoppy.getMS()
        root.times.unshift(str)
        repeat.model = root.times
    }
    function clear() {
        stoppy.reset()
        root.times = []
        repeat.model = root.times
    }

    Item {
        id: stoppy
        property var eclipsed
        property var now
        property bool started: false
        property bool running: root.running

        Component.onCompleted: {
            stoppy.eclipsed = 0
        }
        function start() {
            if (stoppy.started)
                return
            stoppy.now = Date.now()
            stoppy.started = true
        }
        function delta() {
            if (!stoppy.running)
                return
            var newnow = Date.now()
            var diff = newnow - now
            stoppy.now = newnow
            stoppy.eclipsed += diff
        }
        function getString() {
            var date = new Date(stoppy.eclipsed)
            return date.toISOString().substr(11, 8)
        }
        function getMS() {
            var date = new Date(stoppy.eclipsed)
            return date.getMilliseconds()
        }
        function reset() {
            stoppy.eclipsed = null
            stoppy.now = null
            stoppy.started = false
        }
        onRunningChanged: {
            if (running == true) {
                stoppy.now = Date.now()
            }
        }
    }
}
