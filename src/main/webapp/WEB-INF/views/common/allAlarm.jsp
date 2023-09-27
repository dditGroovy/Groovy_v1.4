<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .alarmBox {
    width: 450px;
    border: 1px solid lightgray;
    border-radius: 12px;
    position: relative;
  }

  .aTag {
    display: block;
    padding: 10px;
    text-decoration: none;
    color: #333;
  }

  .readBtn {
    position: absolute;
    top: 0;
    right: 0;
  }
</style>


<div class="alarmWrapper">
	<div class="alarmContainer">
	</div>
	
	<!-- 화면에 안 보여서 div에 margin을 줬어용 번거롭게 해서 미안합니당 지우고 써주셔용!!! -->
	<div style="margin-left: 400px; border: 1px solid;">
		<!-- 리스트에서 고정할 메모 클릭하면 고정되어요~ -->
		<p>고정할 메모 선택</p>
			<table border="1">
				<c:forEach items="${memoList}" var="memo">
					<tr data-memo-sn="${memo.memoSn}">
						<td class="memoCn">${memo.memoCn}</td>
					</tr>
				</c:forEach>
			</table>
	    
	    <!-- 고정된 메모 클릭하면 고정 해제되고 메모 디테일 내용도 사라져요~ -->
		<p>고정된 메모</p>
			<table border="1" id="memoTitleData">
				<tr data-fix-memo-sn="${fixMemo.memoSn}">
					<td class="fixMemoCn">${fixMemo.memoCn}</td>
				</tr>
			</table>
	</div>
  
	<div style="margin-left: 400px; border: 1px solid;">
		<p id="memoDetailDataTitle">${fixMemo.memoSj}</p>
		<p id="memoDetailDataContent">${fixMemo.memoCn}</p>
		<p id="memoDetailDataDate"><fmt:formatDate value="${fixMemo.memoWrtngDate}" type="date" pattern="yyyy-MM-dd"/></p>
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
      console.log(event.data);
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
      $(".alarmContainer").empty();
      for (let i = 0; i < list.length; i++) {
        $(".alarmContainer").append(list[i].ntcnCn);
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
</script>