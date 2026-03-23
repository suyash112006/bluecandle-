const express = require('express');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.static(path.join(__dirname, './')));

app.get('/api/status', (req, res) => {
    res.json({ status: 'online', message: 'BlueCandleFx Backend is running properly.' });
});

app.listen(PORT, () => {
    console.log(`\n==================================================`);
    console.log(`  BlueCandleFx Server is running!`);
    console.log(`  Local:    http://localhost:${PORT}`);
    console.log(`==================================================\n`);
});
