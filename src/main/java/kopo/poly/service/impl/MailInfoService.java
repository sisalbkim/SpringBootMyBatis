package kopo.poly.service.impl;

import kopo.poly.dto.MailDTO;
import kopo.poly.mapper.IMailMapper;
import kopo.poly.service.IMailInfoService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor

public class MailInfoService implements IMailInfoService {

    private final IMailMapper MailMapper;

    @Override
    public List<MailDTO> getMailList() throws Exception {
        return MailMapper.getMailList();
    }

    @Override
    public void insertMail(MailDTO pDTO) throws Exception {
        MailMapper.insertMail(pDTO);
    }
}
