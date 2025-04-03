require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");

const app = express();
const PORT = process.env.PORT || 3001;

app.use(express.json());

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB Connected"))
  .catch(err => console.error(err));

// Sample Schema
const DataSchema = new mongoose.Schema({ message: String });
const Data = mongoose.model("Data", DataSchema);

// Routes
app.get("/", (req, res) => res.send("API is running..."));

app.post("/data", async (req, res) => {
  const { message } = req.body;
  const newData = new Data({ message });
  await newData.save();
  res.json({ success: true, data: newData });
});

app.get("/data", async (req, res) => {
  const data = await Data.find();
  res.json(data);
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
