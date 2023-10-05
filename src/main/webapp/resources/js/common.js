document.addEventListener("DOMContentLoaded",()=>{
    const navList = document.querySelectorAll(".nav-list > a");
    const activeIndex = sessionStorage.getItem('activeNavItem');

    /*  aside   */
    navList.forEach((item, index) => {
        item.addEventListener('click', (e) => {
            e.preventDefault();

            navList.forEach((otherItem) => {
                otherItem.classList.remove('active');
            });
            item.classList.add('active');
            sessionStorage.setItem('activeNavItem', index);
        });
    });
    if (activeIndex === null || activeIndex === undefined) {
        navList[0].classList.add('active');
        sessionStorage.setItem('activeNavItem', 0);
    }
    /*  관리자 Aside   */
    const departmentItems   = document.querySelectorAll(".department.nav-list");
    function setActiveDepartment(item) {
        const departmentItems = document.querySelectorAll('.depth1 .department.nav-list');
        departmentItems.forEach(function (department) {
            department.classList.remove("active");
            const ul = department.nextElementSibling;
            if (ul) {
                ul.style.maxHeight = "0";
            }
        });
        item.classList.add("active");
        const ul = item.closest("li").nextElementSibling;
        if (ul) {
            ul.style.maxHeight = ul.scrollHeight + "px";
        }
    }

    departmentItems.forEach(function (item) {
        item.addEventListener("click", function (e) {
            const target = e.target;
            setActiveDepartment(target);

        });
    });

})