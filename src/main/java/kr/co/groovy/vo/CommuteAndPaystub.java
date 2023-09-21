package kr.co.groovy.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class CommuteAndPaystub {
    private CommuteVO commuteVO;
    private PaystubVO paystubVO;
}
