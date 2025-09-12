package kopo.poly.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.MsgDTO;
import kopo.poly.dto.UserInfoDTO;
import kopo.poly.service.IUserInfoService;
import kopo.poly.util.CmmUtil;
import kopo.poly.util.EncryptUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Optional;

@Slf4j
@RequestMapping(value = "/user")
@RequiredArgsConstructor
@Controller
public class






UserInfoController {

    private final IUserInfoService userInfoService;

    @GetMapping(value = "userRegForm")
    public String userRegForm() {
        log.info("{}.user/userRegForm", this.getClass().getName());

        return "/user/userRegForm";
    }


    @ResponseBody
    @PostMapping(value = "getUserIdExists")
    public UserInfoDTO getUserExists(HttpServletRequest request) throws Exception{

        log.info("{}.getUserIdExists start!", this.getClass().getName());

        String userId = CmmUtil.nvl(request.getParameter("userId"));

        log.info("userId = {}", userId);

        UserInfoDTO pDTO = new UserInfoDTO();
        pDTO.setUserId(userId);

        UserInfoDTO rDTO = Optional.ofNullable(userInfoService.getUserIdExists(pDTO)).orElseGet(UserInfoDTO::new);

        log.info("{}.getUserIdExists End!", this.getClass().getName());

        return rDTO;

    }

    @ResponseBody
    @PostMapping(value = "getEmailExists")
    public UserInfoDTO getEmailExists(HttpServletRequest request) throws Exception{

        log.info("{}.getEmailExists start!", this.getClass().getName());

        String email = CmmUtil.nvl(request.getParameter("email"));

        log.info("email = {}", email);

        UserInfoDTO pDTO = new UserInfoDTO();
        pDTO.setEmail(EncryptUtil.encAES128CBC(email));

        UserInfoDTO rDTO = Optional.ofNullable(userInfoService.getEmailExists(pDTO)).orElseGet(UserInfoDTO::new);

        log.info("{}.getEmailExists End!", this.getClass().getName());

        return rDTO;

    }

    @ResponseBody
    @PostMapping(value = "insertUserInfo")
    public MsgDTO insertUserInfo(HttpServletRequest request) {

        log.info("{}.insertUserInfo start!", this.getClass().getName());

        int res = 0;
        String msg = "";
        MsgDTO dto;

        UserInfoDTO pDTO;

        try{

            String userId = CmmUtil.nvl(request.getParameter("userId"));
            String userName = CmmUtil.nvl(request.getParameter("userName"));
            String password = CmmUtil.nvl(request.getParameter("password"));
            String email = CmmUtil.nvl(request.getParameter("email"));
            String addr1 = CmmUtil.nvl(request.getParameter("addr1"));
            String addr2 = CmmUtil.nvl(request.getParameter("addr2"));

            log.info("userId : " + userId);
            log.info("userName : " + userName);
            log.info("password : " + password);
            log.info("email : " + email);
            log.info("addr1 : " + addr1);
            log.info("addr2 : " + addr2);

            pDTO = new UserInfoDTO();

            pDTO.setUserId(userId);
            pDTO.setUserName(userName);

            pDTO.setPassword(EncryptUtil.encHashSHA256(password));

            pDTO.setEmail(EncryptUtil.encAES128CBC(email));
            pDTO.setAddr1(addr1);
            pDTO.setAddr2(addr2);

            res = userInfoService.insertUserInfo(pDTO);

            log.info("회원가입 결과 (res) : " + res);

            if (res == 1) {
                msg = "회원가입되었습니다.";

            } else if (res == 2) {
                msg = "이미 가입된 아이디입니다.";

            } else {
                msg = "오류로 인해 회원가입이 실패하였습니다.";

            }
        } catch (Exception e) {

            msg = "실패하였습니다. : " + e;
            log.info(e.toString());

        } finally {

            dto = new MsgDTO();
            dto.setResult(res);
            dto.setMsg(msg);

            log.info("{}.insertUserInfo End!", this.getClass().getName());

        }
        return dto;
    }

    @GetMapping(value = "login")
    public String login() {
        log.info("{}.login Start!", this.getClass().getName());

        log.info("{}.login End!", this.getClass().getName());

        return "user/login";
    }

    @ResponseBody
    @PostMapping(value = "loginProc")
    public MsgDTO loginProc(HttpServletRequest request, HttpSession session) {

        log.info("{}.loginProc Start!", this.getClass().getName());

        int res = 0;
        String msg = "";
        MsgDTO dto;

        try {
            String userId = CmmUtil.nvl(request.getParameter("userId"));
            String password = CmmUtil.nvl(request.getParameter("password"));
            String encPassword = EncryptUtil.encHashSHA256(password);

            log.info("userId : {} / encPassword : {}", userId, encPassword);

            UserInfoDTO pDTO = new UserInfoDTO();
            pDTO.setUserId(userId);
            pDTO.setPassword(encPassword);

            UserInfoDTO rDTO = userInfoService.getLogin(pDTO);

            if (!CmmUtil.nvl(rDTO.getUserId()).isEmpty()) {
                res = 1;
                msg = "로그인이 성공했습니다.";

                // ✅ 세션에 사용자 정보 저장
                session.setAttribute("SS_USER_ID", rDTO.getUserId());
                session.setAttribute("SS_USER_NAME", rDTO.getUserName());

                log.info("세션 저장 완료: SS_USER_ID={}, SS_USER_NAME={}",
                        rDTO.getUserId(), rDTO.getUserName());

            } else {
                msg = "아이디와 비밀번호가 올바르지 않습니다.";
            }

        } catch (Exception e) {
            msg = "시스템 문제로 로그인이 실패했습니다.";
            res = 2;
            log.error("loginProc 오류: ", e);

        } finally {
            dto = new MsgDTO();
            dto.setResult(res);
            dto.setMsg(msg);

            log.info("{}.loginProc End!", this.getClass().getName());
        }

        return dto;
    }

    @GetMapping(value = "logout")
    public String logout(HttpSession session) {
        log.info("{}.logout Start!", this.getClass().getName());

        // ✅ 세션 전체 초기화
        session.invalidate();

        log.info("{}.logout End!", this.getClass().getName());

        // 로그아웃 후 메인으로 이동
        return "redirect:/html/index.jsp";
    }

    @GetMapping(value = "loginResult")
    public String loginSuccess() {
        log.info("{}.loginResult Start!", this.getClass().getName());

        log.info("{}.loginResult End!", this.getClass().getName());

        return "user/loginResult";
    }

    @GetMapping(value = "searchUserId")
    public String searchUserId() {
        log.info("{}.user/searchUserId Start!", this.getClass().getName());

        log.info("{}.user/searchUserId End!", this.getClass().getName());

        return "user/searchUserId";
    }

    @PostMapping(value = "searchUserIdProc")
    public String searchUserIdProc(HttpServletRequest request, ModelMap model) throws Exception {
        log.info("{}.searchUserIdProc Start!", this.getClass().getName());


        String userName =  CmmUtil.nvl(request.getParameter("userName"));
        String email =  CmmUtil.nvl(request.getParameter("email"));

        log.info("userName : {} email : {}", userName, email);

        UserInfoDTO pDTO = new UserInfoDTO();
        pDTO.setUserName(userName);
        pDTO.setEmail(EncryptUtil.encAES128CBC(email));

        UserInfoDTO rDTO = Optional.ofNullable(userInfoService.searchUserIdOrPasswordProc(pDTO))
                .orElseGet(UserInfoDTO::new);

        model.addAttribute("rDTO", rDTO);

        log.info("{}.searchUserIdProc End!", this.getClass().getName());

        return "user/searchUserIdResult";
    }

    @GetMapping(value = "searchPassword")
    public String searchPassword(HttpSession session) {
        log.info("{}.searchPassword Start!", this.getClass().getName());

        session.setAttribute("NEW_PASSWORD", "");
        session.removeAttribute("NEW_PASSWORD");

        log.info("{}.searchPassword End!", this.getClass().getName());

        return "user/searchPassword";
    }

    @PostMapping(value = "searchPasswordProc")
    public String searchPasswordProc(HttpServletRequest request, ModelMap model, HttpSession session) throws Exception {
        log.info("{}.searchPasswordProc Start!", this.getClass().getName());

        String userId = CmmUtil.nvl(request.getParameter("userId"));
        String userName = CmmUtil.nvl(request.getParameter("userName"));
        String email =  CmmUtil.nvl(request.getParameter("email"));

        log.info("userId: {} / userName : {} / email : {}", userId, userName, email);

        UserInfoDTO pDTO = new UserInfoDTO();
        pDTO.setUserId(userId);
        pDTO.setUserName(userName);
        pDTO.setEmail(EncryptUtil.encAES128CBC(email));

        UserInfoDTO rDTO = Optional.ofNullable(userInfoService.searchUserIdOrPasswordProc(pDTO)).orElseGet(UserInfoDTO::new);
        model.addAttribute("rDTO", rDTO);

        session.setAttribute("NEW_PASSWORD", userId);

        log.info("{}.searchPasswordProc End!", this.getClass().getName());

        return "user/newPassword";

    }

    @PostMapping(value = "newPasswordProc")
    public String newPasswordProc(HttpServletRequest request, ModelMap model, HttpSession session) throws Exception {

        log.info("{}.user/newPasswordProc Start!", this.getClass().getName());

        String msg;

        String newPassword = CmmUtil.nvl((String) session.getAttribute("NEW_PASSWORD"));

        if (!newPassword.isEmpty()) {

            String password = CmmUtil.nvl(request.getParameter("password"));

            log.info("password : {}", password);

            UserInfoDTO pDTO = new UserInfoDTO();
            pDTO.setUserId(newPassword);
            pDTO.setPassword(EncryptUtil.encHashSHA256(password));



            userInfoService.newPasswordProc(pDTO);

            session.setAttribute("NEW_PASSWORD", "");
            session.removeAttribute("NEW_PASSWORD");

            msg = "비밀번호가 재설정되었습니다.";

        } else {
            msg = "비정상 접근입니다.";
        }
        model.addAttribute("msg", msg);

        log.info("{}.user/newPasswordProc End!", this.getClass().getName());

        return "user/newPasswordResult";
    }
    // ✅ 채팅방 목록 페이지
    @GetMapping(value = "/chat/list")
    public String chatList(ModelMap model, HttpSession session) {
        log.info("{}.chatList Start!", this.getClass().getName());

        // 세션에서 사용자 정보 가져오기 (로그인 한 경우만 접근 가능하게)
        String userId = (String) session.getAttribute("SS_USER_ID");
        String userName = (String) session.getAttribute("SS_USER_NAME");

        if (userId == null) {
            // 로그인 안 했으면 로그인 페이지로 리다이렉트
            return "redirect:/html/index.jsp";
        }

        // 일단은 채팅방 데이터 없이 빈 리스트 전달
        // (Service 만들어서 DB에서 불러오게 개선 가능)
        model.addAttribute("chatList", null);

        log.info("{}.chatList End!", this.getClass().getName());

        return "chat/chatList"; // chatList.jsp 로 이동
    }





}
