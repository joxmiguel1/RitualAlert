local addonName, addonTable = ...

local locale = (GetLocale and GetLocale()) or "enUS"

local L = {}

L.ui = {
    title = "Ritual Alerts",
    subtitle = "Enable or disable alerts for Twilight Ascension ritual messages.",
    alerts_header = "Alerts",
    alert_start = "Begun summoning (ritual started)",
    alert_interrupt = "Ritual interrupted",
    alert_eclipse = "Voice of the Eclipse",
    alert_void = "Ephemeral Void manifested",
    tomtom_header = "TomTom",
    tomtom_desc = "TomTom: Automatic waypoint for any alert",
    sound_on = "Sound: On",
    sound_off = "Sound: Off",
}

L.match = {
    start = {
        "The Twilight's Blade",
    },
    interrupt = {
        "ritual has been interrupted",
    },
    eclipse = {
        "The Voice of the Eclipse has emerged",
    },
    void = {
        "Ephemeral Void has manifested",
    },
}

if locale == "esES" or locale == "esMX" then
    L.ui = {
        title = "Alertas del Ritual",
        subtitle = "Activa o desactiva alertas para mensajes del ritual de Ascensión Crepuscular.",
        alerts_header = "Alertas",
        alert_start = "Comenzó la invocación (ritual iniciado)",
        alert_interrupt = "Ritual interrumpido",
        alert_eclipse = "Voz del Eclipse",
        alert_void = "Vacío Efímero manifestado",
        tomtom_header = "TomTom",
        tomtom_desc = "TomTom: Punto automático para cualquier alerta",
        sound_on = "Sonido: Activado",
        sound_off = "Sonido: Silenciado",
    }
    L.match = {
        start = {
            "La Daga Crepuscular",
        },
        interrupt = {
            "el ritual de",
            "ha sido interrumpido",
        },
        eclipse = {
            "La Voz del Eclipse ha surgido",
        },
        void = {
            "Un Vacío",
        },
    }
end

addonTable.L = L
