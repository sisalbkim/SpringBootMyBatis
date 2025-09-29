<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700;900&display=swap');

        body {
            margin: 0;
            font-family: "Noto Sans KR", sans-serif;
            background-image: url('/images/bg.png');   /* ✅ 배경 이미지 추가 */
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center center;
            height: 100vh;
            position: relative; /* overlay 얹기 위해 필요 */
        }

        /* ✅ 흐림 효과 오버레이 */
        body::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(255,255,255,0.7); /* 반투명 흰색 */
            backdrop-filter: blur(4px);        /* 블러 효과 */
            z-index: -1;                       /* 컨텐츠보다 뒤 */
        }

        /* ✅ container는 흰색 박스 느낌 유지 */
        .container {
            max-width: 700px;
            margin: 20px auto;
            padding: 10px;
            position: relative;
            z-index: 1;  /* overlay 위에 보이게 */
        }


        /* ✅ 상단바 스타일 (메인화면 기반) */
        .topbar {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            grid-template-areas: "home chat setting auth brand";
            align-items: center;
            height: 70px;
            padding: 0 24px;
            background: linear-gradient(to right, #5D584D 0%, #EAEAEA 80%, #F5F5F5 100%);
            border-bottom: 1px solid #cfcfcf;
        }

        .nav-home   { grid-area: home; }
        .nav-chat   { grid-area: chat; }
        .nav-setting{ grid-area: setting; }
        .nav-user   { grid-area: auth; display:flex; gap:12px; justify-content:center; align-items:center; }
        .brand-box  { grid-area: brand; display:flex; justify-content:center; align-items:center; }

        .navitem {
            --icon-size: 64px;
            --text-gap: 10px;
            display:flex;
            justify-content:center;
            align-items:center;
            font-weight:700;
            text-decoration:none;
            color:#565050;
        }
        .navitem img {
            width: var(--icon-size);
            height: var(--icon-size);
            object-fit: contain;
        }
        .navitem span {
            display:inline-block;
            margin-left: var(--text-gap);
            font-size:24px;
            font-weight:700;
        }

        .brand-img {
            height: 90px;
            width:auto;
            object-fit:contain;
            pointer-events:none;
        }

        /* ✅ 메인 컨테이너 */
        .container { max-width:700px; margin:20px auto; padding:10px; }

        #region-select { display:flex; gap:10px; margin:15px 0; }
        #region-select select, #region-select button {
            padding:8px; font-size:14px; border-radius:6px; border:1px solid #ccc;
        }

        /* ✅ 채팅방 카드 */
        .chat-room {
            display:flex; align-items:center; justify-content:space-between;
            background:#fff; padding:15px; margin-bottom:10px; border-radius:8px;
            box-shadow:0 2px 5px rgba(0,0,0,0.1); cursor:pointer; transition:background 0.2s;
        }
        .chat-room:hover { background:#f5f5f5; }

        .chat-info { display:flex; align-items:center; }
        .chat-avatar {
            width:50px; height:50px; background:#ccc; border-radius:50%;
            margin-right:15px; flex-shrink:0;
        }
        .chat-text h3 { margin:0; font-size:16px; font-weight:bold; }
        .chat-text p { margin:5px 0 0; font-size:13px; color:#666; }

        .chat-menu { font-size:20px; color:#555; }

        .empty-box {
            text-align:center; padding:40px; background:#fff;
            border-radius:10px; box-shadow:0 4px 10px rgba(0,0,0,0.1);
        }
        .create-btn {
            display:inline-block; margin-top:10px; padding:10px 20px;
            background:#4CAF50; color:#fff; border-radius:5px; text-decoration:none;
        }

        /* ✅ 모달 */
        #createRoomModal {
            display:none;
            position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(0,0,0,0.4);
            align-items:center; justify-content:center;
            z-index:999;
        }
        .form-box {
            background:#fff; padding:30px; border-radius:10px;
            box-shadow:0 4px 10px rgba(0,0,0,0.1); width:400px; text-align:center;
        }
        .form-box input, .form-box button {
            width:100%; padding:10px; margin-top:10px; border-radius:5px; border:1px solid #ddd;
        }
        .form-box button { background:#4CAF50; color:#fff; border:none; cursor:pointer; }
        .form-box button:hover { background:#45a049; }

        /* ✅ 페이지네이션 */
        .pagination { display:inline-flex; list-style:none; padding:0; margin:0; }
        .pagination li { margin:0 3px; }
        .pagination a, .pagination span {
            display:inline-block; padding:6px 12px;
            border:1px solid #ddd; border-radius:4px;
            text-decoration:none; color:#333; font-size:14px;
        }
        .pagination a:hover { background:#f0f0f0; }
        .pagination .active span {
            background:#4CAF50; color:#fff; border-color:#4CAF50; font-weight:bold;
        }
        .pagination .disabled span { color:#aaa; border-color:#eee; }
    </style>
</head>
<body>

<!-- ✅ 상단바 -->
<header class="topbar">
    <a class="navitem nav-home" href="/html/index.jsp">
        <img src="/images/home.png" alt=""><span>메인 화면</span>
    </a>
    <a class="navitem nav-chat" href="/chat/list">
        <img src="/images/door.png" alt=""><span>채팅</span>
    </a>
    <a class="navitem nav-setting" href="/settings">
        <img src="/images/setting.png" alt=""><span>설정</span>
    </a>

    <% if (session.getAttribute("SS_USER_ID") == null) { %>
    <a class="navitem nav-user" href="javascript:openLogin()">
        <img src="/images/user.png" alt=""><span>로그인</span>
    </a>

    <% } else { %>
    <div class="navitem nav-user">
        <img src="/images/user.png" alt="">
        <span><%= (String)session.getAttribute("SS_USER_NAME") %> 님</span>
        <a href="/user/logout" style="margin-left:10px; font-size:14px; color:#333;">로그아웃</a>
    </div>
    <% } %>

    <div class="brand-box">
        <img class="brand-img" src="/images/logo.png" alt="Atalk">
    </div>
</header>

<!-- ✅ 본문 -->
<div class="container">
    <!-- 지역 선택 -->
    <div id="region-select">
        <select id="sido"><option value="">시 선택</option></select>
        <select id="sigungu"><option value="">구 선택</option></select>
        <select id="dong"><option value="">동 선택</option></select>
        <button id="searchRoom">검색</button>
    </div>

    <%
        java.util.List<kopo.poly.dto.ChatDTO> chatList =
                (java.util.List<kopo.poly.dto.ChatDTO>) request.getAttribute("chatList");
        if (chatList == null || chatList.isEmpty()) {
    %>
    <div class="empty-box">
        <div style="font-size:50px; margin-bottom:10px;">💬</div>
        <h2>아직 개설된 채팅방이 없습니다</h2>
        <p>새로운 채팅방을 만들어보세요!</p>
        <a href="javascript:openModal()" class="create-btn">새 채팅방 만들기</a>
    </div>
    <% } else { %>
    <div class="chat-room" onclick="openModal()">
        <div class="chat-info">
            <div class="chat-avatar" style="background:#eee; font-size:24px; color:#666;
                 display:flex; align-items:center; justify-content:center;">+</div>
            <div class="chat-text">
                <h3>새로운 채팅방 추가</h3>
                <p>새로운 대화를 시작하세요</p>
            </div>
        </div>
    </div>

    <%  for (kopo.poly.dto.ChatDTO room : chatList) { %>
    <div class="chat-room"
         onclick="<%= (session.getAttribute("SS_USER_ID") == null)
                ? "openLogin()"
                : "location.href='/chat/room/" + room.getRoomId() + "'" %>">
        <div class="chat-info">
            <div class="chat-avatar"></div>
            <div class="chat-text">
                <h3><%=room.getRoomName()%></h3>
                <p><%=room.getAddr1()%> <%=room.getAddr2()%></p>
            </div>
        </div>
        <div class="chat-menu">⋯</div>
    </div>
    <%  } %>
    <%  } %> <!-- chatList if/else 닫기 -->

</div>

<!-- ✅ 모달 -->
<div id="createRoomModal">
    <div class="form-box">
        <h2>새 채팅방 만들기</h2>
        <form action="/chat/createProc" method="post">
            <input type="hidden" name="addr1" id="modalAddr1">
            <input type="hidden" name="addr2" id="modalAddr2">
            <input type="text" name="roomName" placeholder="채팅방 이름" required>
            <button type="submit">만들기</button>
            <button type="button" onclick="closeModal()" style="background:#ccc; margin-top:10px;">취소</button>
        </form>
    </div>
</div>

<!-- ✅ 페이지네이션 -->
<div style="margin-top:40px; margin-bottom:30px; text-align:center;">
    <%
        int currentPage = (int) request.getAttribute("currentPage");
        int totalPage = (int) request.getAttribute("totalPage");
        int startPage = (int) request.getAttribute("startPage");
        int endPage = (int) request.getAttribute("endPage");

        String addr1 = (String) request.getAttribute("addr1");
        String addr2 = (String) request.getAttribute("addr2");

        String queryBase = "";
        if (addr1 != null && !addr1.isEmpty() && addr2 != null && !addr2.isEmpty()) {
            queryBase = "addr1=" + java.net.URLEncoder.encode(addr1, "UTF-8")
                    + "&addr2=" + java.net.URLEncoder.encode(addr2, "UTF-8") + "&";
        }
    %>

    <ul class="pagination">
        <li class="<%= (currentPage > 1) ? "" : "disabled" %>">
            <% if (currentPage > 1) { %>
            <a href="?<%=queryBase%>page=<%=currentPage-1%>">이전</a>
            <% } else { %><span>이전</span><% } %>
        </li>

        <% if (startPage > 1) { %>
        <li><a href="?<%=queryBase%>page=1">1</a></li>
        <li><span>...</span></li>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
        <li class="<%= (i == currentPage) ? "active" : "" %>">
            <% if (i == currentPage) { %><span><%=i%></span>
            <% } else { %><a href="?<%=queryBase%>page=<%=i%>"><%=i%></a><% } %>
        </li>
        <% } %>

        <% if (endPage < totalPage) { %>
        <li><span>...</span></li>
        <li><a href="?<%=queryBase%>page=<%=totalPage%>"><%=totalPage%></a></li>
        <% } %>

        <li class="<%= (currentPage < totalPage) ? "" : "disabled" %>">
            <% if (currentPage < totalPage) { %>
            <a href="?<%=queryBase%>page=<%=currentPage+1%>">다음</a>
            <% } else { %><span>다음</span><% } %>
        </li>
    </ul>
</div>

<script>
    $(document).ready(function () {
        $.get("/region/sido", function (data) {
            data.forEach(function (sido) { $("#sido").append(new Option(sido, sido)); });
        });

        $("#sido").change(function () {
            let sido = $(this).val();
            $("#sigungu").empty().append(new Option("구 선택", ""));
            $("#dong").empty().append(new Option("동 선택", ""));
            if (sido) {
                $.get("/region/sigungu", {sido: sido}, function (data) {
                    data.forEach(function (gu) { $("#sigungu").append(new Option(gu, gu)); });
                });
            }
        });

        $("#sigungu").change(function () {
            let sido = $("#sido").val();
            let sigungu = $(this).val();
            $("#dong").empty().append(new Option("동 선택", ""));
            if (sigungu) {
                $.get("/region/dong", {sido: sido, sigungu: sigungu}, function (data) {
                    data.forEach(function (dong) { $("#dong").append(new Option(dong, dong)); });
                });
            }
        });

        $("#searchRoom").click(function () {
            let sido = $("#sido").val();
            let sigungu = $("#sigungu").val();
            let dong = $("#dong").val();
            if (!sido || !sigungu || !dong) { alert("시/구/동을 모두 선택해주세요!"); return; }
            location.href = "/chat/list?addr1=" + encodeURIComponent(sido + " " + sigungu) +
                "&addr2=" + encodeURIComponent(dong);
        });
    });

    function openModal() {
        const urlParams = new URLSearchParams(window.location.search);
        let addr1 = urlParams.get("addr1") || ($("#sido").val() + " " + $("#sigungu").val());
        let addr2 = urlParams.get("addr2") || $("#dong").val();
        $("#modalAddr1").val(addr1);
        $("#modalAddr2").val(addr2);
        $("#createRoomModal").css("display", "flex");
    }
    function closeModal() { $("#createRoomModal").hide(); }

    function openLogin() {
        $("#authModal").css("display", "flex").addClass("is-ready");
    }
    $(".modal-close, .modal-overlay").on("click", function () {
        $("#authModal").removeClass("is-ready").hide();
    });

</script>
<script src="/js/auth.js"></script>
<div id="modal-root"></div>
<%@ include file="/WEB-INF/views/common/authModal.jsp" %>

</body>
</html>
