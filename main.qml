import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import Qt.WebSockets 1.0
import QtQuick.LocalStorage 2.0
import "Service.js" as Service

ApplicationWindow {
    id: mainWindow
    title: qsTr("Hello World")
    width: 640
    height: 480
    visible: true

    property bool dummyFlag: false

    Item {
        id: database
        property var db
        signal databaseOpen
        function getUserName()
        {
            var name = "";
            db.transaction(function(tx) {
                //tx.executeSql("drop table Player");
                tx.executeSql("create table if not exists Player(id number primary key, name text, key text)");
                var rs = tx.executeSql("select * from Player");
                for (var ii = 0; ii < rs.rows.length; ++ii)
                {
                    name = rs.rows.item(ii).name;
                }
            });
            return name;
        }
        function setUserName(name)
        {
            if (!db) return;
            db.transaction(function(tx) {
                tx.executeSql("create table if not exists Player(id number primary key, name text)");
                tx.executeSql("insert or replace into Player(id, name) values(?, ?)", [1, name]);
            });
        }

        Component.onCompleted: {
            db = LocalStorage.openDatabaseSync("theotherone", "0.0.1", "TheOtherOne");
            databaseOpen();
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    Game {
        id: game
    }

    WebSocket {
        id:  socket
        url: Service.server
        active: false
        onTextMessageReceived: {
            Service.handleMessage(message);
        }
        onStatusChanged: {
            if (status === WebSocket.Open)
            {
                var login = {method: "login", name: Service.userName};
                Service.socket = socket;
                socket.sendTextMessage(JSON.stringify(login));
            }
            else
            {
                console.log("WebSocket Status Changed to " + status);
            }
        }
    }

    MainMenuView {

    }

    Loader {
        id: loader
        anchors.fill: parent
        visible: status === Loader.Ready
    }

    Component.onCompleted: {
        Service.mainWindow = mainWindow;
    }
}
