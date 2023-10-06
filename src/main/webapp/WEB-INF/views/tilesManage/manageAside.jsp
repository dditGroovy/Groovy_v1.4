<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
<div id="sideBar" class="manageSideBar">
    <header id="header">
        <div id="profile">
            <img src="/uploads/profile/${CustomUser.employeeVO.proflPhotoFileStreNm}" alt="profileImage"/>
        </div>
        <div class="user">
            <div class="user-info">
                <span id="departName" class="font-24 font-md">인사부</span>
            </div>
            <div class="btn-wrap">
                <button id = "logout" class="font-11 btn-free-white"><a href="${pageContext.request.contextPath}/signOut" style="color: black;" >로그아웃<i class="icon i-signOut"></i></a></button>
                <button id = "toHome" class="font-11 btn-free-white"><a href="${pageContext.request.contextPath}/home" style="color: black;" >사원모드<i class="icon i-home"></i></a></button>
            </div>
        </div>
    </header>
    <nav id="nav">
        <div class="hrt">
            <ul class="depth1">
                <li class="department nav-list"><a href="#" class="active">인사팀  <i class="icon i-arr-bt"></i></a></li>
                <ul class="depth2">
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/sanction/admin/DEPT010"><i class="icon i-sanction"></i >수신 문서함</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/employee/manageEmp"><i class="icon i-emp"></i >사원 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/vacation/manage"><i class="icon i-todo"></i >연차 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/attendance/manage"><i class="icon i-job"></i >근태 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/schedule/scheduleMain"><i class="icon i-calendar"></i>회사 일정 관리</a></li>
                </ul>
            </ul>
        </div>
        <div class="gat">
            <ul class="depth1">
                <li class="department nav-list"><a href="#">총무팀 <i class="icon i-arr-bt"></i></a></li>
                <ul class="depth2">
                    <li class="depth2-nav-list"><a href="#" ><i class="icon i-sanction"></i>수신 문서함</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/notice/manage"><i class="icon i-notice"></i>공지사항 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/club/admin"><i class="icon i-share"></i>동호회 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/reserve/manageRoom"><i class="icon i-building"></i>시설 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/reserve/manageVehicle"><i class="icon i-parking"></i>차량 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/diet/dietMain"><i class="icon i-meal"></i>식단 관리</a></li>
                </ul>
            </ul>
        </div>
        <div class="at">
            <ul class="depth1">
                <li class="department nav-list"><a href="#">회계팀  <i class="icon i-arr-bt"></i></a></li>
                <ul class="depth2">
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/sanction/admin/DEPT011"><i class="icon i-sanction"></i>수신 문서함</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/card/manage"><i class="icon i-card"></i>회사 카드 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/salary/calculate"><i class="icon i-pig"></i >급여 정산</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/salary/list"><i class="icon i-todo"></i>급여 명세서 관리</a></li>
                    <li class="depth2-nav-list"><a href="${pageContext.request.contextPath}/salary"><i class="icon i-money"></i >기본 급여 및 공제 관리</a></li>
                </ul>
            </ul>
        </div>
    </nav>
</div>
</sec:authorize>
<script>
    var socket = null;
    $(document).ready(function() {
        connectWs();
    });

    function connectWs() {
        //웹소켓 연결
        sock = new SockJS("/echo-ws");
        socket = sock;

        sock.onmessage = function(event) {
            let $socketAlarm = $("#alarm");

            //handler에서 설정한 메시지 넣어준다.
            $socketAlarm.html(event.data);
        }

        sock.onerror = function (err) {
            console.log("ERROR: ", err);
        }
    }
    const navList = document.querySelectorAll(".nav-list > a");
    const activeIndex = sessionStorage.getItem('activeNavItem');

    /*  aside   */
    navList.forEach((item, index) => {
        item.addEventListener('click', (e) => {
            e.preventDefault();

            navList.forEach((otherItem) => {
                otherItem.classList.remove('active');
            });
            item.classList.add('active');
            sessionStorage.setItem('activeNavItem', index);
        });
    });
    if (activeIndex === null || activeIndex === undefined) {
        navList[0].classList.add('active');
        sessionStorage.setItem('activeNavItem', 0);
    }
    /*  관리자 Aside   */
    const departmentItems   = document.querySelectorAll(".department.nav-list");
    function setActiveDepartment(item) {
        const departmentItems = document.querySelectorAll('.depth1 .department.nav-list');
        departmentItems.forEach(function (department) {
            department.classList.remove("active");
            const ul = department.nextElementSibling;
            if (ul) {
                ul.style.maxHeight = "0";
            }
        });
        if (item != null) {
            item.classList.add("active");
        }

        const ul = item.closest("li").nextElementSibling;
        if (ul) {
            ul.style.maxHeight = ul.scrollHeight + "px";
        }
    }

    departmentItems.forEach(function (item) {
        item.addEventListener("click", function (e) {
            const target = e.target;
            setActiveDepartment(target);
        });
    });
    const idx = sessionStorage.getItem("activeNavItem")
    setActiveDepartment(departmentItems[idx]);
</script>