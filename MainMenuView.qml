import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3
import "Service.js" as Service

Rectangle {
    anchors.fill: parent

    Connections {
        target: database
        onDatabaseOpen: {
            var userName = database.getUserName();
            console.log("got user name" + userName);
            editName.text = userName;
        }
    }

    GridLayout {
        anchors.centerIn: parent
        columns: 2
        Label {
            text: "Name"
        }
        TextField {
            id: editName
            text: "Martin"
            onTextChanged: {
                Service.userName = editName.text;
                database.setUserName(editName.text);
            }
        }
        Label {
            text: "Server"
        }
        TextField {
            id: editServer
            text: "ws://127.0.0.1:51481"
            onTextChanged: {
                Service.server = editServer.text;
            }
        }

        Button {
            Layout.columnSpan: 2
            text: "Play"
            onClicked: {
                socket.active = true;
                loader.source = "RoomListView.qml";
            }
        }
    }
}

