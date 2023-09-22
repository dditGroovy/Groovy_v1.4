<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<link href="/resources/css/schedule/calendar.css" rel="stylesheet" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script src="/resources/fullcalendar/main.js"></script>
<script src="/resources/fullcalendar/ko.js"></script>
<head>

<style>

.fc-event-time {
	display: none;
}
</style>
<script>
$(document).ready(function(){	
	
	$(function(){
		let request = $.ajax({
			url : "/schedule/schedule",
			method : "GET",
			dataType : "json"
		});
		
		request.done(function(data){
			let calendarEl = document.getElementById('calendar');
			calendar = new FullCalendar.Calendar(calendarEl,{
				height : '700px',
				slotMinTime : '08:00',
				slotMaxTime : '20:00',
				headerToolbar :{
					left : 'today prev,next',
					center : 'title',
					right : 'dayGridMonth,listWeek'
				},
				initialView : 'dayGridMonth',
				navLinks : true, 
				selectable : true, 
				events : data,
				locale : 'ko' 
			});
			calendar.render();
		});
	});
})
</script>
</head>
<body>

	<div id="calendar"></div>

</body>
</html>