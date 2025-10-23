<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <style>
        :root{
            /* Green palette */
            --g-900:#0f3d2e;
            --g-700:#156f52;
            --g-600:#1c8a66;
            --g-500:#22a374;
            --g-300:#a7e3c8;
            --g-200:#d8f3e7;
            --g-100:#eefaf4;

            --text:#0f1a14;
            --muted:#587467;
            --radius:16px;
            --gap:28px;
        }
        *{box-sizing:border-box}
        body{margin:0;font-family:"Noto Sans KR",sans-serif;color:var(--text);background:#fff}

        /* Top bar */
        .topbar{display:flex;align-items:center;justify-content:space-between;padding:28px 32px}
        .brand a{font-size:32px;font-weight:900;text-decoration:none;color:var(--g-900)}
        .page-title{font-size:24px;font-weight:900;color:var(--g-900)}

        /* Layout */
        .wrap{padding:0 32px 32px}
        .grid{display:grid;grid-template-columns:320px 1fr;gap:var(--gap);align-items:start}
        @media (max-width:980px){.grid{grid-template-columns:1fr}}

        /* Cards */
        .card{border-radius:var(--radius);padding:22px;background:var(--g-100);border:1px solid var(--g-200)}
        .card.deep{background:#f7f9f8}
        .title{font-size:18px;font-weight:900;margin:0 0 12px;color:var(--g-900)}
        .muted{color:var(--muted);font-size:13px}

        /* Profile summary */
        .profile{display:flex;align-items:center;gap:14px}
        .avatar{width:84px;height:84px;border-radius:50%;object-fit:cover;background:#eee;border:3px solid var(--g-300)}
        .name{font-weight:900;font-size:20px;color:var(--g-700)}

        /* Forms */
        .field{display:flex;flex-direction:column;gap:6px;margin-bottom:12px}
        input[type="file"]{padding:8px;border:1px solid #d9e7df;border-radius:10px;background:#fff}
        .btn{display:inline-block;padding:10px 14px;border-radius:10px;border:1px solid var(--g-600);background:#fff;color:var(--g-700);cursor:pointer;font-weight:700}
        .btn.primary{background:var(--g-600);color:#fff;border-color:var(--g-600)}
        .btn.ghost{border-color:#cfe7dc;color:var(--g-700)}
        .stack{display:flex;flex-direction:column;gap:18px}

        /* Right list */
        .list table{width:100%;border-collapse:collapse;background:#fff;border-radius:12px;overflow:hidden}
        .list thead th{background:var(--g-100);color:var(--g-900)}
        .list th,.list td{padding:12px 14px;border-bottom:1px solid #eef3ef;text-align:left}
        .pagination{display:flex;gap:6px;justify-content:flex-end;margin-top:12px}
        .pagination a{padding:6px 10px;border:1px solid #d9e7df;border-radius:8px;text-decoration:none;color:var(--g-700)}
        .pagination .on{background:var(--g-600);color:#fff;border-color:var(--g-600)}
        a{color:var(--g-700);text-decoration:none}
        a:hover{text-decoration:underline}
    </style>
</head>
<body>

<!-- Top -->
<div class="topbar">
    <div class="brand"><a href="/">Atalk</a></div>
    <div class="page-title">마이페이지</div>
</div>

<div class="wrap">
    <div class="grid">

        <!-- Left column -->
        <div class="stack">
            <!-- 회원정보 카드: 프로필 이미지 + 이름만 -->
            <section class="card deep">
                <div class="title">회원정보</div>
                <div class="profile">
                    <img class="avatar"
                         src="${empty me.profileImageUrl ? '/images/default-avatar.png' : me.profileImageUrl}"
                         alt="프로필">
                    <div>
                        <div class="name">${me.userName}</div>
                    </div>
                </div>
            </section>

            <!-- 프로필 이미지 변경 -->
            <section class="card">
                <div class="title">프로필 이미지 변경</div>
                <form action="/mypage/profile-image" method="post" enctype="multipart/form-data">
                    <div class="field">
                        <label class="muted">새 이미지 파일 선택</label>
                        <input type="file" name="file" accept="image/*"/>
                    </div>
                    <button class="btn primary" type="submit">업로드</button>
                </form>
            </section>

            <!-- 회원정보 수정(추후 연결) -->
            <section class="card">
                <div class="title">회원정보 수정</div>
                <p class="muted" style="margin:0 0 10px"></p>
                <!-- 나중에 원하는 링크로 교체 -->
                <button class="btn ghost" type="button" onclick="alert('준비 중입니다.')">열기</button>
            </section>
        </div>

        <!-- Right column: 참여한 채팅방 -->
        <section class="card" style="background:var(--g-100)">
            <h2 class="title">참여한 채팅방</h2>
            <div class="list">
                <table>
                    <thead>
                    <tr>
                        <th style="width:45%">방 이름</th>
                        <th style="width:12%">인원</th>
                        <th style="width:43%">최근 메시지 / 시간</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${myRooms}">
                        <tr>
                            <td><a href="/chat/room?roomId=${r.roomId}">${r.roomName}</a></td>
                            <td>${r.memberCnt}</td>
                            <td>
                                <div style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                    <c:out value="${r.lastMsg}" />
                                </div>
                                <div class="muted">${r.lastMsgAt}</div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty myRooms}">
                        <tr><td colspan="3" class="muted">참여한 채팅방이 없습니다.</td></tr>
                    </c:if>
                    </tbody>
                </table>

                <div class="pagination">
                    <c:set var="totalPage" value="${(roomTotal + roomSize - 1) / roomSize}" />
                    <c:forEach var="i" begin="1" end="${totalPage}">
                        <a href="/mypage?roomPage=${i}" class="<c:if test='${i==roomPage}'>on</c:if>">${i}</a>
                    </c:forEach>
                </div>
            </div>
        </section>

    </div>
</div>
</body>
</html>
