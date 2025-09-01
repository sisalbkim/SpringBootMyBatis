<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
        }

        .empty-box {
            background: #fff;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .chat-list {
            max-width: 600px;
            margin: 20px auto;
        }

        .chat-room {
            background: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: background 0.2s;
            text-align: center;
        }

        .chat-room:hover {
            background: #f0f0f0;
        }

        .create-btn {
            display: inline-block;
            margin-top: 10px;
            padding: 10px 20px;
            background: #4CAF50;
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.2s;
        }

        .create-btn:hover {
            background: #45a049;
        }
    </style>
</head>
<body>

<!-- 상단 메뉴 -->
<div class="navbar" style="background:#eee; padding:15px; display:flex; justify-content:space-evenly;">
    <a href="/html/index.jsp">메인 화면</a>
    <a href="/chat/list">채팅</a>
    <a href="#">설정</a>
    <a href="/user/logout">로그아웃</a>
</div>

<div class="container">
    <c:choose>
        <!-- 채팅방이 없을 경우 -->
        <c:when test="${empty chatRoomList}">
            <div class="empty-box">
                <div style="font-size: 50px; margin-bottom: 10px;">💬</div>
                <h2>아직 개설된 채팅방이 없습니다</h2>
                <p>새로운 채팅방을 만들어보세요!</p>
                <a href="/chat/create" class="create-btn">새 채팅방 만들기</a>
            </div>
        </c:when>

        <!-- 채팅방이 있을 경우 -->
        <c:otherwise>
            <div class="chat-list">
                <c:forEach var="room" items="${chatRoomList}">
                    <div class="chat-room" onclick="location.href='/chat/room/${room.roomId}'">
                        <h3>${room.roomName}</h3>
                        <!-- 참여자 수 대신 버튼 -->
                        <a href="/chat/create" class="create-btn">새 채팅방 만들기</a>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>
