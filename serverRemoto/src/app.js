require('dotenv').config();
const express = require('express')
const path = require('path')
const methodOverride = require('method-override')
const bodyParser = require('body-parser');
const sequelize = require('./database/config/database');
const cors = require('cors');
const usersRoutes = require('./routes/usersRoutes');
const session = require('express-session');
const cookies = require('cookie-parser');

const PORT = process.env.PORT || 3001;

const app = express()


sequelize.sync()
    .then(() => console.log("Base de datos sincronizada"))
    .catch(error => console.log("Error al sincronizar la base de datos", error));
    
app.use(cors());
app.use(express.json());
app.use(methodOverride('_method'));
app.use(bodyParser.json()); 
app.use(bodyParser.urlencoded({extended: true}));
app.use(session({secret: 'UserAuth', saveUninitialized: true, resave: false}));
app.use(cookies())


app.get('/api/test', (req, res) => {
    res.json({ message: 'Conexión exitosa' });
}); // prueba de conexion ELIMINAR.


app.listen(PORT, '0.0.0.0', () => {
    console.log('Servidor corriendo en el puerto '+PORT);
});


app.use('/api', usersRoutes);

