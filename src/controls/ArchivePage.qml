import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

import org.mauikit.controls 1.3 as Maui
import org.mauikit.filebrowsing 1.3 as FM

import org.kde.arca 1.0 as Arca

Maui.Page
{

    id: control
    title: _manager.model.fileName || root.title
    property alias url : _manager.url
    showTitle: false

    Arca.CompressedFile
    {
        id: _manager
    }



    headBar.middleContent: Maui.SearchField
    {
        Layout.maximumWidth: 500
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter
        enabled: _manager.model.count > 1

        placeholderText: i18np("Search", "Search %1 files", _manager.model.count );
        onAccepted:
        {
            if(text.includes(","))
            {
                _archiveModel.filters = text.split(",")
            }else
            {
                _archiveModel.filter = text
            }
        }

        onCleared: _archiveModel.clearFilters()
    }

    headBar.leftContent: [

        Maui.ToolButtonMenu
        {
            icon.name:  "archive-extract"
            enabled: _manager.model.opened

            MenuItem
            {
                text: i18n("Extract")
            }

            MenuItem
            {
                text: i18n("Extract to...")
            }
        },

        ToolButton
        {
            icon.name: "archive-insert"
            enabled: _manager.model.opened
            onClicked: control.insertFiles()
        }
    ]

    headBar.rightContent: [

        ToolButton
        {
            icon.name: "go-up"
            onClicked: _manager.model.goUp()
            enabled: _manager.model.canGoUp
        },

        ToolButton
        {
            icon.name: "folder-root"
            onClicked: _manager.model.goToRoot()
            enabled: _manager.model.opened
        },

        Maui.ToolButtonMenu
        {
            icon.name: "view-sort"

            MenuItem
            {
                autoExclusive: true
                text: i18n("Name")
                checked : _archiveModel.sort === "label"
                onTriggered: _archiveModel.sort = "label"
            }

            MenuItem
            {
                autoExclusive: true
                text: i18n("Date")
                checked : _archiveModel.sort === "date"
                onTriggered: _archiveModel.sort = "date"
            }

            MenuItem
            {
                autoExclusive: true
                text: i18n("Size")
                checked : _archiveModel.sort === "size"
                onTriggered: _archiveModel.sort = "size"
            }

        }

    ]

    Maui.ListBrowser
    {
        id: _browser
        anchors.fill: parent
        model: Maui.BaseModel
        {
            id: _archiveModel
            sort: "label"
            sortOrder: Qt.AscendingOrder
            recursiveFilteringEnabled: true
            sortCaseSensitivity: Qt.CaseInsensitive
            filterCaseSensitivity: Qt.CaseInsensitive
            list: _manager.model
        }


        holder.visible: _browser.count === 0
        holder.emoji: "archive-insert"
        holder.title: i18n("Compress")
        holder.body: "Drop files in here to compress them."



        delegate: Maui.ListBrowserDelegate
        {
            width: ListView.view.width

            label1.text: model.label
            //            label2.text: model.path
            label2.text: Qt.formatDateTime(new Date(model.date), "d MMM yyyy")
            //            label4.text: Maui.Handy.formatSize(model.size)
            iconSource: model.icon

            onClicked:
            {
                if(Maui.Handy.singleClick)
                {
                    _browser.currentIndex = index
                    openItem(_browser.model.get(index))
                }

            }

            onDoubleClicked:
            {
                if(!Maui.Handy.singleClick)
                {
                    _browser.currentIndex = index
                    openItem(_browser.model.get(index))
                }
            }

            onRightClicked:
            {
                _browser.currentIndex = index
                _menu.item = _browser.model.get(index)
                _menu.show()
            }


        }


        Maui.ContextualMenu
        {
            id: _menu

            property var item

            MenuItem
            {
                text: i18n("Preview")
                icon.name: "quickopen"
                onTriggered: root.previewFile(_menu.item.path)
            }

            MenuItem
            {
                text: i18n("Open")
                icon.name: "document-open"
            }

            MenuItem
            {
                text: i18n("Open with")
            }

            MenuSeparator{}

            MenuItem
            {
                text: i18n("Delete")
                icon.name: "entry-delete"
            }
        }

    }


    Item
    {
        visible: _dropArea.containsDrag
        anchors.fill: parent

        Rectangle
        {
            anchors.fill: parent
            color: Maui.Theme.backgroundColor
            opacity: 0.8
        }

        Maui.Holder
        {
            anchors.fill: parent
            visible: true
            title: i18n("Add here")
            body: i18n("Drop file in here to add them to the archive")
            emoji: "archive-insert"
        }
    }

    DropArea
    {
        id: _dropArea
        anchors.fill: parent

        onDropped:
        {
            if(drop.hasUrls)

            {
                var urls = drop.urls.join(",").split(",")
                console.log("DROP URLS", urls )
                _manager.model.addFiles(urls, _manager.model.currentPath);
            }

        }
    }

    function openItem(item)
    {
        if(item.isdir === "true")
        {
            _manager.model.openDir(item.path)

        }else
        {
            var url = _manager.model.temporaryFile(item.path)
            previewFile(url)
        }
    }

    function insertFiles()
    {
        _dialogLoader.sourceComponent = _fileDialogComponent
        dialog.mode = dialog.modes.OPEN
        dialog.settings.filterType= FM.FMList.NONE
        dialog.callback = (paths) => {

            _manager.model.addFiles(paths, _manager.model.currentPath);

        }

        dialog.open()
    }

}
