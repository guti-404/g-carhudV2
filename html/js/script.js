$(() => {
    HUD = {}
    HUD.close = () => {
        $("#carhud").fadeOut(300)
    }
    HUD.close();
    window.addEventListener("message", (event) => {
        let data = event.data;
        let damage = Math.round(data.damage)
        if (data.action === "showCarhud") {
            $("#carhud").fadeIn(300)
            $(".velocidad-texto").text(Math.round(data.speed))
            $(".km").text(data.unit)
            $(".progressBarFuel").css({"width": Math.round(data.fuel)* 0.60 + "%"})

            if (Math.round(data.speed) <= 9) {
                $(".velocidad-texto").text("00"+Math.round(data.speed))
            } else if (Math.round(data.speed) >= 9 && Math.round(data.speed) <= 99) {
                $(".velocidad-texto").text("0"+Math.round(data.speed))
            }

            if (Math.round(data.speed) === 0) {$(".velocidad-texto").text("NRP")}
        } else if (data.action === "hideCarhud") {
            $("#carhud").fadeOut(300)
        }
        if (data.whenCinto === "cinto") {
            $(".cinturon").css({"transition":".3s","filter": "invert(2)"})
        } else if (data.whenCinto === "noCinto") {
            $(".cinturon").css({"transition":".3s","filter": "invert(0)"})
        }
        if (data.whenMotor === "motor") {
            $(".motor").css({"transition":".3s","filter": "invert(2)"})
        } else if (data.whenMotor === "noMotor") {
            $(".motor").css({"transition":".3s","filter": "invert(0)"})
        }
        if (data.callesData === "calle") {
            $(".calles").css({"top": "0.5vw"})
            $(".calles-text").text(data.streetName)
        } else if (data.callesData == "noCalle") {$(".calles").fadeOut(300);return false}
        const daño = data.damage /10;
        if (daño > 80 && daño <= 100) {
            $("#engine-icon").css(
                {
                    color: "white",
                }
            )
        } else if (daño > 0 && daño < 30) {
            $("#engine-icon").css(
                {
                    color: "red",
                }
            )
        }
    })
})