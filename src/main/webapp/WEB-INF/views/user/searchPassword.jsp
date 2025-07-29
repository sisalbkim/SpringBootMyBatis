<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 찾기</title>
  <link rel="stylesheet" href="/css/table.css"/>
  <script type="text/javascript" src="/js/jquery-3.7.1.min.js"></script>
  <script type="text/javascript">
    $(document).ready(function () {

      $("#btnLogin").on("click", function () {
        location.href = "/user/login";
      })
      $("#btnSearchPassword").on("click", function() {
        let f = document.getElementById("f");

        if (f.userId.value === "") {
          alert("아이디를 입력하세요.");
          f.userId.focus();
          return;
        }

        if (f.userName.value === "") {
          alert("이름을 입력하세요.");
          f.userName.focus();
          return;
        }

        if (f.email.value === "") {
          alert("이메일을 입력하세요.");
          f.email.focus();
          return;
        }

        f.method = "post";
        f.action = "/user/searchPasswordProc"

        f.submit();

      })
    })
  </script>
</head>
<body>
<h2>비밀번호 찾기</h2>
<hr/>
<br/>
<form id="f">
  <div class="divTable minimalistBlack">
    <div class="divTableBody">
      <div class="divTableRow">
        <div class="divTableCell">아이디
        </div>
        <div class="divTableCell">
          <input type="text" name="userId" id="userId" style="width: 95%"/>
        </div>
      </div>
      <div class="divTableRow">
        <div class="divTableCell">이름
        </div>
        <div class="divTableCell">
          <input type="text" name="userName" id="userName" style="width: 95%"/>
        </div>
      </div>
      <div class="divTableRow">
        <div class="divTableCell">이메일
        </div>
        <div class="divTableCell">
          <input type="text" name="email" id="email" style="width: 95%"/>
        </div>
      </div>
    </div>
  </div>
  <div>
    <button id="btnSearchPassword" type="button">비밀번호 찾기</button>
    <button id="btnLogin" type="button">로그인</button>
  </div>
</form>
</body>
</html>
