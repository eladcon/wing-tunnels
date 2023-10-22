const { connect } = require("./dist/index");

// connect({ port: 443, hostname: "https://oit8tg8y50.execute-api.us-east-1.amazonaws.com/prod", subdomain: "stam1", wsServer: "wss://x4d9xbuor4.execute-api.us-east-1.amazonaws.com/prod" }).then((d) => {
//   console.log(13, d);
// })

connect({ port: 4000, subdomain: "stam", wsServer: "wss://nv8z9mli8a.execute-api.us-east-1.amazonaws.com/prod" }).then((d) => {
  console.log(13, d);
})
