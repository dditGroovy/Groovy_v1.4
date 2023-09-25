package kr.co.groovy.security;

import kr.co.groovy.employee.EmployeeMapper;
import kr.co.groovy.enums.ClassOfPosition;
import kr.co.groovy.enums.Department;
import kr.co.groovy.vo.ConnectionLogVO;
import kr.co.groovy.vo.EmployeeVO;
import kr.co.groovy.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Service;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;

@Slf4j
@Service
public class CustomUserDetailsService implements UserDetailsService {
    private final EmployeeMapper mapper;

    public CustomUserDetailsService(EmployeeMapper mapper) {
        this.mapper = mapper;
    }

    @Override
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
        EmployeeVO employeeVO = this.mapper.signIn(id);
        NotificationVO notificationVO = mapper.getNoticeAt(id);
        if (notificationVO != null) {
            employeeVO.setNotificationVO(notificationVO);
        }
        employeeVO.setDeptNm(Department.valueOf(employeeVO.getCommonCodeDept()).label());
        employeeVO.setClsfNm(ClassOfPosition.valueOf(employeeVO.getCommonCodeClsf()).label());
        return employeeVO == null ? null : new CustomUser(employeeVO);
    }
}
