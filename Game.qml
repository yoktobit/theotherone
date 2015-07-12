import QtQuick 2.0
import "Service.js" as Service

Item {
    id: game
    property alias rooms: _rooms
    ListModel {
        id: _rooms
    }
    property var room: null

    /*property alias players: _players
    ListModel {
        id: _players
    }

    onRoomChanged: {
        _players.clear();
        if (!room) return;
        console.log("Room Changed " + JSON.stringify(room));
        console.log("Rooms Users " + JSON.stringify(room.users));
        for (var ii = 0; ii < room.users.count; ++ii)
        {
            console.log("User "+ ii +" in room " + JSON.stringify(room.users.get(ii)));
            _players.append(room.users.get(ii));
        }
    }*/

    Component.onCompleted: {
        Service.rooms = _rooms;
        Service.game = game;
    }
}

