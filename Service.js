.pragma library

var userName;
var server;
var socket;
var rooms;
var listModel;
var game;
var room;
var user;
var mainWindow;
var players;

function refreshRoom(i_room)
{
    var found = false;
    var ii;
    for(ii = 0;ii < game.rooms.count;++ii)
    {
        console.log("Room " + ii + " " + game.rooms.get(ii));
        if (i_room.id === game.rooms.get(ii).id)
        {
            console.log("Room found " + JSON.stringify(game.rooms.get(ii)));
            game.rooms.set(ii, i_room);
            console.log("Room is now " + JSON.stringify(game.rooms.get(ii)));
            if (game.room.id === i_room.id)
            {
                console.log("Room is active room, refreshing player list");
                game.room = game.rooms.get(ii);
                for(var jj = 0;jj < game.rooms.get(ii).users.count;++jj)
                {
                    if (game.rooms.get(ii).users.get(jj).name === userName)
                    {
                        game.rooms.get(ii).subject = game.rooms.get(ii).users.get(jj).subject;
                    }
                }
            }
            found = true;
        }
    }
    if (!found)
    {
        game.rooms.append(i_room);
    }
}

function handleMessage(message)
{
    console.log("Response: " + message);
    var content = JSON.parse(message);
    var ii;
    if (content.method === "login")
    {
        user = content.user;
        getRoomsSend(listModel);
    }
    else if (content.method === "getRooms")
    {
        rooms.clear();
        for(ii in content.rooms)
        {
            refreshRoom(content.rooms[ii]);
        }
    }
    else if (content.method === "enterRoom")
    {
        var tempRoom = content.room;
        refreshRoom(tempRoom);
        mainWindow.dummyFlag = !mainWindow.dummyFlag;
    }
    else if (content.method === "getRoom")
    {
        room = content.room;
        refreshRoom(room);
    }
    else if (content.method === "sendTip")
    {
        room = content.room;
        refreshRoom(room);
    }
    else if (content.method === "sendDrawing")
    {
        room = content.room;
        refreshRoom(room);
    }
    else if (content.method === "startGame")
    {
        game.room.subject = content.subject;
        mainWindow.dummyFlag = !mainWindow.dummyFlag;
    }
}

function getSubject(dummyFlag)
{
    return game.room.subject;
}

function getRoomsSend(model)
{
    var request = {method: "getRooms"};
    console.log("Request: " + JSON.stringify(request));
    socket.sendTextMessage(JSON.stringify(request));
}

function enterRoomSend(i_room)
{
    game.room = i_room;
    var request = {method: "enterRoom", room: {id: game.room.id}};
    console.log("Request: " + JSON.stringify(request));
    socket.sendTextMessage(JSON.stringify(request));
}

function startGameSend()
{
    var request = {method: "startGame", room: {id: game.room.id}};
    console.log("Request: " + JSON.stringify(request));
    socket.sendTextMessage(JSON.stringify(request));
}

function sendDrawingSend(drawing)
{
    var request = {method: "sendDrawing", drawing: drawing};
    console.log("Request: " + JSON.stringify(request));
    socket.sendTextMessage(JSON.stringify(request));
}

function sendTipSend(tip)
{
    var request = {method: "sendTip", tip: tip};
    console.log("Request: " + JSON.stringify(request));
    socket.sendTextMessage(JSON.stringify(request));
}
