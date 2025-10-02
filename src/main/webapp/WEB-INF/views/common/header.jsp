<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %> <%-- 세션 사용 선언 --%>

<style>
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
    .nav-user   { grid-area: auth; display:flex; gap:12px; justify-content:center; align-items:center; }
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
    .navitem span {
        display:inline-block;
        margin-left: var(--text-gap);
        transform: translateY(-40px);
        font-size: 22px;
        font-weight: 900;
    }

    /* 항목별 아이콘 크기/위치 조정 */
    .nav-home   { --icon-size:68px;  --icon-dy:-40px; --text-gap:0px;  }
    .nav-chat   { --icon-size:60px;  --icon-dy:-40px; --text-gap:6px;  }
    .nav-setting{ --icon-size:127px; --icon-dy:-40px; --text-gap:-30px; }
    .nav-user   { --icon-size:100px; --icon-dy:-40px; --text-gap:-30px; }

    /* 로그인 상태 메뉴 */
    .account{ position: relative; display:inline-flex; align-items:center; }
    .account-trigger{ display:inline-flex; align-items:center; gap:8px; cursor:pointer; }
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

    .account-trigger:hover + .account-dropdown,
    .account-dropdown:hover{
        max-height:300px; opacity:1; visibility:visible;
    }

    .nav-user.account { --dx: 18px; }
    .nav-user .nav-user-label{ transform:none !important; }
    .navitem.nav-user{ --icon-dy:-40px; }
    .navitem.nav-user .nav-user-label{ transform: translateY(-40px) !important; }

    .brand-img {
        position: relative;
        height: 160px;
        top: -40px;
        width: auto;
        object-fit: contain;
        pointer-events: none;
    }
</style>

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

    <!-- 로그인 여부 -->
    <% if (session.getAttribute("SS_USER_ID") == null) { %>
    <a class="navitem nav-user" onclick="openLogin()">
        <img src="/images/user.png" alt=""><span>로그인</span>
    </a>
    <% } else { %>
    <div class="navitem nav-user account">
        <div class="account-trigger">
            <img src="/images/user.png" alt="">
            <span class="nav-user-label"><%= (String)session.getAttribute("SS_USER_ID") %> 님</span>
        </div>
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
