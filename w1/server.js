const app = require("./app")
const port = 4000;

app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});