// src/controllers/usersController.js
const bcryptjs = require('bcryptjs');
const { validationResult } = require("express-validator");
const User = require('../database/models/User');
const jwt = require('jsonwebtoken');


const usersController = {

    procesarRegistro: async (req, res) => {
        console.log('Datos recibidos para registro:', req.body); 

        const {username, password } = req.body;

        console.log({username},{password} )


        if (!username || !password) {
            return res.status(400).json({ message: 'Email y contraseña son requeridos.' });
        }

        console.log("antes del try")

        try {
            console.log("dentro del try")
            const existingUser = await User.findOne({ where: { username } });
            if (existingUser) {
            return res.status(409).json({ message: 'El usuario ya existe.' });
            }

          
            const newUser = await User.create({ username, password });
            console.log("usuario creado correctamente", newUser)
            res.status(201).json({ message: 'Usuario creado exitosamente.', user: newUser });
        } catch (error) {
            console.error('Error al crear usuario  1:', error);
            res.status(500).json({ message: 'Error del servidor', error });
        }
    },

    procesarLogin: async (req, res) => {

        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            console.log("Error: ", errors)
        }
        console.log("entro a procesarLogin")
        console.log('Datos enviados:', req.body); 
        try {
            console.log("try---")
            const user = await User.findOne({ where: { username: req.body.username } });
            console.log("user----- ",user.password)
            console.log('body-------- ',req.body.password)

            if (user && req.body.password == user.password) {
                
                const token = jwt.sign({ id: user.id, username: user.username }, 'estaEsMiClaveSecreta', { expiresIn: '1h' });
               
                return res.status(200).json({
                    success: true,
                    token, 
                    user: { id: user.id, username: user.username }
                });
            } else {
                res.status(401).json({
                    success: false,
                    errors: { username: { msg: 'Las credenciales son inválidas' } }
                });
            }
        } catch (error) {
            console.error("Error en el inicio de sesión:", error);
            res.status(500).send("Error del servidor");
        }
    },
    
    logout: (req, res) => {
        req.session.destroy();
        res.clearCookie('usuarioEmail');
        res.redirect('/');
    }
};

module.exports = usersController;
