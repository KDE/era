import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3

import org.mauikit.controls 1.3 as Maui

import org.mauikit.filebrowsing 1.3 as FB

Maui.Dialog
{
    id: control
    implicitHeight: 1000
    property url currentUrl: ""
    property var iteminfo: FB.FM.getFileInfo(control.currentUrl)

    ListModel { id: infoModel }


    hint: 1
    maxWidth: 800
    maxHeight: implicitHeight
    defaultButtons: false

    title: iteminfo.path

    headBar.rightContent: ToolButton
    {
        icon.name: "documentinfo"
        checkable: true
        checked: _stackView.depth === 2
        onClicked:
        {
            if(_stackView.depth === 2)
            {
                _stackView.pop()
            }else
            {
                _stackView.push(_infoComponent)
            }

        }
    }

    stack:  StackView
    {
        id: _stackView
        Layout.fillHeight: true
        Layout.fillWidth: true

        initialItem: Loader
        {
            id: previewLoader
            asynchronous: true
            active: control.visible
            source: show()
        }

        Component
        {
            id: _infoComponent

            ScrollView
            {
                contentHeight: _layout.implicitHeight
                contentWidth: availableWidth
                clip: true
                padding: Maui.Style.space.big
                background: null

                Component.onCompleted:
                {
                           initModel()
                }

                Flickable
                {
                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement: Flickable.StopAtBounds

                    ColumnLayout
                    {
                        id: _layout
                        width: parent.width
                        spacing: Maui.Style.space.huge

                        Item
                        {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 150

                            Maui.IconItem
                            {
                                height: parent.height * 0.9
                                width: height
                                anchors.centerIn: parent
                                iconSource: iteminfo.icon
                                imageSource: iteminfo.thumbnail
                                iconSizeHint: Maui.Style.iconSizes.large
                            }
                        }

                        Maui.SettingsSection
                        {
                            Layout.fillWidth: true

                            title: i18n("Details")
                            description: i18n("File information")
                            Repeater
                            {
                                model: infoModel
                                delegate:  Maui.SettingTemplate
                                {
                                    visible:  model.value ? true : false
                                    Layout.fillWidth: true
                                    label1.text: model.key
                                    label2.text: model.value
                                    label2.wrapMode: Text.Wrap
                                }
                            }
                        }
                    }
                }
            }
        }

    }


    footBar.rightContent: Button
    {
        text: i18n("Open")
        icon.name: "document-open"
        //        flat: true
        onClicked:
        {
            currentBrowser.openFile(control.currentUrl)
        }
    }

    function show()
    {
        var source = "DefaultPreview.qml"
        if(FB.FM.checkFileType(FB.FMList.AUDIO, iteminfo.mime))
        {
            source = "AudioPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.VIDEO, iteminfo.mime))
        {
            source = "VideoPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.TEXT, iteminfo.mime))
        {
            source = "TextPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.IMAGE, iteminfo.mime))
        {
            source = "ImagePreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.DOCUMENT, iteminfo.mime))
        {
            source = "DocumentPreview.qml"
        }else if(FB.FM.checkFileType(FB.FMList.FONT, iteminfo.mime))
        {
            source = "FontPreviewer.qml"
        }else
        {
            source = "DefaultPreview.qml"
        }

        return source;
    }


    function initModel()
    {
        infoModel.clear()
        infoModel.append({key: "Name", value: iteminfo.label})
        infoModel.append({key: "Type", value: iteminfo.mime})
        infoModel.append({key: "Date", value: Qt.formatDateTime(new Date(model.date), "d MMM yyyy")})
        infoModel.append({key: "Modified", value: Qt.formatDateTime(new Date(model.modified), "d MMM yyyy")})
        infoModel.append({key: "Last Read", value: Qt.formatDateTime(new Date(model.lastread), "d MMM yyyy")})
        infoModel.append({key: "Owner", value: iteminfo.owner})
        infoModel.append({key: "Group", value: iteminfo.group})
        infoModel.append({key: "Size", value: Maui.Handy.formatSize(iteminfo.size)})
        infoModel.append({key: "Symbolic Link", value: iteminfo.symlink})
        infoModel.append({key: "Path", value: iteminfo.path})
        infoModel.append({key: "Thumbnail", value: iteminfo.thumbnail})
        infoModel.append({key: "Icon Name", value: iteminfo.icon})
    }


}
