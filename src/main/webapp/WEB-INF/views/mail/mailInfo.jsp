<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.dto.MailDTO" %>
<%@ page import="kopo.poly.util.CmmUtil" %>

<%
    MailDTO rDTO = (MailDTO) request.getAttribute("rDTO");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메일 상세보기</title>
    <link rel="stylesheet" href="/css/table.css"/>
    <style>
        /* 라벨 칸 폭 줄이기 */
        .labelCell {
            width: 120px;
            font-weight: bold;
            background-color: #f8f8f8;
            text-align: center;
        }
        .valueCell {
            padding-left: 10px;
            text-align: left;
        }
    </style>
    <script src="/js/jquery-3.7.1.min.js"></script>
    <script>
        $(document).ready(function () {
            $("#btnList").on("click", function () {
                location.href = "/mail/list";
            });
        });
    </script>
</head>
<body>
<div style="padding-left: 10px;">
    <h2 style="margin: 0;">
        <a href="/html/index.jsp" style="text-decoration: none; color: black;">메인화면으로</a>
    </h2>
    <h2 style="margin: 0;">메일 상세보기</h2>
</div>
<hr/>
<br/>
<div class="divTable minimalistBlack">
    <div class="divTableBody">
        <div class="divTableRow">
            <div class="divTableCell labelCell">받는사람</div>
            <div class="divTableCell valueCell"><%=CmmUtil.nvl(rDTO.getToMail())%></div>
        </div>
        <div class="divTableRow">
            <div class="divTableCell labelCell">제목</div>
            <div class="divTableCell valueCell"><%=CmmUtil.nvl(rDTO.getTitle())%></div>
        </div>
        <div class="divTableRow">
            <div class="divTableCell labelCell">발송일</div>
            <div class="divTableCell valueCell"><%=CmmUtil.nvl(rDTO.getSendDt())%></div>
        </div>
        <div class="divTableRow">
            <div class="divTableCell labelCell">내용</div>
            <div class="divTableCell valueCell" style="white-space:pre-wrap;"><%=CmmUtil.nvl(rDTO.getContents())%></div>
        </div>
    </div>
</div>
<div style="margin-top: 10px;">
    <button id="btnList" type="button">목록</button>
</div>
</body>
</html>
