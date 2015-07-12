import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import Qt.WebSockets 1.0
import "Service.js" as Service

Rectangle {
    anchors.fill: parent

    Connections {
        target: socket
        onStatusChanged: {
            if (socket.status === WebSocket.Closed)
            {
                loader.source = "";
            }
        }
    }

    GridLayout {

        id: layout
        columns: 2

        anchors.centerIn: parent

        Button {
            text: "Create Room"
            onClicked: {

            }
        }

        Button {
            text: "Enter Room"
            onClicked: {
                console.log("Entering Room Nr. " + roomTable.currentRow);
                console.log("Entering Room " + game.rooms.get(roomTable.currentRow));
                Service.enterRoomSend(game.rooms.get(roomTable.currentRow));
                loader.source = "RoomView.qml";
            }
        }

        TableView {
            id: roomTable
            Layout.columnSpan: 2
            model: game.rooms
            TableViewColumn {
                role: "name"
                title: "Room Name"
            }
        }
    }
}
