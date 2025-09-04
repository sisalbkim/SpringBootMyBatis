<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>채팅방 만들기</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .form-box {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            width: 400px;
            text-align: center;
        }
        input, button {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
        button {
            background: #4CAF50;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background: #45a049;
        }
    </style>
</head>
<body>
<div class="form-box">
    <h2>새 채팅방 만들기</h2>
    <form action="/chat/createProc" method="post">
        <input type="text" name="roomName" placeholder="채팅방 이름" required>
        <input type="text" name="addr1" placeholder="시/도 (예: 서울특별시)" required>
        <input type="text" name="addr2" placeholder="구/도로명 (예: 금천구 가산로)" required>
        <button type="submit">만들기</button>
    </form>


</div>
</body>
</html>
