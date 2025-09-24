package kopo.poly.controller;

import jakarta.servlet.http.HttpSession;
import kopo.poly.dto.ChatDTO;
import kopo.poly.dto.ChatMessageDTO;
import kopo.poly.service.IChatService;
import kopo.poly.util.RegionUtils; // ✅ 유틸 추가
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/chat")
public class ChatController {

    private final IChatService chatService;

    /** 채팅방 목록 */
    @GetMapping("/list")
    public String chatList(@RequestParam(required = false) String addr1,
                           @RequestParam(required = false) String addr2,
                           @RequestParam(defaultValue = "1") int page,  // ✅ 페이지 번호
                           ModelMap model, HttpSession session) throws Exception {

        log.info("ChatController.chatList Start!");
        log.info("검색 조건 - addr1: {}, addr2: {}, page: {}", addr1, addr2, page);

        String userId = (String) session.getAttribute("SS_USER_ID");
        log.info("세션 사용자 ID: {}", userId);

        int pageSize = 10; // ✅ 한 페이지에 보여줄 개수
        int offset = (page - 1) * pageSize;

        int totalCount;
        List<ChatDTO> rList;

        if (addr1 == null || addr1.isEmpty() || addr2 == null || addr2.isEmpty()) {
            log.info("주소 파라미터 없음 → 전체 채팅방 조회");
            totalCount = chatService.getChatListCount();   // ✅ 전체 개수
            rList = chatService.getChatListPaged(offset, pageSize);
        } else {
            // ✅ addr1 정규화
            String[] parts = addr1.split(" ", 2);
            String sido = parts[0];
            String sigungu = (parts.length > 1) ? parts[1] : "";
            addr1 = RegionUtils.normalizeSido(sido) + " " + sigungu;

            log.info("정규화된 addr1: {}", addr1);

            totalCount = chatService.getChatListCountByAddr(addr1, addr2); // ✅ 조건별 개수
            rList = chatService.getChatListByAddrPaged(addr1, addr2, offset, pageSize);
        }

        int totalPage = (int) Math.ceil((double) totalCount / pageSize);

        // ✅ 페이지네이션 범위 계산 (5개 단위)
        int pageBlock = 5;  // 한 번에 보여줄 페이지 수
        int startPage = ((page - 1) / pageBlock) * pageBlock + 1;
        int endPage = Math.min(startPage + pageBlock - 1, totalPage);

        model.addAttribute("chatList", rList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("addr1", addr1);
        model.addAttribute("addr2", addr2);

        log.info("조회된 채팅방 개수: {}", rList.size());
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
        return "chat/create";
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

        // ✅ 방 생성 시에도 주소 정규화
        String[] parts = addr1.split(" ", 2);
        String sido = parts[0];
        String sigungu = (parts.length > 1) ? parts[1] : "";
        addr1 = RegionUtils.normalizeSido(sido) + " " + sigungu;

        ChatDTO pDTO = new ChatDTO();
        pDTO.setRoomName(roomName);
        pDTO.setAddr1(addr1);
        pDTO.setAddr2(addr2);
        pDTO.setUserId(userId);

        chatService.createRoom(pDTO);

        // ✅ 검색 조건 유지해서 리다이렉트
        return "redirect:/chat/list?addr1=" + URLEncoder.encode(addr1, "UTF-8")
                + "&addr2=" + URLEncoder.encode(addr2, "UTF-8");
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
