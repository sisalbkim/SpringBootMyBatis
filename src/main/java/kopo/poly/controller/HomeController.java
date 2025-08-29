package kopo.poly.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    // 루트("/")로 접근할 때 → /html/index.jsp 로 redirect
    @GetMapping("/")
    public String redirectToIndex() {
        return "redirect:/html/index.jsp";
    }

    // /html/index.jsp 직접 열리도록 설정
    @GetMapping("/html/index.jsp")
    public String index() {
        return "html/index"; // /webapp/html/index.jsp
    }
}
