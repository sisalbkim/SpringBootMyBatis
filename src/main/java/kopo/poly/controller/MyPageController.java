package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.UserInfoDTO;
import kopo.poly.service.IMyActivityService;
import kopo.poly.service.IMyPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MyPageController {

    private final IMyPageService myPageService;
    // (선택) BCrypt 사용 시 주입
    // private final BCryptPasswordEncoder passwordEncoder;

    private final IMyActivityService myActivityService;

    private String getLoginUserId(HttpSession session) {
        // 프로젝트마다 세션 키가 달라서 안전하게 여러 키 체크
        Object v = session.getAttribute("LOGIN_USER_ID");
        if (v == null) v = session.getAttribute("SS_USER_ID");
        if (v == null) v = session.getAttribute("userId");
        return v == null ? null : String.valueOf(v);
    }

    @GetMapping
    public String view(@RequestParam(defaultValue = "1") int roomPage,
                       Model model, HttpSession session) {
        String userId = getLoginUserId(session);
        if (!StringUtils.hasText(userId)) {
            return "redirect:/login";
        }
        // 좌측: 회원정보
        UserInfoDTO me = myPageService.getMyInfo(userId);
        model.addAttribute("me", me);

        // 우측: 활동 내역(내가 속한 채팅방)
        int roomSize = 10;
        model.addAttribute("myRooms", myActivityService.getMyChatRooms(userId, roomPage, roomSize));
        model.addAttribute("roomTotal", myActivityService.countMyChatRooms(userId));
        model.addAttribute("roomPage", roomPage);
        model.addAttribute("roomSize", roomSize);

        return "mypage/mypage";
    }


    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute UserInfoDTO in, HttpSession session) {
        String userId = getLoginUserId(session);
        if (!StringUtils.hasText(userId)) return "redirect:/login";

        // 부분 업데이트: 보내온 값만 적용되도록 Mapper에서 <set><if> 사용 중
        in.setUserId(userId);
        myPageService.updateProfile(in);
        return "redirect:/mypage";
    }

    @PostMapping("/password")
    public String changePassword(@RequestParam String newPassword,
                                 @RequestParam String newPasswordConfirm,
                                 Model model, HttpSession session) {
        String userId = getLoginUserId(session);
        if (!StringUtils.hasText(userId)) return "redirect:/login";

        if (!StringUtils.hasText(newPassword) || !newPassword.equals(newPasswordConfirm)) {
            model.addAttribute("pwError", "비밀번호가 비거나 일치하지 않습니다.");
            return "mypage/mypage";
        }

        UserInfoDTO p = new UserInfoDTO();
        p.setUserId(userId);

        // (선택) BCrypt 사용 시
        // p.setPassword(passwordEncoder.encode(newPassword));

        // 평문 그대로라면 ↓ (현재 로그인 로직이 평문 비교라면 일단 유지)
        p.setPassword(newPassword);

        myPageService.changePassword(p);
        model.addAttribute("pwSuccess", "비밀번호가 변경되었습니다.");
        model.addAttribute("me", myPageService.getMyInfo(userId));
        return "mypage/mypage";
    }

    @PostMapping("/profile-image")
    public String uploadProfile(@RequestParam("file") MultipartFile file,
                                HttpSession session) throws Exception {
        String userId = getLoginUserId(session);
        if (!StringUtils.hasText(userId)) return "redirect:/login";

        if (file != null && !file.isEmpty()) {
            // ✅ 절대 경로로 저장할 디렉토리 설정 (원하는 위치로 바꿔도 됨)
            Path dir = Paths.get(System.getProperty("user.home"), "atalk-data", "profile").toAbsolutePath();
            Files.createDirectories(dir);

            String filename = userId + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();

            // ✅ 반드시 절대 경로로!
            Path savePath = dir.resolve(filename).toAbsolutePath();
            file.transferTo(savePath.toFile());

            UserInfoDTO u = new UserInfoDTO();
            u.setUserId(userId);
            // 정적 리소스로 노출될 URL (아래 StaticResourceConfig와 짝)
            u.setProfileImageUrl("/static/profile/" + filename);
            myPageService.updateProfile(u);
        }
        return "redirect:/mypage";
    }


    @PostMapping("/notify")
    public String updateNotify(@RequestParam(defaultValue = "0") int notifyEmail, HttpSession session) {
        String userId = getLoginUserId(session);
        if (!StringUtils.hasText(userId)) return "redirect:/login";

        UserInfoDTO u = new UserInfoDTO();
        u.setUserId(userId);
        // Boolean로 매핑되면 true/false, 정 안 맞으면 DTO를 Integer로 바꿔도 됨
        u.setNotifyEmail(notifyEmail == 1);
        myPageService.updateProfile(u);
        return "redirect:/mypage";
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }



}
