<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="panel" id="view-signup1" aria-hidden="true">
    <form id="signupStep1Form" autocomplete="off" novalidate>
        <h2 class="form-title"><span class="en">Atalk</span> 계정 생성</h2>

        <div class="field">
            <input type="email" id="su_email" name="email" placeholder="이메일을 입력해 주세요" />
            <button type="button" id="btnEmailCheck" class="btn-inline">이메일 중복체크</button>
        </div>

        <div class="field">
            <input type="text" id="su_code" placeholder="인증번호" />
        </div>

        <button type="button" id="btnToStep2" class="btn-primary">확인</button>
        <button type="button" class="link" data-back>뒤로</button>
    </form>
</section>

<style>
    /* 기본적으로는 한글/영문 전부 산세리프 */
    #view-signup1 .form-title {
        font-family: "Noto Sans KR", system-ui, sans-serif;
        font-weight: 700;

        font-size: 37px;       /* 크기 조정 */
        color: #000000;        /* 색상 변경 */
        text-align: center;    /* 가운데 정렬 */
        margin: -38px 0 6px;   /* 위아래 여백으로 위치 조정 */
    }

    /* 영어만 세리프 느낌으로 */
    #authModal .form-title span.en {
        font-family: "Noto Serif", Georgia, "Times New Roman", serif;
    }

    /* 컨테이너 레이아웃: 로그인과 동일 폭 느낌 */
    #view-signup1 form{
        width: 500px;
        margin: 0 auto;
        display: flex; flex-direction: column; align-items: center;
    }

    /* 필드 한 줄: 입력 + 우측 버튼 */
    #view-signup1 .field{
        width: 100%;
        display: flex;
        grid-template-columns: 1fr auto;
        gap: 10px;
        margin: 9px 0;
    }

    /* 입력창: 로그인 톤과 일치 */
    #view-signup1 input,
    #view-signup1 .btn-primary{
        width: 500px;
        max-width: none;
        height: 38px;
        font-size: 16px;
        border-radius: 10px;
    }


    #view-signup1 input{
        box-sizing: border-box;
        padding: 10px 14px;
        line-height: 1.2;
        font-weight: 700;
    }

    #view-signup1 input:focus{
        border-color: #2b6cb0;
        box-shadow: 0 0 0 3px rgba(43,108,176,.15);
        font-weight: 700;
    }

    #view-signup1 input::placeholder{
        font-family: inherit;
        color: rgba(0,0,0,.38);
    }


    #view-signup1 input::placeholder{ color: rgba(0,0,0,.38); }

    #view-signup1 input:focus{
        border-color:#2E5E4E;
        box-shadow: 0 0 0 3px rgba(46,94,78,.12);
    }

    /* 우측 인라인 버튼 */
    #view-signup1 .btn-inline {
        height: 37px;
        min-width: 140px;
        padding: 0 16px;
        border: 0;
        border-radius: 8px;
        background: #2E5E4E;    /* 로그인 버튼 색상 */
        color: #fff;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        white-space: nowrap;
        cursor: pointer;
    }
    #view-signup1 .btn-inline:hover {
        filter: brightness(.96);   /* hover 효과 */
    }
    #view-signup1 .btn-inline:disabled {
        background: #1e4d7a;
        cursor: not-allowed;
    }


    /* 메인 버튼(확인/다음) */
    #view-signup1 .btn-primary{
        width: 160px; height: 36px; margin-top: 8px;
        border: 0; border-radius: 10px;
        background:#2E5E4E; color:#fff; font-weight: 700;
        display:flex; align-items:center; justify-content:center; cursor:pointer;
    }
    #view-signup1 .btn-primary:hover{ filter: brightness(.96); }
    #view-signup1 .btn-primary:disabled{ background:#9FB2AB; cursor:not-allowed; opacity:.9; }

    /* 뒤로 링크 */
    #view-signup1 .link{
        margin-top: 8px; background:none; border:0; cursor:pointer;
        color:#6e6e6e; font-weight:700;
        text-decoration: underline; text-underline-offset:2px;
    }

    /* 반응형 */
    @media (max-width: 560px){
        #view-signup1 form{ width: 90vw; }
        #view-signup1 .field{ grid-template-columns: 1fr; }
        #view-signup1 .btn-inline{ width: 100%; }
    }

</style>
