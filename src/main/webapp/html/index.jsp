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
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700;900&display=swap');

        body {
            margin: 0;
            font-family: "Noto Sans KR", sans-serif;
            background-image: url('/images/bg.png');
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center center;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* 🔹 기존 .navbar 관련 코드는 삭제/대체 */
        /* 상단바 새 디자인 */
        .topbar {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            grid-template-areas: "home chat setting auth brand";
            align-items: center;
            height: 80px;
            padding: 0 36px;
            background: linear-gradient(to right, #5D584D 0%, #EAEAEA 80%, #F5F5F5 100%);
            border-bottom: 1px solid #cfcfcf;
        }

        .nav-home   { grid-area: home; }
        .nav-chat   { grid-area: chat; }
        .nav-setting{ grid-area: setting; }
        .nav-user  { grid-area: auth; display:flex; gap:12px; justify-content:center; align-items:center; }
        .brand-box  { grid-area: brand; position:relative; display:flex; justify-content:center; align-items:center; }

        .navitem {
            --icon-size: 30px;
            --icon-dy: 0px;
            --text-gap: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 700;
            text-decoration: none;
            color: #565050;
        }
        .navitem img {
            width: var(--icon-size);
            height: var(--icon-size);
            transform: translateY(var(--icon-dy));
            object-fit: contain;
        }
        .navitem span{
            display:inline-block;
            margin-left: var(--text-gap);
            transform: translateY(-40px);
            font-size: 22px;   /* ← 글자 크기 추가 */
            font-weight: 900;  /* ← 글자 굵기 */
        }

        /* 항목별 미세 조정 */
        .nav-home   { --icon-size:68px;  --icon-dy:-40px; --text-gap:0px;  }
        .nav-chat   { --icon-size:60px;  --icon-dy:-40px; --text-gap:6px;  }
        .nav-setting{ --icon-size:127px; --icon-dy:-40px; --text-gap:-30px; }
        .nav-user   { --icon-size:100px;  --icon-dy:-40px; --text-gap:-30px; }

        /* 로그인 상태 내부 배치 */
        .auth-logged-in { display:flex; align-items:center; gap:14px; }
        .auth-name      { display:flex; align-items:center; gap:8px; }
        .auth-logout    { text-decoration:none; font-weight:700; }

        /* 로고 크기/위치 */
        .brand-img {
            position: relative;
            height: 160px;
            top: -40px;
            width: auto;
            object-fit: contain;
            pointer-events: none;
        }

        /* ===========================
   형의 HTML에 맞춘 중앙 영역 스타일
   (로고: .logo img,  주소 CTA: .message-box)
   =========================== */

        /* 중앙 로고 컨테이너: 화면 가운데로 */
        .logo img {
            height: 200px;       /* 크기 */
            margin-top: 0px;   /* 위로 올림 */
            display: block;
            margin-left: auto;
            margin-right: auto;  /* 가운데 정렬 */
        }


        /* 로고 이미지 크기/효과 */
        .logo img{
            height: 420px;            /* 로고 크기 (200~320px에서 조절 추천) */
            width: auto;
            display:block;
            pointer-events:none;
            filter: drop-shadow(0 6px 22px rgba(0,0,0,.24));
        }

        /* 주소 CTA(말풍선 느낌) — 형 HTML의 .message-box에 적용 */
        .message-box {
            min-width: 700px;                /* 네가 추가한 가로 크기 */
            max-width: 80vw;
            margin-top: -540px;                /* 위치는 자연스럽게 */

            background-color: rgba(255,255,255,0.9); /* 형 코드: 반투명 흰색 */
            border-radius: 9999px;           /* 네 코드: pill 형태 */

            padding: 18px 10px;              /* 두 코드 절충: 세로 20, 가로 28 */
            font-size: 18px;                 /* 네 코드에서 글자 크게 */
            font-weight: 600;
            color:#333;

            box-shadow: 0 8px 20px rgba(0,0,0,.15);  /* 네 코드(강한 그림자)와 형 코드(얇은 그림자) 중간 */
            text-align: center;
            cursor: pointer;                 /* 형 코드: 마우스 포인터 */
        }

        /* 반응형 (선택) */
        @media (max-width: 760px){
            .logo{ padding-top: 10vh; }
            .logo img{ height: 140px; }
            .message-box{
                min-width: 0;
                width: 88vw;
                padding: 12px 16px;
                font-size: 16px;
            }
        }


        /* ✅ 여기까지가 상단바(네비게이션) */
        /* 아래부터는 기존 내용 그대로 유지 */

        .content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
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

        /* 트리거(아이콘+이름) */
        .account{ position: relative; display:inline-flex; align-items:center; }
        .account-trigger{ display:inline-flex; align-items:center; gap:8px; cursor:pointer; }

        /* 드롭다운: 서랍처럼 펼쳐짐(초기 접힘) */
        .account-dropdown{
            position:absolute;
            top: calc(100% + -49px);
            left:50%;
            transform: translateX(calc(-50% + var(--dx, 0px)));
            background:#fff; border:1px solid #ddd; border-radius:6px;
            min-width:160px; box-shadow:0 8px 16px rgba(0,0,0,.15);
            max-height:0; overflow:hidden; opacity:0; visibility:hidden;
            transition:max-height .55s ease, opacity .35s ease;
            z-index:100;
        }
        .account-dropdown a{ display:block; padding:10px 14px; color:#333; text-decoration:none; font-weight:600; }
        .account-dropdown a:hover{ background:#f5f5f5; }

        /* 트리거에 올리면 열리고, 메뉴 위에 있어도 열린 상태 유지 */
        .account-trigger:hover + .account-dropdown,
        .account-dropdown:hover{
            max-height:300px; opacity:1; visibility:visible;
        }

        /* 좌우 미세조정(원하면 숫자만 바꿔) */
        .nav-user.account { --dx: 18px; }

        /* 유저명은 전역 -40px 규칙 끄기 */
        .nav-user .nav-user-label{ transform:none !important; }

        /* (옵션) 아이콘이 위로 떠 있으면 아이콘 오프셋 0으로 */
        .navitem.nav-user{ --icon-dy: 0; }

        /* 유저 메뉴 전용 오프셋 */
        .navitem.nav-user { --icon-dy: -40px; }                 /* 아이콘 ↑ */
        .navitem.nav-user .nav-user-label { transform: translateY(-40px) !important; }  /* 글자 ↑ */

    </style>



</head>
<body>
<!-- 상단 메뉴 -->
<header class="topbar">
    <!-- 메인 -->
    <a class="navitem nav-home" href="/html/index.jsp">
        <img src="/images/home.png" alt=""><span>메인 화면</span>
    </a>

    <!-- 채팅 -->
    <a class="navitem nav-chat" href="/chat/list">
        <img src="/images/door.png" alt=""><span>채팅</span>
    </a>

    <!-- 설정 -->
    <a class="navitem nav-setting" href="/settings">
        <img src="/images/setting.png" alt=""><span>설정</span>
    </a>

    <!-- 로그인 여부에 따라 분기 -->
    <% if (session.getAttribute("SS_USER_ID") == null) { %>
    <!-- 로그인 버튼 (모달 열기) -->
    <a class="navitem nav-user" onclick="openLogin()">
        <img src="/images/user.png" alt=""><span>로그인</span>
    </a>
    <% } else { %>
    <!-- 로그인 되어 있으면: 유저명 표시 + 로그아웃 -->
    <div class="navitem nav-user account">
        <!-- 🔥 트리거 부분 (아이콘 + 아이디) -->
        <div class="account-trigger">
            <img src="/images/user.png" alt="">
            <span class="nav-user-label"><%= (String)session.getAttribute("SS_USER_NAME") %> 님</span>
        </div>

        <!-- 🔥 드롭다운 메뉴 -->
        <div class="account-dropdown">
            <a href="/user/myProfile">My프로필</a>
            <a href="/user/logout">로그아웃</a>
        </div>
    </div>
    <% } %>

    <!-- 브랜드 로고 -->
    <div class="brand-box">
        <img class="brand-img" src="/images/logo.png" alt="Atalk">
    </div>
</header>

    <div class="logo">
        <img src="/images/logo.png" alt="Atalk 로고">
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
                // addr1 = 시/도 + 시/군/구
                var addr1 = (data.sido || '') + (data.sigungu ? ' ' + data.sigungu : '');

                // 기본 addr2 = 읍/면/동 + 리까지 올 수 있음
                var addr2 = data.bname || '';

                // ✅ 마지막 단어가 '리'로 끝나면 제거
                if (addr2.endsWith("리")) {
                    // 예: "강동면 정동리" → "강동면"
                    addr2 = addr2.replace(/ [^ ]*리$/, "");
                }

                // 채팅방 목록으로 이동
                var url = "/chat/list?addr1=" + encodeURIComponent(addr1)
                    + "&addr2=" + encodeURIComponent(addr2);

                window.location.href = url;
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
