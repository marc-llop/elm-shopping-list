import { Elm } from "./Main.elm";

const modelStorageKey = 'model'

const backgroundTextureUrl = new URL(
    'assets/SeemlessBlackbrushed.png',
    import.meta.url
).href

const app = Elm.Main.init({
    node: document.getElementById("root"),
    flags: {backgroundTextureUrl}
});

app.ports.storeModel.subscribe(modelObj => {
    console.log(modelObj)
    localStorage.setItem(modelStorageKey, JSON.stringify(modelObj))
})
