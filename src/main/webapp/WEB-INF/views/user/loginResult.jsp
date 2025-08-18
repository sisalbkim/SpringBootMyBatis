<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.dto.UserInfoDTO" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%
  String ssUserName = CmmUtil.nvl((String) session.getAttribute("SS_USER_NAME"));
  String ssUserId = CmmUtil.nvl((String) session.getAttribute("SS_USER_ID"));
%>
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
  <meta charset="UTF-8">
  <title>로그인 성공</title>
  <link rel="stylesheet" href="/css/table.css"/>
  <script type="text/javascript" src="/js/jquery-3.7.1.min.js"></script>
  <script type="text/javascript">

    $(document).ready(function () {

      $("#btnSend").on("click", function () {

        location.href = "/html/index.html";
      })
    })
  </script>
</head>
<body>
<div style="display: flex; align-items: center; gap: 50px; padding-left: 10px;">
  <h2 style="margin: 0;">
    <a href="/html/index.html" style="text-decoration: none; color: black;">메인화면으로</a>
  </h2>
  <h2 style="margin: 0;">로그인완료</h2>
</div>
<div class="divTable minimalistBlack">
  <div class="divTableBody">
    <div class="divTableRow">
      <div class="divTableCell">로그인된 사용자이름
      </div>
      <div class="divTableCell"><%=ssUserName%>님이 로그인하였습니다.</div>
    </div>
    <div class="divTableRow">
      <div class="divTableCell">로그인된 사용자아이디
      </div>
      <div class="divTableCell"><%=ssUserId%> 입니다.</div>
    </div>
  </div>
</div>
<div></div>
<br/><br/>
<button id="btnSend" type="button">메인 화면 이동</button>
</body>
</html>