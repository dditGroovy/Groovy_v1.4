<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    #fReadBtn {
        position: absolute;
        top: 30%;
        right: 0;
    }

    #fATag {
        display: block;
        padding: 10px;
        text-decoration: none;
        color: #333;
    }

    #floatingAlarm {
        width: 450px;
        position: relative;
    }

    .icon-cloud {
        content:url("/resources/images/icon/cloud.svg");
    }
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<div id="floating">
    <ul>
        <li><a href="${pageContext.request.contextPath}/humanResources/loadLog"><i class="icon i-manage"></i></a></li>
        <li><a href="${pageContext.request.contextPath}/chat"><i class="icon i-send"></i></a></li>
        <li><a href="${pageContext.request.contextPath}/cloud/main"><i class="icon icon-cloud"></i></a></li>
    </ul>
</div>

<div id="floatingAlarm" style="display: none">
    <div id="aTagBox"></div>
    <button type="button" id="fReadBtn">읽음</button>
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
            console.log("info: connection opened");
        };

        sock.onmessage = function(event) {
            let $socketAlarm = $("#aTagBox");
            $("#floatingAlarm").css("display", "block");

            $socketAlarm.html(event.data);
        }

        sock.onclose = function () {
            console.log("close");
        }

        sock.onerror = function (err) {
            console.log("ERROR: ", err);
        }
    }

    //실시간 알림 읽음 처리
    $("#fReadBtn").on("click", function () {
        var ntcnSn = $("#fATag").attr("data-seq");
        $.ajax({
            type: 'delete',
            url: '/alarm/deleteAlarm?ntcnSn=' + ntcnSn,
            success: function () {
                $("#floatingAlarm").remove();
            },
            error: function (xhr) {
                xhr.status;
            }
        });
    })
</script>