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

    .checkBtn {
        width: calc((120 / var(--vw)) * 100vw);
        height: var(--vh-64);
    }

    main {
        display: flex;
        flex-direction: column;
        gap: var(--vh-40);
    }

    #modifyRes {
        color: var(--color-font-md);
        font-size: var(--font-size-14);
        margin-left: 16px;
    }

    .form-container {
        display: flex;
        gap: var(--vw-16);
    }
</style>
<div class="content-container">
    <header id="tab-header">
        <c:if test="${page == 'info'}">
            <h1><a href="${pageContext.request.contextPath}/employee/confirm/info" class="on">내 정보 관리</a></h1>
        </c:if>
        <c:if test="${page == 'salary'}">
            <h1><a href="${pageContext.request.contextPath}/vacation">내 휴가</a></h1>
            <h1><a href="${pageContext.request.contextPath}/employee/confirm/salary" class="on">내 급여</a></h1>
            <h1><a href="${pageContext.request.contextPath}/vacation/request">휴가 기록</a></h1>
        </c:if>
        <c:if test="${page == 'email'}">
            <h1><a href="${pageContext.request.contextPath}/employee/confirm/email" class="on">메일</a></h1>
        </c:if>
    </header>

    <main>
        <div class="content-header">
            <h2 class="main-title">비밀번호 확인 🤭</h2>
            <p class="main-desc">
                개인정보 보호를 위해 비밀번호를 <br/>
                한번 더 확인합니다.
            </p>
        </div>
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/email/all" method="post" id="emailForm">
                <input type="password" id="password" name="password" placeholder="PASSWORD"
                       class="userPw btn-free-white input-l"/>
            </form>
            <button type="button" class="btn-free-blue checkBtn btn">확인</button>
        </div>
        <div id="modifyRes" class="main-desc">
        </div>
    </main>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-cookie/3.0.1/js.cookie.min.js"></script>

<script>
    let currentPage = '${page}';
    let urlMappings = {
        'info': '${pageContext.request.contextPath}/employee/myInfo',
        'salary': '${pageContext.request.contextPath}/salary/paystub'
    };
    let url = urlMappings[currentPage];

    $("button").click(checkPassword);
    document.querySelector("input").addEventListener('keyup', function (event) {
        if (event.key === 'Enter') {
            checkPassword();
        }
    });

    function checkPassword() {
        let password = $("#password").val();
        $.ajax({
            url: `/employee/confirm/\${currentPage}`,
            type: "post",
            data: JSON.stringify({"password": password}),
            contentType: "application/json",
            success: function (result) {
                if (result === 'correct') {
                    if (currentPage != "email") {
                        window.location.href = url;
                    } else {
                        document.querySelector("#emailForm").submit();
                    }
                } else {
                    $("#modifyRes").html('비밀번호가 일치하지 않습니다.')
                    $("#password").val("")
                }
            },
            error: function (xhr) {
                $("#modifyRes").html('오류로 인하여 비밀번호를 확인할 수 없습니다.')
            }
        });
    }
</script>