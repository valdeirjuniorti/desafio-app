require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { pool } = require('./db');
const challengesRouter = require('./routes/challenges');

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

// Rota de saúde
app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok' });
  } catch (err) {
    res.status(500).json({ status: 'error', detail: err.message });
  }
});

// API de desafios
app.use('/api/challenges', challengesRouter);

app.listen(PORT, () => {
  console.log(`Backend rodando na porta ${PORT}`);
});
