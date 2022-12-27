import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.3 as Maui


Maui.ApplicationWindow
{
    id: root
    title: Maui.App.about.displayName
    Maui.Style.styleType: night ? Maui.Style.Dark :  Maui.Style.Light
    Maui.Style.accentColor: "#ff959f"
    maximumHeight: 700
    minimumHeight: 700
    maximumWidth: 500
    minimumWidth: 500

    property bool night: _mainClock.night

    Maui.AppViews
    {
        anchors.fill: parent
        //title: root.title
        showCSDControls: true
        headBar.forceCenterMiddleContent: true


        headBar.leftContent: Loader
        {
            asynchronous: true

            sourceComponent: Maui.ToolButtonMenu
            {
                icon.name: "application-menu"

                MenuItem
                {
                    text: i18n("Settings")
                    icon.name: "settings-configure"
                    onTriggered: openSettingsDialog()
                }

                MenuItem
                {
                    text: i18n("About")
                    icon.name: "documentinfo"
                    onTriggered: root.about()
                }
            }
        }

        Maui.AppViewLoader
        {
            Maui.AppView.title: i18n("Clock")
            Maui.AppView.iconName: "clock"
            Maui.Page
            {

                headBar.visible: false

                footBar.rightContent: ToolButton
                {
                    icon.name: "list-add"
                }

                Maui.ListBrowser
                {
                    id: _clocksListView
                    anchors.fill: parent
                    snapMode: ListView.SnapOneItem

                    flickable.header: Item
                    {
                        width: parent.width
                        height: _mainClock.height

                        AnalogClock
                        {
                            id: _mainClock
                            internationalTime: false
                            anchors.centerIn: parent
                        }

                    }

                    model: ListModel
                    {
                        ListElement { cityName: "New York"; timeShift: -4 }
                        ListElement { cityName: "Oslo"; timeShift: 1 }
                        ListElement { cityName: "Mumbai"; timeShift: 5.5 }
                        ListElement { cityName: "Tokyo"; timeShift: 9 }
                        ListElement { cityName: "Brisbane"; timeShift: 10 }
                        ListElement { cityName: "Los Angeles"; timeShift: -8 }
                    }

                    delegate:  DigitalClock
                    {
                        //                            height: 100
                        //                            width: 100
                        width: ListView.view.width
                        city: model.cityName; shift: model.timeShift
                    }
                }

            }
        }

        Maui.AppViewLoader
        {

            Maui.AppView.title: i18n("Stopwatch")
            Maui.AppView.iconName: "stopwatch"
            Maui.Page
            {
            Stopwatch
            {
                anchors.fill: parent
            }

            }

        }

        Maui.AppViewLoader
        {

            Maui.AppView.title: i18n("Timer")
            Maui.AppView.iconName: "timer"
            Maui.Page
            {


            }

        }

        Maui.AppViewLoader
        {

            Maui.AppView.title: i18n("Alarm")
            Maui.AppView.iconName: "alarm"
            Maui.Page {}

        }

    }

}
