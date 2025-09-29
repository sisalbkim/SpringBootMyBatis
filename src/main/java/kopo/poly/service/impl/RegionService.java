package kopo.poly.service.impl;

import kopo.poly.mapper.IRegionMapper;
import kopo.poly.service.IRegionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RegionService implements IRegionService {

    private final IRegionMapper regionMapper;

    @Override
    public List<String> getSidoList() throws Exception {
        return regionMapper.getSidoList();
    }

    @Override
    public List<String> getSigunguList(String sido) throws Exception {
        return regionMapper.getSigunguList(sido);
    }

    @Override
    public List<String> getDongList(String sido, String sigungu) throws Exception {
        return regionMapper.getDongList(sido, sigungu);
    }
}
