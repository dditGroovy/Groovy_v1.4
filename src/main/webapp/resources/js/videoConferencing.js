const videoStream = document.getElementById('videoStream');
const joinBtn = document.getElementById('joinBtn');
const cameraBtn = document.getElementById('cameraBtn');
const micBtn = document.getElementById('micBtn');
const leaveBtn = document.getElementById('leaveBtn');
const streamControls = document.getElementById('streamControls');

const appId = '';
const token = '';
const channelName = 'groovy';

const client = AgoraRTC.createClient({mode:"rtc", codec:"vp8"});

let localTracks = [];
let remoteUsers = {}

let joinAndDisplayLocalStream = async () => {

    client.on('user-published', handleUserJoined);
    client.on('user-left', handleUserLeft);

    let UID = await client.join(appId, channelName, token, null);
    localTracks = await AgoraRTC.createMicrophoneAndCameraTracks();
    let participant = `<div class="video-container" id="userContainer${UID}">
                            <div class="video-player" id="user${UID}"></div>
                           </div>`;
    videoStream.insertAdjacentHTML('beforeend', participant);
    localTracks[1].play(`user${UID}`);
    await client.publish([localTracks[0], localTracks[1]])
    joinBtn.style.display = 'none';
    streamControls.style.display = 'block';
}

let joinStream = async () => {
    await joinAndDisplayLocalStream();

}

let handleUserJoined = async (user, mediaType) => {
    remoteUsers[user.uid] = user;
    await client.subscribe(user, mediaType);

    if(mediaType === 'video') {
        let participant = document.getElementById(`userContainer${user.uid}`);
        if(participant != null) {
            participant.remove();
        }

        participant = `<div class="video-container" id="userContainer${user.uid}">
                               <div class="video-player" id="user${user.uid}"></div>
                           </div>`;
        videoStream.insertAdjacentHTML('beforeend', participant);

        user.videoTrack.play(`user${user.uid}`);
    }

    if(mediaType === 'audio') {
        user.audioTrack.play();
    }
}

let handleUserLeft = async (user) => {
    delete remoteUsers[user.uid];
    document.getElementById(`userContainer${user.uid}`).remove();
}

let leaveAndRemoveLocalStream = async () => {
    for(let i = 0; localTracks.length > i; i++) {
        localTracks[i].stop();
        localTracks[i].close();
    }

    await client.leave()
    document.getElementById('joinBtn').style.display = 'block';
    document.getElementById('streamControls').style.display = 'none';
    document.getElementById('videoStream').innerHTML = '';
}

let toggleMic = async (e) => {
    if(localTracks[0].muted) {
        await localTracks[0].setMuted(false);
        e.target.innerText = '마이크 ON'
        e.target.style.backgroundColor = 'skyblue'
    } else {
        await localTracks[0].setMuted(true)
        e.target.innerText = '마이크 OFF'
        e.target.style.backgroundColor = 'pink'
    }
}

let toggleCam = async (e) => {
    if(localTracks[1].muted) {
        await localTracks[1].setMuted(false);
        e.target.innerText = '카메라 ON'
        e.target.style.backgroundColor = 'skyblue'
    } else {
        await localTracks[1].setMuted(true)
        e.target.innerText = '카메라 OFF'
        e.target.style.backgroundColor = 'pink'
    }
}

document.getElementById('joinBtn').addEventListener('click', joinAndDisplayLocalStream)
document.getElementById('leaveBtn').addEventListener('click', leaveAndRemoveLocalStream)
document.getElementById('micBtn').addEventListener('click', toggleMic)
document.getElementById('cameraBtn').addEventListener('click', toggleCam)