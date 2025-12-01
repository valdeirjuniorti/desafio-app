import React, { useEffect, useState } from 'react';

const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:4000';

const defaultForm = {
  title: '',
  description: '',
  difficulty: 'medio',
  status: 'pendente',
  category: '',
  start_date: '',
  end_date: '',
  progress: 0
};

export default function App() {
  const [challenges, setChallenges] = useState([]);
  const [form, setForm] = useState(defaultForm);
  const [editingId, setEditingId] = useState(null);
  const [loading, setLoading] = useState(false);

  async function loadChallenges() {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/api/challenges`);
      const data = await res.json();
      setChallenges(data);
    } catch (err) {
      console.error('Erro ao carregar desafios', err);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadChallenges();
  }, []);

  function handleChange(e) {
    const { name, value } = e.target;
    setForm(prev => ({ ...prev, [name]: name === 'progress' ? Number(value) : value }));
  }

  async function handleSubmit(e) {
    e.preventDefault();

    const method = editingId ? 'PUT' : 'POST';
    const url = editingId
      ? `${API_BASE}/api/challenges/${editingId}`
      : `${API_BASE}/api/challenges`;

    const res = await fetch(url, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form)
    });

    if (!res.ok) {
      alert('Erro ao salvar desafio');
      return;
    }

    setForm(defaultForm);
    setEditingId(null);
    loadChallenges();
  }

  function handleEdit(challenge) {
    setEditingId(challenge.id);
    setForm({
      title: challenge.title || '',
      description: challenge.description || '',
      difficulty: challenge.difficulty || 'medio',
      status: challenge.status || 'pendente',
      category: challenge.category || '',
      start_date: challenge.start_date || '',
      end_date: challenge.end_date || '',
      progress: challenge.progress || 0
    });
  }

  async function handleDelete(id) {
    if (!confirm('Tem certeza que deseja remover este desafio?')) return;

    const res = await fetch(`${API_BASE}/api/challenges/${id}`, {
      method: 'DELETE'
    });

    if (!res.ok) {
      alert('Erro ao remover desafio');
      return;
    }

    loadChallenges();
  }

  return (
    <div style={{ maxWidth: 900, margin: '0 auto', padding: 24, fontFamily: 'sans-serif' }}>
      <h1>App de Desafios</h1>
      <p>Cadastre desafios pessoais (hábitos, estudos, treinos, etc.) e acompanhe o progresso.</p>

      <section style={{ marginTop: 24, marginBottom: 32 }}>
        <h2>{editingId ? 'Editar desafio' : 'Novo desafio'}</h2>
        <form onSubmit={handleSubmit} style={{ display: 'grid', gap: 12 }}>
          <input
            required
            name="title"
            placeholder="Título"
            value={form.title}
            onChange={handleChange}
          />
          <textarea
            name="description"
            placeholder="Descrição"
            value={form.description}
            onChange={handleChange}
          />
          <div style={{ display: 'flex', gap: 8 }}>
            <select name="difficulty" value={form.difficulty} onChange={handleChange}>
              <option value="facil">Fácil</option>
              <option value="medio">Médio</option>
              <option value="dificil">Difícil</option>
            </select>

            <select name="status" value={form.status} onChange={handleChange}>
              <option value="pendente">Pendente</option>
              <option value="em_andamento">Em andamento</option>
              <option value="concluido">Concluído</option>
            </select>

            <input
              name="category"
              placeholder="Categoria (ex: estudos)"
              value={form.category}
              onChange={handleChange}
            />
          </div>

          <div style={{ display: 'flex', gap: 8 }}>
            <label style={{ flex: 1 }}>
              Início
              <input
                type="date"
                name="start_date"
                value={form.start_date || ''}
                onChange={handleChange}
              />
            </label>
            <label style={{ flex: 1 }}>
              Fim
              <input
                type="date"
                name="end_date"
                value={form.end_date || ''}
                onChange={handleChange}
              />
            </label>
          </div>

          <label>
            Progresso: {form.progress}%
            <input
              type="range"
              name="progress"
              min="0"
              max="100"
              value={form.progress}
              onChange={handleChange}
            />
          </label>

          <div style={{ display: 'flex', gap: 8, marginTop: 8 }}>
            <button type="submit">
              {editingId ? 'Salvar alterações' : 'Criar desafio'}
            </button>
            {editingId && (
              <button
                type="button"
                onClick={() => {
                  setEditingId(null);
                  setForm(defaultForm);
                }}
              >
                Cancelar
              </button>
            )}
          </div>
        </form>
      </section>

      <section>
        <h2>Desafios cadastrados</h2>
        {loading && <p>Carregando...</p>}
        {!loading && challenges.length === 0 && <p>Nenhum desafio ainda.</p>}

        <ul style={{ listStyle: 'none', padding: 0, display: 'grid', gap: 12 }}>
          {challenges.map(ch => (
            <li
              key={ch.id}
              style={{
                border: '1px solid #ddd',
                borderRadius: 8,
                padding: 12,
                display: 'flex',
                flexDirection: 'column',
                gap: 4
              }}
            >
              <strong>{ch.title}</strong>
              {ch.category && <span>Categoria: {ch.category}</span>}
              <small>
                Dificuldade: {ch.difficulty} | Status: {ch.status} | Progresso:{' '}
                {ch.progress}%
              </small>
              {ch.description && <p>{ch.description}</p>}
              <div style={{ display: 'flex', gap: 8, marginTop: 8 }}>
                <button onClick={() => handleEdit(ch)}>Editar</button>
                <button onClick={() => handleDelete(ch.id)}>Excluir</button>
              </div>
            </li>
          ))}
        </ul>
      </section>
    </div>
  );
}
