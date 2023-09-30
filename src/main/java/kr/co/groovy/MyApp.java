package kr.co.groovy;

import com.amazonaws.SdkClientException;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Arrays;
import java.util.List;

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
        String bucketName = null; // 버킷 이름을 저장할 변수를 선언하고 초기화합니다.
        List<Bucket> buckets = s3Client.listBuckets(); // S3 버킷 목록을 가져옵니다.

        if (!buckets.isEmpty()) { // 버킷 목록이 비어있지 않은 경우
            Bucket firstBucket = buckets.get(0); // 첫 번째 버킷을 얻습니다.
            bucketName = firstBucket.getName(); // 첫 번째 버킷의 이름을 얻습니다.
        }

// list all in the bucket
        try {
            ListObjectsRequest listObjectsRequest = new ListObjectsRequest()
                    .withBucketName(bucketName)
                    .withMaxKeys(300);

            ObjectListing objectListing = s3Client.listObjects(listObjectsRequest);

            System.out.println("Object List:");
            while (true) {
                for (S3ObjectSummary objectSummary : objectListing.getObjectSummaries()) {
                    System.out.println("    name=" + objectSummary.getKey() + ", size=" + objectSummary.getSize() + ", owner=" + objectSummary.getOwner().getId());
                }

                if (objectListing.isTruncated()) {
                    objectListing = s3Client.listNextBatchOfObjects(objectListing);
                } else {
                    break;
                }
            }
        } catch (AmazonS3Exception e) {
            System.err.println(e.getErrorMessage());
            System.exit(1);
        }

// top level folders and files in the bucket
        String file = null;

        try {
            ListObjectsRequest listObjectsRequest = new ListObjectsRequest()
                    .withBucketName(bucketName)
                    .withDelimiter("/")
                    .withMaxKeys(300);

            ObjectListing objectListing = s3Client.listObjects(listObjectsRequest);

            System.out.println("Folder List:");
            for (String commonPrefixes : objectListing.getCommonPrefixes()) {
                System.out.println("    name=" + commonPrefixes);
            }

            System.out.println("File List:");
            for (S3ObjectSummary objectSummary : objectListing.getObjectSummaries()) {
                System.out.println("    name=" + objectSummary.getKey() + ", size=" + objectSummary.getSize() + ", owner=" + objectSummary.getOwner().getId());
                file = objectSummary.getKey();
            }
        } catch (AmazonS3Exception e) {
            e.printStackTrace();
        } catch(SdkClientException e) {
            e.printStackTrace();
        }
        model.addAttribute("env", bucketName);
        model.addAttribute("image", file);
        return "aws";
    }
}