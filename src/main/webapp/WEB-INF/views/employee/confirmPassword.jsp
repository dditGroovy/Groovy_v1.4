<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="CustomUser"/>
<style>
    .content-header {
        display: flex;
        flex-direction: column;
        gap: var(--vh-24);
    }
    .checkBtn{
        width: calc((120/var(--vw))*100vw);
        height: var(--vh-64);
    }
    main {
        display: flex;
        flex-direction: column;
        gap: var(--vh-56);
    }
</style>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/employee/myInfo" class="on">내 정보 관리</a></h1>
    </header>

    <main>
        <div class="content-header">
            <h2 class="main-title">비밀번호 확인 🤭</h2>
            <p class="main-desc">
                개인정보 보호를 위해 비밀번호를 <br />
                한번 더 확인합니다.
            </p>
        </div>
        <div>
            <input type="password" id="password" placeholder="PASSWORD" class="userPw btn-free-white input-l"/>
            <button class="btn-free-blue checkBtn btn">확인</button>
        </div>
    </main>
</div>

<script>
    $("button").click(function () {
        let password = $("#password").val();
        $.ajax({
            url: "/salary/paystub/checkPassword",
            type: "post",
            data: password,
            contentType: "application/json",
            success: function (result) {
                if (result === "success") {
                    window.location.href = "/employee/myInfo";
                } else {
                    alert("비밀번호가 일치하지 않습니다.");
                    $("#password").val("")
                }
            },
            error: function (xhr) {
                alert("오류로 인하여 비밀번호를 확인할 수 없습니다.");
            }
        });
    });
</script>