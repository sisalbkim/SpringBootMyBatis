let __opening = false;

window.openLogin = function () {
    // 2. 잠겨있으면 즉시 종료합니다.
    if (__opening) return;

    // 3. 문을 잠급니다.
    __opening = true;

    const SHELL_URL = '/user/loginModal';
    const PANEL_URLS = {
        login:   '/user/modal/login',
        signup1: '/user/modal/userRegForm1',
        signup2: '/user/modal/userRegForm2',
        recover1: '/user/modal/recover1', // 추가
        recover2: '/user/modal/recover2'  // 추가
    };

    // 쉘 로드
    $('#modal-root').load(SHELL_URL, function(response, status) {
        if (status !== 'success') {
            __opening = false; // 실패 시 잠금 해제
            alert('모달 로딩 실패');
            return;
        }

        const $m = $('#authModal');
        const $stack = $m.find('.view-stack');

        // ★★★ 가장 중요: 모달을 화면에 보여주는 코드 ★★★
        $m.css('display', 'flex');
        $('body').css('overflow', 'hidden');

        const cache = {};
        const inflight = {};

        function fitHeight($panel){ $stack.height($panel.outerHeight(true)); }

        function injectPanelStyles(name, $doc) {
            $('head').find(`style[data-panel-style="${name}"], link[data-panel-style="${name}"]`).remove();
            const $styles = $doc.filter('style,link[rel="stylesheet"]').add($doc.find('style,link[rel="stylesheet"]'));
            $styles.each(function () {
                const $tag = $(this).clone();
                $tag.attr('data-panel-style', name);
                if ($tag.is('style') && !$tag.attr('type')) $tag.attr('type', 'text/css');
                $('head').append($tag);
            });
        }

        function showPanel(name) {
            const url = PANEL_URLS[name];
            if (!url) return;
            const $dlg = $m.find('.modal-dialog');
            const use = ($next) => {
                $next.addClass('panel').attr('data-view', name);
                $stack.children('.panel').not($next).css('pointer-events','none');
                $next.css('pointer-events','auto');
                $stack.children('.panel.is-active').removeClass('is-active');
                $next.addClass('is-active');
                requestAnimationFrame(() => fitHeight($next));
                $dlg.removeClass('anim-in anim-out');
                void $dlg[0].offsetWidth;
                $dlg.addClass('anim-in');
                setTimeout(() => {
                    $m.addClass('is-ready');
                    $next.find('input:visible,button:visible,select:visible,textarea:visible').first().trigger('focus');
                }, 400);
            };
            const $pre = $stack.children(`#view-${name}`);
            if ($pre.length) { cache[name] = $pre; }
            if (cache[name]) { use(cache[name]); return; }
            if (inflight[name]) { inflight[name].then(use); return; }
            inflight[name] = $.get(url).then(html => {
                const $doc = $(html);
                injectPanelStyles(name, $doc);
                let $next = $doc.filter('section.panel').first();
                if (!$next.length) $next = $doc.find('section.panel').first();
                if (!$next.length) $next = $('<section class="panel"></section>').append($doc);
                $next.attr('id', 'view-'+name);
                $stack.children(`#view-${name}, .panel[data-view="${name}"]`).remove();
                cache[name] = $next;
                $stack.append($next);
                return $next;
            }).always(() => { delete inflight[name]; });
            inflight[name].then(use).fail(() => alert('패널 로드 실패: ' + url));
        }

        function close() {
            const $dialog  = $m.find('.modal-dialog');
            const $overlay = $m.find('.modal-overlay');

            // 닫기 상태로 전환
            $m.addClass('closing').removeClass('is-ready');

            // 혹시 '열기' 중에 붙었던 애니메이션 클래스 제거
            $dialog.removeClass('anim-in anim-out');

            // 강제 리플로우로 애니메이션 트리거 보장 (일부 브라우저 안전장치)
            // eslint-disable-next-line no-unused-expressions
            $dialog[0].offsetWidth;

            let done = false;
            const cleanup = () => {
                if (done) return;
                done = true;
                $m.remove();                    // DOM 제거
                $('body').css('overflow', '');  // 스크롤 복원
                $(document).off('keydown.auth');
                $(window).off('resize.auth');
                __opening = false;
            };

            // 애니메이션 정상 종료 감지
            $dialog.one('animationend', cleanup);
            // 혹시 animationend가 안 오는 예외 대비 타임아웃(여유롭게 500ms)
            setTimeout(cleanup, 500);
        }

        $m.on('click', '.modal-close, .modal-overlay', close);
        $(document).on('keydown.auth', e => { if (e.key === 'Escape') close(); });
        $(window).on('resize.auth', () => {
            const $active = $stack.children('.panel.is-active');
            if ($active.length) fitHeight($active);
        });

        $m.on('click', '#btnUserReg',     () => showPanel('signup1'));
        $m.on('click', '#btnFindAccount', () => showPanel('recover'));
        $m.on('click', '[data-back]',     () => showPanel('login'));

        $m.on('click', '#btnLogin', function () {
            const f = $m.find('#loginForm')[0];
            if (!f) return;
            if (!f.userId.value.trim()) { alert('아이디를 입력하세요.'); f.userId.focus(); return; }
            if (!f.password.value.trim()) { alert('비밀번호를 입력하세요.'); f.password.focus(); return; }
            const $btn = $(this).prop('disabled', true).text('로그인 중…');
            $.ajax({
                url:'/user/loginProc', type:'post', dataType:'json', data: $(f).serialize(),
                complete: () => $btn.prop('disabled', false).text('로그인'),
                success: (json) => {
                    if (json.result === 1) {
                        alert(json.msg);
                        close();
                        setTimeout(() => location.reload(), 100);
                    } else {
                        alert(json.msg);
                        $m.find('#userId').focus();
                    }
                }
            });
        });

        $m.on('keydown', '#loginForm input', e => {
            if (e.key === 'Enter') { e.preventDefault(); $m.find('#btnLogin').click(); }
        });

        const state = { email: null, emailVerified: false, idOk: false };

        $m.on('click', '#btnEmailCheck', function(){
            const email = $('#su_email').val().trim();
            if(!email){ alert('이메일을 입력하세요.'); return; }
            const $btn = $(this).prop('disabled', true).text('확인 중…');
            $.post('/user/getEmailExists', { email })
                .done(rDTO=>{
                    const existsYn = (rDTO && rDTO.existsYn) ? rDTO.existsYn : 'N';
                    if(existsYn === 'Y'){ alert('이미 가입된 이메일입니다.'); }
                    else { alert('인증번호를 전송했습니다. 메일을 확인하세요.'); state.email = email; }
                })
                .fail(()=> alert('이메일 확인 실패'))
                .always(()=> $btn.prop('disabled', false).text('이메일 중복체크'));
        });

        $m.on('input', '#su_email', function () {
            state.email = null;
            state.emailVerified = false;
            $('#su_code').val('');
        });

        $m.on('click', '#btnToStep2', function () {
            if (state.emailVerified) { showPanel('signup2'); return; }
            const code = $('#su_code').val().trim();
            if (!state.email) { alert('이메일 중복체크 먼저 해주세요.'); return; }
            if (!code)        { alert('인증번호를 입력하세요.'); $('#su_code').focus(); return; }
            const $btn = $(this).prop('disabled', true).text('확인 중…');
            $.post('/user/verifyEmailCode', { email: state.email, code })
                .done(json => {
                    if (json.ok) {
                        state.emailVerified = true;
                        showPanel('signup2');
                    } else {
                        alert('인증번호가 올바르지 않습니다.');
                        $('#su_code').focus();
                    }
                })
                .fail(() => alert('인증 확인 실패'))
                .always(() => $btn.prop('disabled', false).text('확인'));
        });

        $m.on('DOMNodeInserted', '.view-stack', function(e){
            if ($(e.target).is('#view-signup2') && state.email){
                $('#view-signup2').find('#su_email_hidden').val(state.email);
            }
        });

        $m.on('click', '#btnIdCheck', function(){
            const v = $('#su_userId').val().trim();
            if(!v){ alert('아이디를 입력하세요.'); return; }
            const $btn = $(this).prop('disabled', true).text('확인 중…');
            $.post('/user/getUserIdExists', { userId: v })
                .done(rDTO=>{
                    const existsYn = (rDTO && rDTO.existsYn) ? rDTO.existsYn : 'N';
                    if(existsYn === 'Y'){ alert('이미 사용 중인 아이디입니다.'); state.idOk = false; }
                    else { alert('사용 가능한 아이디입니다.'); state.idOk = true; }
                })
                .fail(()=> alert('아이디 확인 실패'))
                .always(()=> $btn.prop('disabled', false).text('아이디 중복체크'));
        });

        $m.on('click', '#btnSignup', function(){
            const f = document.getElementById('signupStep2Form'); if(!f) return;
            if(!state.emailVerified) return alert('이메일 인증을 완료하세요.');
            if(!state.idOk) return alert('아이디 중복확인을 해주세요.');
            const pw1 = $('#su_password').val(), pw2 = $('#su_password2').val();
            if(!pw1) return alert('비밀번호를 입력하세요.');
            if(pw1 !== pw2) return alert('비밀번호가 일치하지 않습니다.');
            const $btn = $(this).prop('disabled', true).text('가입 중…');
            $.ajax({
                url:'/user/insertUserInfo', type:'post', dataType:'json', data: $(f).serialize()
            }).done(dto=>{
                if(dto.result === 1){
                    alert(dto.msg || '가입 완료!');
                    $m.find('[data-back]').click();
                    setTimeout(()=> $('#userId').val($('#su_userId').val()).focus(), 300);
                }else{ alert(dto.msg || '가입 실패'); }
            }).fail(()=> alert('서버 통신 오류'))
                .always(()=> $btn.prop('disabled', false).text('계정 만들기'));
        });

        // '아이디/비밀번호 찾기' 버튼 클릭 시 recover1 패널 보여주기
        $m.on('click', '#btnFindAccount', () => showPanel('recover1'));

// recover1 패널의 '링크 전송' 버튼 클릭 시 AJAX 통신
        $m.on('click', '#btnSendLink', function() {
            const email = $('#recover_email').val().trim();
            if (!email) { alert('이메일을 입력하세요.'); return; }

            const $btn = $(this).prop('disabled', true).text('전송 중…');
            $.post('/user/sendResetLink', { email })
                // auth.js의 #btnSendLink 클릭 이벤트
                // auth.js의 #btnSendLink 클릭 이벤트
                .done(json => {
                    if (json.ok) {
                        // 1. 빈 그릇('recover2' 패널)을 먼저 보여주고
                        showPanel('recover2');

                        // 2. 서버가 보내준 메시지(json.msg)를
                        //    'info-text'라는 이름의 그릇에 넣어줍니다.
                        setTimeout(() => {
                            $('#view-recover2 .info-text').html(json.msg.replace(/\n/g, '<br>'));
                        }, 50);

                    } else {
                        alert(json.msg || '전송에 실패했습니다.');
                    }
                })
                .fail(() => alert('서버 요청 실패'))
                .always(() => $btn.prop('disabled', false).text('확인완료'));
        });

        // auth.js에 추가

// '아이디/비밀번호 찾기' 폼(#recoverForm) 안에서 엔터를 누르면,
// 새로고침을 막고 '링크 전송' 버튼(#btnSendLink)을 클릭한 것처럼 동작시킴
        $m.on('keydown', '#recoverForm input', e => {
            if (e.key === 'Enter') {
                e.preventDefault(); // 1. 브라우저의 새로고침 본능을 막습니다.
                $m.find('#btnSendLink').click(); // 2. 버튼을 대신 클릭해줍니다.
            }
        });

        // auth.js에 추가

// 회원가입 1단계 폼(#signupStep1Form)에서 엔터를 누르면,
// '확인' 버튼(#btnToStep2)을 클릭한 것처럼 동작시킴
        $m.on('keydown', '#signupStep1Form input', e => {
            if (e.key === 'Enter') {
                e.preventDefault();
                $m.find('#btnToStep2').click();
            }
        });

        // auth.js에 추가

// 회원가입 마지막 단계 폼(#signupStep2Form)에서 엔터를 누르면,
// 새로고침을 막고 '계정 생성' 버튼(#btnSignup)을 클릭한 것처럼 동작시킴
        $m.on('keydown', '#signupStep2Form input', e => {
            if (e.key === 'Enter') {
                e.preventDefault();
                $m.find('#btnSignup').click();
            }
        });

        showPanel('login');
    });
};