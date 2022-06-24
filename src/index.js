import { Elm } from "./Main.elm";

const modelStorageKey = 'model'

const model = JSON.parse(localStorage.getItem(modelStorageKey))

const backgroundTextureUrl = new URL(
    'assets/SeemlessBlackbrushed.png',
    import.meta.url
).href

const app = Elm.Main.init({
    node: document.getElementById("root"),
    flags: {
        ...model,
        backgroundTextureUrl,
    },
});

app.ports.storeModel.subscribe(modelObj => {
    localStorage.setItem(modelStorageKey, JSON.stringify(modelObj))
})
