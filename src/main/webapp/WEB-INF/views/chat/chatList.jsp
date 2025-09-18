<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>

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
        }

        .navbar {
            background: #eee;
            padding: 15px;
            display: flex;
            justify-content: space-evenly;
            align-items: center;
            border-bottom: 1px solid #ddd;
        }

        .container {
            max-width: 700px;
            margin: 20px auto;
            padding: 10px;
        }

        /* 채팅방 카드 */
        .chat-room {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fff;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: background 0.2s;
        }

        .chat-room:hover {
            background: #f5f5f5;
        }

        .chat-info {
            display: flex;
            align-items: center;
        }

        .chat-avatar {
            width: 50px;
            height: 50px;
            background: #ccc;
            border-radius: 50%;
            margin-right: 15px;
            flex-shrink: 0;
        }

        .chat-text {
            text-align: left;
        }

        .chat-text h3 {
            margin: 0;
            font-size: 16px;
            font-weight: bold;
        }

        .chat-text p {
            margin: 5px 0 0;
            font-size: 13px;
            color: #666;
        }

        .chat-menu {
            font-size: 20px;
            color: #555;
        }

        .empty-box {
            text-align: center;
            padding: 40px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .create-btn {
            display: inline-block;
            margin-top: 10px;
            padding: 10px 20px;
            background: #4CAF50;
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
        }
    </style>
</head>
<body>

<!-- 상단 메뉴 -->
<div class="navbar">
    <a href="/html/index.jsp">메인 화면</a>
    <a href="/chat/list">채팅</a>
    <a href="#">설정</a>
    <a href="/user/logout">로그아웃</a>
</div>

<div class="container">
    <!-- 맨 위에 고정되는 새 채팅방 추가 -->
    <div class="chat-room" onclick="location.href='/chat/create'">
        <div class="chat-info">
            <div class="chat-avatar" style="background:#eee; font-size:24px; color:#666;
                 display:flex; align-items:center; justify-content:center;">+</div>
            <div class="chat-text">
                <h3>새로운 채팅방 추가</h3>
                <p>새로운 대화를 시작하세요</p>
            </div>
        </div>
    </div>

    <%
        java.util.List<kopo.poly.dto.ChatDTO> chatList =
                (java.util.List<kopo.poly.dto.ChatDTO>) request.getAttribute("chatList");

        if (chatList == null || chatList.isEmpty()) {
    %>
    <div class="empty-box">
        <div style="font-size: 50px; margin-bottom: 10px;">💬</div>
        <h2>아직 개설된 채팅방이 없습니다</h2>
        <p>새로운 채팅방을 만들어보세요!</p>
        <a href="/chat/create" class="create-btn">새 채팅방 만들기</a>
    </div>
    <%
    } else {
        // 채팅방 목록 반복 출력
        for (kopo.poly.dto.ChatDTO room : chatList) {
    %>
    <div class="chat-room" onclick="location.href='/chat/room/<%=room.getRoomId()%>'">
        <div class="chat-info">
            <div class="chat-avatar"></div>
            <div class="chat-text">
                <h3><%=room.getRoomName()%></h3>
                <p><%=room.getAddr1()%> <%=room.getAddr2()%></p>
            </div>
        </div>
        <div class="chat-menu">⋯</div>
    </div>
    <%
            }
        }
    %>
</div>




</body>
</html>
