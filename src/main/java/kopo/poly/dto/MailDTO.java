package kopo.poly.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MailDTO {

    private int mailId;
    String toMail;
    String title;
    String contents;
    String sendDt;
}
