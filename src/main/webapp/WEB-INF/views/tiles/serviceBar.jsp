<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="${pageContext.request.contextPath}/resources/css/alarm/alarm.css" rel="stylesheet"/>
<div class="alarmWrapper">
	<section class="alarmContainer">
		<h2 class="alarm-title">알림</h2>
		<header id="alarm-header">
			<a href="/employee/confirm/info" class="setting"><i class="icon i-setting"></i>알림 관리</a>
			<button id="allReadAlarm" class="btn">모두 읽기</button>
		</header>
		<div class="alarm-area"></div>
	</section>
	<!-- 화면에 안 보여서 div에 margin을 줬어용 번거롭게 해서 미안합니당 지우고 써주셔용!!! -->
	<section class="memoContainer">
		<!-- 리스트에서 고정할 메모 클릭하면 고정되어요~ -->
		<div class="fixed-memo">
					<c:choose>
						<c:when test="${not empty memoList}">
							<c:forEach items="${memoList}" var="memo">
						<div data-memo-sn="${memo.memoSn}">
							<div class="memoCn">${memo.memoCn}</div>
						</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="no-memo">
								<button id="addMemo" class="btn"></button>
							</div>
						</c:otherwise>
					</c:choose>
				</div>

			<!-- 고정된 메모 클릭하면 고정 해제되고 메모 디테일 내용도 사라져요~ -->
				<div id="memoTitleData">
					<div data-fix-memo-sn="${fixMemo.memoSn}">
						<td class="fixMemoCn">${fixMemo.memoCn}</td>
					</div>
				</div>
		<div class="flip-memo">
			<p id="memoDetailDataTitle">${fixMemo.memoSj}</p>
			<p id="memoDetailDataContent">${fixMemo.memoCn}</p>
			<p id="memoDetailDataDate"><fmt:formatDate value="${fixMemo.memoWrtngDate}" type="date" pattern="yyyy-MM-dd"/></p>
		</div>
	</section>
  	<div class="service-tab">

	</div>

  
</div>

<script>
  getList();
  var socket = null;
  $(document).ready(function() {
    connectWs();
  });

  function connectWs() {
    // 웹소켓 연결
    sock = new SockJS("<c:url value='/echo-ws'/>");
    socket = sock;

    sock.onopen = function () {
      console.log("info: connection opened");
    };

    sock.onmessage = function(event) {
      getList();
    }

    sock.onclose = function () {
      console.log("close");
    }

    sock.onerror = function (err) {
      console.log("ERROR: ", err);
    }
  }
document.querySelector(".alarmContainer").addEventListener("click",(e)=>{
   const target = e.target;
   if(target.classList.contains("readBtn")){
     var ntcnSn = target.previousElementSibling.getAttribute("data-seq");
     $.ajax({
       type: 'delete',
       url: '/alarm/deleteAlarm?ntcnSn=' + ntcnSn,
       success: function () {
         target.parentElement.remove();
       },
       error: function (xhr) {
         xhr.status;
       }
     });

   }
})
function getList() {
  $.ajax({
    type: 'get',
    url: '/alarm/getAllAlarm',
    dataType: 'json',
    success: function (list) {
      console.log(list);
      $(".alarm-area").empty();
      for (let i = 0; i < list.length; i++) {
        $(".alarm-area").append(list[i].ntcnCn);
      }
    }
  });
}


$(document).ready(function(){
	$("td.fixMemoCn").on("click", function() {
		let number = $(this).closest("tr").data("fix-memo-sn");
		
		let memoSn = parseInt(number, 10);
		
		console.log(memoSn);
		
		$.ajax({
			type: 'put',
			url: '/alarm/noFix/' + memoSn,
			success: function(res) {
				$("#memoTitleData").text(null);
		        
		        $("#memoDetailDataTitle").text(null);
		        $("#memoDetailDataContent").text(null);
		        $("#memoDetailDataDate").text(null);
			}
		})
	})
})


$(document).ready(function() {
	$("td.memoCn").on("click", function() {
		let number = $(this).closest("tr").data("memo-sn");
		
		let memoSn = parseInt(number, 10);
		
		console.log(memoSn);
		
		$.ajax({
			type: 'put',
			url: '/alarm/updateMemoAlarm/' + memoSn,
			success: function(res) {
				$.ajax({
                    type: 'get',
                    url: '/alarm/updateMemoAlarm/' + memoSn,
                    success: function(data) {
                        let memoDate = data.memoWrtngDate;
                        
                        let date = new Date(memoDate);
                        
                        let formattedDate = date.getFullYear() + '-' + 
                        					('0' + (date.getMonth() + 1)).slice(-2) + '-' + 
                        					('0' + date.getDate()).slice(-2);
                        
                        $("#memoTitleData").text(data.memoCn);
                        
                        $("#memoDetailDataTitle").text(data.memoSj);
                        $("#memoDetailDataContent").text(data.memoCn);
                        $("#memoDetailDataDate").text(formattedDate);
						
						
						$("#memoTitleData").on("click", function() {
                        	let memoSn = data.memoSn;
                        
                        	$("tr[data-fix-memo-sn]").attr("data-fix-memo-sn", memoSn);
                        
	                        $.ajax({
	                			type: 'put',
	                			url: '/alarm/noFix/' + memoSn,
	                			success: function(res) {
	                				$("#memoTitleData").text(null);
	                		        
	                		        $("#memoDetailDataTitle").text(null);
	                		        $("#memoDetailDataContent").text(null);
	                		        $("#memoDetailDataDate").text(null);
	                			}
	                		})
						}) 
                    }
                });
			}
		});
	});
})
  const serviceTab = document.querySelector(".service-tab");
  const alarmWrapper = document.querySelector(".alarmWrapper");

  serviceTab.addEventListener("click", function() {
	  alarmWrapper.classList.toggle("on");
  });
</script>