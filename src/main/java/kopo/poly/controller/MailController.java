package kopo.poly.controller;

import jakarta.servlet.http.HttpServletRequest;
import kopo.poly.dto.MailDTO;
import kopo.poly.dto.MsgDTO;
import kopo.poly.service.IMailService;
import kopo.poly.util.CmmUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Slf4j
@RequestMapping(value = "/mail")
@RequiredArgsConstructor
@Controller

public class MailController{

    private final IMailService mailService;

    @GetMapping(value = "mailForm")
    public String mailForm() {

        log.info("{}.mailForm Start!", this.getClass().getName());

        return "mail/mailForm";
    }


    @ResponseBody
    @PostMapping(value = "sendMail")
    public MsgDTO sendMail(HttpServletRequest request) {

        log.info("{}.sendMail Start!", this.getClass().getName());

        String msg;

        String toMail = CmmUtil.nvl(request.getParameter("toMail"));
        String title = CmmUtil.nvl(request.getParameter("title"));
        String contents = CmmUtil.nvl(request.getParameter("contents"));

        log.info("toMail : {} / title : {} / contents : {}", toMail, title, contents);

        MailDTO pDTO = new MailDTO();

        pDTO.setToMail(toMail);
        pDTO.setTitle(title);
        pDTO.setContents(contents);

        int res = mailService.doSendMail(pDTO);

        if (res == 1) {
            msg = "메일 발송했습니다.";
        } else {
            msg = "메일 발송 실패했습니다.";
        }

        log.info(msg);

        MsgDTO dto = new MsgDTO();
        dto.setMsg(msg);

        log.info("{}.sendMail end!", this.getClass().getName());

        return dto;
    }

    @GetMapping("/list")
    public String mailList(ModelMap model) throws Exception {

        log.info("{}.mailList Start!", this.getClass().getName());

        List<MailDTO> rList = mailService.getMailList();

        model.addAttribute("rList", rList);

        log.info("{}.mailList End!", this.getClass().getName());

        return "mail/mailList"; // JSP 파일 경로
    }
    @GetMapping("/info")
    public String mailInfo(HttpServletRequest request, ModelMap model) throws Exception {

        log.info("{}.mailInfo Start!", this.getClass().getName());

        // URL에서 mailId 파라미터 꺼내기
        int mailId = Integer.parseInt(CmmUtil.nvl(request.getParameter("mailId")));
        log.info("mailId : {}", mailId);

        MailDTO pDTO = new MailDTO();
        pDTO.setMailId(mailId);

        MailDTO rDTO = mailService.getMailInfo(pDTO);

        if (rDTO == null) {
            rDTO = new MailDTO(); // 널 방지
        }

        model.addAttribute("rDTO", rDTO);

        log.info("{}.mailInfo End!", this.getClass().getName());

        return "mail/mailInfo"; // JSP 경로
    }


}
