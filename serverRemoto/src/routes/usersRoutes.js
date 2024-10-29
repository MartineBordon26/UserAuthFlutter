const express = require('express');
const router = express.Router();
const usersController = require('../controllers/usersControllers');

router.post('/registro', usersController.procesarRegistro);

router.post('/login' , usersController.procesarLogin);


module.exports = router;
