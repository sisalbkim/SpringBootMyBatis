<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>채팅방 목록</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background-color: #f9f9f9; }

        .navbar {
            background: #eee; padding: 15px; display: flex; justify-content: space-evenly;
            align-items: center; border-bottom: 1px solid #ddd;
        }

        .container { max-width: 700px; margin: 20px auto; padding: 10px; }

        #region-select {
            display: flex; gap: 10px; margin: 15px 0;
        }
        #region-select select, #region-select button {
            padding: 8px; font-size: 14px; border-radius: 6px; border: 1px solid #ccc;
        }

        .chat-room {
            display: flex; align-items: center; justify-content: space-between;
            background: #fff; padding: 15px; margin-bottom: 10px; border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); cursor: pointer; transition: background 0.2s;
        }
        .chat-room:hover { background: #f5f5f5; }

        .chat-info { display: flex; align-items: center; }
        .chat-avatar {
            width: 50px; height: 50px; background: #ccc; border-radius: 50%;
            margin-right: 15px; flex-shrink: 0;
        }
        .chat-text h3 { margin: 0; font-size: 16px; font-weight: bold; }
        .chat-text p { margin: 5px 0 0; font-size: 13px; color: #666; }

        .chat-menu { font-size: 20px; color: #555; }

        .empty-box {
            text-align: center; padding: 40px; background: #fff;
            border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .create-btn {
            display: inline-block; margin-top: 10px; padding: 10px 20px;
            background: #4CAF50; color: #fff; border-radius: 5px; text-decoration: none;
        }

        /* ✅ 모달 스타일 */
        /* ✅ 모달 기본은 닫혀 있어야 함 */
        #createRoomModal {
            display:none; /* 기본 닫힘 */
            position:fixed; top:0; left:0; width:100%; height:100%;
            background:rgba(0,0,0,0.4);
            align-items:center; justify-content:center;
            z-index:999;
        }

        .form-box {
            background: #fff; padding: 30px; border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 400px; text-align: center;
        }
        .form-box input, .form-box button {
            width: 100%; padding: 10px; margin-top: 10px; border-radius: 5px; border: 1px solid #ddd;
        }
        .form-box button {
            background: #4CAF50; color: #fff; border: none; cursor: pointer;
        }
        .form-box button:hover { background: #45a049; }
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
    <!-- 채팅방 없을 때 -->
    <div class="empty-box">
        <div style="font-size: 50px; margin-bottom: 10px;">💬</div>
        <h2>아직 개설된 채팅방이 없습니다</h2>
        <p>새로운 채팅방을 만들어보세요!</p>
        <a href="javascript:openModal()" class="create-btn">새 채팅방 만들기</a>
    </div>
    <%
    } else {
    %>
    <!-- 채팅방 있을 때만 “새 채팅방 추가” 버튼 -->
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
    <%  } } %>
</div>

<!-- ✅ 모달은 조건과 상관없이 항상 DOM에 있어야 함 -->
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

<script>
    $(document).ready(function () {
        // 시 목록
        $.get("/region/sido", function (data) {
            data.forEach(function (sido) { $("#sido").append(new Option(sido, sido)); });
        });

        // 시 → 구
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

        // 구 → 동
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

        // 검색 버튼
        $("#searchRoom").click(function () {
            let sido = $("#sido").val();
            let sigungu = $("#sigungu").val();
            let dong = $("#dong").val();

            if (!sido || !sigungu || !dong) {
                alert("시/구/동을 모두 선택해주세요!");
                return;
            }
            location.href = "/chat/list?addr1=" + encodeURIComponent(sido + " " + sigungu) +
                "&addr2=" + encodeURIComponent(dong);
        });
    });

    function openModal() {
        // 현재 URL에서 addr1, addr2 파라미터 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        let addr1 = urlParams.get("addr1") || ($("#sido").val() + " " + $("#sigungu").val());
        let addr2 = urlParams.get("addr2") || $("#dong").val();

        $("#modalAddr1").val(addr1);
        $("#modalAddr2").val(addr2);
        $("#createRoomModal").css("display", "flex");
    }


</script>

</body>
</html>
