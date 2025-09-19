package kopo.poly.controller;

import kopo.poly.service.IRegionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/region")
public class RegionController {

    private final IRegionService regionService;

    /** 시/도 목록 */
    @GetMapping("/sido")
    public List<String> getSido() throws Exception {
        log.info("GET /region/sido");
        return regionService.getSidoList();
    }

    /** 시군구 목록 */
    @GetMapping("/sigungu")
    public List<String> getSigungu(@RequestParam("sido") String sido) throws Exception {
        log.info("GET /region/sigungu: {}", sido);
        return regionService.getSigunguList(sido);
    }

    /** 읍면동 목록 */
    @GetMapping("/dong")
    public List<String> getDong(@RequestParam("sido") String sido,
                                @RequestParam("sigungu") String sigungu) throws Exception {
        log.info("GET /region/dong: {} {}", sido, sigungu);
        return regionService.getDongList(sido, sigungu);
    }
}
