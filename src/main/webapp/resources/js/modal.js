const closeBtn = document.querySelectorAll(".close");
const modalOpenBtn = document.querySelectorAll(".btn-modal");
const modalDm = document.querySelector(".modal-dim");
const modalLayer = document.querySelectorAll(".modal-layer");

function modalClose() {
    modalDm.style.display = "none";
    modalLayer.forEach(item => {
        item.classList.remove("on");
    })
}

function modalOpen(dataName) {
    modalDm.style.display = "block";
    modalLayer.forEach(layer => {
        if (layer.classList.contains(dataName)) {
            layer.classList.add("on");
        }
    });
}

/*  모달 열기   */
modalOpenBtn.forEach(item => {
    item.addEventListener("click", function () {
        const dataName = this.getAttribute("data-name");
        modalDm.style.display = "block";
        modalLayer.forEach(layer => {
            if (layer.classList.contains(dataName)) {
                layer.classList.add("on");
            }
        });
    });
});
/*  모달 닫기   */
closeBtn.forEach(item => {
    item.addEventListener("click", modalClose);
})