package kopo.poly.util;

import java.util.Map;

public class RegionUtils {

    private static final Map<String, String> SIDO_MAP = Map.ofEntries(
            Map.entry("서울", "서울특별시"),
            Map.entry("부산", "부산광역시"),
            Map.entry("대구", "대구광역시"),
            Map.entry("인천", "인천광역시"),
            Map.entry("광주", "광주광역시"),
            Map.entry("대전", "대전광역시"),
            Map.entry("울산", "울산광역시"),
            Map.entry("세종", "세종특별자치시"),
            Map.entry("강원", "강원특별자치도"),
            Map.entry("전북", "전북특별자치도"),
            Map.entry("경기", "경기도"),
            Map.entry("충북", "충청북도"),
            Map.entry("충남", "충청남도"),
            Map.entry("전남", "전라남도"),
            Map.entry("경북", "경상북도"),
            Map.entry("경남", "경상남도"),
            Map.entry("제주", "제주특별자치도")
    );

    /** 시·도 명칭을 풀네임으로 통일 */
    public static String normalizeSido(String input) {
        return SIDO_MAP.getOrDefault(input, input);
    }
}
