import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "Service.js" as Service

Rectangle {
    anchors.fill: parent

    GridLayout {
        anchors.centerIn: parent
        columns: 2

        Button {
            Layout.columnSpan: 2
            text: "Start Game"
            enabled: game.room.users.count >= 3
            onClicked: {
                Service.startGameSend();
            }
        }
        Button {
            Layout.columnSpan: 2
            text: "Draw"
            onClicked: {

            }
        }
        Label {
            Layout.columnSpan: 2
            text: "You have to draw: " + Service.getSubject(mainWindow.dummyFlag);
        }

        TableView {
            id: tableView
            model: game.room.users
            TableViewColumn {
                role: "name"
                title: "Player Name"
            }
        }
    }
}

