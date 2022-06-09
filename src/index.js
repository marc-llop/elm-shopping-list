import { Elm } from "./Main.elm";

const backgroundTextureUrl = new URL(
    'assets/SeemlessBlackbrushed.png',
    import.meta.url
).href

Elm.Main.init({
    node: document.getElementById("root"),
    flags: {backgroundTextureUrl}
});
