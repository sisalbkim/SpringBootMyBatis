<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div id="authModal" class="modal" role="dialog" aria-modal="true" style="display:none;">
    <div class="modal-overlay"></div>

    <div class="modal-dialog">
        <button class="modal-close" aria-label="닫기">✕</button>
        <img src="/images/logo.png" class="logo" alt="Atalk"/>
        <div class="view view-login">
            <form id="loginForm" autocomplete="off">
                <div class="field">
                    <input type="text" id="userId" name="userId" placeholder="아이디" />
                </div>
                <div class="field">
                    <input type="password" id="password" name="password" placeholder="비밀번호" />
                </div>
                <button type="button" id="btnLogin" class="btn-primary">로그인</button>
            </form>

            <div class="links">
                <button type="button" id="btnUserReg" class="link">아직 계정이 없다면?</button>
                <div class="right">
                    <button type="button" id="btnSearchUserId" class="link">아이디 찾기</button>
                    <span class="sep">/</span>
                    <button type="button" id="btnSearchPassword" class="link">비밀번호 찾기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    /* 모달 최상위: 화면 전체 덮기 */
    #authModal{
        position: fixed; inset: 0; z-index: 1000;
        display: none;                /* openLogin()에서 flex로 바꿈 */
        align-items: center; justify-content: center;
        background: transparent;      /* 배경은 overlay가 담당 */
    }

    /* 뒤 배경 흐림/딤 */
    #authModal .modal-overlay{
        position: absolute; inset: 0;
        background: rgba(0,0,0,.35);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        cursor: default;              /* 커서가 I-beam으로 바뀌지 않도록 */
    }

    /* 가운데 카드 */
    #authModal .modal-dialog{
        position: relative; z-index: 1;
        width: 420px; max-width: 90vw;
        background: #fff; border-radius: 12px;
        padding: 28px 24px;
        box-shadow: 0 12px 40px rgba(0,0,0,.25);
    }

    /* 닫기 버튼 */
    #authModal .modal-close{
        position: absolute; top: 10px; right: 12px;
        font-size: 20px; border: 0; background: none;
        cursor: pointer;
    }

    #authModal .logo{
        width: 140px; display: block; margin: 0 auto 16px;
        pointer-events: none;
    }

    /* 입력칸 간격 */
    #authModal .field{ margin: 10px 0; }

    /* 입력칸 모양 */
    #authModal input{
        width: 100%; max-width: 360px;
        padding: 12px 14px;
        border: 1px solid #d6d6d6;
        border-radius: 8px;
        font-size: 15px;
        outline: none;
    }
    #authModal input:focus{
        border-color: #2b6cb0;
        box-shadow: 0 0 0 3px rgba(43,108,176,.15);
    }

    /* 로그인 버튼 모양 */
    #authModal .btn-primary{
        width: 100%; max-width: 380px;
        padding: 12px; margin-top: 8px;
        border: 0; border-radius: 8px;
        background: #2b6cb0; color: #fff; font-weight: 700;
        cursor: pointer;
    }
    #authModal .btn-primary:hover{ background:#1e4d7a; }

    /* 아래 링크 줄(회원가입/찾기) */
    #authModal .links{
        margin-top: 12px;
        display: flex; align-items: center; justify-content: space-between;
        max-width: 380px; gap: 8px;
    }
    #authModal .links .right{ display:flex; align-items:center; gap:8px; }
    #authModal .link{
        background:none; border:0; padding:0;
        color:#2b6cb0; text-decoration:underline; cursor:pointer;
        font-size:14px;
    }
    #authModal .sep{ color:#888; }

</style>
