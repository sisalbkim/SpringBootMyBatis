package kopo.poly.service;

import kopo.poly.dto.MailDTO;

import java.util.List;

public interface IMailInfoService {
    List<MailDTO> getMailList() throws Exception;
    void insertMail(MailDTO pDTO) throws Exception;
}
