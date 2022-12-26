import QtQuick 2.0
import QtQuick.Controls 2.15
import org.mauikit.controls 1.3 as Maui

Control
{
    id : clock


spacing: Maui.Style.space.medium
    implicitWidth: _layout.implicitWidth + leftPadding + rightPadding
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding

    font.bold: true
    font.weight: Font.Black
    font.pointSize: Maui.Style.fontSizes.big
    font.family: "Open 24 Display St"
font.letterSpacing: Maui.Style.space.big
    padding: Maui.Style.space.big
    property string city: i18n("Local")
    property int hours
    property int minutes
    property int seconds
    property real shift
    property bool night: false
    property bool internationalTime: true //Unset for local time

    function timeChanged() {
        var date = new Date;
        hours = internationalTime ? date.getUTCHours() + Math.floor(clock.shift) : date.getHours()
        night = ( hours < 7 || hours > 19 )
        minutes = internationalTime ? date.getUTCMinutes() + ((clock.shift % 1) * 60) : date.getMinutes()
        seconds = date.getUTCSeconds();
    }

    function formatTime(i)
    {
        if (i < 10) {
            i = "0" + i;
        }
        return i;
    }

    background: Rectangle
    {
        color: Maui.Theme.alternateBackgroundColor
        radius: Maui.Style.radiusV
    }

    Timer {
        interval: 100; running: true; repeat: true;
        onTriggered: clock.timeChanged()
    }


    contentItem: Column
    {
        spacing: clock.spacing
        id: _layout
        Label
        {
            font: clock.font
            text: formatTime(hours) + ":" + formatTime(minutes)
        }

        Maui.ListItemTemplate
        {

            id: cityLabel
            width: parent.width
            label1.font.family: "Monospace"
            label1.text: clock.city
            label3.text: "+"+clock.shift+ "HRS"
            label2.text: "1/11/11"
//            font: clock.font
        }
    }
}
