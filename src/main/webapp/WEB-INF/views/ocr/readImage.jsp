<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>

<%

    String res = CmmUtil.nvl((String) request.getAttribute("res"));

    res = res.replaceAll("\n", " ");
    res = res.replaceAll("\"", " ");


%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>이미지 파일로부터 인식된 문자열 읽어주기</title>
        <link rel="stylesheet" href="/css/table.css"/>
        <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
        <script>
            const myOcrText = "<%= res %>";


            $(document).ready(function() {
                $("#btnTextRead").on("click", function() {
                speak(myOcrText);
                })
            })

            // 문자열 읽기 함수
            function speak(text) {
                if (typeof SpeechSynthesisUtterance === "undefined" ||
                    typeof window.speechSynthesis === "undefined") {
                    alert("이 브라우저는 문자읽기 기능을 지원하지 않습니다.");
                    return;
                }

                window.speechSynthesis.cancel(); // 현재 읽고있다면 초기화

                const speechMsg = new SpeechSynthesisUtterance();
                speechMsg.rate = 1;   // 속도: 0.1 ~ 10
                speechMsg.pitch = 1;  // 음높이: 0 ~ 2
                speechMsg.lang = "ko-KR";  // 읽을 언어는 한국어 설정
                speechMsg.text = text;

                // 문자 읽기
                window.speechSynthesis.speak(speechMsg);
            }

        </script>
    </head>

    <body>
    <h2>이미지 파일로부터 인식된 문자열 읽어주기</h2>
    <hr/>
    <br/>

    <div class="divTable minimalistBlack">
        <div class="divTableHeading">
            <div class="divTableRow">
                <div class="divTableHead">이미지로부터 텍스트 인식 결과</div>
            </div>
        </div>

        <div class="divTableBody">
            <div class="divTableRow">
                <div class="divTableCell"><%=res%></div>
            </div>
        </div>
    </div>

    <div>
        <button id="btnTextRead" type="button">문자열 읽기</button>
    </div>
    </body>
</html>

</html>