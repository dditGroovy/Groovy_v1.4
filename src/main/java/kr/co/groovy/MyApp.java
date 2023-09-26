package kr.co.groovy;

import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

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
        // 환경 변수에서 AWS 액세스 키와 시크릿 키 읽어오기
        DefaultAWSCredentialsProviderChain credentialsProvider = DefaultAWSCredentialsProviderChain.getInstance();

        // Amazon S3 클라이언트 생성
        AmazonS3 s3Client = AmazonS3Client.builder()
                .withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration("s3.ap-northeast-2.amazonaws.com", "ap-northeast-2"))
                .build();


        // AWS S3 서비스 사용
        // 예: 버킷 목록 가져오기
        final String[] name = new String[1];
        s3Client.listBuckets().forEach(bucket -> {
            name[0] = bucket.getName();
        });
        model.addAttribute("env", name);
        return "aws";
    }
}