<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${roomInfo.roomName}</title>
    <script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
    <style>
        /* === 기존 스타일 그대로 === */
        body {
            margin: 0;
            font-family: 'Apple SD Gothic Neo', Arial, sans-serif;
            background: #ececec;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .chat-header { background: #6a5acd; color: #fff; padding: 15px; display: flex; justify-content: space-between; }
        .chat-messages { flex: 1; padding: 15px; overflow-y: auto; display: flex; flex-direction: column; }
        .message { max-width: 70%; margin-bottom: 12px; display: flex; align-items: flex-end; }
        .message.left { justify-content: flex-start; }
        .message.left .bubble { background: #fff; border-radius: 15px 15px 15px 0; padding: 10px 14px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .message.right { justify-content: flex-end; }
        .message.right .bubble { background: #2f8f83; color: #fff; border-radius: 15px 15px 0 15px; padding: 10px 14px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .nickname { font-size: 11px; color: #666; margin: 0 5px; }
        .chat-input { display: flex; padding: 10px; background: #fff; border-top: 1px solid #ccc; }
        .chat-input input { flex: 1; padding: 10px; border: 1px solid #ccc; border-radius: 20px; outline: none; }
        .chat-input button { margin-left: 8px; padding: 10px 15px; background: #6a5acd; border: none; border-radius: 50%; color: #fff; cursor: pointer; }
    </style>
</head>
<body>

<div class="chat-header">
    <div class="title">${roomInfo.roomName}</div>
    <div class="menu">☰</div>
</div>

<div class="chat-messages" id="chatBody">
    <c:forEach var="msg" items="${msgList}">
        <div class="message ${msg.userId eq sessionScope.SS_USER_ID ? 'right' : 'left'}">
            <span class="nickname">${msg.userId}</span>
            <div class="bubble">${msg.message}</div>
        </div>
    </c:forEach>
</div>


<div class="chat-input">
    <input type="text" id="msgInput" placeholder="채팅을 입력하세요"/>
    <button id="sendBtn">➤</button>
</div>

<script>
    let stompClient = null;

    function connect() {
        let socket = new SockJS("${pageContext.request.contextPath}/ws-chat");
        stompClient = Stomp.over(socket);

        stompClient.connect({}, function(frame) {
            console.log("Connected: " + frame);
            stompClient.subscribe("/topic/public", function(message) {
                let msg = JSON.parse(message.body);
                showMessage(msg.userId, msg.message, msg.userId === "${sessionScope.SS_USER_ID}");
            });
        });
    }

    function sendMessage() {
        let text = document.getElementById("msgInput").value;
        if (!text) return;

        let msg = {
            userId: "${sessionScope.SS_USER_ID}",
            message: text,
            chatRoomId: ${roomInfo.roomId}
        };
        stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(msg));
        document.getElementById("msgInput").value = "";
    }

    function showMessage(sender, content, isMe) {
        let chatBody = document.getElementById("chatBody");
        let side = isMe ? "right" : "left";
        let msgHtml =
            '<div class="message ' + side + '">' +
            (!isMe ? '<span class="nickname">' + sender + '</span>' : '') +
            '<div class="bubble">' + content + '</div>' +
            (isMe ? '<span class="nickname">' + sender + '</span>' : '') +
            '</div>';

        chatBody.innerHTML += msgHtml;
        chatBody.scrollTop = chatBody.scrollHeight;
    }

    document.getElementById("sendBtn").onclick = sendMessage;
    document.getElementById("msgInput").addEventListener("keypress", function(e) {
        if (e.key === "Enter") sendMessage();
    });

    window.onload = connect;
</script>
</body>
</html>
