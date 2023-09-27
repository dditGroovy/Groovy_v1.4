<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/resources/css/schedule/calendar.css" rel="stylesheet"/>
<script
        src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script src="/resources/fullcalendar/main.js"></script>
<script src="/resources/fullcalendar/ko.js"></script>

<style>

    .fc-event-time {
        display: none;
    }
    .calendar-wrap {
        padding: var(--vw-32);
    }
	#calendar{
		margin-top: var(--vh-40);
	}
</style>

<div class="content-container">
    <div class="calendar-wrap card card-df">
        <div id="calendar"></div>
    </div>
</div>
<script>
	$(document).ready(function () {

		$(function () {
			let request = $.ajax({
				url: "/schedule/schedule",
				method: "GET",
				dataType: "json"
			});

			request.done(function (data) {
				let calendarEl = document.getElementById('calendar');
				calendar = new FullCalendar.Calendar(calendarEl, {
					height: '700px',
					slotMinTime: '08:00',
					slotMaxTime: '20:00',
					headerToolbar: {
						left: 'today prev,next',
						center: 'title',
						right: 'dayGridMonth,listWeek'
					},
					initialView: 'dayGridMonth',
					navLinks: true,
					selectable: true,
					events: data,
					locale: 'ko'
				});
				calendar.render();
			});
		});
	})
</script>