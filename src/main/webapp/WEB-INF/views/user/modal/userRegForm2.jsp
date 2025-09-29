<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<section class="panel" id="view-signup2" aria-hidden="true">
    <form id="signupStep2Form" autocomplete="off" novalidate>
        <!-- step1에서 전달받을 이메일 (스크립트가 값 주입) -->
        <input type="hidden" id="su_email_hidden" name="email" />

        <h2 class="form-title"><span class="en">Atalk</span> 계정 생성</h2>

        <!-- 아이디 + 중복체크 -->
        <div class="field field-inline">
            <input type="text" id="su_userId" name="userId" placeholder="아이디" />
            <button type="button" id="btnIdCheck" class="btn-inline">아이디 중복체크</button>
        </div>

        <!-- 비밀번호 -->
        <div class="field">
            <input type="password" id="su_password" name="password" placeholder="비밀번호" />
        </div>

        <!-- 비밀번호 확인 -->
        <div class="field">
            <input type="password" id="su_password2" placeholder="비밀번호 확인" />
        </div>

        <!-- 제출/뒤로 -->
        <button type="button" id="btnSignup" class="btn-primary">계정 생성</button>
        <button type="button" class="link" data-back>뒤로</button>
    </form>
</section>

<style>
    /* ===== 공통 타이틀 (step1과 톤 동일) ===== */
    #authModal .form-title{
        font-family:"Noto Sans KR",system-ui,sans-serif;
        font-weight:700;
        font-size:32px;
        color:#000;
        text-align:center;
        margin:-24px 0 8px;
    }
    #authModal .form-title .en{
        font-family:"Noto Serif",Georgia,"Times New Roman",serif;
    }

    /* ===== 레이아웃 ===== */
    #view-signup2 form{
        width:500px;
        margin:0 auto;
        display:flex;
        flex-direction:column;
        align-items:center;
    }
    #view-signup2 .field{ width:100%; margin:9px 0; }

    /* ===== 기본 컴포넌트 크기 (로그인/step1과 일치) ===== */
    #view-signup2 input,
    #view-signup2 .btn-primary{
        width:500px;
        max-width:none;
        height:38px;
        font-size:16px;
        border-radius:10px;
    }

    /* ===== 인풋 공통 ===== */
    #view-signup2 input{
        box-sizing:border-box;
        padding:10px 14px;
        line-height:1.2;
        font-weight:700;
    }
    #view-signup2 input:focus{
        border-color:#2E5E4E;
        box-shadow:0 0 0 3px rgba(46,94,78,.12);
    }
    #view-signup2 input::placeholder{ color:rgba(0,0,0,.38); }

    /* ===== 아이디 인라인 라인업 (인풋 + 버튼) ===== */
    #view-signup2 .field-inline{
        display:grid;
        grid-template-columns: 1fr auto;  /* 왼쪽 꽉 + 오른쪽 버튼 자동 */
        align-items:center;
        gap:8px; /* Figma처럼 살짝 띄움 */
    }
    /* 인라인 영역에선 인풋은 가로 100%, 버튼은 고정폭 */
    #view-signup2 .field-inline > input{ width:100%; }
    #view-signup2 .field-inline > .btn-inline{ width:160px; }

    /* 인라인 버튼 (step1과 톤 동일) */
    #view-signup2 .btn-inline{
        height:38px;
        min-width:140px;
        padding:0 16px;
        border:0;
        border-radius:8px;
        background:#2E5E4E;
        color:#fff;
        font-weight:700;
        display:flex; align-items:center; justify-content:center;
        white-space:nowrap; cursor:pointer;
    }
    #view-signup2 .btn-inline:hover{ filter:brightness(.96); }
    #view-signup2 .btn-inline:disabled{ background:#9FB2AB; cursor:not-allowed; }

    /* 제출 버튼 */
    #view-signup2 .btn-primary{
        width:160px; height:38px; margin-top:8px;
        border:0; border-radius:10px;
        background:#2E5E4E; color:#fff; font-weight:800;
        display:flex; align-items:center; justify-content:center; cursor:pointer;
    }
    #view-signup2 .btn-primary:hover{ filter:brightness(.96); }
    #view-signup2 .btn-primary:disabled{ background:#9FB2AB; cursor:not-allowed; opacity:.9; }

    /* 뒤로 */
    #view-signup2 .link{
        margin-top:8px; background:none; border:0; cursor:pointer;
        color:#6e6e6e; font-weight:700;
        text-decoration:underline; text-underline-offset:2px;
    }

    /* 반응형 */
    @media (max-width:560px){
        #view-signup2 form{ width:90vw; }
        #view-signup2 input,
        #view-signup2 .btn-primary{ width:100%; }
        #view-signup2 .field-inline{ grid-template-columns:1fr; }
        #view-signup2 .field-inline > .btn-inline{ width:100%; }
    }
</style>


