const express = require('express')
var db = require('./Database.js')
const cors = require('cors')
// express app
const app = express();
app.use(cors())
app.use(express.json());

// Server port
var HTTP_PORT = 80;
// Start server
app.listen(HTTP_PORT, () => {
  console.log("Server running on port %PORT%".replace("%PORT%", HTTP_PORT));
});

// Root endpoint
app.get("/", (req, res, next) => {
    res.json({ message: "" });
  });
  
  // Insert here other API endpoints

  app.post("/Sensors/", (req, res, next) => {
    var errors = []; // error array
    if (!req.body.reading) {
      errors.push("No reading sent");
    }
    var SensorData = {

      Temperature: req.body.Temperature,
      Humidity: req.body.Humidity,
      Time: new Date(),
    };
    var sql = "INSERT INTO Sensors (Temperature,Time) VALUES (?,?)";
    var parameters = [SensorData.Temperature, SensorData.Time];
    db.run(sql, parameters, function (err, result) {
      if (err) {
        res.status(400).json({ error: err.message });
        return;
      }
      res.json({


        message: "success",
        data: SensorData,
        id: this.lastID,
      
        
      });
    //  console.log(data) 
    });
  });
  
 
  app.get("/Sensors/", (req, res, next) => {
    // console.log(SensorData)
    var sql = "select * from Sensors";
    var parameters = [];
    db.all(sql, parameters, (err, rows) => {
      if (err) {
        res.status(400).json({ error: err.mesasge });
        return;
      }
      res.json({
        message: "success",
        data: rows,
        
      });
    });
  });

  app.post("/toggleLed",(req, res)=>{
    toggle = !toggle;
    console.log(toggle);
    res.json({
      message: "success",
    });
  });

  app.get("/toggleLed",(req, res)=>{
    res.json({
      message: "success",
      data : toggle
    });
  });
  