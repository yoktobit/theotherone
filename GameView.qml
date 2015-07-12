import QtQuick 2.0
import Qt.WebSockets 1.0
import "Service.js" as Service

Rectangle {
    id: game
    anchors.fill: parent

    property bool drawing;
    property bool startDrawing: false;
    property int lastX;
    property int lastY;

    Canvas {
        id: canvas

        anchors.fill: parent

        onPaint: {
            var ctx = canvas.getContext("2d");
            if (startDrawing)
            {
                ctx.moveTo(lastX, lastY);
                startDrawing = false;
            }
            else
            {
                ctx.fillStyle = "black";
                ctx.strokeStyle = "black";
                ctx.lineWidth = 2;
                ctx.lineTo(lastX, lastY);
                ctx.stroke();

            }

        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPressed: {
                drawing = true;
                startDrawing = true;
                lastX = mouse.x;
                lastY = mouse.y;
                console.debug("started drawing at " + lastX + ";" + lastY);
                numberAnimation.start();
            }
            onPositionChanged: {
                if (drawing)
                {
                    lastX = mouse.x;
                    lastY = mouse.y;
                    canvas.requestPaint();
                    console.debug("line to " + mouse.x + ";" + mouse.y);
                }
            }
            onReleased: {
                drawing = false;
                console.debug("end drawing");
            }
        } // MouseArea
    } // Canvas
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Math.ceil(counter)
        font.pixelSize: parent.height * 0.05
    }
    property real counter
    NumberAnimation {
        id: numberAnimation
        target: game
        property: "counter"
        from: 5.0
        to: 0.0
        duration: 5000
        onRunningChanged: {
            if (!running)
            {
                var content = {method: "sendDrawing", content: canvas.toDataURL()}
                Service.socket.sendTextMessage(JSON.stringify(content));
            }
        }
    }
}

