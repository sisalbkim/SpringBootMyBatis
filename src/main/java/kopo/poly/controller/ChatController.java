package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.ChatDTO;
import kopo.poly.service.IChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class ChatController {

    private final IChatService chatService;

    @GetMapping("/list")
    public String chatList(ModelMap model, HttpSession session) throws Exception {
        log.info("ChatController.chatList Start!");

        String userId = (String) session.getAttribute("SS_USER_ID");
        if (userId == null) {
            return "redirect:/html/index.jsp";
        }

        List<ChatDTO> rList = chatService.getChatList();
        model.addAttribute("chatList", rList);

        log.info("ChatController.chatList End!");
        return "chat/chatList"; // JSP 이동
    }
}
