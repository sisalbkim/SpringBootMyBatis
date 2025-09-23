package kopo.poly.service;

import kopo.poly.dto.MailDTO;

import java.util.List;

public interface IMailService {
    int doSendMail(MailDTO pDTO);
    MailDTO getMailInfo(MailDTO pDTO) throws Exception;
    List<MailDTO> getMailList() throws Exception;

}
