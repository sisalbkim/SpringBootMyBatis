<h2>${room.roomName}</h2>

<div id="chat-box">
    <c:forEach var="msg" items="${messages}">
        <p><b>${msg.userId}</b>: ${msg.message} <span>(${msg.sendDt})</span></p>
    </c:forEach>
</div>

<form action="/chat/proc" method="post">
    <input type="hidden" name="chatRoomId" value="${room.roomId}">
    <input type="text" name="message" placeholder="메시지 입력" required>
    <button type="submit">보내기</button>
</form>
