<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${roomInfo.roomName}</title>
    <style>
        body {
            margin: 0;
            font-family: 'Apple SD Gothic Neo', Arial, sans-serif;
            background: #ececec;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 상단 바 */
        .chat-header {
            background: #6a5acd;
            color: #fff;
            padding: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 16px;
        }

        .chat-header .title {
            font-weight: bold;
        }

        /* 메시지 영역 */
        .chat-messages {
            flex: 1;
            padding: 15px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        /* 말풍선 공통 */
        .message {
            max-width: 70%;
            margin-bottom: 12px;
            display: flex;
            align-items: flex-end;
        }

        /* 상대방 */
        .message.left {
            justify-content: flex-start;
        }
        .message.left .bubble {
            background: #fff;
            border-radius: 15px 15px 15px 0;
            padding: 10px 14px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* 나 */
        .message.right {
            justify-content: flex-end;
        }
        .message.right .bubble {
            background: #2f8f83;
            color: #fff;
            border-radius: 15px 15px 0 15px;
            padding: 10px 14px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* 닉네임 */
        .nickname {
            font-size: 11px;
            color: #666;
            margin: 0 5px;
        }

        /* 입력창 */
        .chat-input {
            display: flex;
            padding: 10px;
            background: #fff;
            border-top: 1px solid #ccc;
        }

        .chat-input input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 20px;
            outline: none;
        }

        .chat-input button {
            margin-left: 8px;
            padding: 10px 15px;
            background: #6a5acd;
            border: none;
            border-radius: 50%;
            color: #fff;
            cursor: pointer;
        }

        .chat-input button:hover {
            background: #5a4abc;
        }
    </style>
</head>
<body>

<div class="chat-header">
    <div class="title">${roomInfo.roomName}</div>
    <div class="menu">☰</div>
</div>

<div class="chat-messages">
    <!-- 예시 메시지 -->
    <div class="message left">
        <div class="bubble">야.. 뭐함?</div>
        <span class="nickname">친구A</span>
    </div>

    <div class="message right">
        <span class="nickname">나</span>
        <div class="bubble">몰라</div>
    </div>
</div>

<div class="chat-input">
    <input type="text" placeholder="채팅을 입력하세요"/>
    <button>➤</button>
</div>

</body>
</html>
