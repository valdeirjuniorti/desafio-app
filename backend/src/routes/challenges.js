const express = require('express');
const router = express.Router();
const { pool } = require('../db');

// Cria tabela se não existir
async function ensureTable() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS challenges (
      id SERIAL PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      description TEXT,
      difficulty VARCHAR(20),
      status VARCHAR(20) DEFAULT 'pendente',
      category VARCHAR(100),
      start_date DATE,
      end_date DATE,
      progress INTEGER DEFAULT 0,
      created_at TIMESTAMP DEFAULT NOW(),
      updated_at TIMESTAMP DEFAULT NOW()
    );
  `);
}
ensureTable().catch(console.error);

// LISTAR todos
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM challenges ORDER BY created_at DESC'
    );
    res.json(result.rows);
  } catch (err) {
    console.error('Erro GET /challenges', err);
    res.status(500).json({ error: 'Erro ao listar desafios' });
  }
});

// CRIAR
router.post('/', async (req, res) => {
  try {
    const {
      title,
      description,
      difficulty,
      status,
      category,
      start_date,
      end_date,
      progress
    } = req.body;

    const result = await pool.query(
      `INSERT INTO challenges
        (title, description, difficulty, status, category, start_date, end_date, progress)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
       RETURNING *`,
      [
        title,
        description || '',
        difficulty || 'medio',
        status || 'pendente',
        category || '',
        start_date || null,
        end_date || null,
        progress || 0
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error('Erro POST /challenges', err);
    res.status(500).json({ error: 'Erro ao criar desafio' });
  }
});

// ATUALIZAR
router.put('/:id', async (req, res) => {
  try {
    const id = Number(req.params.id);
    const {
      title,
      description,
      difficulty,
      status,
      category,
      start_date,
      end_date,
      progress
    } = req.body;

    const result = await pool.query(
      `UPDATE challenges
       SET title = $1,
           description = $2,
           difficulty = $3,
           status = $4,
           category = $5,
           start_date = $6,
           end_date = $7,
           progress = $8,
           updated_at = NOW()
       WHERE id = $9
       RETURNING *`,
      [
        title,
        description,
        difficulty,
        status,
        category,
        start_date,
        end_date,
        progress,
        id
      ]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Desafio não encontrado' });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error('Erro PUT /challenges/:id', err);
    res.status(500).json({ error: 'Erro ao atualizar desafio' });
  }
});

// REMOVER
router.delete('/:id', async (req, res) => {
  try {
    const id = Number(req.params.id);

    const result = await pool.query(
      'DELETE FROM challenges WHERE id = $1',
      [id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: 'Desafio não encontrado' });
    }

    res.status(204).send();
  } catch (err) {
    console.error('Erro DELETE /challenges/:id', err);
    res.status(500).json({ error: 'Erro ao remover desafio' });
  }
});

module.exports = router;
