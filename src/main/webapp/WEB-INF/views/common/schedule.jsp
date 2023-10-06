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
        margin-top: var(--vh-64);
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
    const isSameDate = (date1, date2) => {
        return date1.getFullYear() === date2.getFullYear()
            && date1.getMonth() === date2.getMonth()
            && date1.getDate() === date2.getDate();
    }
	$(document).ready(function () {

		$(function () {
			let request = $.ajax({
				url: "/schedule/schedule",
				method: "GET",
				dataType: "json"
			});

			request.done(function (datas) {
                datas.forEach((data) => {
                    startDate = new Date(data.start);

                    dataYear = new Date(data.end).getFullYear();
                    dataMonth = new Date(data.end).getMonth();
                    dataDay = new Date(data.end).getDate();
                    dataDate = new Date(dataYear, dataMonth, dataDay);
                    if (!isSameDate(startDate, dataDate)) {
                        dataDate.setDate(dataDate.getDate() + 1)
                        data.end = dataDate.getTime();
                    }
                });
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
					events: datas,
					locale: 'ko'
				});
				calendar.render();
			});
		});
	})
</script>