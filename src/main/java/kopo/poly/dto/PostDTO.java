package kopo.poly.dto;

import lombok.Data;

@Data
public class PostDTO {
    private Long postId;
    private String title;
    private String createdAt;
    private Long viewCnt;
}
