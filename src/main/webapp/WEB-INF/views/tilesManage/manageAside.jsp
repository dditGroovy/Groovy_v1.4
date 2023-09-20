<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
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
            <ul class="depth1 active">
                <li class="department nav-list"><a href="#" class="active">인사팀  <i class="icon i-arr-bt"></i></a></li>
                <ul>
                    <li class="nav-list"><a href="#"><i class="icon i-sanction"></i >결재 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/employee/manageEmp"><i class="icon i-emp"></i >사원 관리</a></li>
                    <li class="nav-list"><a href="#"><i class="icon i-todo"></i >연차 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/employee/loadLog"><i class="icon i-job"></i >근태 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/salary"><i class="icon i-money"></i >기본 급여 및 시간외 수당 관리</a></li>
                </ul>
            </ul>
        </div>
        <div class="gat">
            <ul class="depth1">
                <li class="department nav-list"><a href="#">총무팀 <i class="icon i-arr-bt"></i></a></li>
                <ul>
                    <li class="nav-list"><a href="#" ><i class="icon i-sanction"></i>결재 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/notice/manageNotice"><i class="icon i-notice"></i>공지사항 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/schedule/scheduleMain"><i class="icon i-calendar"></i>회사 일정 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/club/admin"><i class="icon i-share"></i>동호회 관리</a></li>
                    <li class="nav-list"><a href="#"><i class="icon i-building"></i>시설 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/reserve/manageVehicle"><i class="icon i-parking"></i>주차차량 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/diet/dietMain"><i class="icon i-notice"></i>식단 관리</a></li>
                </ul>
            </ul>
        </div>
        <div class="at">
            <ul class="depth1">
                <li class="department nav-list"><a href="#">회계팀  <i class="icon i-arr-bt"></i></a></li>
                <ul>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/card/sanction"><i class="icon i-sanction"></i>결재 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/card/manage"><i class="icon i-card"></i>회사 카드 관리</a></li>
                    <li class="nav-list"><a href="${pageContext.request.contextPath}/salary/list"><i class="icon i-todo"></i>급여 명세서 관리</a></li>
                </ul>
            </ul>
        </div>
    </nav>

</div>
<script>
    var socket = null;
    $(document).ready(function() {
        connectWs();
    });

    function connectWs() {
        //웹소켓 연결
        sock = new SockJS("<c:url value="/echo-ws"/>");
        socket = sock;

        sock.onopen = function () {
            console.log("info: connection opend");
        };

        sock.onmessage = function(event) {
            console.log(event.data);
            let $socketAlarm = $("#alarm");

            //handler에서 설정한 메시지 넣어준다.
            $socketAlarm.html(event.data);
        }

        sock.onclose = function () {
            console.log("close");
        }

        sock.onerror = function (err) {
            console.log("ERROR: ", err);
        }
    }
    const depth1 = $(".depth1");
    console.log(depth1);
    let depth2Li = $(".depth1.active ul li a");
    depth1.on("click",function(){
        depth1.removeClass("active");
        $(".department > a").removeClass("active");
        $(this).find(".department > a").addClass("active");
        $(this).addClass("active");
    })
    depth2Li.on("click",function(){

        depth2Li.removeClass("active");
        $(this).addClass("active");
    })
</script>