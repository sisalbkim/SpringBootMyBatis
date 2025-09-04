<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <script type="text/javascript" src="/js/jquery-3.7.1.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: url('/images/bg.png') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* 반투명 배경 */
        .overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.4);
            z-index: 1;
        }

        /* 로그인 박스 */
        .login-box {
            position: relative;
            z-index: 2;
            background: #fff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.25);
            width: 360px;
            text-align: center;
        }

        .login-box img.logo {
            width: 150px; /* 로고 크기 조절 */
            margin-bottom: 20px;
            cursor: pointer;
        }

        .login-box input {
            width: 90%;
            padding: 12px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .login-box button {
            width: 95%;
            padding: 12px;
            background: #4CAF50;
            border: none;
            border-radius: 6px;
            color: #fff;
            font-size: 15px;
            margin-top: 12px;
            cursor: pointer;
        }

        .login-box button:hover {
            background: #45a049;
        }

        .login-box .links {
            margin-top: 15px;
            font-size: 13px;
        }

        .login-box .links a {
            color: #333;
            text-decoration: none;
            margin: 0 5px;
        }

        .login-box .links a:hover {
            text-decoration: underline;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function (){
            $("#btnUserReg").on("click", function() {
                location.href = "/user/userRegForm";
            })
            $("#btnSearchUserId").on("click", function (){
                location.href = "/user/searchUserId";
            })
            $("#btnSearchPassword").on("click", function () {
                location.href = "/user/searchPassword";
            })
            $("#btnLogin").on("click", function(){
                let f = document.getElementById("f");

                if (f.userId.value === "") {
                    alert("아이디를 입력하세요.");
                    f.userId.focus();
                    return;
                }
                if (f.password.value === "") {
                    alert("비밀번호를 입력하세요.");
                    f.password.focus();
                    return;
                }

                $.ajax({
                    url:"/user/loginProc",
                    type:"post",
                    dataType:"JSON",
                    data: $("#f").serialize(),
                    success: function (json) {
                        if(json.result === 1) {
                            alert(json.msg);
                            location.href = "/user/loginResult";
                        } else {
                            alert(json.msg);
                            $("#userId").focus();
                        }
                    }
                })
            })
        })
    </script>
</head>
<body>

<div class="overlay"></div>

<div class="login-box">
    <!-- ✅ 로고 이미지 (클릭 시 메인화면 이동) -->
    <a href="/html/index.jsp">
        <img src="/images/logo.png" alt="Atalk Logo" class="logo">
    </a>

    <form id="f">
        <input type="text" name="userId" id="userId" placeholder="아이디" />
        <input type="password" name="password" id="password" placeholder="비밀번호" />

        <button id="btnLogin" type="button">로그인</button>
        <button id="btnUserReg" type="button">회원가입</button>

        <div class="links">
            <a href="/user/searchUserId">아이디 찾기</a> |
            <a href="/user/searchPassword">비밀번호 찾기</a>
        </div>
    </form>
</div>

</body>
</html>
