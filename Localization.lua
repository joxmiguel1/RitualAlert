local addonName, addonTable = ...

local locale = (GetLocale and GetLocale()) or "enUS"

local L = {}

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
    L.match = {
        start = {
            "La Daga Crepuscular",
        },
        interrupt = {
            "el ritual de",
            "ha sido interrumpido",
        },
        eclipse = {
            "La Voz del Eclipse ha surgido",m
        },
        void = {
            "Un Vacio Efimero se ha manifestado",
            "Un Vacio Efímero se ha manifestado",
        },
    }
end

addonTable.L = L
