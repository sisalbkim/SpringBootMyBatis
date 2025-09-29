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
            margin-top: 0;   /* 위로 올림 */
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
        .nav-user img,
        .nav-user span {
            cursor: pointer;
        }

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
            <span class="nav-user-label"><%= (String)session.getAttribute("SS_USER_ID") %> 님</span>
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
                alert("선택된 주소: " + data.address);
            }
        }).open();
    }
</script>

<script src="/js/auth.js"></script>

<div id="modal-root"></div>

</body>
</html>
