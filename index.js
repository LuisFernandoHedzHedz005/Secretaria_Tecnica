const express = require('express');
const path = require('path');
const indexRouter = require('./routes/index');
const administradorRouter = require('./routes/administrador');
const sugerenciasRouter = require('./routes/sugerencias');



const app = express();
const PORT = 3000;

// Configura la ubicación de las vistas
app.set('views', __dirname + '/views');

// Configura el motor de plantillas
app.set('view engine', 'ejs');

app.use(express.json());
app.use(express.urlencoded({extended:false}));

// Configura la carpeta de archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));


// Rutas
app.use('/', indexRouter);
app.use('/administrador', administradorRouter);
app.use('/sugerencias', sugerenciasRouter);

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor ejecutándose en http://localhost:${PORT}`);
});