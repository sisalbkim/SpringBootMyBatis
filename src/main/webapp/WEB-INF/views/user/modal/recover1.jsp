<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="panel" id="view-recover1">
    <form id="recoverForm" autocomplete="off">
        <h2 class="form-title">아이디/비밀번호 찾기</h2>

        <div class  ="field">
            <input type="email" id="recover_email" name="email" placeholder="이메일을 입력해 주세요" />
        </div>

        <button type="button" id="btnSendLink" class="btn-primary">아이디/비밀번호 찾기</button>
        <button type="button" class="link" data-back>뒤로</button>
    </form>
</section>

<style>
    /* recover1.jspf 전용 스타일 (기존 패널들과 유사) */
    #view-recover1,
    #view-recover1 input,
    #view-recover1 button {
        font-family: "Noto Sans KR", system-ui, sans-serif;
    }

    /* 2. 제목 스타일 */
    #view-recover1 .form-title {
        font-weight: 700;
        font-size: 35px; /* 아이디/비밀번호 찾기 제목에 맞는 크기 */
        color: #000000;
        text-align: center;
        margin: -34px 0 18px; /* 로고와의 간격 */
    }

    /* 3. 폼 레이아웃 */
    #view-recover1 form {
        width: 500px;
        margin: 0 auto;
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    #view-recover1 .field {
        width: 100%;
        margin-bottom: 18px;
    }

    /* 4. 입력창(input) 스타일 */
    #view-recover1 input {
        width: 100%;
        height: 42px;
        font-size: 16px;
        border-radius: 10px;
        box-sizing: border-box;
        padding: 10px 14px;
        line-height: 1.2;
        font-weight: 700;
    }
    #view-recover1 input:focus {
        border-color: #2E5E4E;
        box-shadow: 0 0 0 3px rgba(46, 94, 78, .12);
        font-weight: 700;
        outline: none;
    }
    #view-recover1 input::placeholder {
        font-family: inherit; /* input의 폰트를 그대로 상속 */
        color: rgba(0,0,0,.38);
    }

    /* 5. 메인 버튼(btn-primary) 스타일 */
    #view-recover1 .btn-primary {
        width: 210px; /* 아이디/비밀번호 찾기 버튼은 꽉 차게 */
        height: 38px;
        font-size: 15px;
        border: 0;
        border-radius: 10px;
        background: #2E5E4E;
        color: #fff;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
    }
    #view-recover1 .btn-primary:hover {
        filter: brightness(.96);
    }

    /* 6. 뒤로 가기 링크 스타일 */
    #view-recover1 .link {
        margin-top: 10px;
        background: none;
        border: 0;
        cursor: pointer;
        color: #6e6e6e;
        font-weight: 700;
        text-decoration: underline;
        text-underline-offset: 2px;
    }
</style>
