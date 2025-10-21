const express = require('express');
const app = express();
const PORT = process.env.PORT || 8080;

// Root route — matches your live Azure App Service
app.get('/', (req, res) => {
  res.send(`
    ✅ TaskFlow<br>
    A simple task manager built with DevOps best practices<br><br>
    Set up Azure DevOps project<br>
    Configure CI pipeline<br>
    Deploy to Azure App Service<br>
    Add monitoring & security
  `);
});

// Health check endpoint (required for Azure App Service, GCP Cloud Run, Kubernetes)
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    service: 'TaskFlow API',
    timestamp: new Date().toISOString()
  });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`TaskFlow API listening on port ${PORT}`);
});
