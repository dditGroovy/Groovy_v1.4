package kr.co.groovy.cloud;

import kr.co.groovy.vo.CloudVO;

public interface CloudMapper {
    void insertCloud(CloudVO cloudVO);

    String getEmplNm(String cloudObjectKey);

    void deleteCloud(String cloudObjectKey);
}
