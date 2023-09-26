package kr.co.groovy;

import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.core.env.Environment;

@Slf4j
@Controller
@RequestMapping("/jenkins")
public class MyApp {
    private final Environment env;

    public MyApp(Environment env) {
        this.env = env;
    }

    @GetMapping("/aws")
    public String getInfo(Model model) {
        // Jenkins 환경 변수에서 AWS 액세스 키와 시크릿 키 읽어오기
        String accessKey = env.getProperty("AWS_ACCESS_KEY_ID");
        String secretKey = env.getProperty("AWS_SECRET_ACCESS_KEY");

        // AWS 자격 증명 객체 생성
        BasicAWSCredentials credentials = new BasicAWSCredentials(accessKey, secretKey);
        log.info(accessKey);
        log.info(secretKey);

        // AWS S3 클라이언트 생성
        AmazonS3 s3Client = AmazonS3ClientBuilder
                .standard()
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .withRegion(Regions.AP_NORTHEAST_2) // AWS 지역 설정
                .build();

        // AWS S3 서비스 사용
        // 예: 버킷 목록 가져오기
        final String[] name = new String[1];
        s3Client.listBuckets().forEach(bucket -> {
            name[0] =  bucket.getName();
        });

        model.addAttribute("key", name[0]);
        return "aws";
    }
}