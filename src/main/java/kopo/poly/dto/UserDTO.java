package kopo.poly.dto;

import lombok.Data;

@Data
public class UserDTO {
    private Long userId;
    private String email;
    private String name;
    private String profileImageUrl;
    private Boolean notifyEmail;
    private String createdAt;
    private String updatedAt;
}
