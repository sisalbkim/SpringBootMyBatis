package kopo.poly.service;

import java.util.List;

public interface IRegionService {
    List<String> getSidoList() throws Exception;
    List<String> getSigunguList(String sido) throws Exception;
    List<String> getDongList(String sido, String sigungu) throws Exception;
}
