<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %> <%-- 세션 사용 선언 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메인화면</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <script src="/js/jquery-3.7.1.min.js"></script>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-image: url('/images/bg.png');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center center;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            background-color: rgba(255, 255, 255, 0.9);
            display: flex;
            justify-content: space-evenly;
            align-items: center;
            padding: 15px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .navbar a, .navbar span {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            font-size: 16px;
            cursor: pointer;
        }
        .logo img { height: 30px; }
        .content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .message-box {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 15px 25px;
            border-radius: 25px;
            font-size: 16px;
            color: #333;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            cursor: pointer;
        }
        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: #fff;
            padding: 40px;
            border-radius: 10px;
            width: 700px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            position: relative;
        }
        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 20px;
            cursor: pointer;
        }
        .modal-content input {
            width: 90%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .modal-content button {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            border: none;
            border-radius: 5px;
            background: #2b6cb0;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
        .modal-content button:hover {
            background: #1e4d7a;
        }
    </style>
</head>
<body>
<!-- 상단 메뉴 -->
<div class="navbar">
    <a href="#">메인 화면</a>
    <a href="#">채팅</a>
    <a href="#">설정</a>

    <%-- ✅ 로그인 여부에 따라 분기 --%>
    <% if (session.getAttribute("SS_USER_ID") == null) { %>
    <a onclick="openLogin()">로그인</a>
    <% } else { %>
    <span><%= session.getAttribute("SS_USER_NAME") %> 님</span>
    <a href="/user/logout">로그아웃</a>
    <% } %>


    <div class="logo">
        <img src="/images/logo.png" alt="Atalk 로고">
    </div>
</div>

<!-- 중앙 메시지 -->
<div class="content">
    <div class="message-box" onclick="openDaumPostcode()">
        주소를 입력해 위치를 찾아서 채팅을 시작하세요
    </div>
</div>

<!-- 카카오 주소 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function openDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                alert("선택된 주소: " + data.address);
            }
        }).open();
    }
</script>

<!-- 로그인 모달 -->
<div id="loginModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeLogin()">&times;</span>
        <div style="text-align:center; margin-bottom:15px;">
            <img src="/images/logo.png" alt="Atalk 로고" style="height:50px;">
        </div>
        <h2 style="text-align:center; margin:10px 0;">로그인</h2>
        <form id="loginForm" style="text-align:center;">
            <input type="text" name="userId" id="userId" placeholder="아이디" style="width:70%; margin:8px 0;"><br>
            <input type="password" name="password" id="password" placeholder="비밀번호" style="width:70%; margin:8px 0;"><br>
            <button id="btnLogin" type="button" style="width:75%; margin-top:10px;">로그인</button>
        </form>
        <div style="display:flex; justify-content:space-between; margin-top:15px; font-size:14px;">
            <div>
                <span id="btnUserReg" style="color:#2b6cb0; cursor:pointer; text-decoration:underline;">
                    아직 계정이 없다면?
                </span>
            </div>
            <div>
                <span id="btnSearchUserId" style="color:#2b6cb0; cursor:pointer; margin-right:10px; text-decoration:underline;">아이디 찾기</span>
                /
                <span id="btnSearchPassword" style="color:#2b6cb0; cursor:pointer; margin-left:10px; text-decoration:underline;">비밀번호 찾기</span>
            </div>
        </div>
    </div>
</div>

<!-- 회원가입 모달 -->
<div id="signupModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeSignup()">&times;</span>
        <div style="text-align:center; margin-bottom:15px;">
            <img src="/images/logo.png" alt="Atalk 로고" style="height:50px;">
        </div>
        <h2 style="text-align:center; margin:10px 0;">회원가입</h2>
        <form id="signupForm">
            <div style="display:flex; align-items:center; justify-content:space-between; margin:8px 0;">
                <input type="text" name="userId" id="signupUserId" placeholder="아이디" style="flex:1; margin-right:5px;">
                <button id="btnUserId" type="button" style="width:120px;">중복체크</button>
            </div>
            <input type="text" name="userName" placeholder="이름" style="width:100%; margin:8px 0;">
            <input type="password" name="password" placeholder="비밀번호" style="width:100%; margin:8px 0;">
            <input type="password" name="password2" placeholder="비밀번호 확인" style="width:100%; margin:8px 0;">
            <div style="display:flex; align-items:center; justify-content:space-between; margin:8px 0;">
                <input type="email" name="email" id="signupEmail" placeholder="이메일주소" style="flex:1; margin-right:5px;">
                <button id="btnEmail" type="button" style="width:120px;">인증</button>
            </div>
            <input type="text" name="authNumber" id="authNumber" placeholder="메일 인증번호" style="width:100%; margin:8px 0;">
            <div style="display:flex; align-items:center; justify-content:space-between; margin:8px 0;">
                <input type="text" name="addr1" id="addr1" placeholder="주소" style="flex:1; margin-right:5px;">
                <button id="btnAddr" type="button" style="width:120px;">우편번호</button>
            </div>
            <input type="text" name="addr2" id="addr2" placeholder="상세주소" style="width:100%; margin:8px 0;">
            <button id="btnSend" type="button" style="width:100%; margin-top:15px;">회원가입</button>
        </form>
    </div>
</div>

<script>
    function openLogin() { document.getElementById("loginModal").style.display = "flex"; }
    function closeLogin() { document.getElementById("loginModal").style.display = "none"; }
    function openSignup() { document.getElementById("signupModal").style.display = "flex"; }
    function closeSignup() { document.getElementById("signupModal").style.display = "none"; }
    window.onclick = function(event) {
        if (event.target === document.getElementById("loginModal")) closeLogin();
        if (event.target === document.getElementById("signupModal")) closeSignup();
    }

    $(document).ready(function () {
        $("#btnLogin").on("click", function(){
            let f = document.getElementById("loginForm");
            if (f.userId.value === "") { alert("아이디를 입력하세요."); f.userId.focus(); return; }
            if (f.password.value === "") { alert("비밀번호를 입력하세요."); f.password.focus(); return; }

            $.ajax({
                url:"/user/loginProc",
                type:"post",
                dataType:"JSON",
                data: $("#loginForm").serialize(),
                success: function (json) {
                    if(json.result === 1) {
                        alert(json.msg);
                        location.href = "/"; // ✅ 로그인 성공 시 메인으로 이동
                    } else {
                        alert(json.msg);
                        $("#userId").focus();
                    }
                }
            })
        });

        $("#btnUserReg").on("click", function() { closeLogin(); openSignup(); });
        $("#btnSearchUserId").on("click", function () { location.href = "/user/searchUserId"; });
        $("#btnSearchPassword").on("click", function () { location.href = "/user/searchPassword"; });

        $("#btnUserId").on("click", function () {
            let f = document.getElementById("signupForm");
            if (f.userId.value === "") { alert("아이디를 입력하세요."); f.userId.focus(); return; }
            $.ajax({
                url: "/user/getUserIdExists",
                type: "post",
                dataType: "JSON",
                data: $("#signupForm").serialize(),
                success: function (json) {
                    if (json.existsYn === "Y") { alert("이미 가입된 아이디입니다."); f.userId.focus(); }
                    else { alert("사용 가능한 아이디입니다."); userIdCheck = "N"; }
                }
            });
        });

        $("#btnEmail").on("click", function () {
            let f = document.getElementById("signupForm");
            if (f.email.value === "") { alert("이메일을 입력하세요."); f.email.focus(); return; }
            $.ajax({
                url: "/user/getEmailExists",
                type: "post",
                dataType: "JSON",
                data: $("#signupForm").serialize(),
                success: function (json) {
                    if (json.existsYn === "Y") { alert("이미 가입된 이메일입니다."); f.email.focus(); }
                    else { alert("이메일로 인증번호가 발송되었습니다."); emailAuthNumber = json.authNumber; }
                }
            });
        });

        $("#btnAddr").on("click", function () {
            let f = document.getElementById("signupForm");
            new daum.Postcode({
                oncomplete: function (data) { f.addr1.value = "(" + data.zonecode + ") " + data.address; }
            }).open();
        });

        $("#btnSend").on("click", function () {
            let f = document.getElementById("signupForm");
            if (f.userId.value === "" || userIdCheck !== "N") { alert("아이디를 확인하세요."); return; }
            if (f.userName.value === "") { alert("이름을 입력하세요."); return; }
            if (f.password.value === "" || f.password2.value === "") { alert("비밀번호를 입력하세요."); return; }
            if (f.password.value !== f.password2.value) { alert("비밀번호가 일치하지 않습니다."); return; }
            if (f.email.value === "") { alert("이메일을 입력하세요."); return; }
            if (f.authNumber.value === "" || f.authNumber.value != emailAuthNumber) { alert("이메일 인증번호가 올바르지 않습니다."); return; }
            if (f.addr1.value === "") { alert("주소를 입력하세요."); return; }
            if (f.addr2.value === "") { alert("상세주소를 입력하세요."); return; }

            $.ajax({
                url: "/user/insertUserInfo",
                type: "post",
                dataType: "JSON",
                data: $("#signupForm").serialize(),
                success: function (json) {
                    if(json.result === 1) {
                        alert(json.msg);
                        closeSignup();
                        openLogin();
                    } else { alert(json.msg); }
                }
            });
        });
    });
</script>
</body>
</html>
