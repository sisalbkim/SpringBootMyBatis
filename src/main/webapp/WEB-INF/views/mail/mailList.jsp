<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="kopo.poly.dto.MailDTO" %>
<%@ page import="kopo.poly.util.CmmUtil" %>

<%
    List<MailDTO> rList = (List<MailDTO>) request.getAttribute("rList");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>메일 발송 내역</title>
    <link rel="stylesheet" href="/css/table.css"/>
</head>
<body>
<div style="padding-left: 10px;">
    <h2 style="margin: 0;">
        <a href="/html/index.jsp" style="text-decoration: none; color: black;">메인화면으로</a>
    </h2>
    <h2 style="margin: 0;">메일 발송 내역</h2>
</div>
<hr/>
<br/>
<div class="divTable minimalistBlack">
    <div class="divTableHeading">
        <div class="divTableRow">
            <div class="divTableHead">받는사람</div>
            <div class="divTableHead">제목</div>
            <div class="divTableHead">내용</div>
            <div class="divTableHead">발송시간</div>
        </div>
    </div>
    <div class="divTableBody">
        <%
            if (rList != null) {
                for (MailDTO dto : rList) {
        %>
        <div class="divTableRow">
            <div class="divTableCell"><%=CmmUtil.nvl(dto.getToMail())%></div>

            <!-- 제목 한 번만 출력 & 클릭 이벤트 추가 -->
            <div class="divTableCell"
                 style="cursor:pointer; color:blue; text-decoration:underline;"
                 onclick="location.href='/mail/info?mailId=<%=dto.getMailId()%>'">
                <%=CmmUtil.nvl(dto.getTitle())%>
            </div>

            <div class="divTableCell"><%=CmmUtil.nvl(dto.getContents())%></div>
            <div class="divTableCell"><%=CmmUtil.nvl(dto.getSendDt())%></div>
        </div>
        <%
            }
        } else {
        %>
        <div class="divTableRow">
            <div class="divTableCell" colspan="4">발송된 메일이 없습니다.</div>
        </div>
        <%
            }
        %>
    </div>
</div>

</body>
</html>
