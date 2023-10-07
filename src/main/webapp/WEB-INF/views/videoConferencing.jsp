<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/commonStyle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/videoConferencing.css">
<script src="${pageContext.request.contextPath}/resources/js/AgoraRTC_N-4.19.0.js"></script>
<header>
    <div class="logo">
        <img src="${pageContext.request.contextPath}/resources/images/logo.png" />
    </div>
</header>
<main>
    <div id="joinControl" class="btn-join">
        <button id="joinBtn" class="btn btn-fill-bl-sm font-md font-18">회의 참여하기</button>
    </div>

    <div id="streamWrap">
        <div id="videoStream" class="video-wrap">

        </div>
        <div id="streamControls" class="btn-control">
            <button id="cameraBtn" class="btn btn-icon"></button>
            <button id="micBtn" class="btn btn-icon"></button>
            <button id="leaveBtn" class="btn btn-icon"></button>
        </div>
    </div>
</main>
<script>
    const videoStream = document.getElementById('videoStream');
    const joinControl = document.getElementById('joinControl');
    const joinBtn = document.getElementById('joinBtn');
    const cameraBtn = document.getElementById('cameraBtn');
    const micBtn = document.getElementById('micBtn');
    const leaveBtn = document.getElementById('leaveBtn');
    const streamControls = document.getElementById('streamControls');

    const appId = '3e5fbb869b084748968baccbcb51dd6f';
    const token = '007eJxTYFBu0yl/4PKrOP8LQ5JUU3nw3a9C2bmamVXPJ05e89op+acCg3GqaVpSkoWZZZKBhYm5iYWlmUVSYnJyUnKSqWFKilla9lKF1IZARoak3KXMjAwQCOKzMaQX5eeXVTIwAACwHSER';
    const channelName = 'groovy';

    const client = AgoraRTC.createClient({mode:"rtc", codec:"vp8"});


    let localTracks = [];
    let remoteUsers = {}

    let joinAndDisplayLocalStream = async () => {

        client.on('user-published', handleUserJoined);
        client.on('user-left', handleUserLeft);

        let UID = await client.join(appId, channelName, token, null);
        localTracks = await AgoraRTC.createMicrophoneAndCameraTracks();
        let player = `<div class="video-container" id="userContainer\${UID}">
                                <div class="video-player" id="user\${UID}"></div>
                           </div>`;
        videoStream.insertAdjacentHTML('beforeend', player);
        localTracks[1].play(`user\${UID}`);
        await client.publish([localTracks[0], localTracks[1]])
        joinControl.style.display = 'none';
        streamControls.style.display = 'flex';
    }

    let joinStream = async () => {
        await joinAndDisplayLocalStream();

    }

    let handleUserJoined = async (user, mediaType) => {
        remoteUsers[user.uid] = user;
        await client.subscribe(user, mediaType);

        if(mediaType === 'video') {
            let player = document.getElementById(`userContainer\${user.uid}`);
            if(player != null) {
                player.remove();
            }

            player = `<div class="video-container" id="userContainer\${user.uid}">
                           <div class="video-player" id="user\${user.uid}"></div>
                      </div>`;
            videoStream.insertAdjacentHTML('beforeend', player);

            user.videoTrack.play(`user\${user.uid}`);
        }

        if(mediaType === 'audio') {
            user.audioTrack.play();
        }
    }

    let handleUserLeft = async (user) => {
        delete remoteUsers[user.uid];
        document.getElementById(`userContainer\${user.uid}`).remove();
    }

    let leaveAndRemoveLocalStream = async () => {
        for(let i = 0; localTracks.length > i; i++) {
            localTracks[i].stop();
            localTracks[i].close();
        }

        await client.leave();
        videoStream.innerHTML = '';
        joinControl.style.display = 'block';
        streamControls.style.display = 'none';
    }

    let toggleMic = async (e) => {
        if(localTracks[0].muted) {
            await localTracks[0].setMuted(false);
            e.target.style.backgroundImage = 'url("/resources/images/icon/mic.svg")';
        } else {
            await localTracks[0].setMuted(true)
            e.target.style.backgroundImage = 'url("/resources/images/icon/mic-off.svg")';
        }
    }

    let toggleCam = async (e) => {
        if(localTracks[1].muted) {
            await localTracks[1].setMuted(false);
            e.target.style.backgroundImage = 'url("/resources/images/icon/video.svg")';
        } else {
            await localTracks[1].setMuted(true)
            e.target.style.backgroundImage = 'url("/resources/images/icon/video-off.svg")';
        }
    }

    joinBtn.addEventListener('click', joinAndDisplayLocalStream)
    leaveBtn.addEventListener('click', leaveAndRemoveLocalStream)
    micBtn.addEventListener('click', toggleMic)
    cameraBtn.addEventListener('click', toggleCam)

</script>