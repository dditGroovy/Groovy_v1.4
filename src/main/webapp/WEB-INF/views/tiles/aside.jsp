<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div id="sideBar">
        <header id="header">
            <div id="profile">

                <img src="/uploads/profile/${CustomUser.employeeVO.proflPhotoFileStreNm}" alt="profileImage"
                     id="asideProfile"/>
            </div>
            <div class="user">
                <div class="user-info">
                    <span id="userName" class="font-24 font-md">${CustomUser.employeeVO.emplNm}</span>
                    <span id="userHierarchy" class="font-14 font-md">${CustomUser.employeeVO.commonCodeClsf}</span>
                </div>
                <div class="user-service">
                    <ul class="font-11 font-reg">
                        <li><i class="icon i-mail"></i><span>&nbsp;메일</span><a
                                href="${pageContext.request.contextPath}/employee/confirm/email" id="linkMail"></a></li>
                        <li><a href="${pageContext.request.contextPath}/employee/confirm/info" id="settingMyinfo">내 정보
                            관리</a>
                        </li>
                    </ul>
                </div>
                <div class="btn-wrap">
                    <button id="logout" class="font-11 btn-free-white"><a
                            href="#" style="color: black;">로그아웃<i
                            class="icon i-signOut"></i></a></button>
                    <button id="reservation" class="font-11 btn-free-white"><a
                            href="${pageContext.request.contextPath}/facility/meeting"><span
                            class="btn-detail">예약</span></a></button>
                    <button id="videoConference" class="font-11 btn-free-white"><a
                            href="https://5f3c-175-116-155-226.ngrok-free.app/employee/videoConferencing"><span
                            class="btn-detail">화상회의</span></a></button>
                </div>
            </div>
        </header>
        <nav id="nav">
            <div class="personal">
                <span class="nav-cate">개인</span>
                <ul>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/home"><i class="icon i-home"></i>홈</a>
                    </li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/employee/commute"><i
                            class="icon i-job"></i>출 · 퇴근</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/vacation"><i
                            class="icon i-vacation"></i>휴가 · 급여</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/job/main"><i
                            class="icon i-todo"></i>내 할 일</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/sanction/box"><i
                            class="icon i-sanction"></i>결재함</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/memo/memoMain"><i
                            class="icon i-memo"></i>메모</a></li>
                </ul>
            </div>
            <div class="team">
                <span class="nav-cate">팀</span>
                <ul>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/schedule/emplScheduleMain"><i
                            class="icon i-org"></i>캘린더</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/teamCommunity"><i
                            class="icon i-community"></i>팀 커뮤니티</a></li>
                </ul>
            </div>
            <div class="company">
                <span class="nav-cate">회사</span>
                <ul>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/notice/list"><i
                            class="icon i-notice"></i>공지사항</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/club"><i class="icon i-share"></i>동호회</a>
                    </li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/common/orgChart"><i
                            class="icon i-org"></i>조직도</a></li>
                </ul>
            </div>
        </nav>
    </div>
</sec:authorize>
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-cookie/3.0.1/js.cookie.min.js"></script>
<script>
    const navList = document.querySelectorAll(".nav-list > a");
    /*  aside   */
    navList.forEach((item, index) => {
        item.addEventListener("click", () => {
            sessionStorage.setItem("activeNavItem", index);
        });

        const activeIndex = sessionStorage.getItem("activeNavItem");
        if (activeIndex && index === parseInt(activeIndex)) {
            navList.forEach((otherItem) => {
                otherItem.classList.remove("active");
            });
            item.classList.add("active");
        }
    });
    $(document).ready(function () {
        if (Cookies.get("email")) {
            $("#linkMail").prop("href", "/email/all");
        }

        $.ajax({
            url: "/email/unreadCount",
            type: "get",
            success: function (result) {
                $("#linkMail").text(result);
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        })

    });
    $("#logout").on("click", function () {
        $.ajax({
            url: "/signOut",
            type: "post",
            <%--beforeSend : function(xhr) {--%>
            <%--    xhr.setRequestHeader("${_csrf.headerName}","${_csrf.token}");--%>
            <%--},--%>
            success: function (result) {
                window.location.href = '/employee/signIn'
            },
            error: function (xhr, status, error) {
                console.log("code: " + xhr.status);
                console.log("message: " + xhr.responseText);
                console.log("error: " + xhr.error);
            }
        })
    })

</script>