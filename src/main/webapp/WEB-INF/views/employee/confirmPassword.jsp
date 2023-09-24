<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="CustomUser"/>
<div class="content-container">

<main>
    <div>
        <p>비밀번호 확인</p>
    </div>
    <div>
        <input type="password" id="password" placeholder="PASSWORD"/>
        <button>확인</button>
    </div>
</main>

</div>

<script>
    $("button").click(function() {
        let password = $("#password").val();
        $.ajax({
            url: "/salary/paystub/checkPassword",
            type: "post",
            data: password,
            contentType: "application/json",
            success: function(result) {
                if (result === "success") {
                    window.location.href = "/employee/myInfo";
                } else {
                    alert("비밀번호가 일치하지 않습니다.");
                    $("#password").val("")
                }
            },
            error : function (xhr) {
                alert("오류로 인하여 비밀번호를 확인할 수 없습니다.");
            }
        });
    });
</script>