<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<section class="panel" id="view-login" aria-hidden="false">
    <div class="login-body">
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
            <button type="button" id="btnUserReg"     class="link">아직 계정이 없다면?</button>
            <button type="button" id="btnFindAccount" class="link">아이디/비밀번호 찾기</button>
        </div>
    </div>
</section>


<style>
    /* ── 모달 쉘(공통) ── */
    #authModal{
        position: fixed; inset: 0; z-index: 1000;
        display: none; align-items: center; justify-content: center;
        background: transparent;
    }
    #authModal, #authModal *{
        font-family: "Noto Sans KR", system-ui, -apple-system, "Segoe UI", Arial, sans-serif;
    }
    #authModal .modal-overlay{
        position: absolute; inset: 0;
        background: rgba(0,0,0,.35);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        cursor: default;
    }
    #authModal .modal-dialog{
        position: relative; z-index: 1;
        height: 500px;
        width: 970px; max-width: 90vw;
        background: #fff; border-radius: 12px;
        padding: 28px 24px;
        box-shadow: 0 12px 40px rgba(0,0,0,.25);
        display: flex; flex-direction: column;
        align-items: center; justify-content: center;
        gap: 12px;
    }
    #authModal .modal-close{
        position: absolute; top: 10px; right: 12px;
        font-size: 20px; border: 0; background: none; cursor: pointer;
    }
    #authModal .logo{
        width: 340px; display: block; margin: -200px auto -80px;
        pointer-events: none;
    }
    /* 패널 클릭 가능 레이어/커서 */
    #authModal .modal-overlay{ z-index: 0; }
    #authModal .modal-dialog{  z-index: 1; }
    #authModal .panel{ pointer-events: none; }
    #authModal .panel.is-active{ pointer-events: auto; }
    #authModal .btn-primary, #authModal .link{ cursor: pointer; }

    /* ── 로그인 전용 ── */
    #view-login .field{ margin: 17px 0; }

    #view-login input,
    #view-login .btn-primary{
        width: 500px;
        max-width: none;
        height: 38px;
        font-size: 16px;
        border-radius: 10px;
    }

    #view-login input{
        box-sizing: border-box;
        padding: 10px 14px;
        line-height: 1.2;
        font-weight: 700;
    }

    #view-login input:focus{
        border-color: #2b6cb0;
        box-shadow: 0 0 0 3px rgba(43,108,176,.15);
        font-weight: 700;
    }

    #view-login input::placeholder{
        font-family: inherit;
        color: rgba(0,0,0,.38);
    }

    /* 로그인 버튼 */
    #view-login .btn-primary{
        padding: 12px; margin-top: 8px;
        border: 0; border-radius: 8px;
        background: #2E5E4E; color: #fff; font-weight: 700;
        display: flex; align-items: center; justify-content: center;
    }
    #view-login .btn-primary:hover{ background: #1e4d7a; }

    /* 레이아웃 컨테이너 */
    #view-login .login-body{
        width: 500px;
        margin: 0 auto;
        display: flex; flex-direction: column; align-items: center;
    }

    /* 하단 링크 줄 */
    #view-login .links{
        width: 100%;
        margin-top: 12px;
        display: flex; align-items: center; justify-content: space-between; gap: 0;
    }
    #view-login .links .link{
        background: none; border: 0; padding: 2px 0;
        color: rgba(0,0,0,.4);
        text-decoration: none;
        font-size: 14px; font-weight: 600;
        transition: color .15s ease, text-decoration-color .15s ease;
    }
    #view-login .links .link:hover,
    #view-login .links .link:focus-visible{
        text-decoration: underline; text-underline-offset: 2px;
        color: rgba(0,0,0,.72);
        font-weight: 700;
    }
    #view-login .sep{ color:#888; }

</style>