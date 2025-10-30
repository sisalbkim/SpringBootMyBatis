<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 재설정</title>
    <style>
        /* 이 페이지 전용 스타일 */
        body {
            font-family: system-ui, -apple-system, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .card {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            width: 400px;
            text-align: center;
        }
        .form-title {
            font-size: 24px;
            margin-top: 0;
            margin-bottom: 24px;
        }
        .field {
            margin-bottom: 16px;
            text-align: left;
        }
        input {
            width: 100%;
            height: 44px;
            padding: 0 12px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
        }
        .btn-primary {
            width: 100%;
            height: 44px;
            border: 0;
            background: #2E5E4E;
            color: #fff;
            font-weight: 700;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 8px;
        }
        .message {
            margin-top: 16px;
            color: red;
        }
    </style>
</head>
<body>
<div class="card">
    <h2 class="form-title">비밀번호 재설정</h2>
    <form id="resetPasswordForm" method="post" action="/user/updatePassword">

        <input type="hidden" name="token" value="${token}">

        <div class="field">
            <input type="password" name="newPassword" placeholder="수정할 비밀번호" required>
        </div>
        <div class="field">
            <input type="password" name="confirmPassword" placeholder="수정할 비밀번호 확인" required>
        </div>

        <button type="submit" class="btn-primary">비밀번호 재설정</button>
    </form>
    <p class="message">${msg}</p> </div>
</body>
</html>
