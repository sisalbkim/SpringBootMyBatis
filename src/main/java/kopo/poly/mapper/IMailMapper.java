package kopo.poly.mapper;

import kopo.poly.dto.MailDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper

public interface IMailMapper {
    List<MailDTO> getMailList() throws Exception;
    void insertMail(MailDTO pDTO) throws Exception;
    MailDTO getMail(MailDTO pDTO) throws Exception;
}
