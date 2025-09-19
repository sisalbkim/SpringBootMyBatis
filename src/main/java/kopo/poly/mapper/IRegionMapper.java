package kopo.poly.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IRegionMapper {

    List<String> getSidoList() throws Exception;

    List<String> getSigunguList(String sido) throws Exception;

    List<String> getDongList(String sido, String sigungu) throws Exception;
}
