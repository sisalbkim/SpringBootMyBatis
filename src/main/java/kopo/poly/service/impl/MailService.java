package kopo.poly.service.impl;

import jakarta.mail.internet.MimeMessage;
import kopo.poly.dto.MailDTO;
import kopo.poly.mapper.IMailMapper;
import kopo.poly.service.IMailService;
import kopo.poly.util.CmmUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@Service
public class MailService implements IMailService {


    private final JavaMailSender mailSender;
    private final IMailMapper mailMapper; // ✅Mapper 인터페이스 주입

    @Value("${spring.mail.username}")
    private String fromMail;

    @Override
    public int doSendMail(MailDTO pDTO) {

        log.info("{}.doSendMail start!", this.getClass().getName());

        int res = 1;

        if (pDTO == null) {
            pDTO = new MailDTO();
        }

        String toMail = CmmUtil.nvl(pDTO.getToMail());
        String title = CmmUtil.nvl(pDTO.getTitle());
        String contents = CmmUtil.nvl(pDTO.getContents());

        log.info("toMail : {}, title: {}, contents: {}", toMail, title, contents);

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper messageHelper = new MimeMessageHelper(message, "UTF-8");

            // 메일 전송
            messageHelper.setTo(toMail);
            messageHelper.setFrom(fromMail);
            messageHelper.setSubject(title);
            messageHelper.setText(contents, true);

            mailSender.send(message);

            // ✅ Mapper 인터페이스로 DB 저장
            mailMapper.insertMailInfo(pDTO);

        } catch (Exception e) {
            res = 0;
            log.info("[ERROR] doSendMail : {}", e);
        }

        log.info("{}.doSendMail end!", this.getClass().getName());
        return res;
    }
    @Override
    public MailDTO getMailInfo(MailDTO pDTO) throws Exception {
        return mailMapper.getMailInfo(pDTO);
    }

    @Override
    public List<MailDTO> getMailList() throws Exception {
        return mailMapper.getMailList();
    }


}

