import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.3 as Maui


Maui.ApplicationWindow
{
    id: root
    title: Maui.App.about.displayName
	
Maui.AppViews
{
anchors.fill: parent
//title: root.title
showCSDControls: true


Maui.AppViewLoader
{

Maui.AppView.title: i18n("Clock")
Maui.AppView.iconName: "clock"
Maui.Page
{

    AnalogClock
    {
        anchors.centerIn: parent
        city: "Medellin"
        shift: 0
    }
}

}

Maui.AppViewLoader
{

Maui.AppView.title: i18n("Timer")
Maui.AppView.iconName: "clock"
Maui.Page {}

}

Maui.AppViewLoader
{

Maui.AppView.title: i18n("Alarm")
Maui.AppView.iconName: "clock"
Maui.Page {}

}

}

}
