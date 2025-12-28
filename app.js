const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const os = require('os');

app.use(express.json());

// Health check - shows which node/container this is
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    node: os.hostname(), // Shows which node is responding
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Main API endpoint
app.get('/api/message', (req, res) => {
  res.json({ 
    message: 'Hello from CI/CD Pipeline!',
    node: os.hostname(), // Shows which node is responding
    environment: process.env.NODE_ENV || 'development'
  });
});

// Create a new item
app.post('/api/items', (req, res) => {
  const { name } = req.body;
  if (!name) {
    return res.status(400).json({ error: 'Name is required' });
  }
  res.status(201).json({ 
    id: Date.now(), 
    name,
    node: os.hostname(),
    created: new Date().toISOString()
  });
});

// Start server
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Node: ${os.hostname()}`);
  });
}

module.exports = app;
