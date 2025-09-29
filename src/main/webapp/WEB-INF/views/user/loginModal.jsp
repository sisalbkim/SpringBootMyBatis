<!-- authModal.jsp (또는 HTML 파일) -->
<div id="authModal" class="modal" role="dialog" aria-modal="true" style="display:none;">
    <div class="modal-overlay"></div>
    <div class="modal-dialog">
        <button class="modal-close" aria-label="닫기" type="button" title="닫기">&times;</button>
        <img src="/images/logo.png" class="logo" alt="Atalk"/>
        <!-- ⬇️ 이 컨테이너는 비워둡니다. (여기로 패널이 주입됨) -->
        <div class="view-stack"></div>
    </div>
</div>

<style>
    /* ─────────── 모달 전체 레이아웃 ─────────── */

    /* 모달 열기 애니메이션 */
    @keyframes modal-slide-up {
        from { transform: translateY(32px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    /* 모달 닫기 애니메이션 */
    @keyframes modal-slide-down {
        from { transform: translateY(0); opacity: 1; }
        to { transform: translateY(24px); opacity: 0; }
    }

    /* 패널 전환 효과 (모달 전체 카드) */
    @keyframes card-slide-up {
        from { transform: translateY(40px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    @keyframes card-slide-out {
        from { transform: translateY(0); opacity: 1; }
        to { transform: translateY(-20px); opacity: 0; }
    }
    @keyframes overlay-fade-in { from {opacity:0} to {opacity:1} }
    @keyframes overlay-fade-out { from {opacity:1} to {opacity:0} }

    /* ─────────── 모달 기본 다이얼로그 ─────────── */
    #authModal .modal-dialog {
        position: relative;
        z-index: 1;
        width: 970px;
        max-width: 90vw;
        background:#fff;
        border-radius:12px;
        padding:28px 24px;
        box-shadow:0 12px 40px rgba(0,0,0,.25);
        opacity: 0;
        transform: translateY(16px);
        transition: opacity .22s ease, transform .22s ease;
        will-change: transform, opacity;
    }

    /* 모달이 준비되면 나타나기 */
    #authModal.is-ready .modal-dialog {
        animation: overlay-fade-in .28s ease forwards;
    }
    /* 모달 닫기 */
    #authModal.closing .modal-dialog {
        animation: modal-slide-down .28s cubic-bezier(.2,.8,.2,1) forwards;
    }
    /* 전환 들어올 때 */
    #authModal .modal-dialog.anim-in {
        animation: card-slide-up 0.6s cubic-bezier(.2,.8,.2,1);
    }
    /* 전환 나갈 때 */
    #authModal .modal-dialog.anim-out {
        animation: card-slide-out 0.5s cubic-bezier(.2,.8,.2,1);
    }

    /* ─────────── 모달 레이아웃(필수) ─────────── */
    #authModal {
        position: fixed;
        inset: 0;
        z-index: 1000;
        display: none; /* openLogin()에서 flex로 변경 */
        align-items: center;
        justify-content: center;
        background: transparent;
    }
    #authModal .modal-overlay {
        animation: overlay-fade-in .28s ease forwards;
    }
    #authModal .modal-dialog {
        position: relative;
        z-index: 1;
        width: 970px;
        max-width: 90vw; /* 공통 가로폭 */
        background:#fff;
        border-radius:12px;
        padding:28px 24px;
        box-shadow:0 12px 40px rgba(0,0,0,.25);
    }
    #authModal .view-stack {
        position: relative;
        transition: height .36s ease;
    }

    /* ─────────── 패널 전환(필수) ─────────── */
    #authModal .panel {
        position:absolute;
        inset:0;
        opacity:0;
        transform:translateY(24px);
        pointer-events:none;
        transition:opacity .36s cubic-bezier(.2,.8,.2,1),
        transform .36s cubic-bezier(.2,.8,.2,1);
    }
    #authModal .panel.is-active {
        position:relative;
        opacity:1;
        transform:translateY(0);
        pointer-events:auto;
    }
    #authModal .panel.is-leaving {
        opacity:0;
        transform:translateY(-12px);
    }

    /* 로고 고정 크기 (점프 방지) */
    #authModal .logo {
        width: 340px;
        height: auto;
        margin: -120px auto -80px;
        object-fit: contain;
        flex: 0 0 auto;
        pointer-events: none;
    }

    /* 첫 렌더링 동안 다이얼로그 숨김 */
    #authModal .modal-dialog {
        opacity: 0;
        transform: translateY(16px);
        transition: opacity .22s ease, transform .22s ease;
        will-change: transform, opacity;
    }
    /* 패널이 준비되면 클래스 추가해서 보이게 */
    #authModal.is-ready .modal-dialog {
        opacity: 1;
        transform: translateY(0);
    }

    /* 패널 컨테이너: 초기 최소 높이 확보 */
    #authModal .view-stack {
        position: relative;
        min-height: 220px; /* 초기 깜빡임 방지 */
        transition: height .36s ease;
    }
</style>

