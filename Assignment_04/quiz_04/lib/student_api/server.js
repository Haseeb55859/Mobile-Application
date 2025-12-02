const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const cors = require('cors');
const app = express();

app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type"]
}));

app.use(bodyParser.json());

// load DB
let db = JSON.parse(fs.readFileSync('db.json'));

function saveDb() {
  fs.writeFileSync('db.json', JSON.stringify(db, null, 2));
}

// GET ALL
app.get('/students', (req, res) => {
  res.json(db.students);
});

// GET ONE
app.get('/students/:id', (req, res) => {
  const s = db.students.find(x => x.id == req.params.id);
  if (!s) return res.status(404).json({error:'not found'});
  res.json(s);
});

// CREATE
app.post('/students', (req, res) => {
  const newStudent = req.body;
  db.students.push(newStudent);
  saveDb();
  res.status(201).json(newStudent);
});

// UPDATE
app.put('/students/:id', (req, res) => {
  const id = req.params.id;
  const updated = req.body;
  db.students = db.students.map(s => s.id == id ? updated : s);
  saveDb();
  res.json(updated);
});

// DELETE
app.delete('/students/:id', (req, res) => {
  const id = req.params.id;
  db.students = db.students.filter(s => s.id != id);
  saveDb();
  res.json({status:'deleted'});
});

app.listen(3000, () => console.log("API running on port 3000"));