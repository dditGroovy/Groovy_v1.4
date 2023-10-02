package kr.co.groovy.alarm;

import kr.co.groovy.vo.CloudVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CloudMapper {
    void insertCloud(CloudVO cloudVO);
}
