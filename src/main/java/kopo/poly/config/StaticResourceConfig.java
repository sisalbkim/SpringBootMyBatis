package kopo.poly.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Paths;

@Configuration
public class StaticResourceConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 위 컨트롤러의 저장 경로와 동일해야 함
        String profileDir = Paths.get(System.getProperty("user.home"), "atalk-data", "profile")
                .toAbsolutePath().toString()
                .replace("\\", "/");

        registry.addResourceHandler("/static/profile/**")
                .addResourceLocations("file:" + profileDir + "/");
    }
}
