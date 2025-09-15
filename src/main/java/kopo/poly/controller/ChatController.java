package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.ChatDTO;
import kopo.poly.dto.ChatMessageDTO;
import kopo.poly.service.IChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class ChatController {

    private final IChatService chatService;

    /** 채팅방 목록 */
    @GetMapping("/list")
    public String chatList(@RequestParam(required = false) String addr,
                           ModelMap model, HttpSession session) throws Exception {

        log.info("ChatController.chatList Start!");

        String userId = (String) session.getAttribute("SS_USER_ID");
        log.info("세션 사용자 ID: {}", userId);

        List<ChatDTO> rList;

        if (addr == null || addr.isEmpty()) {
            log.info("주소 파라미터 없음 → 전체 채팅방 조회");
            rList = chatService.getChatList();
        } else {
            log.info("주소 파라미터 존재: {} → 주소 기반 채팅방 조회", addr);
            rList = chatService.getChatListByAddr(addr);
        }

        if (rList == null || rList.isEmpty()) {
            log.warn("조회된 채팅방이 없습니다!");
        } else {
            log.info("조회된 채팅방 개수: {}", rList.size());
            for (ChatDTO room : rList) {
                log.info("방 ID: {}, 이름: {}, 주소: {} {}, 참여자: {}명",
                        room.getRoomId(), room.getRoomName(),
                        room.getAddr1(), room.getAddr2(), room.getUserCount());
            }
        }

        // JSP에서 참조할 수 있도록 모델에 담기
        model.addAttribute("chatList", rList);

        log.info("ChatController.chatList End!");
        return "chat/chatList";
    }

    /** 채팅방 생성 폼 (GET) */
    @GetMapping("/create")
    public String createRoomForm(HttpSession session) {
        String userId = (String) session.getAttribute("SS_USER_ID");
        if (userId == null) {
            return "redirect:/html/index.jsp";
        }
        return "chat/create"; // chat/create.jsp 로 이동
    }

    /** 채팅방 생성 처리 (POST) */
    @PostMapping("/createProc")
    public String createRoom(@RequestParam String roomName,
                             @RequestParam String addr1,
                             @RequestParam String addr2,
                             HttpSession session) throws Exception {

        String userId = (String) session.getAttribute("SS_USER_ID");
        if (userId == null) {
            return "redirect:/html/index.jsp";
        }

        // 👉 주소 합치기
        String fullAddr = addr1 + " " + addr2;

        ChatDTO pDTO = new ChatDTO();
        pDTO.setRoomName(roomName);
        pDTO.setAddr1(addr1);
        pDTO.setAddr2(addr2);
        pDTO.setUserId(userId);

        chatService.createRoom(pDTO);

        // 👉 URL 인코딩 (한글 깨짐/에러 방지)
        String encodedAddr = java.net.URLEncoder.encode(fullAddr, java.nio.charset.StandardCharsets.UTF_8);

        // 방 생성 후 목록으로 이동 (검색 결과까지 보여주기)
        return "redirect:/chat/list?addr=" + encodedAddr;
    }


    /** 채팅방 입장 */
    @GetMapping("/room/{roomId}")
    public String chatRoom(@PathVariable("roomId") int roomId,
                           HttpSession session,
                           ModelMap model) throws Exception {

        String userId = (String) session.getAttribute("SS_USER_ID");

        if (userId == null) {
            return "redirect:/user/login";
        }

        ChatDTO rDTO = chatService.getRoomInfo(roomId);

        if (rDTO == null) {
            model.addAttribute("msg", "존재하지 않는 채팅방입니다.");
            model.addAttribute("url", "/chat/list");
            return "redirect";
        }

        // ✅ 메시지 기록 조회 추가
        List<ChatMessageDTO> msgList = chatService.getMessageList(roomId);

        model.addAttribute("roomInfo", rDTO);
        model.addAttribute("msgList", msgList);

        return "chat/chatRoom";
    }



    /** 메시지 전송 */
    @PostMapping("/proc")
    public String sendMessage(@RequestParam int chatRoomId,
                              @RequestParam String message,
                              HttpSession session) throws Exception {
        String userId = (String) session.getAttribute("SS_USER_ID");
        if (userId == null) {
            return "redirect:/html/index.jsp";
        }

        ChatMessageDTO pDTO = new ChatMessageDTO();
        pDTO.setChatRoomId(chatRoomId);
        pDTO.setUserId(userId);
        pDTO.setMessage(message);

        chatService.insertMessage(pDTO);

        // 전송 후 해당 채팅방 다시 로딩
        return "redirect:/chat/room/" + chatRoomId;
    }



    @GetMapping("/test")
    public String testPage() {
        return "test";
    }




}
